local Object = GameObject:Register( "Object_MoneyPrinter", Object);

Object.members = {
	model = "models/props_lab/servers.mdl",
	maxHealth = 1000,
	balance = 0, 
	maxBalance = 1000, 
	printAmount = 10
};

Object.upgradetree = {
	[1] = { 
	    name = "Armor Plating", 
		desc = "Adds health and damage resistence to gunshots.", 
		effects = { 
			["Immediate"] = BW.upgrade:HealthIncreaserConstant(500),
			["OnTakeDamage"] = BW.upgrade:DamageReducer(DMG_BULLET, 0.50)
		},
		children = {2},
		parent = {}
	},
	[2] = {
	   	name = "Hotstreak",
		desc = "Prints 2x Faster for 5 minutes",
		effects = {},
		parent = {1}
	}
}