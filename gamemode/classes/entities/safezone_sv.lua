local Object = {};

Object.members = {
		model = "models/props_combine/combinethumper002.mdl",
	}

Object.FLAGS = { UNBUYABLE = true };

--//
--//	Constructs a money printer object.
--//
function Object:new( ply, position, maxBalance, printAmount )
	return GameObject:new(Object, clone(Object.members), ply, position);
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

--Trigger to player (entering safe szone), send curtime to sync with draw.
function SafeZoneCheck(ply)
		
	for k, v in pairs (ents.GetAll()) do
		
		if (!v.GetObject && v:GetObject():GetType() != "Object_SafeZone") then
			continue;	
		end

		
		local minVectorLocal = v:OBBMins() + Vector(-200,-200,0);
		local maxVectorLocal = v:OBBMaxs() + Vector(200,200,0);
		local absolutePos1 = v:LocalToWorld(minVectorLocal);
		local absolutePos2 = v:LocalToWorld(maxVectorLocal);
		
		local minPos = minVector(absolutePos1, absolutePos2);
		local maxPos = maxVector(absolutePos1, absolutePos2);
		
		local nope = false;
		for k, v in pairs (ents.FindInBox( minPos, maxPos )) do
			
			if (v == ply) then
				return false;
			end
		end
	end
	
	
end
hook.Add("PlayerShouldTakeDamage", "Hook_SafeZoneCheck", SafeZoneCheck)

GameObject:Register( "Object_SafeZone", Object);