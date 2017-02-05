AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.model = ""

function ENT:Initialize()

	self:SetModel(self.model or Model("models/props_junk/CinderBlock01a.mdl"))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject();
	if(phys:IsValid()) then
		phys:Wake();
	end
	
	self.Grabbed = false;
	
end

function ENT:Use(activator,caller, USE_SET)
	
	if (activator:IsPlayer() && activator:IsValid()) && !(self.Grabbed) then
		print(self:Get_itemName())
		print(self:Get_itemWeight())
		print(self:Get_itemDescription())
		Inventory:grabItem(activator,self)
	end
	
end

function ENT:receiveData(item)

	if self:IsValid() then
		local itemData = items[item]
		self:Set_itemName(itemData.Name)
		self:Set_itemWeight(itemData.Weight)
		self:Set_itemDescription(itemData.Description)
		self:Set_itemID(itemData.ID)
		self.model = Model("models/props_junk/PopCan01a.mdl")
	end
	
end