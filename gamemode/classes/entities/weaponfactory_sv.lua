local Object = {};

Object.members = {
	model = "models/props_wasteland/laundry_washer003.mdl",
}

--//
--//	Constructs a weapon factory object.
--//
function Object:new( ply, position, maxBalance, printAmount )
	
	return GameObject:new(Object, table.Copy(Object.members), ply, position);
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function Object:Use(ply, ent)
	if (!ply:HasWeapon( "weapon_bw_pistol" )) then
        ply:Give("weapon_bw_pistol");
	end
end

GameObject:Register( "Object_WeaponFactory", Object);