Object_Soda = Object_Soda or {};
Object_Soda.__index = Object_Soda;
local Object = Object_Soda;
   
--//
--//	Constructs a soda object.
--//
function Object:new( ply, pos, angle )
	
	local metaProperties = {
		entityType = "item_soda",
		propModel = "models/props_junk/PopCan01a.mdl",
		owner = ply or nil,
		ent = nil
	}
	
	return GameObject:new(Object, metaProperties, ply, pos, angle);
end

function Object:Use(ply, ent)
	if (ply:IsValid()) then 
    	ent:Remove();
    	PrintMessage( HUD_PRINTCENTER, "You drink the can of soda."); 
    end
    
end

function Object:Remove()
	if (self.owner != nil && self.owner.gamedata != nil) then 
    	table.RemoveByValue( self.owner.gamedata.entities, self )
    end
end

--[[
--			
--		Console Command Functions.
--
--]]
concommand.Add( "createSoda", function( ply, cmd, args ) 
	
    local trace = {};
    trace.start = ply:EyePos();
    trace.endpos = trace.start + ply:GetAimVector() * 85;
    trace.filter = ply;
    
    local tr = util.TraceLine(trace);
    
	local newSoda = Object_Soda:new(ply, tr.HitPos); 
	
	table.insert(ply.gamedata.entities, newSoda)
	
end)

