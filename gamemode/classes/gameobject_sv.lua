function GameObject:new(metaObject, gameobject, ply, pos, angle)
	
	-- Check if player that created the gameobjectect, exists.
	if (!ply || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the game object.
	setmetatable( gameobject, metaObject );
	
	-- Add Game Object to global list of entities. 
	gameobject:SetIndex(GameObject:GetIndex());
	GameObject:IncrementIndex();
	GameObject:AddGameObject(gameobject);
	
	local objectEntity = BW.utility:CreateEntity("ent_skeleton", pos, angle);
	objectEntity:SetObject(gameobject);
	objectEntity:Spawn();
	
	-- Assign ownership, give health, set entity, and set gameobject type.
	gameobject:SetOwner(ply);
	gameobject:SetHealth(gameobject:GetMaxHealth());
	gameobject:SetEntity(objectEntity);
	gameobject:SetType(metaObject.objectType);

	---Game Object Flags Handled Here-------------------------------------------
	
	-- If game object should be spawned frozen.
	if (metaObject.FLAGS && metaObject.FLAGS.FROZEN) then
		if gameobject and objectEntity:IsValid() then
			objectEntity:GetPhysicsObject():EnableMotion(false);
		end
	elseif (metaObject.FLAGS == nil || metaObject.FLAGS.FROZEN == nil) then
		objectEntity:GetPhysicsObject():EnableMotion(false);
	end
	
	-- If game object has custom collisions.
	if (metaObject.FLAGS && metaObject.FLAGS.COLLISION) then
		objectEntity:SetCollisionGroup(metaObject.FLAGS.COLLISION);
	end
	
	-- If game object must be spawned on the ground.
	if (metaObject.FLAGS && metaObject.FLAGS.ONGROUND) then
		
		local tr = util.TraceLine( {
			start = objectEntity:GetPos(),
			endpos = objectEntity:GetPos() - Vector(0,0,2);
			filter = function(ent) return ent:IsWorld() end
		} )
		
		if (!tr.Hit) then
			objectEntity:Remove();
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
				GameObject:RegisterHook(metaObject, vFunc, gameobject);				
			end
		end
	end

	return gameobject;
end

--//
--//	Constructs a metatable for an incoming GameObject.
--//
function GameObject:newProp(metaObject, gameobject, ent, ply)

	-- Check if player that created the GameObject, exists.
	if (!ply || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the game object.
	setmetatable( gameobject, metaObject );
	
	-- Assign ownership and gain health.
	gameobject:SetOwner(ply);
	gameobject:SetHealth(gameobject:GetMaxHealth());
	
	ent:SetNWInt( 'EdicID', gameobject:GetIndex() )
	
	gameobject:SetEntity(ent);
	gameobject:SetType(metaObject.objectType);
	ent:CallOnRemove( "RemoveGameObject", function( ent ) if (ent:GetObject()) then ent:GetObject():Remove() end end )
	
	-- Add Game Object to global list of entities.
	gameobject:SetIndex(GameObject.IndexNumber);
	GameObject:IncrementIndex();
	GameObject:AddGameObject(gameobject);



	return gameobject;
end

--//
--//	Constructs a metatable for an incoming GameObject which is a player.
--//
function GameObject:newPlayer(metaObject, gameobject, ply)
	
	-- Check if player that created the GameObject, exists.
	if (!gameobject || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the game object.
	setmetatable( gameobject, metaObject );
	
	--GameObject.Cache[ply] = {};	// CACHE
	gameobject:SetIndex(GameObject.IndexNumber);
	GameObject:IncrementIndex();
	GameObject:AddGameObject(gameobject);
	
	-- We NEED TO DO this before we set the entity of the gameobject.
	ply:SetNWInt( 'EdicID', gameobject:GetIndex() )
	
	gameobject:SetOwner(ply);
	gameobject:SetEntity(ply);
	gameobject:SetType(metaObject.objectType);
	

	return gameobject;
end

function GameObject:GetAttachedEntities()
	return GameObject.AllAttachedEntities;	
end

--//////////////////////////////////////////////////////////////////////////////
--///GameObject Networking Functions-------------------------------------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Sends GameObject data for a single game object to all clients.
--//
function GameObject:SendGameObjectDataSingle(ply, gameobject)
	
	if (!ply.GetObject || !ply:GetObject()) then
		return;
	end
	
	local entityIndex = gameobject:GetEntityID();
	
	BW.debug:PrintStatement( {"[Server] Sending singular GameObject data message to", ply:GetName(), " about: ", gameobject}, "Networking", BW.debug.enums.network.medium)
	
	net.Start("GameObject_SendGameObjectData_AboutOne");
	net.WriteTable(gameobject);
	net.Send(ply);
end

--//
--//	Sends GameData about many game object to all clients.
--//
function GameObject:SendGameObjectDataMany(ply, gameobjects)
	
	BW.debug:PrintStatement( {"[Server] Sending GameObject data about many game objects to ", ply:GetName(), ": ", gameobjects}, "Networking", BW.debug.enums.network.low)

	net.Start("GameObject_SendGameObjectData_AboutMany");
	net.WriteTable(gameobjects);
	net.Send(ply);
end

--//
--//	Sends GameObject data for a single game object to all clients.
--//
function GameObject:TriggerEventLocal(ply, gameobject, event, args) 
	
	if (!ply.GetObject || !ply:GetObject()) then
		return;	
	end
	
	BW.debug:PrintStatement( {"[Server] Sending GameObject data to local: ", ply:GetName(), " ", gameobject}, "Networking", BW.debug.enums.network.medium)

	net.Start("GameObject_SendTriggerEvent");
	net.WriteTable(gameobject);
	net.WriteString(event);
	net.WriteTable(args or {});
	net.Send(ply);
end

--//
--//	Sends Event for a single game object to all clients.
--//
function GameObject:TriggerEventInSphere(pos, radius, gameobject, event, args) 
	
	local playersInRegion = {};
	for k, v in pairs (ents.FindInSphere( pos, radius )) do
	
		if (v && v:IsPlayer()) then
			table.insert(playersInRegion, v)
		end
		
	end
	
	net.Start("GameObject_SendTriggerEvent");
	net.WriteTable(gameobject);
	net.WriteString(event);
	net.WriteTable(args or {});
	net.Send(playersInRegion);
end


--//
--//	Sends Event for a single game object to all clients.
--//
function GameObject:TriggerEventGlobal(gameobject, event, args) 
	
	net.Start("GameObject_SendTriggerEvent");
	net.WriteTable(gameobject);
	net.WriteString(event);
	net.WriteTable(args or {});
	net.Broadcast();
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
	
	local gameobject = ent:GetObject()
	
	if (gameobject && gameobject.OnPhysgunPickup) then
		return gameobject:OnPhysgunPickup(ply);
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
	if (target.GetObject && target:GetObject().OnTakeDamage) then
		target:GetObject():OnTakeDamage(dmginfo);
	end
end)