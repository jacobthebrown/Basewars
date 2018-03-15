local Object = {};

--//
--//	Constructs a spawn point object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

GameObject:Register( "Object_Prop", Object);