PlayerData = {};
PlayerData.__index = PlayerData;

--//
--//    Constructs a new object to store player data.
--//
function PlayerData:new( ply )

	if (ply == nil || !ply:IsValid() || !ply:IsPlayer()) then
		return nil;
	end
	
	local metaPlayerData = {
        wealth = 0,
        nickname = ply:Nick(),
        player = ply,
        entities = {}
	}
	setmetatable( metaPlayerData, PlayerData ) 
	
	return metaPlayerData;

end
setmetatable( PlayerData, {__call = PlayerData.new } )

--//
--//    Set player's wealth.
--//
function PlayerData:SetWealth(amount)
    
    if ( self.player:IsValid() && isnumber(amount) ) then
        self.wealth = amount;
    else
        print("PlayerData:RecieveMoney() - No player data exists, or money given");
    end
        
end

--//
--//    Give player wealth.
--//
function PlayerData:GiveWealth(amount)
    
    if ( self.player:IsValid() && isnumber(amount) ) then
        self.wealth = self.wealth + amount;
    else
        print("PlayerData:RecieveMoney() - No player data exists, or money given");
    end
        
end

--//
--//    Take player's wealth.
--//
function PlayerData:TakeWealth(amount)
    
    if ( self.player:IsValid() && isnumber(amount) ) then
        self.wealth = self.wealth - amount;
    else
        print("PlayerData:RecieveMoney() - No player data exists, or money given");
    end
        
end

--[[
--		
--		Console Command Functions.
--
--]]
concommand.Add( "reloadPlayerData", function( ply, cmd, args ) 
	
	for k, v in pairs( player.GetAll() ) do
        InitializePlayerData(v);    
    end
	
end)