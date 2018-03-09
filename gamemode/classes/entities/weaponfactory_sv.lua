Object_WeaponFactory = {};
Object_WeaponFactory.__index = Object_WeaponFactory;
GameObject:Register( "Object_WeaponFactory", Object_WeaponFactory)
local Object = Object_WeaponFactory;

--//
--//	Constructs a weapon factory object.
--//
function Object:new( ply, position, maxBalance, printAmount )
	
	local metaProperties = {
		entityType = "Object_WeaponFactory",
		propModel = "models/props_wasteland/laundry_washer003.mdl",
	}
	
	return GameObject:new(Object, metaProperties, ply, position);
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function Object:Use(ply, ent)
	if (!ply:HasWeapon( "weapon_bw_pistol" )) then
        ply:Give("weapon_bw_pistol");
	end
end