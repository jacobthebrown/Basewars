Object_VendingMachine = {};
Object_VendingMachine.__index = Object_VendingMachine;
GameObject:Register( "Object_VendingMachine", Object_VendingMachine)
local Object = Object_VendingMachine;

--//
--//	Constructs a vending machine object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

--//
--//	Function for rendering the object to the client.
--//
function Object:Draw()

	local vectorOffset = Vector(21,0,10)
	local angleOffset = Angle(0,90,90)
	local scale = 0.05 -- scale
	
	local ent = self:GetEntity();
	local angle = ent:GetAngles()
	
	local width = math.abs(ent:OBBMins().x) + ent:OBBMaxs().x;
	
	cam.Start3D2D(ent:LocalToWorld(vectorOffset + Vector(-width/2,0,75)), Angle(0,180 + (180 * CurTime()) % 360, 90) , .1);
	
		draw.DrawText("Free Soda!", "TheDefaultSettings", 5, 5, Color(0,0,0), TEXT_ALIGN_CENTER)
		draw.DrawText("Free Soda!", "TheDefaultSettings", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER)
		
	cam.End3D2D();
	cam.Start3D2D(ent:LocalToWorld(vectorOffset + Vector(-width/2,0,75)), Angle(0, (180 * CurTime()) % 360,90) , .1);
	
		draw.DrawText("Free Soda!", "TheDefaultSettings", 5, 5, Color(0,0,0), TEXT_ALIGN_CENTER)
		draw.DrawText("Free Soda!", "TheDefaultSettings", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER)
		
	cam.End3D2D();

	
end