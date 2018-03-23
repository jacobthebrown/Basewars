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
	
	-- On lua refresh, we don't want multiple timers wanging around.
	if (timer.Exists( "Timer_NetworkGameObjects" )) then
		timer.Remove( "Timer_NetworkGameObjects" )
	end
	
	-- We localize this function to increase performance.
	local funcFindHumans = player.GetHumans;
	local funcFindInSphere = ents.FindInSphere;
	
	timer.Create( "Timer_NetworkGameObjects", 0.25, 0, function() 
	
		-- Iterate through all players and send them game object data.
		local allplayers = funcFindHumans();
		
		-- Iterate through all players.
		for i=1, #allplayers do
			
			local objectsToUpdate = {};
			local ply = allplayers[i];
			
			-- If player does not have an edic, we know they aren't initalized.
			if (!ply:GetEdic()) then
				continue;
			end
			
			local entsInSphere = funcFindInSphere(ply:GetPos(), 512);
			
			for j=1, #entsInSphere do
				
				local ent = entsInSphere[j];
				
				-- If entity has an edic, it has a object attached to it..
				if (ent && ent:GetEdic()) then
					table.insert(objectsToUpdate, ent:GetObject());
				end
			end

			-- Send uncached objects to player.
			if (!table.IsEmpty(objectsToUpdate)) then
				GameObject:SendGameObjectDataMany(ply, objectsToUpdate);
			end
		
		end
	end );
end
hook.Add("OnReloaded", "OnReloaded_InitNetworkTimers", MODULE.InitNetworkTimers)
hook.Add("PostGamemodeLoaded", "PostGamemodeLoaded_InitNetworkTimers", MODULE.InitNetworkTimers)