Object_MoneyPrinter = {};
Object_MoneyPrinter.__index = Object_MoneyPrinter;
GameObject:Register( "Object_MoneyPrinter", Object_MoneyPrinter)
local Object = Object_MoneyPrinter;

--//
--//	Constructs a money printer object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

--//
--//	Function for rendering the object to the client.
--//
function Object:Draw()

	local vectorOffset = Vector(17,0,50)
	local angleOffset = Angle(0,90,90)
	local scale = 0.1
	
	local angle = self.ent:GetAngles()
	
	cam.Start3D2D(self.ent:LocalToWorld(vectorOffset), self.ent:LocalToWorldAngles(angleOffset), scale);

		surface.SetDrawColor(255, 255, 255, 255);
		draw.DrawText("Type: " .. tostring(self.entityType), "TheDefaultSettings", 0, 100, Color(255,255,255), TEXT_ALIGN_CENTER);
		draw.DrawText("Balance: " .. tostring(self.balance), "TheDefaultSettings", 0, 200, Color(255,255,255), TEXT_ALIGN_CENTER);
		
	cam.End3D2D();

end