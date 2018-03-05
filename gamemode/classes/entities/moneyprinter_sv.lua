local CONFIG_PrintTimer = 3;
local CONFIG_DefaultMaxBalance = 1000;
local CONFIG_DefaultPrintAmount = 1;

Object_MoneyPrinter = Object_MoneyPrinter or {};
Object_MoneyPrinter.__index = Object_MoneyPrinter;
local Object = Object_MoneyPrinter;

--//
--//	Constructs a money printer object.
--//
function Object:new( ply, position, maxBalance, printAmount )
	
	local metaInstance = {
		entityType = "Object_MoneyPrinter",
		propModel = "models/props_lab/servers.mdl",
		balance = 0,
		maxBalance = maxBalance or CONFIG_DefaultMaxBalance,
		owner = ply or nil,
		ent = nil,
		printAmount = printAmount or CONFIG_DefaultPrintAmount
	}
	
	local objectInstance = GameObject:new(Object, metaInstance, ply, position);
	GameObject:newClient(objectInstance);
	
	return objectInstance;
end

--//
--//	Entity prints money until full.
--//	~Normally we would want to send a net message to the client to update the balance
--//	but we are doing that in a global timer to all printers for net efficency.~
--//
function Object:Print()
    self.balance = math.min( self.balance + self.printAmount, self.maxBalance);
    
    return self.balance;
end

--//
--//	Withdraw money from entity.
--//
function Object:Withdraw(ply, amount)

	if (self.balance <= 0) then
		return;
	end

    if (ply:IsValid()) then
        ply.gamedata:GiveWealth(math.min(amount, self.balance));
        self.balance = self.balance - math.min(amount, self.balance);

		-- After a withdraw we need to update the balance for the client..
		GameObject:SendGameDataSingle(self.ent, {balance = self.balance});
    else
        print("Obj_MoneyPrinter:Withdraw() - Player was invalid / does not exist");
    end
    
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function Object:Use(ply, ent)	
	
	if (self.balance <= 0) then
		return;
	end

	self:Withdraw(ply, self.balance);

	net.Start("GameObject_SendGameDataSingle");
	net.WriteEntity(ent);
	net.WriteTable(self)
	net.Send(ply);
	
	

end

--//
--// Garbage collect money printer.
--// TODO: Make sure garbage collection is actually happening.
--//
function Object:Remove() 
	table.RemoveByValue( self.owner.gamedata.entities, self )
end


--[[
--		
--		Console Command Functions.
--
--]]
concommand.Add( "createPrinter", function( ply, cmd, args ) 
	
    local trace = {};
    trace.start = ply:EyePos();
    trace.endpos = trace.start + ply:GetAimVector() * 85;
    trace.filter = ply;
    
    local tr = util.TraceLine(trace);
	local newPrinter = Object_MoneyPrinter:new(ply, tr.HitPos); 
	
	table.insert(ply.gamedata.entities, newPrinter)
	
end)

--[[
--		
--		Static Functions for the Obj__MoneyPrinter Class.
--
--]]

--//
--//	Creates a global timer that loops through every printer and prints.
--//
function InitalizeGlobalTimers()
	timer.Create( "Timers_PrintAll", CONFIG_PrintTimer, 0, function() 

		local updatedPrinters = {};
		for k_1, v_player in pairs( player.GetAll() ) do
			if (v_player.gamedata != nil && v_player.gamedata.entities != nil) then
				for k_2, v_ent in pairs( v_player.gamedata.entities ) do
					if (v_ent.entityType == "Object_MoneyPrinter" && v_ent.balance < v_ent.maxBalance) then
						table.insert(updatedPrinters, { ent = v_ent.ent, gamedata = { balance = v_ent:Print() } } );
					end
				end
			end
		end
		-- TODO: IN THE FUTURE DO A CHECK TO MAKE SURE prnitersToUpdate is not bigger than max net message.
		GameObject:SendGameDataMany(updatedPrinters);
	end )
end
hook.Add("PostGamemodeLoaded", "Hook_InitalizeGlobalTimers", InitalizeGlobalTimers)

