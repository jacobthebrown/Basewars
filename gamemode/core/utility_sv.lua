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

function table.MergeUncached( dest, source, cache, prev_dest, prev_key )

	for k_source, v_source in pairs(source) do
		if (istable(v_source) && (istable(cache[k_source]))) then

			if (dest == nil) then
				prev_dest[prev_key] = {};
				dest = prev_dest[prev_key];
			end
			
			table.MergeUncached( dest[k_source], v_source, cache[k_source], dest, k_source )
			
			if (istable(dest[k_source]) && table.Count(dest[k_source]) <= 0) then
				prev_dest[prev_key] = nil;
			end
			
		else
			if (dest == nil) then

				dest = prev_dest[prev_key];
			end
			if(k_source == "ADMIN") then
				--print(tostring(k_source).." | "..tostring(cache[k_source]))
				--print(k_source.." | "..tostring(v_source))
			end
			
			if (cache[k_source] == v_source) then
				continue;
			elseif (istable(v_source)) then
				dest[k_source] = {};
				table.CopyFromTo(v_source, dest[k_source]);	
			else
				dest[k_source] = v_source
			end
		end
		
	end
	
	
	
	return dest

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
