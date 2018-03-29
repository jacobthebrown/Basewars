AddCSLuaFile("cl_init.lua")
DEFINE_BASECLASS("base_gmodentity")

ENT.TimeInitalized = 0;

function ENT:Initialize()

	PrintTable(debug.getmetatable(self:GetObject()))

	self:SetModel(Model(self:GetObject():GetModel()) or Model("models/props_lab/servers.mdl"));
	
	-- Allows for one 'Use' per button press.
	self:SetUseType(SIMPLE_USE);
	
	-- Initalize Physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	-- Wake up physics.
	local phys = self:GetPhysicsObject();
	if(phys:IsValid()) then
		phys:Wake();
	end
	
end

function ENT:UpdateTransmitState()

	if ( self.transmitting ) then
		print("true")
		return TRANSMIT_ALWAYS
	end
	
	print("false");
	return TRANSMIT_PVS
end


function ENT:Use(activator, caller, USE_SET)
	
	if ( caller:IsValid() or caller:IsPlayer()) then
		
		local object = self:GetObject();
		
		if (object) then
			if (object.Use) then
				object:Use(activator, self);
			else
				BW.debug:PrintStatement( {"GameObject was used but had no 'Use' function: ", object}, "GameObject", BW.debug.enums.gameobject.low);
			end
		
		end
	end
	
end


function ENT:OnRemove()
	
	local object = self:GetObject();
	
	if (object) then
		BW.debug:PrintStatement( {"GameObject is being removed: ", object}, "GameObject", BW.debug.enums.gameobject.low);
		object:Remove();
	end
end
