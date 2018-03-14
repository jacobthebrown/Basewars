local CONFIG_PrintTimer = 3;
local CONFIG_DefaultMaxBalance = 1000;
local CONFIG_DefaultPrintAmount = 1;

Object_MoneyPrinter = {};
Object_MoneyPrinter.__index = Object_MoneyPrinter;
Object_MoneyPrinter.members = {"balance", "maxBalance", "printAmount"};
GameObject:Register( "Object_MoneyPrinter", Object_MoneyPrinter)
local Object = Object_MoneyPrinter;

Object.SkillTree = {
	{ 
		name = "Greased Gears", 
		desc = "", 
		effects = function(obj) obj:SetMaxHealth(obj:GetMaxHealth() + 10); end 
	}
}

--//
--//	Constructs a money printer object.
--//
function Object:new( ply, position, maxBalance, printAmount )
	
	local metaInstance = {
		propModel = "models/props_lab/servers.mdl",
		maxHealth = 1000,
		maxBalance = maxBalance or CONFIG_DefaultMaxBalance,
		printAmount = printAmount or CONFIG_DefaultPrintAmount,
		balance = 0
	}
	
	return GameObject:new(Object, metaInstance, ply, position, ply:LocalToWorldAngles(Angle(0,180,0)));
end

--//
--//	Entity prints money unless full, returns the balance.
--//
function Object:Print()
	self:SetBalance( math.min(self:GetBalance() + self:GetPrintAmount(), self:GetMaxBalance()) );
    return self:GetBalance();
end

--//
--//	Withdraw money from entity.
--//
function Object:Withdraw(ply, amount)
	
	local balance = self:GetBalance();
	local plyobject = ply:GetObject();
	
    if (balance > 0 && ply:IsValid() && plyobject) then
        plyobject:GiveWealth(math.min(amount, balance));
        self:SetBalance(balance - math.min(amount, balance));
    end
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function Object:Use(ply, ent)	
	if (self:GetBalance() > 0) then
		self:Withdraw(ply, self:GetBalance());
	end
end

--//
--//
--//
function Object:Upgrade()	
	PrintTable(self.SkillTree);
end

------------[[
--		
--		Static Functions
--
------------]]

--//
--//	Creates a global timer that loops through every printer and prints.
--//
function InitalizeGlobalTimers()
	timer.Create( "Timers_PrintAll", CONFIG_PrintTimer, 0, function() 

		local updatedPrinters = {};
		for k, v in pairs( GameObject:GetAllGameObjects() ) do
			if (v:GetType() == "Object_MoneyPrinter" && v:GetBalance() + v:GetPrintAmount() <= v:GetMaxBalance()) then
				v:Print();
			end
		end
	end )
end
hook.Add("OnReloaded", "OnReloaded_InitalizeGlobalTimers", InitalizeGlobalTimers)
hook.Add("PostGamemodeLoaded", "Hook_InitalizeGlobalTimers", InitalizeGlobalTimers)

