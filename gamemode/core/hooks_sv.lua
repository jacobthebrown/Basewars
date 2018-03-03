function InitializePlayerData(ply)
	ply.gamedata = PlayerData(ply);
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
	
	if (ent == nil) then
		return;
	end
	
	if (ent.gamedata == nil || ent.gamedata.temp == nil) then
		ent.gamedata = ent.gamedata or {};
		ent.gamedata.temp = ent.gamedata.temp or {};
	end
	
	local traceData = { start = ent:GetPos(), endpos = ent:GetPos(), filter = ent }

	local tr = util.TraceEntity( traceData, ent )
	if ( tr.Entity:IsValid() && tr.Entity:IsPlayer() ) then

		if (ent.gamedata.temp.IsGhosted == nil) then
			ent.gamedata.temp = {IsGhosted = true, rendermode = ent:GetRenderMode(), collisiongroup = ent:GetCollisionGroup()};
		elseif (!ent.gamedata.temp.IsGhosted) then
			ent.gamedata.temp.rendermode = ent:GetRenderMode();
			ent.gamedata.temp.collisiongroup = ent:GetCollisionGroup();
			ent.gamedata.temp.IsGhosted = true;
		end
		
		ent:SetColor(Color(255, 255, 255, 200));
		ent:SetRenderMode(RENDERMODE_TRANSALPHA);
		ent:SetCollisionGroup(COLLISION_GROUP_WEAPON);
	else
		if (ent.gamedata.temp.IsGhosted) then
			ent.gamedata.temp.IsGhosted = false;
			ent:SetColor(Color(255, 255, 255, 255));
			ent:SetRenderMode(ent.gamedata.temp.rendermode);
			ent:SetCollisionGroup(ent.gamedata.temp.collisiongroup);
		end
	end
	

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