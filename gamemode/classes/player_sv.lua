Object_Player = {};
Object_Player.__index = Object_Player;
Object_Player.members = {"player","wealth"};
GameObject:Register( "Object_Player", Object_Player)
local Object = Object_Player;

getmetatable("Player").GameObj = function(ply) return ply.gamedata; end 
getmetatable("Player").GameObj = function(ply) return ply.gamedata; end 

Object.settings = {
    CHAR = {}, 
    FRIENDS = {}, 
    TEAM = nil, 
    PPSETTINGS = {
        FRIENDSALLOWED = { 
            PROPS = true, 
            TOOL = false
            
        }, 
        TEAMALLOWED = {
            PROPS = false, 
            TOOL = false
        } 
    },
    ADMIN = true
};

--//
--//    Constructs a new object to store player data.
--//
function Object:new( ply )

	local metaPlayer = {
        wealth = 0,
        player = ply,
        settings = {};
	}

    table.CopyFromTo(Object.settings, metaPlayer.settings);

	return GameObject:newPlayer(Object, metaPlayer, ply);
end

--//
--//    Set player's wealth.
--//
function Object:SetWealth(amount)
    
    if ( self.player:IsValid() && isnumber(amount) ) then
        self.wealth = amount;

        GameObject:SendGameDataSingle(self:GetPlayer(), self);
    else
        print("PlayerData:RecieveMoney() - No player data exists, or money given");
    end
        
end

--//
--//    Give player wealth.
--//
function Object:GiveWealth(amount)
    
    if ( self.player:IsValid() && isnumber(amount) ) then
        self:SetWealth(self.wealth + amount);
    else
        print("PlayerData:RecieveMoney() - No player data exists, or money given");
    end
        
end

--//
--//    Take player's wealth.
--//
function Object:TakeWealth(amount)
    
    if ( self.player:IsValid() && isnumber(amount) ) then
        self:SetWealth(self.wealth - amount);
    else
        print("PlayerData:RecieveMoney() - No player data exists, or money given");
    end
        
end

function Object:AddFriend(targetPlayer)
    
    if (targetPlayer && targetPlayer:IsPlayer()) then
       self.settings.FRIENDS[targetPlayer] = true;
    end
    
end

function Object:RemoveFriend(targetPlayer)
    
    if (targetPlayer && targetPlayer:IsPlayer()) then
       self.settings.FRIENDS[targetPlayer] = nil;
    end
    
end

concommand.Add( "addFriend", function( ply, cmd, args ) 

    local ent = ply:GetEyeTrace().Entity;
    
    if (ent && ent:IsPlayer()) then
       
        ply.gamedata:AddFriend(ent);
        
    end

end)

concommand.Add( "removeFriend", function( ply, cmd, args ) 

    local ent = ply:GetEyeTrace().Entity;
    
    if (ent && ent:IsPlayer()) then
       
        ply.gamedata:RemoveFriend(ent);
        
    end

end)