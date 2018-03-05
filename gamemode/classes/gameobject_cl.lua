GameObject = GameObject or {};
GameObject.__index = GameObject;
GameObject.registry = GameObject.registry or {}; 

--//
--//	Constructs a money printer object.
--//
function GameObject:new( metaObject, metaInstance )

	-- Create a clone of the metatable of the GameObject.
	setmetatable( metaInstance, metaObject ) 

	return metaInstance;
end

--//
--//
--//
function GameObject:Register( ObjectType, MetaObject )
	GameObject.registry[ObjectType] = MetaObject;
end

--//
--//
--//
function GameObject:NewClient( msgLength )
	
	local gamedata = net.ReadTable();
	
	local ent = gamedata.ent;
	local MetaObject = GameObject.registry[gamedata.entityType];
    local objectInstance = MetaObject:new(gamedata);
        
end 
net.Receive( "GameObject_SendGameInitSingle", GameObject.NewClient)
-- We do GameObject.Recieve instead of GameObject:Recieve because '.' is referenceing and ':' is invoking.

--//
--//
--//
function GameObject:RecieveGameData( msgLength )
	
	local targetEntity, gamedata = net.ReadEntity(), net.ReadTable();
    
    if (targetEntity.gamedata != nil) then
		targetEntity.gamedata = gamedata;
		return;
	end
    
    local recursiveUpdate = function(srcTbl, destTbl)
    
	    for k, v in pairs (srcTbl) do
			
			if (destTbl.k == nil) then
				destTbl.k = v;
				continue;
			end
			
			if (istable(v)) then
				recursiveUpdate(destTbl.k, v)
			else
				destTbl.k = v;
				continue;
			end
			
		end    	
    	
    end
    recursiveUpdate(gamedata, targetEntity.gamedata);

    
    PrintTable(targetEntity.gamedata);

        
end 
net.Receive( "GameObject_SendGameDataSingle", GameObject.RecieveGameData)


--//
--//
--//
function RecieveGameDataMany( msgLength )
	
	local ents = net.ReadTable();

    PrintTable(ents);
	
	for k, v in pairs (ents) do
	
		local ent = v.ent;
		local gamedata = v.gamedata;
    	ent.gamedata = gamedata;
    	
		if (ent.gamedata != nil) then
			ent.gamedata = gamedata;
			return;
		end
    	
	    local recursiveUpdate = function(srcTbl, destTbl)
	    
		    for k, v in pairs (srcTbl) do
				
				if (destTbl.k == nil) then
					destTbl.k = v;
					continue;
				end
				
				if (istable(v)) then
					recursiveUpdate(destTbl.k, v)
				else
					destTbl.k = v;
					continue;
				end
				
			end    	
	    	
	    end
	    recursiveUpdate(gamedata, ent.gamedata);
	    
    	PrintTable(ent.gamedata);
	
	end
        
end	
net.Receive( "GameObject_SendGameDataMany", RecieveGameDataMany)