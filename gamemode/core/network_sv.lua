function InitializeNetworkStrings()
	util.AddNetworkString("GameObject_SendGameDataSingle");
	util.AddNetworkString("GameObject_SendGameDataMany");
	util.AddNetworkString("GameObject_SendTriggerEvent")
	util.AddNetworkString("PlayerData_Send")

end
hook.Add( "Initialize", "Hook_InitializeNetworkStrings", InitializeNetworkStrings )



local function CreateUpdateGameObjectTimer()
	timer.Create( "Timer_UpdateGameObjects", 0.1, 0, function() 
	
		for key, ply in pairs (player.GetAll()) do
			
			local entitiesToUpdate = {};
			for key_2, ent in pairs (ents.FindInSphere(ply:GetPos(), 512)) do
				if (!ent:IsPlayer() && ent.gamedata != nil) then
					table.insert(entitiesToUpdate, { entIndex = ent:EntIndex(), gamedata = ent.gamedata})
				end
			end

			if (table.Count(entitiesToUpdate) > 0) then
				GameObject:SendGameDataMany(ply, entitiesToUpdate);
			end
		
		end
	end );
end
hook.Add( "PostGamemodeLoaded", "Init_CreateUpdateGameObjectTimer", CreateUpdateGameObjectTimer )