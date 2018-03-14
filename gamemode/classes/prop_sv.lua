Object_Prop = {};
Object_Prop.__index = Object_Prop;
GameObject:Register( "Object_Prop", Object_Prop)
local Object = Object_Prop;

--//
--//	Constructs a spawn point object.
--//
function Object:new( ply, ent )
	
	local model_min, model_max = ent:GetModelBounds();
	local modelsize = model_min:DistToSqr( model_max ) 
	local health = math.min(10000, bit.rshift( modelsize, 4));
	
	if (health == 0) then
		health = 100;
	end
	
	local metaProperties = {
		maxHealth = health
	}
	
	return GameObject:newProp(Object, metaProperties, ent, ply);
end