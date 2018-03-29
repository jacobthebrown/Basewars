local Object = GameObject:Register( "Object_Prop");

--//
--//	Constructs a spawn point object.
--//
function Object:new( metaInstance )
	return GameObject:new(self, metaInstance);
end