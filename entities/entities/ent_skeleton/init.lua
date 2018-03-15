AddCSLuaFile("cl_init.lua")
DEFINE_BASECLASS("base_gmodentity")

ENT.TimeInitalized = 0;

function ENT:Initialize()

	self:SetModel(Model(self:GetObject():GetModel()) or Model("models/props_lab/servers.mdl"));
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	--self:AddEffects(EF_ITEM_BLINK)
	
	local phys = self:GetPhysicsObject();
	if(phys:IsValid()) then
		phys:Wake();
	end
	
	self:SetNWInt( 'EdicID', self:GetObject():GetIndex() )
	
end

function ENT:Use(activator, caller, USE_SET)
	
	if ( caller:IsValid() or caller:IsPlayer()) then
		if (self:GetObject() != nil and self:GetObject().Use != nil) then
			self:GetObject():Use(activator, self);	
		end
	end
end


function ENT:OnRemove()
	if (self:GetObject()) then
		self:GetObject():Remove();
	end
end

--function ENT:OnTakeDamage(dmginfo)
--	
--	local gamedata = self.gamedata;
--	
--	if (gamedata && self.gamedata.health) then
--	
--		gamedata:OnTakeDamage(dmginfo);
--
--	end
--
--end