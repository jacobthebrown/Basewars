function GameObject:new(metaObject, object, ply, pos, angle)
	
	-- Check if player that created the gameobject, exists.
	if (!ply || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the game object.
	setmetatable( object, metaObject );
	
	-- Issue object an edic. 
	object:SetEdic(GameObject:IssueEdic());
	
	-- The gameobject's physical form is an entity.
	local ent = BW.utility:CreateEntity("ent_skeleton", pos, angle);
	ent:SetObject(object);
	
	PrintTable(ent:GetObject());
	ent:Spawn();
	
	-- Assign ownership, give health, set object type, and set entity.
	object:SetOwner(ply);
	object:SetHealth(object:GetMaxHealth());
	object:SetType(metaObject.objectType);
	object:SetEntity(ent);

	-- Add object to global object's list.
	GameObject:AddGameObject(object);

	---Game Object Flags Handled Here-------------------------------------------
	
	-- If game object should be spawned frozen.
	if (metaObject.FLAGS && metaObject.FLAGS.FROZEN) then
		if object and ent:IsValid() then
			ent:GetPhysicsObject():EnableMotion(false);
		end
	elseif (metaObject.FLAGS == nil || metaObject.FLAGS.FROZEN == nil) then
		ent:GetPhysicsObject():EnableMotion(false);
	end
	
	-- If game object has custom collisions.
	if (metaObject.FLAGS && metaObject.FLAGS.COLLISION) then
		ent:SetCollisionGroup(metaObject.FLAGS.COLLISION);
	end
	
	-- If game object must be spawned on the ground.
	if (metaObject.FLAGS && metaObject.FLAGS.ONGROUND) then
		
		local tr = util.TraceLine( {
			start = ent:GetPos(),
			endpos = ent:GetPos() - Vector(0,0,2);
			filter = function(ent) return ent:IsWorld() end
		} )
		
		if (!tr.Hit) then
			ent:Remove();
			return error("GameObject (Error): This object can only be spawned on a flat surface, on the ground.");
		end
	end
	
	-- If game object should not be moved.
	if (metaObject.FLAGS && metaObject.FLAGS.UNMOVEABLE) then
		--metaObject.FLAGS.UNMOVEABLE = true;
	end

	---Game Object Hooks are handled here---------------------------------------

	-- It is expensive to find functions, therefore we take the function out of it's loop.
	--local reghook = GameObject.RegisterHook;

	-- If game object has any hook functions, we add it to the hook function register.
	for kHook, vHook in pairs (GameObject.hooks) do
		for kFunc, vFunc in pairs (metaObject) do
			if (isfunction(vFunc) && kHook == kFunc) then
				GameObject:RegisterHook(metaObject, vFunc, object);				
			end
		end
	end

	return object;
end

--//
--//	Constructs a metatable for an incoming GameObject.
--//
function GameObject:newProp(metaObject, object, ent, ply)

	-- Check if player that created the GameObject, exists.
	if (!ply || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the game object.
	setmetatable( object, metaObject );
	
	-- Assign ownership and gain health.
	object:SetOwner(ply);
	object:SetHealth(object:GetMaxHealth());
	
	-- Add Game Object to global list of entities.
	object:SetEdic(GameObject:IssueEdic());
	object:SetType(metaObject.objectType);
	object:SetEntity(ent);
	
	-- Hook onto the entities remove funciton, to delete the object.
	ent:CallOnRemove( "RemoveGameObject", function( ent ) 
		
		local object = ent:GetObject();
		
		if (object) then 
			BW.debug:PrintStatement( {"GameObject is being removed: ", object}, "GameObject", BW.debug.enums.gameobject.low);
			object:Remove() 
		end 
	end)
	
	-- Add object to global object's list.
	GameObject:AddGameObject(object);

	return object;
end

--//
--//	Constructs a metatable for an incoming GameObject which is a player.
--//
function GameObject:newPlayer(metaObject, object, ply)
	
	-- Check if player that created the GameObject, exists.
	if (!object || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the game object.
	setmetatable( object, metaObject );
	
	object:SetEdic(GameObject:IssueEdic());
	object:SetOwner(ply);
	object:SetEntity(ply);
	object:SetType(metaObject.objectType);
	
	-- Add object to global object's list.
	GameObject:AddGameObject(object);
	
	return object;
end

--//////////////////////////////////////////////////////////////////////////////
--///GameObject Networking Functions-------------------------------------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Sends GameObject data for a single game object to all clients.
--//
function GameObject:SendGameObjectDataSingle(ply, object)
	
	if (!ply.GetObject || !ply:GetObject()) then
		return;
	end
	
	BW.debug:PrintStatement( {"[Server] Sending singular GameObject data message to", ply:GetName(), " about: ", object}, "Networking", BW.debug.enums.network.medium)
	
	net.Start("GameObject_SendGameObjectData_AboutOne");
	net.WriteTable(object);
	net.Send(ply);
end

--//
--//	Sends GameData about many game object to all clients.
--//
function GameObject:SendGameObjectDataMany(ply, objects)
	
	BW.debug:PrintStatement( {"[Server] Sending GameObject data about many game objects to ", ply:GetName(), ": ", objects}, "Networking", BW.debug.enums.network.low)

	net.Start("GameObject_SendGameObjectData_AboutMany");
	net.WriteTable(objects);
	net.Send(ply);
end

--//
--//	Sends GameObject data for a single game object to all clients.
--//
function GameObject:TriggerEventLocal(ply, object, event, args)
	
	BW.debug:PrintStatement( {"[Server] Sending GameObject data to local: ", ply:GetName(), " ", object}, "Networking", BW.debug.enums.network.medium)

	net.Start("GameObject_SendTriggerEvent");
	net.WriteTable(object);
	net.WriteString(event);
	net.WriteTable(args or {});
	net.Send(ply);
end

--//
--//	Sends Event for a single game object to all clients.
--//
function GameObject:TriggerEventInSphere(pos, radius, object, event, args) 
	
	local playersInRegion = {};
	for k, v in pairs (ents.FindInSphere( pos, radius )) do
	
		if (v && v:IsPlayer()) then
			table.insert(playersInRegion, v)
		end
		
	end
	
	net.Start("GameObject_SendTriggerEvent");
	net.WriteTable(object);
	net.WriteString(event);
	net.WriteTable(args or {});
	net.Send(playersInRegion);
end


--//
--//	Sends Event for a single game object to all clients.
--//
function GameObject:TriggerEventGlobal(object, event, args) 
	
	local ent = object:GetEntity();
	
	if (ent) then
		ent.transmitting = true;
		ent:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	end
	
	-- This is always going to be a race condition between transmitting the entity
	-- and broadcasting the entitie's object, so I gotta figure out a solution.
	timer.Simple(0.1, function() 
		ent.transmitting = nil;
		ent:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
		
		net.Start("GameObject_SendTriggerEvent");
		net.WriteTable(object);
		net.WriteString(event);
		net.WriteTable(args or {});
		net.Broadcast();
	end)
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
	
	local object = ent:GetObject()
	
	if (object && object.OnPhysgunPickup) then
		return object:OnPhysgunPickup(ply);
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
	if (target:GetObject() && target:GetObject().OnTakeDamage) then
		target:GetObject():OnTakeDamage(dmginfo);
	end
end)