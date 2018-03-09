Object_Soda = {};
Object_Soda.__index = Object_Soda;
local Object = Object_Soda;
   
--//
--//	Constructs a soda object.
--//
function Object:new( ply, pos, angle )
	
	local metaProperties = {
		entityType = "Object_Soda",
		propModel = "models/props_junk/PopCan01a.mdl",
		owner = ply or nil,
		ent = nil,
		used = false;
	}
	
	return GameObject:new(Object, metaProperties, ply, pos, angle);
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function Object:Use(ply, ent)
	if (ply:IsValid() and !self.used) then 
		GameObject:TriggerEventLocal(ply, self.ent, self, "DrinkSoda", {FLAGS = {ENTREMOVED = true}});
		
		self.used = true; 
		ent:Remove();
		
    end
    
end