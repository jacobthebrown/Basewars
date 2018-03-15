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
--//	TODO
--//
function MODULE.OnPhysgunPickup(ply, ent)

	print(ply:GetObject())

	if (!ent:GetObject() || !ply || !ply:GetObject() || ent:IsPlayer()) then
		return false;
	end
	
	local entityOwner = ent:GetObject():GetOwner();
	
	if (ply == entityOwner) then
		return true;
	end
	
	if (entityOwner:GetObject().settings.FRIENDS[ply]) then
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
	
	if (entityOwner:GetObject().settings.FRIENDS[ply]) then
		return true;
	end
	
	return false
		
end
hook.Add("CanTool", "CanTool_OnToolgunFire", MODULE.OnToolgunFire )