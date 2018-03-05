GameObject = {};

--//
--//	Constructs a money printer object.
--//
function GameObject:new( metaObject, metaInstance, ply, position, angle )
	
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
	
	return metaInstance;
end

function GameObject:newClient(tbl)

	PrintTable(tbl)
	net.Start("GameObject_SendGameInitSingle")
	net.WriteTable(tbl);
	net.Broadcast();
	
end

function GameObject:SendGameDataSingle(ent, tbl) 
    
	net.Start("GameObject_SendGameDataSingle");
	net.WriteEntity(ent);
	net.WriteTable(tbl);
	net.Broadcast();
	
end

function GameObject:SendGameDataMany(tbl) 
	net.Start("GameObject_SendGameDataMany");
	net.WriteTable(tbl);
	net.Broadcast();
end