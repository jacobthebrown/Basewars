BW.debug = {};
BW.debug.enums = {
	network =  {low = false, medium = false, high = false},
	gameobject = {low = false, medium = false, high = false}
};
local MODULE = BW.debug;

-- on string concat if table print table
function MODULE:PrintStatement(args, enumType, enum) 

    local concatString = "";
    for k, v in pairs(args) do
        
        if (istable(v)) then
            concatString = concatString .. BW.utility:TableToStringCompact(v);
        else
            concatString = concatString .. tostring(v);
        end
    end

    if (enum) then
        MsgC( Color( 0, 153, 255 ), "["..enumType.."] ", Color( 255, 255, 255 ), concatString, "\n"  )
    end
end