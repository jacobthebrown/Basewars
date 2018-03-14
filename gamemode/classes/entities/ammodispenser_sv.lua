Object_AmmoDispenser = {};
Object_AmmoDispenser.__index = Object_AmmoDispenser;
Object_AmmoDispenser.members = {"lastDispensed", "dispenserRate"};
GameObject:Register( "Object_AmmoDispenser", Object_AmmoDispenser);
local Object = Object_AmmoDispenser;


--//
--//	Constructs a ammo dispenser object for the server.
--//
function Object:new( ply, position, maxBalance, printAmount )
	
	local metaInstance = {
		objectType = "Object_AmmoDispenser",
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
	
	if (currentTime >= self:GetLastDispensed() + 1) then 
    	ply:GiveAmmo(10, ply:GetActiveWeapon():GetPrimaryAmmoType());
    	self:SetLastDispensed(currentTime);
    end
    
end