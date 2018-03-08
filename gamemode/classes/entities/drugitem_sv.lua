Object_DrugItem = {};
Object_DrugItem.__index = Object_DrugItem;
local Object = Object_DrugItem;
   
--//
--//	Constructs a drug item object.
--//
function Object:new( ply, pos, angle )
	
	local metaProperties = {
		entityType = "Object_DrugItem",
		propModel = "models/props_c17/trappropeller_lever.mdl",
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
		GameObject:TriggerEventLocal(ply, self.ent, self, "PickupDrugItem", {FLAGS = {ENTREMOVED = true}});
		self.used = true; 
		ent:Remove();
		
    end
    
end

--//
--// Garbage collects the object.
--//
function Object:Remove() 
	GameObject:RemoveGameObject(self);
	self.ent:Remove();
end