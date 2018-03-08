Object_DrugLab = {};
Object_DrugLab.__index = Object_DrugLab;
GameObject:Register( "Object_DrugLab", Object_DrugLab)
local Object = Object_DrugLab;

--//
--//	Constructs a drug lab object.
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
		--draw.DrawText("Balance: " .. tostring(self.balance), "TheDefaultSettings", 0, 200, Color(255,255,255), TEXT_ALIGN_CENTER);
		
	cam.End3D2D();

end

--//
--// Garbage collects the object.
--//
function Object:Remove() 
	GameObject:RemoveGameObject(self);
end