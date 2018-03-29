BW.util = {};
local MODULE = BW.util;

--//
--//	
--//
function MODULE:GetEntityByEdic(edicID, prediction)

	if (!isnumber(edicID)) then
		error("GetEntityByEdic was not given a number!")
	end
	
	-- If we might already know what the entity is then we see if it exists.
	if (prediction && prediction:IsValid()) then
	
		local edic = prediction:GetNWInt('EdicID', -1);
		
		if (edic == edicID) then
			return prediction;	
		end
		
	end
	
	local entFound = nil;
	
	-- Go search for the entity and find it's edic.
	for k, ent in pairs (ents.GetAll()) do
		
		local edic = ent:GetNWInt('EdicID', -1);
		
		if (edic == edicID) then
			entFound = ent;
			break;
		end
	end
	
	return entFound;

end

function MODULE:TableToStringDetailed( tbl, indent, done )

	done = done or {}
	indent = indent or 0
	local keys = table.GetKeys(tbl)

	table.sort( keys, function( a, b )
		if ( isnumber( a ) && isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

    local concatString = "";

	for i = 1, #keys do
		local key = keys[ i ]
		local value = tbl[ key ]
		
		-- Infinite stack overflow will occur.
		if (key == "__index") then
			continue;
		end
		
		concatString = concatString .. string.rep( "\t", indent )

		if  ( istable( value ) && !done[ value ] ) then

			done[ value ] = true
			concatString = concatString .. tostring( key ) .. ":" .. "\n";
			concatString = concatString .. MODULE:TableToStringDetailed ( value, indent + 2, done )
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

		if (key == "__index") then
			continue;
		end

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
