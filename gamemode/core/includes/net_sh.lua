--
-- LMAOLLAMA / LLAMALORDS - This whole function has been re-written.
--
function net.WriteTable( tab, functionToString )

	for k, v in pairs( tab ) do
		
		-- LMAOLLAMA / LLAMALORDS - EDIT
		if (k == "__index" || k == "__metatable") then 
			continue; 
		end
		
		-- LMAOLLAMA / LLAMALORDS - EDIT
		-- LMAOLLAMA: FIX FOR NETCODE
		
		if (isfunction(v)) then
		
			if (!functionToString) then
				continue;
			else
				net.WriteType( tostring(k) )
				net.WriteType( "STRINGIFIED: "..tostring(v) );
				continue;
			end
		end
	
		net.WriteType( k )
		net.WriteType( v, functionToString )
	
	end
	
	-- End of table
	net.WriteType( nil )

end

-- LMAOLLAMA / LLAMALORDS TYPE_TABLE
-- THIS FUNCTION HAS BEEN MODIFIED BY LMAO LALAM
net.WriteVars = 
{
	[TYPE_NIL]			= function ( t, v )	net.WriteUInt( t, 8 )								end,
	[TYPE_STRING]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteString( v )		end,
	[TYPE_NUMBER]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteDouble( v )		end,
	[TYPE_TABLE]		= function ( t, v, carryon )	net.WriteUInt( t, 8 )	net.WriteTable( v, carryon )			end,
	[TYPE_BOOL]			= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteBool( v )			end,
	[TYPE_ENTITY]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteEntity( v )		end,
	[TYPE_VECTOR]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteVector( v )		end,
	[TYPE_ANGLE]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteAngle( v )			end,
	[TYPE_MATRIX]		= function ( t, v ) net.WriteUInt( t, 8 )	net.WriteMatrix( v )		end,
	[TYPE_COLOR]		= function ( t, v ) net.WriteUInt( t, 8 )	net.WriteColor( v )			end,
	
}

-- LMAOLLAMA / LLAMALORDS
-- THIS FUNCTION HAS BEEN MODIFIED
function net.WriteType( v, carryon )
	local typeid = nil

	if IsColor( v ) then
		typeid = TYPE_COLOR
	else
		typeid = TypeID( v )
	end

	local wv = net.WriteVars[ typeid ]
	if ( wv ) then return wv( typeid, v, carryon ) end
	
	error( "net.WriteType: Couldn't write " .. type( v ) .. " (type " .. typeid .. ")" )

end