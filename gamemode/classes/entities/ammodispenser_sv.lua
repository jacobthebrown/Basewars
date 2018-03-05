Object_AmmoDispenser = Object_AmmoDispenser or {};
Object_AmmoDispenser.__index = Object_AmmoDispenser;
local Object = Object_AmmoDispenser;


--//
--//	Constructs a money printer object.
--//
function Object:new( ply, position, maxBalance, printAmount )
	
	local metaProperties = {
		entityType = "obj_ammodispenser",
		propModel = "models/items/ammocrate_grenade.mdl",
		owner = ply or nil,
		ent = nil,
		lastDispensed = 0;
	}
	
	return GameObject:new(Object, metaProperties, ply, position);
end

--//	The function given to the physical entity to be called on ENT:Use.
--//
function Object:Use(ply, ent)
	if (CurTime() >= self.lastDispensed + 2) then 
    	self.lastDispensed = CurTime();
    	ply:GiveAmmo(10, ply:GetActiveWeapon():GetPrimaryAmmoType());
    end
    
end

--//
--// Garbage collect money printer.
--// TODO: Make sure garbage collection is actually happening.
--//
function Object:Remove() 
	table.RemoveByValue( self.owner.gamedata.entities, self )
end

--[[
--		
--		Console Command Functions.
--
--]]
concommand.Add( "createAmmoDispenser", function( ply, cmd, args ) 
	
    local trace = {};
    trace.start = ply:EyePos();
    trace.endpos = trace.start + ply:GetAimVector() * 85;
    trace.filter = ply;
    
    local tr = util.TraceLine(trace);
	local newObject = Object_AmmoDispenser:new(ply, tr.HitPos); 
	
	table.insert(ply.gamedata.entities, newObject)
	
end)