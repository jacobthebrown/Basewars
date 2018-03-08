DEFINE_BASECLASS("base_gmodentity")

ENT.timeDelay = 0;

function ENT:Initialize()
	self.gamedata = nil;
end

function ENT:Draw()
	self:DrawModel();
end

function ENT:OnRemove()
	self.gamedata:Remove();
end