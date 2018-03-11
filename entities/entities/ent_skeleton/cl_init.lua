DEFINE_BASECLASS("base_gmodentity")

ENT.timeDelay = 0;

ENT.Initalized = false;

function ENT:Initialize()
	self.gamedata = nil;
	self.Initalized = false;
end

function ENT:Draw()
	self:DrawModel();
end

function ENT:OnRemove()
	if (self.Initalized && (self.gamedata.FLAGS || self.gamedata.FLAGS.ENTREMOVED) ) then
		self.gamedata:Remove();
	end
end