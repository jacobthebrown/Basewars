BW.protection = {};
BW.protection.Blacklist = {};
local MODULE = BW.protection;

MODULE.Blacklist["models/props_c17/oildrum001_explosive.mdl"] = true;

function MODULE.PlayerSpawnProp(ply, model)

    if (MODULE.Blacklist[model]) then
        return false;
    end

end
hook.Add("PlayerSpawnProp", "PlayerSpawnProp_OnPhysgunPickup", MODULE.PlayerSpawnProp )

--//
--//	Disables physics for all source engine entities on physgun drop.
--//
function MODULE.OnPhysgunDrop( ply, ent )
	
	local phys = ent:GetPhysicsObject();
 
	if phys and phys:IsValid() then
		phys:EnableMotion(false);
	end
	
end
hook.Add("PhysgunDrop", "PhysgunDrop_OnPhysgunDrop", MODULE.OnPhysgunDrop )

--//
--//	Disables physics for all source engine entities spawn.
--//
function MODULE.OnPlayerSpawnObject(ply, model, ent)
	
	if (!ent) then
		return;
	end
	
	if (ent:GetClass() == "prop_physics") then
		local metaobject =  GameObject:GetMetaObject("Object_Prop");
		ent:SetObject(metaobject:new(ply, ent));
	end
	
	local phys = ent:GetPhysicsObject();
 
	if phys and phys:IsValid() then
		phys:EnableMotion(false);
	end
	
end
hook.Add("PlayerSpawnedProp", "Hook_OnPlayerSpawnObject", MODULE.OnPlayerSpawnObject )

--//
--//	TODO
--//
function MODULE.OnPhysgunPickup(ply, ent)

	local playerobject = ply:GetObject();
	local entobject = ent:GetObject();

	if (!entobject || !ply || !playerobject || ent:IsPlayer()) then
		return false;
	end
	
	local entityOwner = entobject:GetOwner();
	
	if (ply == entityOwner) then
		return true;
	end
	
	print(entityOwner)
	
	if (entityOwner:GetObject().settings.FRIENDS[ply:SteamID64()]) then
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
	
	if (ent:GetObject() && (ent:GetClass() != "prop_physics" || !ply || !ply:GetObject() || ent:IsPlayer()) ) then
		return false;
	elseif (!ent:GetObject()) then
		return true;
	end
	
	local entityOwner = ent:GetObject():GetOwner();
	
	if (ply == entityOwner) then
		return true;	
	end
	
	if (entityOwner:GetObject().settings.FRIENDS[ply:SteamID64()]) then
		return true;
	end
	
	return false
		
end
hook.Add("CanTool", "CanTool_OnToolgunFire", MODULE.OnToolgunFire )

