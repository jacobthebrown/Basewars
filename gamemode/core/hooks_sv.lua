function InitializePlayerData(ply)
	print("init spawn")
	ply.gamedata = PlayerData:new(ply);
end
hook.Add( "PlayerInitialSpawn", "Hook_InitializePlayerData", InitializePlayerData )

function CleanUpPlayerData(ply) 
	
end
hook.Add("PlayerDisconnected", "Hook_CleanUpPlayerData", CleanUpPlayerData)

-- Make physgun have a range
function OnPhysgunPickup( ply, ent )

end
hook.Add("PhysgunPickup", "Hook_OnPhysgunPickup", OnPhysgunPickup)

function OnPhysgunDrop( ply, ent )
	
	local phys = ent:GetPhysicsObject();
 
	if phys and phys:IsValid() then
		phys:EnableMotion(false);
	end
	
end
hook.Add("PhysgunDrop", "Hook_OnPhysgunDrop", OnPhysgunDrop)

function OnPlayerSpawnObject(ply, model, ent)
		
	if (ent == nil) then
		return;
	end
	
	local phys = ent:GetPhysicsObject();
 
	if phys and phys:IsValid() then
		phys:EnableMotion(false);
	end
	
end
hook.Add("PlayerSpawnedProp", "Hook_OnPlayerSpawnObject", OnPlayerSpawnObject)

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

