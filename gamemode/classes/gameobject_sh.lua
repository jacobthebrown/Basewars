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
GameObject.IncrementIndex = function() GameObject.IndexNumber = GameObject.IndexNumber + 1 end;
GameObject.GetIndex = function() return GameObject.IndexNumber end;

--GameObject.Cache = {};	// CACHE
GameObject.hooks = GameObject.hooks or { OnOwnerSpawn = {}, OnPhysgunPickup = {}, OnPlayerDeathThink = {}, OnPlayerDeath = {}, OnTakeDamage = {} };
GameObject.unloadedents = GameObject.unloadedents or {};

--//
--//	Constructs a metatable for an incoming GameObject.
--//

--//////////////////////////////////////////////////////////////////////////////
--///MetaObject Registry Functions of the Game Object and Hooks----------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Registers the meta table of the object in the registry and adds base functions.
--//
function GameObject:Register(objectType, metaObject)
	
	metaObject.SetHealth = function(obj, value) obj.health = value; end
	metaObject.GetHealth = function(obj) return obj.health; end
	metaObject.SetMaxHealth = function(obj, value) obj.maxHealth = value; end
	metaObject.GetMaxHealth = function(obj) return obj.maxHealth; end
	metaObject.SetIndex = function(obj, value) obj.objectIndex = value; end
	metaObject.GetIndex = function(obj) return obj.objectIndex; end
	
	metaObject.SetEntity = function(obj, ent) 
			obj.entity = ent;
			obj.entityEdic = ent:GetNWInt('EdicID', nil); 
		end

		
	metaObject.GetEntity = function(obj) 
		return BW.utility:GetEntityByEdic(obj.entityEdic); 
	end
	
	metaObject.SetEntityID = function(obj, entID) obj.entityEdic = entID; end
	metaObject.GetEntityID = function(obj) return obj.entityEdic; end
	metaObject.GetType = function(obj) return objectType; end
	metaObject.SetType = function(obj, objectType) obj.objectType = objectType; end

	metaObject.objectType = objectType;

	metaObject.Remove = function(obj) GameObject:RemoveGameObject(obj); end
	metaObject.SetOwner = function(obj, ply) 
		
		if (ply && isstring(ply)) then 
			obj.owner = ply; return;
		elseif (ply && ply:IsPlayer()) then 
			obj.owner = ply:SteamID64(); return;
		else
			obj.owner = nil;
		end
	end
	metaObject.GetOwner = function(obj) 
		if (obj.owner) then 
			return player.GetBySteamID64(obj.owner);
		end
	end
	
	-- Grabs all the member variables for the meta object and creates getters/setts
	
	local objectmembers = metaObject.members;
	

	
	
	if (objectmembers) then
		for i=1, #objectmembers do
			
			local memberName = string.upper(string.sub( objectmembers[i], 1, 1))..string.sub(objectmembers[i],2);
			local getFunction = "Get"..memberName;
			local setFunction = "Set"..memberName;
			
			metaObject[getFunction] = function(obj) return obj[objectmembers[i]]; end
			metaObject[setFunction] = function(obj, newValue) obj[objectmembers[i]] = newValue; end
			
		end
	end
	
	if (!metaObject.OnTakeDamage) then
		
		metaObject.OnTakeDamage = function(obj, dmginfo)
	
            if (CLIENT) then return end;
            
			if (dmginfo:GetDamageType() == DMG_CRUSH) then
				return;
			end
	
			local totalDamage = math.floor((obj:GetHealth() or 0) - dmginfo:GetBaseDamage());

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
--///GameObject game object operations-----------------------------------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Adds the game object from the global game object list.
--//
function GameObject:AddGameObject(gameobject)
	GameObject.AllGameObjects[gameobject:GetIndex()] = gameobject;
end

--//
--//	Get the game object from the global game object list.
--//
function GameObject:GetGameObject(objectIndex)
	return GameObject.AllGameObjects[objectIndex];
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
function GameObject:RemoveGameObject(gameobject)
	
	
	BW.debug:PrintStatement( {"Object has been removed: ", gameobject}, "GameObject", BW.debug.enums.gameobject.high)

	GameObject.AllGameObjects[gameobject:GetIndex()] = nil;
	
	local ent = gameobject:GetEntity();
	
	if (SERVER && ent) then
		ent:Remove();	
	end
	
	if (CLIENT && ent) then
		ent:SetObject(nil);
	end
	
	for k, v in pairs (GameObject.hooks) do
		table.RemoveByValue(v, gameobject);
	end
	
	BW.debug:PrintStatement( {"List of remaining entities, ", GameObject:GetAllGameObjects()}, "GameObject", BW.debug.enums.gameobject.low)
	
end