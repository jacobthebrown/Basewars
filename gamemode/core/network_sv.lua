BW.network = {};
local MODULE = BW.network;

--//
--//	TODO
--//
function MODULE:InitializeNetworkStrings()
	util.AddNetworkString("GameObject_SendGameDataSingle");
	util.AddNetworkString("GameObject_SendGameDataMany");
	util.AddNetworkString("GameObject_SendTriggerEvent")

end
hook.Add("Initialize", "Initialize_InitializeNetworkStrings", MODULE.InitializeNetworkStrings)

--//
--//	TODO
--//
function MODULE:InitializeUpdateGameObjectsTimer()
	
	if (timer.Exists( "Timer_UpdateGameObjects" )) then
		timer.Remove( "Timer_UpdateGameObjects" )
	end
	
	timer.Create( "Timer_UpdateGameObjects", 1, 0, function() 
	
		for key, ply in pairs (player.GetAll()) do
			local entitiesToUpdate = {};
			for key_2, ent in pairs (ents.FindInSphere(ply:GetPos(), 512)) do
				if (ent && !ent:IsPlayer() && ent.gamedata != nil) then
					table.insert(entitiesToUpdate, { entIndex = ent:EntIndex(), gamedata = ent.gamedata})
				end
			end

			if (table.Count(entitiesToUpdate) > 0) then
				GameObject:SendGameDataMany(ply, entitiesToUpdate);
			end
		
		end
	end );
end
hook.Add("OnReloaded", "OnReloaded_InitializeUpdateGameObjectsTimer", MODULE.InitializeUpdateGameObjectsTimer)
hook.Add("PostGamemodeLoaded", "PostGamemodeLoaded_InitializeUpdateGameObjectsTimer", MODULE.InitializeUpdateGameObjectsTimer)

--//
--//	TODO
--//
function MODULE:InitializeUpdatePlayerTimer()
	
	if (timer.Exists( "Timer_UpdatePlayers" )) then
		timer.Remove( "Timer_UpdatePlayers" )
	end
	
	timer.Create( "Timer_UpdatePlayers", 0.1, 0, function() 
	
		for key, ply in pairs (player.GetAll()) do
			if (ply && ply.gamedata) then
				GameObject:SendGameDataSingle(ply, ply.gamedata);
			end
		end
	end );
end
hook.Add("OnReloaded", "OnReloaded_Create", MODULE.InitializeUpdatePlayerTimer)
hook.Add( "PostGamemodeLoaded", "Init_CreateUpdatePlayerTimer", MODULE.InitializeUpdatePlayerTimer )