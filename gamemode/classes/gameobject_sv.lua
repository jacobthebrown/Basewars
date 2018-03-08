GameObject = GameObject or {};
GameObject.AllGameObjects = GameObject.AllGameObjects or {};
GameObject.registry = GameObject.registry or {}; 
GameObject.hooks = GameObject.hooks or {};
GameObject.hooks.OnOwnerSpawn = GameObject.hooks.OnOwnerSpawn or {};

--//
--//	Constructs a metatable for an incoming GameObject.
--//
function GameObject:new( metaObject, metaInstance, ply, position, angle, OBJFLAGS )
	
	-- Check if player that created the GameObject, exists.
	if (ply == nil || !ply:IsValid() || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create the physical entity that the player interacts with.
	metaInstance.ent = ents.Create( "ent_skeleton" );
	if ( !IsValid( metaInstance.ent ) ) then return end
	metaInstance.ent.gamedata = metaInstance;
	metaInstance.ent:Spawn();
	metaInstance.ent:SetPos(position);
	
	if (angle != nil) then
		metaInstance.ent:SetAngles(angle);
	end
	
	-- Create a clone of the metatable of the GameObject.
	setmetatable( metaInstance, metaObject ) 
	table.insert(GameObject.AllGameObjects, metaInstance)
	
	metaInstance.FLAGS = OBJFLAGS or {};

	
	if (OBJFLAGS != nil) then
	
		if (OBJFLAGS.FROZEN) then
			local phys = metaInstance.ent:GetPhysicsObject();
	 
			if metaInstance and metaInstance.ent:IsValid() then
				phys:EnableMotion(false);
			end
		end
		
		if (OBJFLAGS.COLLISION) then
			metaInstance.ent:SetCollisionGroup(OBJFLAGS.COLLISION);
		end
		
		if (OBJFLAGS.ONGROUND) then
			
			local tr = util.TraceLine( {
				start = metaInstance.ent:GetPos(),
				endpos = metaInstance.ent:GetPos() - Vector(0,0,1);
				filter = function( ent ) if (ent:IsWorld()) then return true end end
			} )
			
			if (!tr.Hit) then
				metaInstance.ent:Remove();
				return nil;
			end
		end
		
		if (OBJFLAGS.UNIQUE) then
			for k, v in pairs (GameObject:GetAllGameObjects()) do
				if (v.entityType == metaInstance.entityType) then
					v:Remove();
				end
			
			end
		end
		
		if (OBJFLAGS.UNMOVEABLE) then
			metaInstance.FLAGS.UNMOVEABLE = true;
		end
		
	end
	
	if (metaObject.OnOwnerSpawn != nil) then
		local hookFunction = table.KeyFromValue(metaObject, metaObject.OnOwnerSpawn);
		table.insert(GameObject.hooks[hookFunction], metaInstance );
	end
	if (metaObject.OnPhysgunPickup != nil) then
		local hookFunction = table.KeyFromValue(metaObject, metaObject.OnPhysgunPickup);
		table.insert(GameObject.hooks[hookFunction], metaInstance );
	end
	
	return metaInstance;
end

--//
--//	Registers the meta table of the object in the registry.
--//
function GameObject:Register( ObjectType, MetaObject )
	GameObject.registry[ObjectType] = MetaObject;
end

--//
--//	Finds the meta game object from the registry.
--//
function GameObject:GetObject( ObjectName )
	return GameObject.registry[ObjectName] or nil;
end

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
--//	Sends GameData for a single game object to all clients.
--//
function GameObject:TriggerEvent(ent, gamedata, event, args) 

	net.Start("GameObject_SendTriggerEvent");
	net.WriteUInt(ent:EntIndex(), 8);
	net.WriteTable(gamedata);
	net.WriteString(event);
	net.WriteTable(args or {});
	net.Broadcast();
	
end

--//
--//	Sends GameData for a single game object to all clients.
--//
function GameObject:TriggerEventLocal(ply, ent, gamedata, event, args, callback) 

	net.Start("GameObject_SendTriggerEvent");
	net.WriteUInt(ent:EntIndex(), 8);
	net.WriteTable(gamedata);
	net.WriteString(event);
	net.WriteTable(args or {});
	net.Send(ply);
	
	if (isfunction(callback)) then
		callback();
	end
	
end

--//
--//	Sends GameData about many game object to all clients.
--//
function GameObject:SendGameDataMany(ply, objs)
	net.Start("GameObject_SendGameDataMany");
	net.WriteTable(objs);
	net.Send(ply);
end

function GameObject:GetAllGameObjects()

	return GameObject.AllGameObjects;
	
end

function GameObject:RemoveGameObject(obj)
	table.RemoveByValue(GameObject.AllGameObjects, obj);
	
	for k, v in pairs (GameObject.hooks) do
		table.RemoveByValue(v, obj);
	end
end

--[[
--		
--		Console Command Functions.
--
--]]
concommand.Add( "create", function( ply, cmd, args ) 
	
	if (GameObject:GetObject("Object_" .. args[1]) == nil) then
		return 
	end
	
    local trace = {};
    trace.start = ply:EyePos();
    trace.endpos = trace.start + ply:GetAimVector() * 85;
    trace.filter = ply;
    
    local tr = util.TraceLine(trace);
	local newObject = GameObject:GetObject("Object_" .. args[1]):new(ply, tr.HitPos); 
	
	GameObject:SendGameDataSingle(ply, newObject.ent, newObject);
	
end)
 
hook.Add( "PlayerSpawn", "GameObject_OnOwnerSpawn", function(ply)
	for k, v in pairs(GameObject.hooks.OnOwnerSpawn) do
		if (v.owner == ply) then
			v:OnOwnerSpawn();
		end
	end
end )
hook.Add( "PhysgunPickup", "GameObject_OnPhysgunPickup", function( ply, ent )
	if (ent.gamedata != nil && ent.gamedata.OnPhysgunPickup != nil) then
		return ent.gamedata:OnPhysgunPickup(ply);
	else
		return true;
	end
end )