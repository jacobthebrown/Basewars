local Object = {};
   
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

GameObject:Register( "Object_Soda", Object);