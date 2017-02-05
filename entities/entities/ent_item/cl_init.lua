include("shared.lua")

ENT.Item = {}

ENT.Item.Name = "Default"

ENT.Item.Weight = 0.0

ENT.Item.Description = "Default"

ENT.Item.Type = "Default"

function ENT:Initialize()
	
	self.Item.Name = self:Get_itemName()
	self.Item.Description = self:Get_itemDescription()
	self.Item.Weight = math.Round(self:Get_itemWeight(),2)
	
end

function ENT:Draw()
	self:DrawModel()
end

