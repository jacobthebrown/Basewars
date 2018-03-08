Object_DrugItem = {};
Object_DrugItem.__index = Object_DrugItem;
GameObject:Register( "Object_DrugItem", Object_DrugItem)
local Object = Object_DrugItem;
   
--//
--//	Constructs a drug item object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

--//
--//	Event: Triggered when the client picks up drugs.
--//

function Object:PickupDrugItem( args )
	LocalPlayer():EmitSound("items/smallmedkit1.wav");
    LocalPlayer():PrintMessage( HUD_PRINTTALK, "You pick up the drugs."); 
end

--//
--// Garbage collects the object.
--//
function Object:Remove() 
	GameObject:RemoveGameObject(self);
end