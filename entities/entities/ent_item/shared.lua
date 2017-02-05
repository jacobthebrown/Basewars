ENT.Type = "anim"
ENT.Base = "ent_base"
ENT.PrintName = "Item"
ENT.Author = ""
ENT.Spawnable = false

DEFINE_BASECLASS("ent_base")

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "_itemName" );
	self:NetworkVar( "Float", 0, "_itemWeight" );
	self:NetworkVar( "String", 1, "_itemDescription" );
	self:NetworkVar( "String", 2, "_itemID")
	
end