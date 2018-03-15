local MODULE = BW.utility;

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

function table.countRecursive( source, runningCount )

	if (runningCount == nil) then
		runningCount = 0;
	end

	for k_source, v_source in pairs(source) do
		
		if (type( v_source )=="table") then
			table.countRecursive( v_source, v_source, cache[k_source], dest, k_source )
		else
			runningCount = runningCount + 1;
		end
	end
	return runningCount;

end

function table.IsEmpty( tbl )
	return next( tbl ) == nil
end

--//
--//
--//
function clone(tbl)
	return table.Copy(tbl);
end