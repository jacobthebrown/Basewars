Object_SafeZone = {};
Object_SafeZone.__index = Object_SafeZone;
GameObject:Register( "Object_SafeZone", Object_SafeZone)
local Object = Object_SafeZone;

--//
--//	Constructs a money printer object.
--//
function Object:new( ply, position, maxBalance, printAmount )
	
	local metaInstance = {
		entityType = "Object_SafeZone",
		propModel = "models/props_combine/combinethumper002.mdl",
		owner = ply or nil,
		ent = nil,
	}
	
	return GameObject:new(Object, metaInstance, ply, position);
end

--//
--// Garbage collects the object.
--//
function Object:Remove() 
	GameObject:RemoveGameObject(self);
	self.ent:Remove();
end
