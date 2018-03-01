ClassPlayerData = {};
ClassPlayerData.__index = ClassPlayerData;

function ClassPlayerData:new( ply )

	if (ply == nil || !ply:IsValid() || !ply:IsPlayer()) then
		return nil;
	end
	
	local metaPlayerData = {
        wealth = 0,
        nickname = ply:Nick(),
        player = ply,
        entities = {}
	}
	setmetatable( metaPlayerData, ClassPlayerData ) 
	
	return metaPlayerData;

end

function ClassPlayerData:RecieveMoney(amount)
    
    if ( self.player:IsValid() && isnumber(amount) ) then
        self.wealth = self.wealth + amount;
        
        net.Start("Entity_Player_Server_SendGameData");
    	net.WriteUInt(self.wealth, 32);
    	net.Send(self.player);
    	
    else
        print("No player data exists, no money given");
    end
        
end

function ClassPlayerData:ReduceMoney(amount)
    
    if ( self.player:IsValid() && isnumber(amount) ) then
        self.wealth = self.wealth - amount;
        
        net.Start("Entity_Player_Server_SendGameData");
    	net.WriteUInt(self.wealth, 32);
    	net.Send(self.player);
    	
    else
        print("No player data exists, no money given");
    end
        
end

setmetatable( ClassPlayerData, {__call = ClassPlayerData.new } )


net.Receive( "Entity_Player_Client_RequestGameData", function( msgLength, ply )
    net.Start("Entity_Player_Server_SendGameData");
	net.WriteUInt(ply.gamedata.wealth, 32);
	net.Send(ply);
end )

net.Receive( "Entity_RequestGameData", function( msgLength, ply )
    
    local entityData = net.ReadEntity();
    
    net.Start("Entity_SendGameData");
    net.WriteEntity(entityData);
	net.WriteTable(entityData.gamedata);
	net.Send(ply);
end )

concommand.Add( "getWealth", function( ply, cmd, args ) 
	
	net.Start("Entity_Player_GetWealth")
	net.WriteUInt(ply.gamedata.wealth, 32)
	net.Send(ply)
	
end)

concommand.Add( "reloadPlayerData", function( ply, cmd, args ) 
	
	for k, v in pairs( player.GetAll() ) do
        InitializePlayerData(v);    
    end
	
end)