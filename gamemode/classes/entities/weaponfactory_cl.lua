Object_WeaponFactory = {};
Object_WeaponFactory.__index = Object_WeaponFactory;
GameObject:Register( "Object_WeaponFactory", Object_WeaponFactory)
local Object = Object_WeaponFactory;

--//
--//	Constructs a vending machine object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end	

print(poop)