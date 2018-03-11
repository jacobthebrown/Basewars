BW.debug = {};
BW.debug.enums = {network =  {low = false, medium = false, high = true}};
local MODULE = BW.debug;


-- on string concat if table print table
function MODULE:PrintStatement(args, enum) 

    local concatString = "";
    for k, v in pairs(args) do
        
        if (istable(v)) then
            concatString = concatString .. MODULE:TableToStringCompact(v);
        else
            concatString = concatString .. tostring(v);
        end
        
        
    end

    if (enum) then
        MsgC( Color( 0, 153, 255 ), "Networking: ", Color( 255, 255, 255 ), concatString, "\n"  )
    end
end

--//
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