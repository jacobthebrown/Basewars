GameObject = GameObject or {};

-- On LuaRefresh, We still want keep the hooks, gameobject list, but we want to refresh all the functions.
for k, v in pairs (GameObject) do
	if (isfunction(v)) then
		GameObject[k] = nil;
	end
end
GameObject.registry = {}; 
GameObject.AllGameObjects = GameObject.AllGameObjects or {};
GameObject.EdicCount = GameObject.EdicCount or 0;

GameObject.IssueEdic = function() 
	GameObject.EdicCount = GameObject.GetEdicCount() + 1 ;
	return GameObject.GetEdicCount();
end;

GameObject.GetEdicCount = function() return GameObject.EdicCount end;

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
function GameObject:Register(objectType, metaobject)
	
	metaobject.__index = metaobject;
	metaobject.override = {};
	
	metaobject.SetHealth = function(obj, value) 
		obj.health = value; 
	end
	metaobject.GetHealth = function(obj) 
		return obj.health; 
	end
	metaobject.SetMaxHealth = function(obj, value) 
		obj.maxHealth = value; 
	end
	metaobject.GetMaxHealth = function(obj) 
		return obj.maxHealth;
	end
	metaobject.SetEdic = function(obj, value) 
		obj.edic = obj.edic or value;
	end
	metaobject.GetEdic = function(obj) 
		return obj.edic; 
	end
	
	metaobject.SetEntity = function(obj, ent) 
		
		if (!ent:IsValid()) then error("Entity was not valid.") end
		
		obj.entity = ent;
		obj.entityid = ent:EntIndex();
		obj.entity:SetNWInt('EdicID', obj:GetEdic()); 
	end

	metaobject.GetEntity = function(obj) 
		return obj.ent or ents.GetByIndex(obj.entityid) or BW.utility:GetEntityByEdic(obj.edic); 
	end

	metaobject.SetEntityID = function(obj, entid) 
		error("Readonly.")
	end
	metaobject.GetEntityID = function(obj) 
		return obj.entityid or obj.ent:EntIndex(); 
	end
	
	metaobject.GetType = function(obj) return objectType; end
	metaobject.SetType = function(obj, objectType) obj.objectType = objectType; end

	metaobject.objectType = objectType;

	metaobject.Remove = function(obj) GameObject:RemoveGameObject(obj); end
	metaobject.SetOwner = function(obj, ply) 
		
		if (ply && isstring(ply)) then 
			obj.owner = ply; return;
		elseif (ply && ply:IsPlayer()) then 
			obj.owner = ply:SteamID64(); return;
		else
			obj.owner = nil;
		end
	end
	metaobject.GetOwner = function(obj) 
		if (obj.owner) then 
			return player.GetBySteamID64(obj.owner);
		end
	end
	
	-- Grabs all the member variables for the meta object and creates getters/setts
	
	local objectmembers = metaobject.members;
	
	if (objectmembers) then
		for k, v in pairs (objectmembers) do
			
			local memberName = string.upper(string.sub( k, 1, 1))..string.sub(k, 2);
			local getFunction = "Get"..memberName;
			local setFunction = "Set"..memberName;
			
			metaobject[getFunction] = function(obj) return obj[k]; end
			metaobject[setFunction] = function(obj, newValue) obj[k] = newValue; end
			
		end
	end
	
	metaobject.RunUpgradeHook = function(gameobject, hooktype, args)
	
		local mo = GameObject:GetMetaObject(gameobject:GetType());
		local updatedArguments = args;

		PrintTable(args)
	
		for k_upgrade, v_upgrade in pairs (gameobject.upgrades) do
			
			print(k_upgrade.." | "..v_upgrade);
			--`PrintTa
			
			for k, v in pairs (mo.upgradetree[v_upgrade].effects) do
				if (k == hooktype) then
					updatedArguments = v(gameobject, args);
				end
			end
		end
		
	end
	
	if (!metaobject.override && !metaobject.override["OnTakeDamage"]) then
	
		metaobject.OnTakeDamage = function(obj, dmginfo)
		
			print("RIPRIRPPR")
			--if (obj.OnTakeDamage) then
			--	dmginfo = obj:OnTakeDamage(obj, dmginfo);
			--end
		
			if (obj.upgrades) then
				print(obj:RunUpgradeHook("OnTakeDamage", {dmginfo = dmginfo} ))
				--dmginfo = --.dmginfo; -- or dmginfo;
			end
		
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
	
	GameObject.registry[objectType] = metaobject;
	
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
	GameObject.AllGameObjects[gameobject:GetEdic()] = gameobject;
end

--//
--//	Get the game object from the global game object list.
--//
function GameObject:GetGameObject(edic)
	return GameObject.AllGameObjects[edic];
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

	GameObject.AllGameObjects[gameobject:GetEdic()] = nil;
	
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