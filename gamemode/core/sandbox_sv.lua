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

	return true;

end

function GM:PlayerSpawnNPC( ply ) 

	return true;

end

function GM:PlayerSpawnEffect( ply ) 

	return true;

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

	return true;

end

function GM:PlayerSpawnSENT( ply ) 

	return true;

end

function GM:PlayerSpawnSWEP( ply ) 

	return true;

end

function GM:PlayerSpawnVehicle( ply ) 

	return true;

end

function GM:OnPhysgunReload( physgun, ply )
	
	return false;	
	
end