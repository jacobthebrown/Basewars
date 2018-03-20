DEFINE_BASECLASS("base_gmodentity")

ENT.timeDelay = 0;
ENT.Edic = -1;
ENT.Initalized = false;

function ENT:Initialize()

end

function ENT:Draw()
	self:DrawModel();
end

function ENT:OnRemove()
	
	local gameobject = self:GetObject() or nil;
	
	if (gameobject || (gameobject && gameobject.FLAGS && gameobject.FLAGS.ENTREMOVED) ) then
		gameobject:Remove();
	end
end