BW.hooks = {};
local MODULE = BW.hooks;


--//
--//	TODO
--//
function MODULE.InitializePlayerData(ply)
	ply.gamedata = Object_Player:new(ply);
	-GameObject.Cache[ply] = nil;
end
hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn_InitializePlayerData", MODULE.InitializePlayerData )

--//
--//	TODO
--//
function MODULE.RemovePlayerData(ply) 
	ply.gamedata:Remove();
end
hook.Add("PlayerDisconnected", "PlayerDisconnected_RemovePlayerData", MODULE.RemovePlayerData )

--//
--//	TODO
--//
function MODULE.OnPhysgunPickup(ply, ent)

	if (!ent.gamedata) then	
		return true;
	elseif (!ply || !ply.gamedata || ent:IsPlayer()) then
		return false;
	end
	
	local entityOwner = ent.gamedata:GetOwner();
	
	if (ply == entityOwner) then
		return true;	
	end
	
	if (entityOwner.gamedata.settings.FRIENDS[ply]) then
		return true;
	end
	
	return false

end
hook.Add("PhysgunPickup", "PhysgunPickup_OnPhysgunPickup", MODULE.OnPhysgunPickup )

--//
--//	TODO
--//
function MODULE.OnToolgunFire( ply, trace, tool )
	
	local ent = trace.Entity;	
	
	if (!ent.gamedata) then	
		return true;
	elseif (!ply || !ply.gamedata || ent:IsPlayer()) then
		return false;
	end
	
	local entityOwner = ent.gamedata:GetOwner();
	
	if (ply == entityOwner) then
		return true;	
	end
	
	if (entityOwner.gamedata.settings.FRIENDS[ply]) then
		return true;
	end
	
	return false
		
end
hook.Add("CanTool", "CanTool_OnToolgunFire", MODULE.OnToolgunFire )

--//
--//	TODO
--//
function MODULE.OnPhysgunDrop( ply, ent )
	
	local phys = ent:GetPhysicsObject();
 
	if phys and phys:IsValid() then
		phys:EnableMotion(false);
	end
	
end
hook.Add("PhysgunDrop", "PhysgunDrop_OnPhysgunDrop", MODULE.OnPhysgunDrop )

--//
--//	TODO
--//
function MODULE.OnPlayerSpawnObject(ply, model, ent)
	
	if (!ent) then
		return;
	end
	
	if (ent:GetClass() == "prop_physics") then
		ent.gamedata = Object_Prop:new(ply, ent);
	end
	
	local phys = ent:GetPhysicsObject();
 
	if phys and phys:IsValid() then
		phys:EnableMotion(false);
	end
	
end
hook.Add("PlayerSpawnedProp", "Hook_OnPlayerSpawnObject", MODULE.OnPlayerSpawnObject )