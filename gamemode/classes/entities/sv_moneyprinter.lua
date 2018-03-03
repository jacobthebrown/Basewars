local CONFIG_PrintTimer = 3;

MoneyPrinter = {};
MoneyPrinter.__index = MoneyPrinter;

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

--//
--//	Entity prints money until full.
--//
function MoneyPrinter:Print()
    self.balance = math.min( self.balance + self.printAmount, self.maxBalance);
    
    return self.balance;
    -- Send game data to all clients to 
    --net.Start("Entity_SendGameData");
    --net.WriteEntity(self.ent);
    --net.WriteTable({ balance = self.balance});
	--net.Broadcast()
    
end

--//
--//	Withdraw money from enttity.
--//
function MoneyPrinter:Withdraw(ply)

    if (ply:IsValid()) then
        ply.playerdata:GiveMoney();
    else
        print("No player data exists");
    end
    
end

function MoneyPrinter:Use(ply, ent)	
	
	if (self.balance == 0) then
		return;
	end

	
	ply.gamedata:RecieveMoney(self.balance);
	self.balance = 0;
	
    net.Start("Entity_SendGameData");
    net.WriteEntity(self.ent);
    net.WriteTable(self);
	net.Broadcast()

end

function MoneyPrinter:Remove() 
	
	table.RemoveByValue( self.owner.gamedata.entities.printers, self )
	
end

setmetatable( MoneyPrinter, {__call = MoneyPrinter.new } )
--setmetatable( MoneyPrinter, {balance = 0 } )

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
	
	if (ply.gamedata.entities.printers == nil) then
		ply.gamedata.entities.printers = {};
	end
	
	table.insert(ply.gamedata.entities.printers, newPrinter)
	
end)

--[[
--		
--		Static Functions for the MoneyPrinter Class.
--
--]]
function InitalizeGlobalTimers()
	timer.Create( "Timers_PrintAll", CONFIG_PrintTimer, 0, function() 
		
		local printersToUpdate = {};
		table.insert(printersToUpdate, )
		for key_index, value_player in pairs( player.GetAll() ) do
			if (value_player.gamedata != nil && value_player.gamedata.entities.printers != nil) then
				for key_index, value_entity in pairs( value_player.gamedata.entities.printers ) do
					value_entity:Print();
				end
			end
		end
		
	    -- Send game data to all clients to 
	    net.Start("Entity_MassSendGameData");
	    net.WriteEntity(self.ent);
	    net.WriteTable({ balance = self.balance});
		net.Broadcast()
		
	end )
end
hook.Add("PostGamemodeLoaded", "Hook_InitalizeGlobalTimers", InitalizeGlobalTimers)

