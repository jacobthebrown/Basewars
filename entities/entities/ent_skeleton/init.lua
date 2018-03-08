AddCSLuaFile("cl_init.lua")
DEFINE_BASECLASS("base_gmodentity")

function ENT:Initialize()

	self:SetModel(Model(self.gamedata.propModel) or Model("models/props_lab/servers.mdl"));
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	local phys = self:GetPhysicsObject();
	if(phys:IsValid()) then
		phys:Wake();
	end
	
end

function ENT:Use(activator, caller, USE_SET)
	if ( caller:IsValid() or caller:IsPlayer()) then
		if (self.gamedata != nil and self.gamedata.Use != nil) then
			self.gamedata:Use(activator, self);	
		end
	end
end


function ENT:OnRemove()
	self.gamedata:Remove();
end