basewars.util.ents = basewars.util.ents or {};

local ENTS = basewars.util.ents;

--//
--//
--//
function ENTS:RecieveGameData( msgLength )
	
	local targetEntity, gamedata = net.ReadEntity(), net.ReadTable();
    targetEntity.gamedata = gamedata;

        
end 
net.Receive( "Entity_SendGameDataSingle", ENTS.RecieveGameData)
-- We do ENTS.Recieve instead of ENTS:Recieve because '.' is referenceing and ':' is invoking.


--//
--//
--//
function ENTS:RecieveAllGameData( msgLength )
	
	local targetEntities = net.ReadTable();

    PrintTable(targetEntities);
	
	for k, v in pairs (targetEntities) do
	
		local ent = v.ent;
		local gamedata = v.gamedata;
    	ent.gamedata = gamedata;
	
	end
        
end
net.Receive( "Entity_SendGameDataMany", ENTS.RecieveAllGameData)
-- We do ENTS.RecieveAllGameData instead of ENTS:RecieveAllGameData because '.' is referenceing and ':' is invoking.