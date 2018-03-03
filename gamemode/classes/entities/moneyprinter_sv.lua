local CONFIG_PrintTimer = 3;

MoneyPrinter = MoneyPrinter or {};
MoneyPrinter.__index = MoneyPrinter;

--//
--//	Constructs a money printer object.
--//
function MoneyPrinter:new( ply, position, maxBalance, printAmount )
	
	-- Check if player that created the entity, exists.
	if (ply == nil || !ply:IsValid() || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the entity.
	local metaMoneyPrinter = {
		entityType = "cash_moneyprinter",
		balance = 0,
		maxBalance = maxBalance or 1000,
		owner = ply or nil,
		ent = nil,
		printAmount = printAmount or 100
	}
	setmetatable( metaMoneyPrinter, MoneyPrinter ) 
	
	-- Create the physical entity that the player interacts with.
	local physicalEntity = ents.Create( "ent_skeleton" );
	if ( !IsValid( physicalEntity ) ) then return end
	physicalEntity:SetPos(position);
	physicalEntity:Spawn();
	physicalEntity.gamedata = metaMoneyPrinter;
	
	-- Attach the aforementioned physical entity to the enttiy.
	metaMoneyPrinter.ent = physicalEntity;
	
	return metaMoneyPrinter;
end
setmetatable( MoneyPrinter, {__call = MoneyPrinter.new } )

--//
--//	Entity prints money until full.
--//	~Normally we would want to send a net message to the client to update the balance
--//	but we are doing that in a global timer to all printers for net efficency.~
--//
function MoneyPrinter:Print()
    self.balance = math.min( self.balance + self.printAmount, self.maxBalance);
    
    return self.balance;
end

--//
--//	Withdraw money from entity.
--//
function MoneyPrinter:Withdraw(ply, amount)

	if (self.balance <= 0) then
		return;
	end

    if (ply:IsValid()) then
        ply.gamedata:GiveWealth(math.min(amount, self.balance));
        self.balance = self.balance - math.min(amount, self.balance);

		-- After a withdraw we need to update the balance for the client..
		basewars.util.ents:SendGameDataSingle(self.ent, {balance = self.balance});
    else
        print("MoneyPrinter:Withdraw() - Player was invalid / does not exist");
    end
    
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function MoneyPrinter:Use(ply, ent)	
	
	if (self.balance <= 0) then
		return;
	end

	self:Withdraw(ply, self.balance);

end

--//
--// Garbage collect money printer.
--// TODO: Make sure garbage collection is actually happening.
--//
function MoneyPrinter:Remove() 
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
	local newPrinter = MoneyPrinter(ply, tr.HitPos); 
	
	table.insert(ply.gamedata.entities, newPrinter)
	
end)

--[[
--		
--		Static Functions for the MoneyPrinter Class.
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
					if (v_ent.balance < v_ent.maxBalance && v_ent.entityType == "cash_moneyprinter") then
						table.insert(updatedPrinters, { ent = v_ent.ent, gamedata = { balance = v_ent:Print() } } );
					end
				end
			end
		end
		
		-- TODO: IN THE FUTURE DO A CHECK TO MAKE SURE prnitersToUpdate is not bigger than max net message.
		basewars.util.ents:SendGameDataMany(updatedPrinters);
	end )
end
hook.Add("PostGamemodeLoaded", "Hook_InitalizeGlobalTimers", InitalizeGlobalTimers)

