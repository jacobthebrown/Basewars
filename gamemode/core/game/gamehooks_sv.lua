BW.hooks = {};
local MODULE = BW.hooks;


--//
--//	Initalizes the player after they render their first frame.
--//	(Sent by the client with PostRender hook)
--//
function MODULE.InitializePlayerData(ply)
	
	local gameobject = ply:GetObject();
	
	if (gameobject) then
		gameobject:Remove();
	end
	
	local metaobject = GameObject:GetMetaObject("Object_Player");	

	ply:SetObject(metaobject:new(ply));
	
end
hook.Add( "PlayerFullyLoaded", "PlayerFullyLoaded_InitializePlayerData", MODULE.InitializePlayerData )	-- CUSTOM HOOK 'PlayerFullyLoaded'

--//
--//	Since bots don't render, we need to make sure they spawn with gameobject
--//	data as well.
--//
function MODULE.InitalizeBotData(ply)
	
	if(!ply:IsBot()) then
		return;	
	end
	
	if (ply:GetObject()) then
		ply:GetObject():Remove();
	end
	
	local metaobject =  GameObject:GetMetaObject("Object_Player");
	ply:SetObject(metaobject:new(ply));
	
end
hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn_InitalizeBotData", MODULE.InitalizeBotData )


--//
--//	Removes the player's gameobject data on disconnect.
--//
function MODULE.RemovePlayerData(ply) 
	
	local gameobject = ply:GetObject();
	
	if (gameobject) then
		gameobject:Remove();
	end
	
end
hook.Add("PlayerDisconnected", "PlayerDisconnected_RemovePlayerData", MODULE.RemovePlayerData )

