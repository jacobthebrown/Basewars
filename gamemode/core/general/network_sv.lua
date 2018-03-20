BW.network = {};
local MODULE = BW.network;

--//
--//	Initializes all netowrk strings used in the net library.
--//
function MODULE:InitializeNetworkStrings()
	
	-- 
	util.AddNetworkString("GameObject_SendGameObjectData_AboutOne");
	util.AddNetworkString("GameObject_SendGameObjectData_AboutMany");
	util.AddNetworkString("GameObject_SendTriggerEvent")
	util.AddNetworkString("GameObject_PlayerFullyLoaded")
	util.AddNetworkString("GameObject_Upgrade")
	
	-- When a client tells us he's fully loaded the first rendered frame of the
	-- game we call the player fully loaded hook
	net.Receive("GameObject_PlayerFullyLoaded", function(len,ply)
		-- TODO: Do a check to make sure the player is not spam calling this.
		hook.Call("PlayerFullyLoaded", nil, ply)
	end)

end
hook.Add("Initialize", "Initialize_InitializeNetworkStrings", MODULE.InitializeNetworkStrings)

--//
--//	Initalizes timer which networks game object data to the client. 
--//
function MODULE:InitNetworkTimers()
	
	if (timer.Exists( "Timer_NetworkGameObjects" )) then
		timer.Remove( "Timer_NetworkGameObjects" )
	end
	
	timer.Create( "Timer_NetworkGameObjects", 0.25, 0, function() 
	
		-- Iterate through all players and send them game object data.
		local allplayers = player.GetAll();
		for i=1, #allplayers do
			local objectsToUpdate = {};
			
				
			if (!allplayers[i]:GetObject()) then
				continue;
			end
			
			local entsInPVS = ents.FindInPVS(allplayers[i]:GetPos());
			for j=1, #entsInPVS do
				if (entsInPVS[j] && entsInPVS[j]:GetObject()) then
					table.insert(objectsToUpdate, entsInPVS[j]:GetObject());
				end
			end

			if (!table.IsEmpty(objectsToUpdate)) then
				GameObject:SendGameObjectDataMany(allplayers[i], objectsToUpdate);
			end
		
		end
	end );
end
hook.Add("OnReloaded", "OnReloaded_InitNetworkTimers", MODULE.InitNetworkTimers)
hook.Add("PostGamemodeLoaded", "PostGamemodeLoaded_InitNetworkTimers", MODULE.InitNetworkTimers)