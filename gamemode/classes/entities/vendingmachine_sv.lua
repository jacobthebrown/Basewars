Object_VendingMachine = {};
Object_VendingMachine.__index = Object_VendingMachine;
GameObject:Register( "Object_VendingMachine", Object_VendingMachine)
local Object = Object_VendingMachine;

--//
--//	Constructs a Soda Vending Machine object.
--//
function Object:new( ply, pos )
	
	local metaProperties = {
		entityType = "Object_VendingMachine",
		propModel = "models/props_interiors/VendingMachineSoda01a.mdl",
		lastDispensed = 0,
	}
	
	return GameObject:new(Object, metaProperties, ply, pos);
end

function Object:Use(ply, ent)
	if (!ply:HasWeapon( "weapon_shotgun" )) then
    	ply:Give("weapon_shotgun");
    	
    end
    
	if (ply:IsValid() && CurTime() >= self.lastDispensed + 1) then 
	    Object_Soda:new( ply, ent:LocalToWorld(Vector(20,-5,-25)), ent:LocalToWorldAngles(Angle(90,0,90)) )
	    self.lastDispensed = CurTime()
	    self.ent:EmitSound("buttons/button4.wav")
	    ply:GiveAmmo(10, ply:GetActiveWeapon():GetPrimaryAmmoType());
    	
    end
    
end
