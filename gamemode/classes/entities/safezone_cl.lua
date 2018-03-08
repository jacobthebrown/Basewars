Object_SafeZone = {};
Object_SafeZone.__index = Object_SafeZone;
GameObject:Register( "Object_SafeZone", Object_SafeZone)
local Object = Object_SafeZone;

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

	local vectorOffset = Vector(17,0,50)
	local angleOffset = Angle(0,90,90)
	local scale = 0.1
	
	local angle = self.ent:GetAngles()

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
	
	local width = math.abs(self.ent:OBBMins().x) + math.abs(self.ent:OBBMaxs().x);
	local girth = math.abs(self.ent:OBBMins().y) + math.abs(self.ent:OBBMaxs().y);
	
	local minVectorLocal = self.ent:OBBMins() + Vector(-200,-200,0);
	local maxVectorLocal = self.ent:OBBMaxs() + Vector(200,200,0);

	render.DrawWireframeBox( self.ent:LocalToWorld(Vector(0,0,0)) ,self.ent:GetAngles(), minVectorLocal, maxVectorLocal, Color(255,255,255,255), true )
	
	local absolutePos1 = self.ent:LocalToWorld(minVectorLocal);
	local absolutePos2 = self.ent:LocalToWorld(maxVectorLocal);
	
	local minPos = minVector(absolutePos1, absolutePos2);
	local maxPos = maxVector(absolutePos1, absolutePos2);

end

--//
--// Garbage collects the object.
--//
function Object:Remove() 
	GameObject:RemoveGameObject(self);
end
