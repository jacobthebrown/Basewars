local Object = {};
Object.members = {
	model = "models/props_lab/servers.mdl",
	maxHealth = 1000,
	balance = 0, 
	maxBalance = 1000, 
	printAmount = 10,
};

Object.upgradetree = {
	[1] = { 
		name = "Armor Plating", 
		desc = "Adds health and damage resistence to gunshots.", 
		children = {2},
		parent = {}
	},
	[2] = {
		name = "Hotstreak",
		desc = "Prints 2x Faster for 5 minutes",
		parent = {1}
	}
}

--//
--//	Constructs a money printer object.
--//`
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


GameObject:Register( "Object_MoneyPrinter", Object);