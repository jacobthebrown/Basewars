local Object = {};

Object.members = {
	model = "models/props_junk/PopCan01a.mdl",
	used = false
};

Object.FLAGS = { UNBUYABLE = true, FROZEN = false, COLLISION = COLLISION_GROUP_DEBRIS};
   
--//
--//	Constructs a soda object.
--//
function Object:new( ply, pos, angle )
	return GameObject:new(Object, clone(Object.members), ply, pos, angle);
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

GameObject:Register( "Object_Soda", Object);