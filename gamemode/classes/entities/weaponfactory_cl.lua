local Object = {};

--//
--//	Constructs a vending machine object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end	

GameObject:Register( "Object_WeaponFactory", Object);