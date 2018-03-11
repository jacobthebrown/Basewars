GameObject = GameObject or {};

-- On LuaRefresh, We still want keep the hooks, gameobject list, but we want to refresh all the functions.
for k, v in pairs (GameObject) do
	if (isfunction(v)) then
		GameObject[k] = nil;
	end
end

GameObject.AllGameObjects = GameObject.AllGameObjects or {};
GameObject.registry = GameObject.registry or {}; 
GameObject.unloadedents = GameObject.unloadedents or {};
GameObject.unloadedevents = GameObject.unloadedevents or {};

--//
--//	Constructs a metatable for an incoming GameObject.
--//
function GameObject:new( metaObject, gameObj )

	-- Create a clone of the metatable of the GameObject.
	setmetatable( gameObj, metaObject ) 
	GameObject:AddGameObject(gameObj);
	
	gameObj.Remove = function() GameObject:RemoveGameObject(gameObj) end;
	
	return gameObj;
end

--//////////////////////////////////////////////////////////////////////////////
--///MetaObject Registry Functions of the Game Object and Hooks----------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Registers the meta table of the object in the registry.
--//
function GameObject:Register(objectType, metaObject)

	metaObject.SetHealth = function(obj, value) obj.health = value; end
	metaObject.GetHealth = function(obj) return obj.health; end
	metaObject.SetMaxHealth = function(obj, value) obj.maxHealth = value; end
	metaObject.GetMaxHealth = function(obj) return obj.maxHealth; end

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
		
	GameObject.registry[objectType] = metaObject;
	
end

--//
--//	Finds the game object from the registry.
--//
function GameObject:GetMetaObject(ObjectName)
	return GameObject.registry[ObjectName] or nil;
end

--//////////////////////////////////////////////////////////////////////////////
--///GameObject game object operations-----------------------------------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Find and create game object from gamedata and ent.
--//
function GameObject:FindAndCreateGameObject(ent, gamedata)

	local MetaObject = GameObject.registry[gamedata.entityType];
	local objectInstance = MetaObject:new(gamedata);

	objectInstance.ent = ent;
	ent.gamedata = objectInstance;
	ent.Initialized = true;
	return objectInstance;

end

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
end

--//////////////////////////////////////////////////////////////////////////////
--///GameObject Networking Functions-------------------------------------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Triggered when the server has sent client to the data about a particular game object.
--//
function GameObject:RecieveTriggerEvent()

	local entIndex = net.ReadUInt(8); 
	local gamedata = net.ReadTable();
	local eventName = net.ReadString();
	local args = net.ReadTable();
	
	local ent = ents.GetByIndex(entIndex);
	
	PrintTable(args);
	
	if (args.FLAGS) then
		-- If the entity has been removed by the time this event was triggered.
		if (args.FLAGS.ENTREMOVED) then
		    gamedata = GameObject:FindAndCreateGameObject(ent, gamedata);
			return gamedata[eventName](gamedata, args);
		end
	end
	
	-- If the entity doesn't exist for the client yet, we need to put it in the queue to load it.
	if (!ent:IsValid() || !ent.gamedata) then
		table.insert(GameObject.unloadedevents, {FirstRequested = CurTime(), entIndex = entIndex, gamedata = gamedata, eventName = eventName, args = args})
	else
		table.Merge(ent.gamedata, gamedata);
		ent.Initialized = true;
		ent.gamedata[eventName](ent.gamedata, args);
	end
end 
net.Receive( "GameObject_SendTriggerEvent", GameObject.RecieveTriggerEvent)


--//
--//	Triggered when the server has sent client to the data about a
--//	particular game object.
--//
function GameObject:RecieveGameData()

	local entIndex = net.ReadUInt(8); 
	local gamedata = net.ReadTable();
	
	local ent = ents.GetByIndex(entIndex);
	
	-- If the entity doesn't exist for the client yet, we need to put it in the queue to load it.
	if (!ent:IsValid() || !ent.gamedata) then
		table.insert(GameObject.unloadedents, {FirstRequested = CurTime(), entIndex = entIndex, gamedata = gamedata})
	else
		if (GameObject.registry[gamedata.entityType] && !ent.gamedata) then

			local MetaObject = GameObject.registry[gamedata.entityType];
			local objectInstance = MetaObject:new(gamedata);

	    	objectInstance.ent = ent;
	    	ent.gamedata = objectInstance;
	  		ent.Initialized = true;
	    else
			table.Merge(ent.gamedata, gamedata);
		   	ent.Initialized = true;
		end
	end
