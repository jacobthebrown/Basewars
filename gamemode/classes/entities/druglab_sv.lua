Object_DrugLab = {};
Object_DrugLab.__index = Object_DrugLab;
GameObject:Register( "Object_DrugLab", Object_DrugLab)
local Object = Object_DrugLab;

--//
--//	Constructs a drug lab object.
--//
function Object:new( ply, position, maxBalance, printAmount )
	
	local metaInstance = {
		entityType = "Object_DrugLab",
		propModel = "models/props_lab/crematorcase.mdl",
		owner = ply or nil,
		ent = nil,
		maxBalance = maxBalance or CONFIG_DefaultMaxBalance,
		printAmount = printAmount or CONFIG_DefaultPrintAmount,
		balance = 0,
		lastDispensed = CurTime() or 0,
	}
	
	return GameObject:new(Object, metaInstance, ply, position);
end

--//
--//	Entity prints money unless full, returns the balance.
--//
function Object:Print()
    self.balance = math.min( self.balance + self.printAmount, self.maxBalance);
    
    return self.balance;
end

--//
--//	Withdraw drugs from entity.
--//
function Object:Withdraw(ply, amount)
    if (self.balance > 0 && ply:IsValid()) then
        ply.gamedata:GiveDrugs(math.min(amount, self.balance));
        self.balance = self.balance - math.min(amount, self.balance);
    end
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function Object:Use(ply, ent)	
	if (ply:IsValid() && CurTime() >= self.lastDispensed + 1) then 
		Object_DrugItem:new( ply, ent:LocalToWorld(Vector(20,-5,-25)), ent:LocalToWorldAngles(Angle(90,0,90)) )
		self.lastDispensed = CurTime()
		self.ent:EmitSound("buttons/button4.wav")
	end
end

--//
--// Garbage collects the object.
--//
function Object:Remove() 
	GameObject:RemoveGameObject(self);
	self.ent:Remove();
end

------------[[
--		
--		Static Functions
--
------------]]

