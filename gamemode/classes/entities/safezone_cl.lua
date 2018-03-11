Object_SafeZone = {};
Object_SafeZone.__index = Object_SafeZone;
GameObject:Register( "Object_SafeZone", Object_SafeZone)
local Object = Object_SafeZone;

--//
--//	Constructs a money printer object.
--//
function Object:new( ply, position, maxBalance, printAmount )
	
	local metaInstance = {
		entityType = "Object_SafeZone",
		propModel = "models/props_combine/combinethumper002.mdl",
	}
	
	return GameObject:new(Object, metaInstance, ply, position);
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
		
		if (v.gamedata == nil || v.gamedata.entityType != "Object_SafeZone") then
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
