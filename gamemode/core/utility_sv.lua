BW.utility = {};
local utility = BW.utility;

function utility:CreateEntity(entType, obj, pos, angle)
    
    -- Create the physical entity that the player in the source engine.
	local ent = ents.Create(entType);
	ent:SetPos(pos or Vector(0,0,0));
	ent:SetAngles(angle or ent:GetAngles());
	ent.gamedata = obj;
	return ent;
	
end