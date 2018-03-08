Object_SpawnPoint = {};
Object_SpawnPoint.__index = Object_SpawnPoint;
GameObject:Register( "Object_SpawnPoint", Object_SpawnPoint)
local Object = Object_SpawnPoint;

--//
--//	Constructs a spawn point object.
--//
function Object:new( ply, position, angle )
	
	local metaProperties = {
		entityType = "Object_SpawnPoint",
		propModel = "models/props_trainstation/trainstation_clock001.mdl",
		owner = ply or nil,
		ent = nil
	}
	
	return GameObject:new(Object, metaProperties, ply, ply:GetPos(), Angle(-90,0,0), { UNMOVEABLE = true, UNIQUE = true, ONGROUND = true, FROZEN = true,  COLLISION = COLLISION_GROUP_DEBRIS});
end

--//
--//
--// https://wiki.garrysmod.com/page/GM/IsSpawnpointSuitable
function Object:OnOwnerSpawn()

	if (self.ent != nil) then
		self.owner:SetPos(self.ent:GetPos())
	end

end

--//
--//
--//
function Object:OnPhysgunPickup(ply)

	return false;

end

--//
--//
--// Garbage collects the object.
--//
function Object:Remove() 
	GameObject:RemoveGameObject(self);
	self.ent:Remove();
end