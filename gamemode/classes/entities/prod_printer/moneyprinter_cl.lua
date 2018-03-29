local Object = GameObject:Register( "Object_MoneyPrinter", Object);

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

	local ent = self:GetEntity();

	if (!ent:IsValid()) then return end

	local vectorTranslation = ent:LocalToWorld(Vector(17 ,0, 50));
	local angleTranslation = ent:LocalToWorldAngles(Angle(0, 90, 90));
	local scale = 0.1;
	
	cam.Start3D2D(vectorTranslation, angleTranslation, scale);
		draw.DrawText("Balance: " .. tostring(self.balance), "EuropaBrush3D2D", 0, 200, Color(255,255,255), TEXT_ALIGN_CENTER);
		draw.DrawText("Health: " .. tostring(self.health), "EuropaBrush3D2D", 0, 300, Color(255,255,255), TEXT_ALIGN_CENTER);
	cam.End3D2D();

end
