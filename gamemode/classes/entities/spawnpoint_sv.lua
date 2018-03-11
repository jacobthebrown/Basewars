Object_SpawnPoint = {};
Object_SpawnPoint.__index = Object_SpawnPoint;
Object_SpawnPoint.members = {"lastDeath", "isSpawning"};
GameObject:Register( "Object_SpawnPoint", Object_SpawnPoint)
local Object = Object_SpawnPoint;

Object.FLAGS = { UNMOVEABLE = true, UNIQUE = true, ONGROUND = true, FROZEN = true,  COLLISION = COLLISION_GROUP_DEBRIS};

--//
--//	Constructs a spawn point object.
--//
function Object:new( ply, position, angle )
	
	local metaProperties = {
		entityType = "Object_SpawnPoint",
		propModel = "models/props_trainstation/trainstation_clock001.mdl",
		lastDeath = 0,
		isSpawning = false;
	}
	
	return GameObject:new(Object, metaProperties, ply, ply:GetPos(), Angle(-90,0,0));
end

--//
--//
--//
function Object:OnOwnerSpawn()
	
	print(owner)
	
	if (self.ent != nil) then
		self:GetOwner().isSpawning = false;
		self:GetOwner():SetPos(self.ent:GetPos())
	end
end

--//
--//
--//
function Object:OnPlayerDeathThink(ply)

	if (!self.isSpawning) then
		if ( ply:KeyPressed(IN_ATTACK) || ply:KeyPressed(IN_ATTACK2) || ply:KeyPressed(IN_JUMP) ) then

			GameObject:TriggerEventInSphere(self.ent:GetPos(), 512, self, "OnOwnerSpawnGlobal") 
			GameObject:TriggerEventLocal(ply, self, "OnOwnerSpawn") 
			self.isSpawning = true;
			
			timer.Create( "Timer_SpawnEffectEnd", 4, 1, function() 
				if (!ply:Alive() && self.isSpawning == true) then
					ply:Spawn();
				end
			end)
		end
	else
		return false;
	end
	
end

--//
--//
--//
function Object:OnPlayerDeath( victim, inflictor, attacker )
	self.isSpawning = false;
end


--//
--//
--//
function Object:OnPhysgunPickup(ply)
	return false;
end