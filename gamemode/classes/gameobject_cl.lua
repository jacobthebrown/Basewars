local CONFIG_PrintTimer = 3;

GameObject = {};

--//
--//	Constructs a money printer object.
--//
function GameObject:new( metaObject, metaProperties, ply, position )
	
	-- Check if player that created the GameObject, exists.
	if (ply == nil || !ply:IsValid() || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the GameObject.
	setmetatable( metaProperties, metaObject ) 
	
	-- Create the physical GameObject that the player interacts with.
	local physicalEntity = ents.Create( "ent_skeleton" );
	if ( !IsValid( physicalEntity ) ) then return end
	physicalEntity.gamedata = metaProperties;
	physicalEntity:Spawn();
	physicalEntity:SetPos(position);
	
	-- Attach the aforementioned physical entity to the enttiy.
	metaProperties.ent = physicalEntity;
	
	return metaProperties;
end