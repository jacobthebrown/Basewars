Object_MoneyPrinter = Object_MoneyPrinter or {};
Object_MoneyPrinter.__index = Object_MoneyPrinter;
GameObject:Register( "Object_MoneyPrinter", Object_MoneyPrinter)
local Object = Object_MoneyPrinter;

--//
--//	Constructs a money printer object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end
