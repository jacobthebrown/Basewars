local Object = {};

Object.members = {
	model = "models/props_interiors/VendingMachineSoda01a.mdl",
	lastDispensed = 0
}
	

--//
--//	Constructs a Soda Vending Machine object.
--//
function Object:new( ply, pos )
	return GameObject:new(Object, clone(Object.members), ply, pos);
end

function Object:Use(ply)
	if (!ply:HasWeapon( "weapon_shotgun" )) then
    	ply:Give("weapon_shotgun");
    	
    end
    
    
    local ent = self:GetEntity();
    
	if (ply:IsValid() && CurTime() >= self.lastDispensed + 1) then 
		
		local sodaobject = GameObject:GetMetaObject("Object_Soda");
		
	    sodaobject:new( ply, ent:LocalToWorld(Vector(20,-5,-25)), ent:LocalToWorldAngles(Angle(90,0,90)) )
	    self.lastDispensed = CurTime()
	    ent:EmitSound("buttons/button4.wav")
	    ply:GiveAmmo(10, ply:GetActiveWeapon():GetPrimaryAmmoType());
    	
    end
    
end

GameObject:Register( "Object_VendingMachine", Object);