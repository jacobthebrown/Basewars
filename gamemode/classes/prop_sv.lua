Object_Prop = {};
Object_Prop.__index = Object_Prop;
GameObject:Register( "Object_Prop", Object_Prop)
local Object = Object_Prop;

--//
--//	Constructs a spawn point object.
--//
function Object:new( ply, ent )
	
	local metaProperties = {
		entityType = "Object_Prop",
		maxHealth = 100
	}
	
	return GameObject:newProp(Object, metaProperties, ent, ply);
end