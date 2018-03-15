local Object = {}
Object.members = {
	model = "models/items/ammocrate_grenade.mdl",
	lastDispensed = 0,
	dispenserRate = 1;
	
};

--//
--//	Constructs a ammo dispenser object for the server.
--//
function Object:new( ply, position, dispenserRate )
	return GameObject:new(Object, clone(Object.members), ply, position);
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function Object:Use(ply, ent)
	
	local currentTime = CurTime();
	
	if (currentTime >= self:GetLastDispensed() + 1) then 
    	ply:GiveAmmo(10, ply:GetActiveWeapon():GetPrimaryAmmoType());
    	self:SetLastDispensed(currentTime);
    end
    
end

GameObject:Register( "Object_AmmoDispenser", Object);