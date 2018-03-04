Obj_AmmoDispenser = Obj_AmmoDispenser or {};
Obj_AmmoDispenser.__index = Obj_AmmoDispenser;

--//
--//	Constructs a money printer object.
--//
function Obj_AmmoDispenser:new( ply, position, maxBalance, printAmount )
	
	local metaProperties = {
		entityType = "obj_ammodispenser",
		propModel = "models/items/ammocrate_grenade.mdl",
		owner = ply or nil,
		ent = nil,
		lastDispensed = 0;
	}
	
	return GameObject:new(Obj_AmmoDispenser, metaProperties, ply, position);
end

--//	The function given to the physical entity to be called on ENT:Use.
--//
function Obj_AmmoDispenser:Use(ply, ent)
	if (CurTime() >= self.lastDispensed + 2) then 
    	self.lastDispensed = CurTime();
    	ply:GiveAmmo(10, ply:GetActiveWeapon():GetPrimaryAmmoType());
    end
    
end

--//
--// Garbage collect money printer.
--// TODO: Make sure garbage collection is actually happening.
--//
function Obj_AmmoDispenser:Remove() 
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
	local newObject = Obj_AmmoDispenser:new(ply, tr.HitPos); 
	
	table.insert(ply.gamedata.entities, newObject)
	
end)