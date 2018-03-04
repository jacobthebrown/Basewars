MoneyPrinter = MoneyPrinter or {};
MoneyPrinter.__index = MoneyPrinter;

--//
--//	Constructs a money printer object.
--//
function MoneyPrinter:new( ply, position, maxBalance, printAmount )
	
	-- Check if player that created the entity, exists.
	if (ply == nil || !ply:IsValid() || !ply:IsPlayer()) then
		return nil;
	end
	
	-- Create a clone of the metatable of the entity.
	local metaMoneyPrinter = {
		entityType = "cash_moneyprinter",
		balance = 0,
		maxBalance = maxBalance or 1000,
		owner = ply or nil,
		ent = nil,
		printAmount = printAmount or 100
	}
	setmetatable( metaMoneyPrinter, MoneyPrinter ) 
	
	-- Create the physical entity that the player interacts with.
	local physicalEntity = ents.Create( "ent_skeleton" );
	if ( !IsValid( physicalEntity ) ) then return end
	physicalEntity:SetPos(position);
	physicalEntity:Spawn();
	physicalEntity.gamedata = metaMoneyPrinter;
	
	-- Attach the aforementioned physical entity to the enttiy.
	metaMoneyPrinter.ent = physicalEntity;
	
	return metaMoneyPrinter;
end
setmetatable( MoneyPrinter, {__call = MoneyPrinter.new } )