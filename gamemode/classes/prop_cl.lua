Object_Prop = {};
Object_Prop.__index = Object_Prop;
GameObject:Register( "Object_Prop", Object_Prop)
local Object = Object_Prop;

--//
--//	Constructs a spawn point object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end