end 
net.Receive( "GameObject_SendGameDataSingle", GameObject.RecieveGameData)

--//
--//	Triggered when the server has sent client to the data about a
--//	many game objects.
--//
function RecieveGameDataMany()
	
	local objects = net.ReadTable();
	
	for k, v in pairs (objects) do

		local ent = ents.GetByIndex(v.entIndex);
		local gamedata = v.gamedata;
	
		-- If the entity doesn't exist for the client yet, we need to put it in the queue to load it.
		if (!ent:IsValid() || !ent.gamedata) then
			GameObject.unloadedents[v.entIndex] = {FirstRequested = CurTime(), entIndex = v.entIndex, gamedata = gamedata};
		else
	    	if (GameObject.registry[gamedata.entityType] && !ent.gamedata) then
	
				local MetaObject = GameObject.registry[gamedata.entityType];
				local objectInstance = MetaObject:new(gamedata);
		    	
	    		objectInstance.ent = ent;
	    		ent.gamedata = objectInstance;
		    	ent.Initialized = true;
		    else
				table.Merge(ent.gamedata, gamedata);
		    	ent.Initialized = true;
			end
		end
	end
        
end	
net.Receive( "GameObject_SendGameDataMany", RecieveGameDataMany)

--//////////////////////////////////////////////////////////////////////////////
--///Loading Entity Hooks for uninitalized client entities---------------------/
--//////////////////////////////////////////////////////////////////////////////

timer.Create( "LoadEnts", 1, 0, function() 
	
	for k,v in pairs(GameObject.unloadedents) do
		
		local ent = ents.GetByIndex(v.entIndex);
		local gamedata = v.gamedata;
		
		if (ent:IsValid() && !ent.gamedata) then
			
			GameObject.unloadedents[k] = nil;
			
	      	if (!ent.gamedata && GameObject.registry[v.gamedata.entityType]) then
		    	ent.gamedata = GameObject:FindAndCreateGameObject(ent, gamedata);
			else
				ent.gamedata = ent.gamedata or {};
				table.Merge(ent.gamedata, gamedata);
				ent.Initialized = true;
			end
		elseif (!ent:IsValid() && v.FirstRequested + 2 < CurTime()) then
			GameObject.unloadedents[k] = nil;	
		else  	
			GameObject.unloadedents[k] = nil;
		end
		
	end
	
end)

timer.Create( "LoadEvents", 1, 0, function() 
	
	for k,v in pairs(GameObject.unloadedevents) do
		
		local ent = ents.GetByIndex(v.entIndex);
		local gamedata = v.gamedata;
		local eventName = v.eventName;
		local args = v.args;
		
		if (ent:IsValid() && !ent.gamedata) then
			
			GameObject.unloadedevents[k] = nil;
			
	      	if (!ent.gamedata && GameObject.registry[v.gamedata.entityType]) then
		    	ent.gamedata = GameObject:FindAndCreateGameObject(ent, gamedata);
		    	ent.gamedata[eventName](ent.gamedata, args);
			else
				table.Merge(ent.gamedata, gamedata);
				ent.Initialized = true;
				ent.gamedata[eventName](ent.gamedata, args);
			end
		elseif (v.FirstRequested + 1 < CurTime()) then
			GameObject.unloadedevents[k] = nil;	
		else
			GameObject.unloadedevents[k] = nil;
		end
	
		
	end
end)
	
hook.Add( "PostDrawOpaqueRenderables", "GameObject_RenderAll", function()
	
	for k, v in pairs(ents.GetAll()) do
		if (v.gamedata) then
			if (v.gamedata.Draw && LocalPlayer():GetPos():DistToSqr(v:GetPos()) < 262144*10) then
				v.gamedata:Draw();
			end
			if (v.gamedata.DrawGlobal) then
				v.gamedata:DrawGlobal();
			end
		end
	end
end )

hook.Add( "HUDPaint", "GameObject_RenderHUD", function()
	
	for k, v in pairs(ents.GetAll()) do
		if (v.gamedata) then
			if (v.gamedata.DrawHUD && v.gamedata:GetOwner() == LocalPlayer()) then
				v.gamedata:DrawHUD();
			end
		end
	end
end )