DEFINE_BASECLASS("base_gmodentity")

ENT.timeDelay = 0;
ENT.Edic = -1;
ENT.Initalized = false;

function ENT:Initialize()

end

--function ENT:Draw()
--	self:DrawModel();
--end

function ENT:OnRemove()
	
	local gameobject = self:GetObject();
	
	if (gameobject) then -- || (gameobject && gameobject.FLAGS && gameobject.FLAGS.ENTREMOVED) ) then
		gameobject:Remove();
		
		BW.debug:PrintStatement( {"GameObject was removed: ", object}, "GameObject", BW.debug.enums.gameobject.low)

	end
end