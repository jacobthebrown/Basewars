--//
--//	Constructs a metatable for an incoming GameObject.
--//
function GameObject:new( metaObject, gameobject )


	local ent = BW.utility:GetEntityByEdic(gameobject.entityEdic)

	if (!ent || !ent:IsValid() || ent:GetObject()) then
		return nil;
		--error("Client game object did not have a entity or already had a gameobject.")	
	end

	-- Create a clone of the metatable of the GameObject.
	setmetatable( gameobject, metaObject ) 
	gameobject.InitializedTime = CurTime();
	GameObject:AddGameObject(gameobject);
	ent:SetObject(gameobject);
	ent:CallOnRemove( "RemoveGameObject", function( entity ) if (entity:GetObject()) then entity:GetObject():Remove() end end )
	
	return gameobject;
end

--//////////////////////////////////////////////////////////////////////////////
--///GameObject Networking Functions-------------------------------------------/
--//////////////////////////////////////////////////////////////////////////////

--//
--//	Triggered when the server has sent client to the data about a
--//	particular game object.
--//
function GameObject:RecieveGameObjectData()

	-- Read net data for game object
	local rawobject = net.ReadTable();
	
	BW.debug:PrintStatement({"[Client] Client has recieved information about: ", rawobject}, "Networking" , BW.debug.enums.network.low) 
	
	GameObject:InitializeOrMerge(rawobject);
	
end 
net.Receive( "GameObject_SendGameObjectData_AboutOne", GameObject.RecieveGameObjectData)

--//
--//	Triggered when the server has sent client to the data about a
--//	many game objects.
--//
function GameObject:RecieveGameObjectsData()
	
	local rawobjects = net.ReadTable();
	
	BW.debug:PrintStatement({"[Client] Client has recieved information about: ", rawobjects}, "Networking" , BW.debug.enums.network.high) 
	
	for k, rawobject in pairs (rawobjects) do
		GameObject:InitializeOrMerge(rawobject);
	end
end	
net.Receive( "GameObject_SendGameObjectData_AboutMany", GameObject.RecieveGameObjectsData)

function GameObject:InitializeOrMerge(rawobject, eventname, args)

	if (!rawobject) then
		error("Raw object was nil")
		return nil;
	end

	local rawIndex = rawobject.objectIndex;
	local ent = BW.utility:GetEntityByEdic(rawobject.entityEdic);
	

	-- If the entity doesn't exist for the client yet, we need to put it in the queue to load it.
	if (!ent || !ent:IsValid()) then
		GameObject.unloadedents[rawIndex] = GameObject.unloadedents[rawIndex] or {};
		GameObject.unloadedents[rawIndex] = {rawobject = rawobject, eventname = eventname or nil, args = args or nil};
	else
		
		local fetchedObject = GameObject:GetGameObject(rawobject.objectIndex);
	
		if (!fetchedObject && GameObject.registry[rawobject.objectType]) then
			
			local metaObject = GameObject.registry[rawobject.objectType];
	    	return metaObject:new(rawobject);
	    else
	    	table.Merge(fetchedObject, rawobject);
	    	return fetchedObject;
	    end
	end

	return nil;
	
end
--//
--//	Triggered when the server has sent client to the data about a particular game object.
--//
function GameObject:RecieveTriggerEvent()

	-- Read net data for event.
	local rawobject = net.ReadTable();
	local eventname = net.ReadString();
	local args = net.ReadTable();
	local gameobject = nil;
	
	BW.debug:PrintStatement({"[Client] Client has recieved information about: ", rawobject, ", and the event triggered: ", eventname}, "Networking" , BW.debug.enums.network.high) 
	
	-- Find entity with given entity index.
	local ent = rawobject.entityIndex;
	
	if (args.FLAGS && args.FLAGS.ENTREMOVED) then
	-- If the entity has been removed by the time this event was triggered.
		local metaObject = GameObject.registry[rawobject.objectType];
		local objectInstance = metaObject:new(rawobject);
		objectInstance[eventname](objectInstance, args);
		return;
	else
		local metaObject = GameObject.registry[rawobject.objectType];
		local objectInstance = metaObject:new(rawobject);
		objectInstance[eventname](objectInstance, args);
		return;
	end
	
	local gameobject = GameObject:InitializeOrMerge(rawobject, eventname, args);
	
	if (gameobject) then
		gameobject[eventname](gameobject, args);
	end

end 
net.Receive( "GameObject_SendTriggerEvent", GameObject.RecieveTriggerEvent)

--//////////////////////////////////////////////////////////////////////////////
--///GameObject hooks---------------------------------------------------------/
--////////////////////////////////////////////////////////////////////////////
timer.Create( "LoadGameObject", .1, 0, function() 
	
	-- For all unloaded entity.
	for k,v in pairs(GameObject.unloadedents) do
		
		-- Remove it from list.
		GameObject.unloadedents[k] = nil;
		
		local gameobject = GameObject:InitializeOrMerge(v.rawobject);
		
		if (initalizedObject && v.eventname) then
			gameobject[v.eventname](gameobject, args);				
		end
		
	end
	
end)
	
hook.Add( "PostDrawOpaqueRenderables", "GameObject_RenderAll", function()
	
	for k, v in pairs(ents.GetAll()) do
		if (v:GetObject()) then
			if (v:GetObject().Draw && LocalPlayer():GetPos():DistToSqr(v:GetPos()) < 262144) then
				v:GetObject():Draw();
			end
			if (v:GetObject().DrawGlobal) then
				v:GetObject():DrawGlobal();
			end
		end
	end
end )

hook.Add( "HUDPaint", "GameObject_RenderHUD", function()
	
	for k, v in pairs(ents.GetAll()) do
		if (v:GetObject()) then
			if (v:GetObject().DrawHUD && v:GetObject():GetOwner() == LocalPlayer()) then
				v:GetObject():DrawHUD();
			end
		end
	end
end )