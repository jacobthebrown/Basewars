local Object = {};

--//
--//	Constructs a ammo dispenser object for the client.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

--//
--//	Function for rendering the object to the client.
--//
function Object:Draw()

	local vectorOffset = Vector(5, 0, 16);
	local angleOffset = Angle(0, 90, 0);
	local scale = 0.05;
	
	local ent = self:GetEntity();
	local angle = ent:GetAngles()
	
	cam.Start3D2D(ent:LocalToWorld(vectorOffset), ent:LocalToWorldAngles(angleOffset), scale)
		draw.DrawText("Type: " .. tostring(self:GetType()), "TheDefaultSettings", 0,100, Color(255,255,255), TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

GameObject:Register( "Object_AmmoDispenser", Object);