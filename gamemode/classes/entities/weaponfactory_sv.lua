Obj_WeaponFactory = Obj_MoneyPrinter or {};
Obj_WeaponFactory.__index = Obj_MoneyPrinter;

--//
--//	Constructs a money printer object.
--//
function Obj_WeaponFactory:new( ply, position, maxBalance, printAmount )
	
	local metaProperties = {
		entityType = "obj_weaponfactory",
		propModel = "models/props_wasteland/laundry_washer003.mdl",
		owner = ply or nil,
		ent = nil
	}
	
	return GameObject:new(Obj_WeaponFactory, metaProperties, ply, position);
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function Obj_WeaponFactory:Use(ply, ent)	
	
	if (!ply:HasWeapon( "weapon_pistol" )) then
        ply:Give("weapon_pistol");
    else
        
    end
    
end

--//
--// Garbage collect money printer.
--// TODO: Make sure garbage collection is actually happening.
--//
function Obj_WeaponFactory:Remove() 
	table.RemoveByValue( self.owner.gamedata.entities, self )
end


--[[
--		
--		Console Command Functions.
--
--]]
concommand.Add( "createWeaponFactory", function( ply, cmd, args ) 
	
    local trace = {};
    trace.start = ply:EyePos();
    trace.endpos = trace.start + ply:GetAimVector() * 85;
    trace.filter = ply;
    
    local tr = util.TraceLine(trace);
	local newPrinter = Obj_WeaponFactory:new(ply, tr.HitPos); 
	
	table.insert(ply.gamedata.entities, newPrinter)
	
end)