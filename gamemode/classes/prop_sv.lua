local Object = {};

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
	
	local metamembers = {
		maxHealth = health
	}
	
	return GameObject:newProp(Object, metamembers, ent, ply);
end
GameObject:Register( "Object_Prop", Object);