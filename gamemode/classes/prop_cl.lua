local Object = {};

Object.FLAGS = { UNBUYABLE = true };

Object.upgradetree = {
	[1] = { 
		name = "Test Test", 
		desc = "Doubles the health of the prop!", 
		children = {2},
		parent = {}
	}
}

--//
--//	Constructs a spawn point object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

GameObject:Register( "Object_Prop", Object);