local Object = GameObject:Register( "Object_Player", Object);

Object.members = {
    wealth = 0, 
    settings = nil
};

Object.members.settings = {
    CHAR = {}, 
    FRIENDS = {}, 
    TEAM = nil, 
    PPSETTINGS = {
        FRIENDSALLOWED = { 
            PROPS = false, 
            TOOL = false
            
        }, 
        TEAMALLOWED = {
            PROPS = false, 
            TOOL = false
        } 
    },
    ADMIN = false
};


Object.override = {};

Object.FLAGS = { UNBUYABLE = true };