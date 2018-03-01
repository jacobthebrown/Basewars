AddCSLuaFile("cl_init.lua")

DEFINE_BASECLASS("base_gmodentity")

ENT.model = ""
ENT.gamedata = {};
ENT.InitializeTime = 0;

function ENT:Initialize()

	self:SetModel(Model("models/props_lab/servers.mdl")) -- (self.model or Model("models/props_junk/CinderBlock01a.mdl"))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject();
	if(phys:IsValid()) then
		phys:Wake();
	end
	
	self.Grabbed = false;
	
	local phys = self:GetPhysicsObject()
 
	if phys and phys:IsValid() then
		phys:EnableMotion(false) -- Freezes the object in place.
	end
	
end

function ENT:Use(activator, caller, USE_SET)
	
	if ( caller:IsPlayer() && caller:IsValid() ) then
		if (self.gamedata != nil) then
			self.gamedata:Use(activator, self);	
		end
	end
	
end


function ENT:OnRemove()

	self.gamedata = {};	
	
end