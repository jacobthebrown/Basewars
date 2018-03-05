Obj_VendingMachine = Obj_VendingMachine or {};
Obj_VendingMachine.__index = Obj_VendingMachine;

--//
--//	Constructs a Soda Vending Machine object.
--//
function Obj_VendingMachine:new( ply, pos )
	
	local metaProperties = {
		entityType = "item_vendingmachine",
		propModel = "models/props_interiors/VendingMachineSoda01a.mdl",
		lastDispensed = 0,
		owner = ply or nil,
		ent = nil
	}
	
	return GameObject:new(Obj_VendingMachine, metaProperties, ply, pos);
end

function Obj_VendingMachine:Use(ply, ent)
	if (ply:IsValid() && CurTime() >= self.lastDispensed + 1) then 
	    Obj_Soda:new( ply, ent:LocalToWorld(Vector(20,-5,-25)), Angle(90,0,90) )
	    self.lastDispensed = CurTime();
	    self.ent:EmitSound("buttons/button4.wav")
    end
    
end

--[[
--			
--		Console Command Functions.
--
--]]
concommand.Add( "createVendingMachine", function( ply, cmd, args ) 
	
    local trace = {};
    trace.start = ply:EyePos();
    trace.endpos = trace.start + ply:GetAimVector() * 85;
    trace.filter = ply;
    
    local tr = util.TraceLine(trace);
    
	local newVendingMachine = Obj_VendingMachine:new(ply, tr.HitPos); 
	
	table.insert(ply.gamedata.entities, newVendingMachine)
	
end)