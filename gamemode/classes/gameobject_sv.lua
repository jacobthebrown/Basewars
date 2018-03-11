GameObject = GameObject or {};

-- On LuaRefresh, We still want keep the hooks, gameobject list, but we want to refresh all the functions.
for k, v in pairs (GameObject) do
	if (isfunction(v)) then
		GameObject[k] = nil;
	end
end
GameObject.registry = {}; 
GameObject.AllGameObjects = GameObject.AllGameObjects or {};
GameObject.IndexNumber = GameObject.IndexNumber or 0;
GameObject.Cache = {};
GameObject.hooks = GameObject.hooks or { OnOwnerSpawn = {}, OnPhysgunPickup = {}, OnPlayerDeathThink = {}, OnPlayerDeath = {}, OnTakeDamage = {} };

--//
--//	Constructs a metatable for an incoming GameObject.
--//
function GameObject:new(metaObject, gameObj, ply, pos, angle, OBJFLAGS)
	
	-- Check if player that created the GameObject, exists.
	if (!ply || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the game object.
	setmetatable( gameObj, metaObject );
	
	-- Assign ownership
	gameObj:SetOwner(ply);
	gameObj:SetHealth(gameObj:GetMaxHealth());
	gameObj.ent = BW.utility:CreateEntity("ent_skeleton", gameObj, pos, angle); -- Create the physical entity that the player in the source engine.
	gameObj.ent:Spawn();
	
	-- Add Game Object to global list of entities. 
	GameObject:AddGameObject(gameObj);
	gameObj:SetIndex(GameObject.IndexNumber);
	GameObject.IndexNumber = GameObject.IndexNumber + 1;
	
	---Game Object Flags Handled Here-------------------------------------------
	
	-- If game objecet should be spawned frozen.
	if (metaObject.FLAGS && metaObject.FLAGS.FROZEN) then
		if gameObj and gameObj.ent:IsValid() then
			gameObj.ent:GetPhysicsObject():EnableMotion(false);
		end
	elseif (metaObject.FLAGS == nil || metaObject.FLAGS.FROZEN == nil) then
		gameObj.ent:GetPhysicsObject():EnableMotion(false);
	end
	
	
	
	-- If game object has custom collisions.
	if (metaObject.FLAGS && metaObject.FLAGS.COLLISION) then
		gameObj.ent:SetCollisionGroup(metaObject.FLAGS.COLLISION);
	end
	
	-- If game object must be spawned on the ground.
	if (metaObject.FLAGS && metaObject.FLAGS.ONGROUND) then
		
		local tr = util.TraceLine( {
			start = gameObj.ent:GetPos(),
			endpos = gameObj.ent:GetPos() - Vector(0,0,2);
			filter = function(ent) return ent:IsWorld() end
		} )
		
		if (!tr.Hit) then
			gameObj.ent:Remove();
			return error("GameObject (Error): This object can only be spawned on a flat surface, on the ground.");
		end
	end
	
	-- If game object should not be moved.
	if (metaObject.FLAGS && metaObject.FLAGS.UNMOVEABLE) then
		--metaObject.FLAGS.UNMOVEABLE = true;
	end

	-- If game object has any hook functions, we add it to the hook function register.
	for kHook, vHook in pairs (GameObject.hooks) do
		for kFunc, vFunc in pairs (metaObject) do
			if (isfunction(vFunc) && kHook == kFunc) then
				GameObject:RegisterHook(metaObject, vFunc, gameObj);				
			end
		end
	end

	return gameObj;
end

--//
--//	Constructs a metatable for an incoming GameObject.
--//
function GameObject:newProp(metaObject, propObj, ent, ply)

	-- Check if player that created the GameObject, exists.
	if (!ply || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the game object.
	setmetatable( propObj, metaObject );
	
	-- Assign ownership and gain health.
	propObj:SetOwner(ply);
	propObj.health = propObj:GetMaxHealth();
	propObj.ent = ent;
	ent:CallOnRemove( "RemoveGameObject", function( ent ) if (ent.gamedata) then ent.gamedata:Remove() end end )
	
	-- Add Game Object to global list of entities. 
	GameObject:AddGameObject(propObj);
	propObj:SetIndex(GameObject.IndexNumber);
	GameObject.IndexNumber = GameObject.IndexNumber + 1;

	return propObj;
end

--//
--//	Constructs a metatable for an incoming GameObject which is a player.
--//
function GameObject:newPlayer(metaObject, playerObj, ply)
	
	-- Check if player that created the GameObject, exists.
	if (!playerObj || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the game object.
	setmetatable( playerObj, metaObject );
	GameObject.Cache[ply] = {};
	playerObj:SetIndex(GameObject.IndexNumber);
	GameObject.IndexNumber = GameObject.IndexNumber + 1;
	
	playerObj.player = ply;
	
	return playerObj;
end

--//////////////////////////////////////////////////////////////////////////////
--///MetaObject Registry Functions of the Game Object and Hooks----------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Registers the meta table of the object in the registry and adds base functions.
--//
function GameObject:Register(objectType, metaObject)
	
	metaObject.__tostring = function(obj) return tostring(obj.ent).." "..obj.entityType; end
	metaObject.ToString = function(obj) return tostring(obj.ent).." "..obj.entityType; end
	metaObject.SetHealth = function(obj, value) obj.health = value or 100; end
	metaObject.GetHealth = function(obj) return obj.health or 100; end
	metaObject.SetMaxHealth = function(obj, value) obj.maxHealth = value or 100; end
	metaObject.GetMaxHealth = function(obj) return obj.maxHealth or 100; end
	metaObject.SetIndex = function(obj, value) obj.objectIndex = value or nil; end
	metaObject.GetIndex = function(obj) return obj.objectIndex or nil; end

	metaObject.Remove = function(obj) GameObject:RemoveGameObject(obj); end
	metaObject.SetOwner = function(obj, ply) 
		
		if (ply && isstring(ply)) then 
			obj.owner = ply; return;
		elseif (ply && ply:IsPlayer()) then 
			obj.owner = ply:SteamID64(); return;
		else 
			obj.owner = ply; return;
		end
	end
	metaObject.GetOwner = function(obj, returnType) 
		if (obj.owner && returnType == "ent") then 
			return player.GetBySteamID64(obj.owner);
		elseif (obj.owner && returnType == "str") then 
			return obj.owner;
		else 

			return player.GetBySteamID64(obj.owner);
		end
	end
	
	if (metaObject.members) then
		for k, v in pairs (metaObject.members) do
			local memberName = string.upper(string.sub( v, 1, 1))..string.sub(v,2);
			local getFunction = "Get"..memberName;
			local setFunction = "Set"..memberName;
			
			metaObject[getFunction] = function(obj) return obj[v]; end
			metaObject[setFunction] = function(obj, newValue) obj[v] = newValue; end
		end
	end
	
	if (!metaObject.OnTakeDamage) then
		
		metaObject.OnTakeDamage = function(obj, dmginfo)
	
			if (dmginfo:GetDamageType() == DMG_CRUSH) then
				return;
			end
	
			local totalDamage = obj:GetHealth() - dmginfo:GetBaseDamage();

			if (totalDamage <= 0) then
				obj:Remove()
			else
				obj:SetHealth(totalDamage);
			end
		end
	end
	
	GameObject.registry[objectType] = metaObject;
	
end

--//
--//	Finds the game object from the registry.
--//
function GameObject:GetMetaObject(ObjectName)
	return GameObject.registry[ObjectName] or nil;
end

--//
--//	Registers the game object's hook function of the object in the hook registry.
--//
function GameObject:RegisterHook(metaObject, metaFunction, gameObj)
	local hookFunction = table.KeyFromValue(metaObject, metaFunction);
	
	if (GameObject.hooks[hookFunction]) then
		table.insert(GameObject.hooks[hookFunction], gameObj );	
	else
		GameObject.hooks[hookFunction] = {gameObj};
	end
end

--//////////////////////////////////////////////////////////////////////////////
--///GameObject Networking Functions-------------------------------------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Sends GameData for a single game object to all clients.
--//
function GameObject:SendGameDataSingle(ply, object)
	
	local entityIndex = ply:EntIndex();
	local newCachedObj = GameObject:TrimCacheForNetworking(ply, object);

	if (table.Count( newCachedObj ) != 0) then
		
		table.CopyFromTo( object, GameObject.Cache[ply][object:GetIndex()] )
		
		uncachedObjectData = uncachedObjectData or {};
		uncachedObjectData[entityIndex] = {entIndex = entityIndex, gamedata = newCachedObj};
	else
		return;
	end	
	
	BW.debug:PrintStatement( {"Sending Single Gamedata Message about: ", newCachedObj}, BW.debug.enums.network.medium)
	
	if (object.player) then
		net.Start("GameObject_SendGameDataSingle");
		net.WriteUInt(object.player:EntIndex(), 8);
		net.WriteTable(newCachedObj);
		net.Send(ply);
		return;
	end
	
	net.Start("GameObject_SendGameDataSingle");
	net.WriteUInt(object.ent:EntIndex(), 8);
	net.WriteTable(newCachedObj);
	net.Send(ply);
end

--//
--//	Sends GameData about many game object to all clients.
--//
function GameObject:SendGameDataMany(ply, objs)
	
	local uncachedObjectData = nil;
	
	for k, indexAndobject in pairs (objs) do

		local object = indexAndobject.gamedata;
		local entityIndex = object.ent:EntIndex();
		local newCachedObj = GameObject:TrimCacheForNetworking(ply, object)

		if (table.Count( newCachedObj ) != 0) then
			
			table.CopyFromTo( object, GameObject.Cache[ply][object:GetIndex()] )
			
			uncachedObjectData = uncachedObjectData or {};
			uncachedObjectData[entityIndex] = {entIndex = entityIndex, gamedata = newCachedObj};
		end	

	end

	if (uncachedObjectData == nil) then
		return;
	end

	BW.debug:PrintStatement( {"Sending Gamedata about many game objects to client.", uncachedObjectData}, BW.debug.enums.network.low)

	
	net.Start("GameObject_SendGameDataMany");
	net.WriteTable(uncachedObjectData);
	net.Send(ply);
end

function GameObject:TrimCacheForNetworking(ply, obj)

		local gameObjectID = obj:GetIndex();
		local trimmedCache = {};
		
		if (!GameObject.Cache[ply]) then
			GameObject.Cache[ply] = {};
			GameObject.Cache[ply][gameObjectID] = {};
		elseif (!GameObject.Cache[ply][gameObjectID]) then
			GameObject.Cache[ply][gameObjectID] = {};
		end
		
		table.MergeUncached( trimmedCache, obj, GameObject.Cache[ply][gameObjectID] )

		return trimmedCache;

end

--//
--//	Sends GameData for a single game object to all clients.
--//
function GameObject:TriggerEventLocal(ply, obj, event, args) 
	
	BW.debug:PrintStatement( {"Sending Gamedata to local ", ply , " ", obj:ToString()}, BW.debug.enums.network.medium)

	net.Start("GameObject_SendTriggerEvent");
	net.WriteUInt(obj.ent:EntIndex(), 8);
	net.WriteTable(obj);
	net.WriteString(event);
	net.WriteTable(args or {});
	net.Send(ply);
end

--//
--//	Sends GameData for a single game object to all clients.
--//
function GameObject:TriggerEventInSphere(pos, radius, obj, event, args) 
	
	local playersInRegion = {};
	for k, v in pairs (ents.FindInSphere( pos, radius )) do
	
		if (v && v:IsPlayer()) then
			table.insert(playersInRegion, v)
		end
		
	end
	
	net.Start("GameObject_SendTriggerEvent");
	net.WriteUInt(obj.ent:EntIndex(), 8);
	net.WriteTable(obj);
	net.WriteString(event);
	net.WriteTable(args or {});
	net.Send(playersInRegion);
end


--//
--//	Sends GameData for a single game object to all clients.
--//
function GameObject:TriggerEventGlobal(obj, event, args) 
	net.Start("GameObject_SendTriggerEvent");
	net.WriteUInt(obj.ent:EntIndex(), 8);
	net.WriteTable(obj);
	net.WriteString(event);
	net.WriteTable(args or {});
	net.Broadcast();
end

--//////////////////////////////////////////////////////////////////////////////
--///GameObject game object operations-----------------------------------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Adds the game object from the global game object list.
--//
function GameObject:AddGameObject(obj)
	
	return table.insert(GameObject.AllGameObjects, obj) or nil;
end

--//
--//	Get all game objects from global game object list.
--//
function GameObject:GetAllGameObjects()
	return GameObject.AllGameObjects;
end

--//
--//	Remove game object from global game object list and hooks list.
--//
function GameObject:RemoveGameObject(obj)
	
	table.RemoveByValue(GameObject.AllGameObjects, obj);
	
	if (obj.ent) then
		obj.ent:Remove();	
	end
	
	for k, v in pairs (GameObject.hooks) do
		table.RemoveByValue(v, obj);
	end
end

--//////////////////////////////////////////////////////////////////////////////
--///Console Command Functions-------------------------------------------------/
--//////////////////////////////////////////////////////////////////////////////

 
--//////////////////////////////////////////////////////////////////////////////
--///GameObject Hooks----------------------------------------------------------/
--//////////////////////////////////////////////////////////////////////////////
hook.Add( "PlayerSpawn", "GameObject_OnOwnerSpawn", function(ply)
	for k, v in pairs(GameObject.hooks.OnOwnerSpawn) do
		if (v:GetOwner() == ply) then
			v:OnOwnerSpawn();
		end
	end
end )

hook.Add( "PhysgunPickup", "GameObject_OnPhysgunPickup", function( ply, ent )
	if (ent.gamedata && ent.gamedata.OnPhysgunPickup) then
		return ent.gamedata:OnPhysgunPickup(ply);
	end
end )

hook.Add( "PlayerDeathThink", "GameObject_OnPlayerDeathThink", function( ply )
	for k, v in pairs(GameObject.hooks.OnPlayerDeathThink) do
		if (v:GetOwner() == ply) then
			v:OnPlayerDeathThink(ply);
		end
	end
end )

hook.Add( "PlayerDeath", "GameObject_OnPlayerDeath", function( victim, inflictor, attacker )
	for k, v in pairs(GameObject.hooks.OnPlayerDeath) do
		if (v:GetOwner() == victim) then
			v:OnPlayerDeath(victim);
		end
	end
end)

hook.Add( "EntityTakeDamage", "GameObject_OnEntityTakeDamage", function( target, dmginfo )
	if (target.gamedata && target.gamedata.OnTakeDamage) then
		target.gamedata:OnTakeDamage(dmginfo);
	end
end)

hook.Add( "EntityTakeDamage", function( target, dmginfo )
	print(target);
end)