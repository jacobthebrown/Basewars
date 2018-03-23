local Object = {};
Object.members = {
	model = "models/props_lab/servers.mdl",
	maxHealth = 1000,
	balance = 0, 
	maxBalance = 1000, 
	printAmount = 10,
	upgrades = {}
};

Object.upgradetree = {
	[1] = { 
		effects = { 
			["Immediate"] = BW.upgrade:HealthIncreaser(500),
			["OnTakeDamage"] = BW.upgrade:DamageReducer(DMG_BULLET, 0.50)
		},
		children = {2},
		parent = {}
	},
	[2] = {
		effects = {},
		parent = {1}
	}
}

--//
--//	Constructs a money printer object.
--//
function Object:new( ply, position)
	return GameObject:new(Object, clone(Object.members), ply, position, ply:LocalToWorldAngles(Angle(0,180,0)));
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
function Object:Upgrade(upgradeID)

	local upgrade = Object.upgradetree[upgradeID];

	if (upgrade && !table.HasValue(self.upgrades, upgradeID)) then
	
		table.insert(self.upgrades, upgradeID);
	
		print("Upgrading");
		
		for k, v in pairs(upgrade.effects) do
			if (k == "Immediate") then
				v(self);
			end
		end
		
	end
	
	
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
	timer.Create( "Timers_PrintAll", 10, 0, function() 

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

GameObject:Register( "Object_MoneyPrinter", Object)

