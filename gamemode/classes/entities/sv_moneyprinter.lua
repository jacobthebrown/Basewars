local CONFIG_PrintTimer = 3;

MoneyPrinter = {};
MoneyPrinter.__index = MoneyPrinter;
--setmetatable( MoneyPrinter, {__call = MoneyPrinter.new } )
--setmetatable( MoneyPrinter, {__tostring = MoneyPrinter.ToString } )

function MoneyPrinter:new( ply, position )
	
	if (ply == nil || !ply:IsValid() || !ply:IsPlayer()) then
		--return nil;
	end
	
	local metaMoneyPrinter = {
		entityType = "cash_moneyprinter",
		balance = 0,
		maxBalance = 1000,
		owner = ply or nil,
		ent = nil,
		printAmount = 100
	}

	setmetatable( metaMoneyPrinter, MoneyPrinter ) 
	
	-- Give 
	local physicalEntity = ents.Create( "ent_skeleton" );
	if ( !IsValid( physicalEntity ) ) then return end
	physicalEntity:SetPos(position);
	physicalEntity:Spawn();
	physicalEntity.gamedata = metaMoneyPrinter;
	
	metaMoneyPrinter.ent = physicalEntity;
	
	return metaMoneyPrinter;
end

function MoneyPrinter:Print()
    self.balance = math.min( self.balance + self.printAmount, self.maxBalance);
    
    PrintTable(self)
    
    net.Start("Entity_SendGameData");
    net.WriteEntity(self.ent);
    net.WriteTable(self);
	net.Broadcast()
    
end

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
	
	PrintTable(newPrinter)
	
	table.insert(ply.gamedata.entities.printers, newPrinter)
	
end)

--[[
--		
--		Static Functions for the MoneyPrinter Class.
--
--]]
function InitalizeGlobalTimers()
	timer.Create( "Timers_PrintAll", CONFIG_PrintTimer, 0, function() 
		for key_index, value_player in pairs( player.GetAll() ) do
			if (value_player.gamedata != nil && value_player.gamedata.entities.printers != nil) then
				for key_index, value_entity in pairs( value_player.gamedata.entities.printers ) do
					value_entity:Print();
				end
			end
		end
	
	end )
end
hook.Add("PostGamemodeLoaded", "Hook_InitalizeGlobalTimers", InitalizeGlobalTimers)

