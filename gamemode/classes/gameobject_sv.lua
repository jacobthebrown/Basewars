GameObject = GameObject or {};
GameObject.AllGameObjects = GameObject.AllGameObjects or {};
GameObject.registry = GameObject.registry or {}; 
GameObject.hooks = GameObject.hooks or {};
GameObject.hooks.OnOwnerSpawn = GameObject.hooks.OnOwnerSpawn or {};

--//
--//	Constructs a metatable for an incoming GameObject.
--//
function GameObject:new(metaObject, gameObj, ply, pos, angle, OBJFLAGS)
	
	-- Check if player that created the GameObject, exists.
	if (!ply || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Assign ownership
	gameObj.owner = ply;
	
	-- Create the physical entity that the player in the source engine.
	gameObj.ent = ents.Create( "ent_skeleton" );
	gameObj.ent:SetPos(pos);
	gameObj.ent.gamedata = gameObj;
	gameObj.ent:SetAngles(angle or gameObj.ent:GetAngles());
	gameObj.ent:Spawn();
	
	-- Create a clone of the metatable of the game object.
	setmetatable( gameObj, metaObject );
	
	-- Add Game Object to global list of entities. 
	GameObject:AddGameObject(gameObj);
	
	-- Game Object flags are flags for the inital creation of the entity.
	gameObj.FLAGS = OBJFLAGS or {};

	-- If game objecet should be spawned frozen.
	if (OBJFLAGS.FROZEN) then
		if gameObj and gameObj.ent:IsValid() then
			gameObj.ent:GetPhysicsObject():EnableMotion(false);
		end
	end
	
	-- If game object has custom collisions.
	if (OBJFLAGS.COLLISION) then
		gameObj.ent:SetCollisionGroup(OBJFLAGS.COLLISION);
	end
	
	-- If game object must be spawned on the ground.
	if (OBJFLAGS.ONGROUND) then
		
		local tr = util.TraceLine( {
			start = gameObj.ent:GetPos(),
			endpos = gameObj.ent:GetPos() - Vector(0,0,1);
			filter = function(ent) return ent:IsWorld() end
		} )
		
		if (!tr.Hit) then
			gameObj.ent:Remove();
			return error("GameObject (Error): This object can only be spawned on a flat surface, on the ground.");
		end
	end
	
	-- If the owner of the game object should only have one game object of its type.
	if (OBJFLAGS.UNIQUE) then
		for k, v in pairs (GameObject:GetAllGameObjects()) do
			if (v.entityType == gameObj.entityType && v.owner == gameObj.owner) then v:Remove(); end
		end
	end
	
	-- If game object should not be moved.
	if (OBJFLAGS.UNMOVEABLE) then
		gameObj.FLAGS.UNMOVEABLE = true;
	end

	-- If meta object contains OnOwnerSpawn hook, then add it to the hook registry.
	if (metaObject.OnOwnerSpawn) then
		GameObject:RegisterHook(metaObject, gameObj);
	end
	
	-- If meta object contains OnPhysgunPickup hook, then add it to the hook registry.
	if (metaObject.OnPhysgunPickup) then
		local hookFunction = table.KeyFromValue(metaObject, metaObject.OnPhysgunPickup);
		table.insert(GameObject.hooks[hookFunction], gameObj );
	end
	
	gameObj.Remove = function() GameObject:RemoveGameObject(gameObj); end
	
	return gameObj;
end

--//////////////////////////////////////////////////////////////////////////////
--///MetaObject Registry Functions of the Game Object and Hooks----------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Registers the meta table of the object in the registry.
--//
function GameObject:Register(ObjectType, MetaObject)
	GameObject.registry[ObjectType] = MetaObject;
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
function GameObject:RegisterHook(metaObject, gameObj)
	local hookFunction = table.KeyFromValue(metaObject, metaObject.OnOwnerSpawn);
	table.insert(GameObject.hooks[hookFunction], gameObj );	
end

--//////////////////////////////////////////////////////////////////////////////
--///GameObject Networking Functions-------------------------------------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Sends GameData for a single game object to all clients.
--//
function GameObject:SendGameDataSingle(ply, ent, obj)
	net.Start("GameObject_SendGameDataSingle");
	net.WriteUInt(ent:EntIndex(), 8);
	net.WriteTable(obj);
	net.Send(ply);
end

--//
--//	Sends GameData about many game object to all clients.
--//
function GameObject:SendGameDataMany(ply, objs)
	net.Start("GameObject_SendGameDataMany");
	net.WriteTable(objs);
	net.Send(ply);
end

--//
--//	Sends GameData for a single game object to all clients.
--//
function GameObject:TriggerEventLocal(ply, ent, gamedata, event, args) 
	net.Start("GameObject_SendTriggerEvent");
	net.WriteUInt(ent:EntIndex(), 8);
	net.WriteTable(gamedata);
	net.WriteString(event);
	net.WriteTable(args or {});
	net.Send(ply);
end

--//
--//	Sends GameData for a single game object to all clients.
--//
function GameObject:TriggerEventGlobal(ent, gamedata, event, args) 
	net.Start("GameObject_SendTriggerEvent");
	net.WriteUInt(ent:EntIndex(), 8);
	net.WriteTable(gamedata);
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
	
	for k, v in pairs (GameObject.hooks) do
		table.RemoveByValue(v, obj);
	end
end

--//////////////////////////////////////////////////////////////////////////////
--///Console Command Functions-------------------------------------------------/
--//////////////////////////////////////////////////////////////////////////////
concommand.Add( "create", function( ply, cmd, args ) 
	
	if (GameObject:GetMetaObject("Object_" .. args[1]) == nil) then
		return 
	end
	
    local trace = {};
    trace.start = ply:EyePos();
    trace.endpos = trace.start + ply:GetAimVector() * 85;
    trace.filter = ply;
    
    local tr = util.TraceLine(trace);
	local newObject = GameObject:GetMetaObject("Object_" .. args[1]):new(ply, tr.HitPos); 
	
	GameObject:SendGameDataSingle(ply, newObject.ent, newObject);
	
end)
 
--//////////////////////////////////////////////////////////////////////////////
--///GameObject Hooks----------------------------------------------------------/
--//////////////////////////////////////////////////////////////////////////////
hook.Add( "PlayerSpawn", "GameObject_OnOwnerSpawn", function(ply)
	for k, v in pairs(GameObject.hooks.OnOwnerSpawn) do
		if (v.owner == ply) then
			v:OnOwnerSpawn();
		end
	end
end )
hook.Add( "PhysgunPickup", "GameObject_OnPhysgunPickup", function( ply, ent )
	if (ent.gamedata && ent.gamedata.OnPhysgunPickup) then
		return ent.gamedata:OnPhysgunPickup(ply);
	end
end )