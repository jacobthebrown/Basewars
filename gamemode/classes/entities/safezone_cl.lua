local Object = {};

--//
--//	Constructs a money printer object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

--//
--//	Function for rendering the object to the client.
--//
function Object:Draw()

end

local function minVector(vec1, vec2)
	
	local zeroVector = Vector(0,0,0);
	
	if (zeroVector:DistToSqr(vec1) < zeroVector:DistToSqr(vec2) ) then
		return vec1;
	else
		return vec2;
	end
	
end

local function maxVector(vec1, vec2)
	
	local zeroVector = Vector(0,0,0);
	
	if (zeroVector:DistToSqr(vec1) > zeroVector:DistToSqr(vec2) ) then
		return vec1;
	else
		return vec2;
	end
	
end

function Object:DrawGlobal()

	local ent = self:GetEntity();
	
	local width = math.abs(ent:OBBMins().x) + math.abs(ent:OBBMaxs().x);
	local girth = math.abs(ent:OBBMins().y) + math.abs(ent:OBBMaxs().y);
	
	local minVectorLocal = ent:OBBMins() + Vector(-200,-200,0);
	local maxVectorLocal = ent:OBBMaxs() + Vector(200,200,0);

	render.DrawWireframeBox( ent:LocalToWorld(Vector(0,0,0)) ,ent:GetAngles(), minVectorLocal, maxVectorLocal, Color(255,255,255,255), true )
	
	local absolutePos1 = ent:LocalToWorld(minVectorLocal);
	local absolutePos2 = ent:LocalToWorld(maxVectorLocal);
	
	local minPos = minVector(absolutePos1, absolutePos2);
	local maxPos = maxVector(absolutePos1, absolutePos2);

end

--//
--// Garbage collects the object.
--//
function Object:Remove() 
	GameObject:RemoveGameObject(self);
end

GameObject:Register( "Object_SafeZone", Object);