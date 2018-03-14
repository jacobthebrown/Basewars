Object_Player = {};
Object_Player.__index = Object_Player;
Object_Player.members = {"wealth", "settings"};
GameObject:Register( "Object_Player", Object_Player)
local Object = Object_Player;

Object.settings = {
    CHAR = {}, 
    FRIENDS = {}, 
    TEAM = nil, 
    PPSETTINGS = {
        FRIENDSALLOWED = { 
            PROPS = false, 
            TOOL = false
            
        }, 
        TEAMALLOWED = {
            PROPS = false, 
            TOOL = false
        } 
    },
    ADMIN = false
};

--//
--//    Constructs a new object to store player data.
--//
function Object:new( ply )

	local metaobject = {
        wealth = 0,
        settings = table.Copy(Object.settings)
	}

	return GameObject:newPlayer(Object, metaobject, ply);
end

--//
--//    Set player's wealth.
--//
function Object:SetWealth(amount)
    
    if ( self:GetEntity():IsValid() && isnumber(amount) ) then
        self.wealth = amount;

        GameObject:SendGameObjectDataSingle(self:GetEntity(), self);
    else
        print("PlayerData:RecieveMoney() - No player data exists, or money given");
    end
        
end

--//
--//    Give player wealth.
--//
function Object:GiveWealth(amount)
    
    print(self.entityID)
    
    if ( self:GetEntity():IsValid() && isnumber(amount) ) then
        self:SetWealth(self.wealth + amount);
    else
        print("PlayerData:RecieveMoney() - No player data exists, or money given");
    end
        
end

--//
--//    Take player's wealth.
--//
function Object:TakeWealth(amount)
    
    if ( self:GetEntity():IsValid() && isnumber(amount) ) then
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

function Object:OnTakeDamage(dmginfo)

    local ply = self:GetEntity();
    local newHealth = ply:Health() - dmginfo:GetBaseDamage();
    
    if (newHealth <= 0) then
        ply:Kill()
    end
    
    self:GetOwner():SetHealth(newHealth);
end

function Object:OnPhysgunPickup()
    return false
end

concommand.Add( "addFriend", function( ply, cmd, args ) 

    local ent = ply:GetEyeTrace().Entity;
    
    if (ent && ent:IsPlayer()) then
       
        ply.gameobject:AddFriend(ent);
        
    end

end)

concommand.Add( "removeFriend", function( ply, cmd, args ) 

    local ent = ply:GetEyeTrace().Entity;
    
    if (ent && ent:IsPlayer()) then
       
        ply.gameobject:RemoveFriend(ent);
        
    end

end)