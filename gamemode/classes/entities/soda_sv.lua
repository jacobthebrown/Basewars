Object_Soda = {};
Object_Soda.__index = Object_Soda;
Object_Soda.members = {"used"};
GameObject:Register( "Object_Soda", Object_Soda)
local Object = Object_Soda;
   
--//
--//	Constructs a soda object.
--//
function Object:new( ply, pos, angle )
	
	local metaProperties = {
		entityType = "Object_Soda",
		propModel = "models/props_junk/PopCan01a.mdl",
		used = false;
	}
	
	return GameObject:new(Object, metaProperties, ply, pos, angle);
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function Object:Use(ply, ent)
	if (ply:IsValid() and !self:GetUsed()) then 
		GameObject:TriggerEventLocal(ply, self, "DrinkSoda", {FLAGS = {ENTREMOVED = true}});
		
		self:SetUsed(true); 
		ent:Remove();
		
    end
end