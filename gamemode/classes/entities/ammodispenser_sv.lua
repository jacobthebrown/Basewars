Object_AmmoDispenser = Object_AmmoDispenser or {};
Object_AmmoDispenser.__index = Object_AmmoDispenser;
GameObject:Register( "Object_AmmoDispenser", Object_AmmoDispenser)
local Object = Object_AmmoDispenser;


--//
--//	Constructs a ammo dispenser object for the server.
--//
function Object:new( ply, position, maxBalance, printAmount )
	
	local metaInstance = {
		entityType = "Object_AmmoDispenser",
		propModel = "models/items/ammocrate_grenade.mdl",
		lastDispensed = 0,
		dispenserRate = 1;
	}
	
	return GameObject:new(Object, metaInstance, ply, position);
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function Object:Use(ply, ent)
	
	local currentTime = CurTime();
	
	if (currentTime >= self.lastDispensed + 1) then 
    	ply:GiveAmmo(10, ply:GetActiveWeapon():GetPrimaryAmmoType());
    	self.lastDispensed = currentTime;
    end
    
end