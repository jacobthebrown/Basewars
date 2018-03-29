BW.debug = {};
BW.debug.enums = {
	network =  {low = false, medium = false, high = false},
	gameobject = {low = false, medium = false, high = false}
};
local MODULE = BW.debug;

-- on string concat if table print table
function MODULE:PrintStatement(args, enumType, enum, detailed) 

    local concatString = "";
    for k, v in pairs(args) do
        
        if (istable(v)) then
            if (detailed) then
                concatString = concatString .. BW.util:TableToStringDetailed(v);
            else
                concatString = concatString .. BW.util:TableToStringCompact(v);
            end
        else
            concatString = concatString .. tostring(v);
        end
    end

    if (enum) then
        MsgC( Color( 0, 153, 255 ), "["..enumType.."] ", Color( 255, 255, 255 ), concatString, "\n"  )
    end
end

-- on string concat if table print table
function MODULE:PrintError(args, detailed) 

    local concatString = "";
    for k, v in pairs(args) do
        
        if (istable(v)) then
            if (detailed) then
                concatString = concatString .. BW.util:TableToStringDetailed(v);
            else
                concatString = concatString .. BW.util:TableToStringCompact(v);
            end
        else
            concatString = concatString .. tostring(v);
        end
    end

    MsgC( Color( 0, 153, 255 ), "[Error] ", Color( 255, 255, 255 ), concatString, "\n"  )

end

if (SERVER) then

-- on string concat if table print table
function MODULE:PrintStatementToClients(args, enumType, enum, ply) 

    net.Start("Debug_Message_ServerToClient");
    net.WriteTable(args, true);
    net.WriteString(enumType);
    net.WriteBool(enum);
    net.Send(ply);

end

end

if (CLIENT) then
   
net.Receive("Debug_Message_ServerToClient", function(length, ply) 

    local args = net.ReadTable();
    local enumType = net.ReadString();
    local enum = net.ReadBool();
    
    MODULE:PrintStatement(args, enumType, enum, true);
    
end) 
    
end