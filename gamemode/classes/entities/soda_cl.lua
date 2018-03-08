Object_Soda = {};
Object_Soda.__index = Object_Soda;
GameObject:Register( "Object_Soda", Object_Soda)
local Object = Object_Soda;
   
--//
--//	Constructs a soda object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

--//
--//	Event: Triggered when the client drinks a soda.
--//
function Object:DrinkSoda( args )
	LocalPlayer():EmitSound("physics/metal/soda_can_impact_hard2.wav");
    LocalPlayer():PrintMessage( HUD_PRINTTALK, "You drink the can of soda."); 
end

--//
--// Garbage collects the object.
--//
function Object:Remove() 
	GameObject:RemoveGameObject(self);
end