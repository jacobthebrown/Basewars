BW.utility = {};
local MODULE = BW.utility;

--//
--//	Using TableA as the most complete source of table data, compares tblB
--//	to tblA to see what tblB is missing compared to tblA
--//

function table.FindDif( dif, tblA, tblB, depth )
	
	depth = depth + 1;

	-- We look through Table A, Table A should have the most information.
	for k_tblA, v_tblA in pairs(tblA) do
		
		print("Key/Value:")
		
		if (istable(v_tblA) && istable(tblB[k_tblA])) then
		--	print(depth.." | "..k_tblA.." | ") PrintTable(v_tblA or {})
			--print(depth.." | "..k_tblA.." | ") PrintTable(tblB[k_tblA] or {})
		else
			--print(depth.." | "..k_tblA.." | ".. (v_tblA or "nil"))
			--print(depth.." | "..k_tblA.." | ".. (tblB[k_tblA] or "nil"))
		end
		
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

function table.AddMany(tbls)
	
	local union = {};
	
    for k,v in pairs(tbls) do
    	table.Add(union, v);
    end
    
    return union;
end


--local tableA = {a=1,b=2,c=3, d={a='1',b='2',c="3"}};	-- Current Data 
--local tableB = {a=1,c=3, d=100}							-- Cache Data
--local dif = {};
--
--tableB = player.GetByID(2):GetObject();
--tableA = player.GetByID(3):GetObject();
--
--player.GetByID(2):GetObject().settings = {};
--
--table.FindDif( dif, tableA, tableB, 0 )
--
--
--print("Difference")
--PrintTable(dif)

--//

function MODULE:GetEntityByEdic(edicID, prediction)

	if (!isnumber(edicID)) then
		error("GetEntityByEdic was not given a number!")
	end
	
	if (prediction && prediction:IsValid()) then
	
		local edic = prediction:GetNWInt('EdicID', nil);
		
		--print("Edic: "..edic);
		
		if (edic == edicID) then
			return prediction;	
		end
		
	end

	local entitysearch = ents.GetAll();
	
	--PrintTable(entitysearch)
	
	local entFound = nil;
	
	for k, ent in pairs (entitysearch) do
		
		local edic = ent:GetNWInt('EdicID', nil);
		
		if (edic && edic == edicID) then
			entFound = ent;
			break;
		end
	end
	
	for k, ply in pairs (player.GetAll()) do
		
		local edic = ply:GetNWInt('EdicID', nil);
		
		if (edic && edic == edicID) then
			entFound = ply;
			break;
		end

	end

	return entFound;

end


function MODULE:TableToStringDetailed( tbl, indent, done )

	done = done or {}
	indent = indent or 0
	local keys = table.GetKeys( tbl )

	table.sort( keys, function( a, b )
		if ( isnumber( a ) && isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

    local concatString = "";

	for i = 1, #keys do
		local key = keys[ i ]
		local value = tbl[ key ]
		concatString = concatString .. string.rep( "\t", indent )

		if  ( istable( value ) && !done[ value ] ) then

			done[ value ] = true
			concatString = concatString .. tostring( key ) .. ":" .. "\n";
			concatString = concatString .. PrintTable ( value, indent + 2, done )
			done[ value ] = nil

		else

			concatString = concatString .. tostring( key ) .. "\t=\t";
			concatString = concatString .. tostring( value ) .. "\n" ;

		end
    
    end

    return concatString;

end

function MODULE:TableToStringCompact( tbl, indent, done )

	done = done or {}
	indent = indent or 0
	local keys = table.GetKeys( tbl )

	table.sort( keys, function( a, b )
		if ( isnumber( a ) && isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

    local concatString = "";

	for i = 1, #keys do
		local key = keys[ i ]
		local value = tbl[ key ]

		if  ( istable( value ) && !done[ value ] ) then

			done[ value ] = true;
			concatString = concatString .. "[" .. tostring( key ) .. "]" .. ":";
			concatString = concatString .. MODULE:TableToStringCompact ( value, done )
			done[ value ] = nil;

		else

			concatString = concatString .. "[" .. tostring( key ) .. "]:" -- .. "\t=\t";
			concatString = concatString .. " " .. tostring( value ) .. " " ;

		end
    
    end

    return concatString;

end
