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
	
	-- Allow meta object to index itself.
	metaobject.__index = metaobject;
	
	-- Table for function overrides for the object.
	metaobject.override = metaobject.override or {};
	
	--
	-- Sets the health of the object.
	--
	metaobject.SetHealth = function(obj, value) 
		obj.health = value; 
	end
	
	--
	-- Get the health of the object.
	--
	metaobject.GetHealth = function(obj) 
		return obj.health; 
	end
	
	--
	--	Set max health of the object.
	--
	metaobject.SetMaxHealth = function(obj, value) 
		obj.maxHealth = value; 
	end
	
	--
	-- Get max health of the object.
	--
	metaobject.GetMaxHealth = function(obj) 
		return obj.maxHealth;
	end
	
	--
	-- Sets the 'edic' of the object. (An Edic is a truly gameobject unique ID);
	--
	metaobject.SetEdic = function(obj, value) 
		obj.edic = obj.edic or value;
	end
	
	--
	-- Get the 'edic' of the object.
	--
	metaobject.GetEdic = function(obj) 
		return obj.edic; 
	end
	
	--
	-- Set the entity of the object.
	--
	metaobject.SetEntity = function(obj, ent) 
		
		-- If entity is invalid, error out.
		if (!ent:IsValid()) then error("Entity was not valid.") end
		
		obj.entity = ent;
		obj.entityid = ent:EntIndex();
	end
	
	--
	-- Get the entity of the object.
	--
	metaobject.GetEntity = function(obj)
		
		if (!obj.entity:IsValid()) then
			print("invalid object entity");
		else
			return obj.entity;
		end
		
		local entbyid = ents.GetByIndex(obj.entityid) or BW.utility:GetEntityByEdic(obj.edic); 
		
		if (entbyid && entbyid:IsValid()) then
			obj.entity = entbyid;
			return entbyid;
		else
			return nil;
		end

	end

	--
	-- EntityID is read only.
	--
	metaobject.SetEntityID = function(obj, entid) 
		--error("SetEntityID is Readonly.")
	end
	
	--
	-- Gets the object's entity id.
	--
	metaobject.GetEntityID = function(obj) 
		return obj.entityid or obj.entity:EntIndex(); 
	end
	
	--
	-- Sets the object's type.
	--
	metaobject.SetType = function(obj, objectType) 
		obj.objectType = objectType; 
	end
	
	--
	-- Gets the object's type.
	--
	metaobject.GetType = function(obj) 
		return obj.objectType; 
	end
	
	-- Set initial type.
	metaobject.objectType = objectType;

	--
	--	Removes the game object from the game.
	--
	metaobject.Remove = function(obj) 
		GameObject:RemoveGameObject(obj); 
	end
	
	--
	--	Sets the owner of the object.
	--
	metaobject.SetOwner = function(obj, ply) 
		
		if (ply && isstring(ply)) then 
			
			-- If we were given a SteamID64, we don't need to convert.
			obj.owner = ply; 
			obj.ownerentity = player.GetBySteamID64(ply);
			return;
			
		elseif (ply && ply:IsPlayer()) then
			obj.owner = ply:SteamID64();
			obj.ownerentity = ply;
			return;
		else
			error("Can not set nil value for owner or owner was not a player.");
		end
	end
	
	--
	-- Gets the owner of the object.
	--
	metaobject.GetOwner = function(obj) 
		if (obj.owner) then 
			
			if (!obj.ownerentity:IsValid()) then
				print("invalid object owner entity");
			else
				return obj.ownerentity;
			end
			
			local plybysteam = player.GetBySteamID64(obj.owner);
			
			if (plybysteam && plybysteam:IsValid()) then
				obj.ownerentity = plybysteam;
				return plybysteam;
			else
				return nil;
			end
		end
	end
	
	metaobject.Upgrade = function(obj, upgradeID)
	
		local upgrade = metaobject.upgradetree[upgradeID];
	
		if (upgrade && !table.HasValue(obj.upgrades, upgradeID)) then
		
			print("yep")
		
			table.insert(obj.upgrades, upgradeID);
		
			print("Upgrading");
			
			for k, v in pairs(upgrade.effects) do
				if (k == "Immediate") then
					v(obj);
				end
			end
			
		end
		
	end
	-- Grabs all the member vars for the metaobject and creates getters/setters.
	metaobject.members = metaobject.members or {};
		
	-- ADD SOME DEFAULT MEMBERS
	metaobject.members.upgrades = metaobject.members.upgrades or {};
	
	for k, v in pairs (metaobject.members) do
		
		if (string.len(k) < 2) then
			error("Memory variable name was too short for the getters/setters");	
		end
		
		local memberName = string.upper(string.sub( k, 1, 1))..string.sub(k, 2);
		local getFunction = "Get"..memberName;
		local setFunction = "Set"..memberName;
		
		metaobject[getFunction] = function(obj) return obj[k]; end
		metaobject[setFunction] = function(obj, newValue) obj[k] = newValue; end
		
		-- Setup the default values of the object as provided by the member var.
		metaobject[k] = v;
		
	end
		
	if (objectType == "Object_Prop") then
		PrintTable(metaobject.members)	
	end
	
		
	metaobject.RunUpgradeHook = function(gameobject, hooktype, args)
	
		local updatedArguments = args;
	
		for k_upgrade, v_upgrade in pairs (gameobject.upgrades) do
			
			for k, v in pairs (metaobject.upgradetree[v_upgrade].effects) do
				if (k == hooktype) then
					updatedArguments = v(gameobject, args);
				end
			end
		end
		
	end
	
	if (!metaobject.override["OnTakeDamage"]) then
		
		metaobject.OnTakeDamage = function(obj, dmginfo)
		
			if (obj.upgrades) then
				obj:RunUpgradeHook("OnTakeDamage", {dmginfo = dmginfo} );
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
	
	--if (CLIENT && ent) then
	--	ent:SetObject(nil);
	--1end
	
	for k, v in pairs (GameObject.hooks) do
		table.RemoveByValue(v, gameobject);
	end
	
	BW.debug:PrintStatement( {"List of remaining entities, ", GameObject:GetAllGameObjects()}, "GameObject", BW.debug.enums.gameobject.low)
	
end