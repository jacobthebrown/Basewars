function GM:PlayerLoadout( ply )
	ply:Give( "weapon_physgun" );
	ply:Give( "gmod_tool" );

	-- Prevent default Loadout.
	return true;
end

function GM:GetFallDamage(client, speed)
	return (speed - 580) * (100 / 444)
end

function GM:PlayerSpawnEffect( ply ) 

	return false;

end


function GM:PlayerSpawnNPC( ply ) 

	return false;

end


function GM:PlayerSpawnEffect( ply ) 

	return false;

end

function GM:PlayerSpawnProp( ply ) 

	return true;

end

function GM:PlayerSpawnNPC( ply ) 

	return true;

end

--function GM:PlayerSpawnObject( ply ) 
--
--	return false;
--
--end

function GM:PlayerSpawnRagdoll( ply ) 

	return false;

end

function GM:PlayerSpawnSENT( ply ) 

	return true;

end

function GM:PlayerSpawnSWEP( ply ) 

	return false;

end

function GM:PlayerSpawnVehicle( ply ) 

	return false;

end

-- Shortcuts for (super)admin only things.
--local IsAdmin = function(_, client) return client:IsAdmin() end

-- Set the gamemode hooks to the appropriate shortcuts.
--GM.PlayerGiveSWEP = IsAdmin
--GM.PlayerSpawnEffect = IsAdmin
--GM.PlayerSpawnSENT = IsAdmin