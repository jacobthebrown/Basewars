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


function MODULE.PlayerMoved(ply) 
	
	--local gameobject = ply:GetObject();
	--
	--if (gameobject) then
	--	return;
	--	--gameobject:Remove();
	--end
	--
	--local metaobject =  GameObject:GetMetaObject("Object_Player");	
	--ply:SetObject(metaobject:new(ply));
	
end
hook.Add("FinishMove", "FinishMove_PlayerMoved", MODULE.PlayerMoved);

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

--//
--//	Disables physics for all source engine entities on physgun drop.
--//
function MODULE.OnPhysgunDrop( ply, ent )
	
	local phys = ent:GetPhysicsObject();
 
	if phys and phys:IsValid() then
		phys:EnableMotion(false);
	end
	
end
hook.Add("PhysgunDrop", "PhysgunDrop_OnPhysgunDrop", MODULE.OnPhysgunDrop )

--//
--//	Disables physics for all source engine entities spawn.
--//
function MODULE.OnPlayerSpawnObject(ply, model, ent)
	
	if (!ent) then
		return;
	end
	
	if (ent:GetClass() == "prop_physics") then
		local metaobject =  GameObject:GetMetaObject("Object_Prop");
		ent:SetObject(metaobject:new(ply, ent));
		
		PrintTable(ent:GetObject())
	end
	
	local phys = ent:GetPhysicsObject();
 
	if phys and phys:IsValid() then
		phys:EnableMotion(false);
	end
	
end
hook.Add("PlayerSpawnedProp", "Hook_OnPlayerSpawnObject", MODULE.OnPlayerSpawnObject )