local Object = GameObject:Register( "Object_Prop");

Object.FLAGS = { UNBUYABLE = true };

Object.upgradetree = {
	[1] = { 
		name = "Test Test", 
		desc = "Doubles the health of the prop!", 
		effects = { 
			["Immediate"] = BW.upgrade:HealthIncreaserMultiple(2)
		},
		children = {2},
		parent = {}
	}
}