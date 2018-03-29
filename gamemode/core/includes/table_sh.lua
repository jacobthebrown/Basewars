--//
--// Recursively counts every element in a table.
--//
function table.countRecursive( source, runningCount )

	if (runningCount == nil) then
		runningCount = 0;
	end

	for k_source, v_source in pairs(source) do
		
		if (type( v_source )=="table") then
			table.countRecursive( v_source, runningCount )
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
--//	Using TableA as the most complete source of table data, compares tblB
--//	to tblA to see what tblB is missing compared to tblA
--//
function table.FindDif( dif, tblA, tblB, depth )
	
	depth = depth + 1;

	-- We look through Table A, Table A should have the most information.
	for k_tblA, v_tblA in pairs(tblA) do
		
		-- If both tables contain a table for this key, we recurse.
		if (istable(v_tblA) && (istable(tblB[k_tblA]))) then

            -- If we have already recursed, dif won't exist since it didn't have that key,value pair
            -- Therefore we need to use the parent key/value to make create it.
  			 dif[k_tblA] = {};
  			
            -- Since the values of tableA[key] and tableB[keys] were both tables, then
            -- we need to go deeper and find the difference in those tables.
  			table.FindDif( dif[k_tblA], v_tblA, tblB[k_tblA], depth )
  			
            -- If we come back out of the recursion, and dif[tableAkey] is empty then we don't
            -- need it.
  			if (!next(dif[k_tblA])) then
				dif[k_tblA] = nil;
			end
			
		else
			if((v_tblA == tblB[k_tblA])) then
				continue;
			elseif (istable(v_tblA)) then
				dif[k_tblA] = table.Copy(v_tblA);	
			else
				dif[k_tblA] = v_tblA;
			end
		end
		
	end
end

--//
--//	Adds many tables together.
--//
function table.AddMany(tbls)
	
	local union = {};
	
    for k,v in pairs(tbls) do
    	table.Add(union, v);
    end
    
    return union;
end
