local MODULE = BW.util;

--//
--//	Creates an source engine entity given a type, position, and angle.
--//
function MODULE:CreateEntity(entityType, pos, angle)
    
    -- Create the physical entity that the player in the source engine.
	local ent = ents.Create(entityType);
	ent:SetPos(pos or Vector(0,0,0));
	ent:SetAngles(angle or ent:GetAngles());
	return ent;
	
end