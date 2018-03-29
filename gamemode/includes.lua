if SERVER then
    
    local function AddCSLuaFileFromDirectory(dir) 
        
        local dirFiles, dirDirectories = file.Find("basewars/gamemode/" .. dir .. "*", "LUA");
       
        for i=1, #dirFiles do
            if (string.match(dirFiles[i], "_cl.lua$") or string.match(dirFiles[i], "_sh.lua$")) then
                AddCSLuaFile(dir .. dirFiles[i])
            end
        end
    
        for i=1, #dirDirectories do
            AddCSLuaFileFromDirectory(dir..dirDirectories[i] .. "/") 
        end
        
    end
    
    
    AddCSLuaFileFromDirectory("core/");
    AddCSLuaFileFromDirectory("classes/");

end

--//
--// Recursively includes all client/server/shared lua files within folder.
--//
local function IncludeRecursively(dir) 
    
    local dirFiles, dirDirectories = file.Find("basewars/gamemode/" .. dir .. "*", "LUA");
    local sharedFiles = {};
    local genericFiles = {};
   
    -- If client, include all cs files, otherwise include all sv files.
    if (CLIENT) then
        for i=1, #dirFiles do
            if (string.match(dirFiles[i], "_cl.lua$")) then
                table.insert(genericFiles, dir .. dirFiles[i]);
            elseif (string.match(dirFiles[i], "_sh.lua$")) then
                table.insert(sharedFiles, dir .. dirFiles[i]);
            end
        end
    else
        for k, fileName in pairs(dirFiles) do
            if (string.match(fileName, "_sv.lua$")) then
                table.insert(genericFiles, dir .. fileName);
            elseif (string.match(fileName, "_sh.lua$")) then
                table.insert(sharedFiles, dir .. fileName);
            end
        end
    end

    -- Shared files from this directory, should be include first, as they may
    -- have dependencies.
    for i=1, #sharedFiles do
        include(sharedFiles[i]);
    end
    for i=1, #genericFiles do
        include(genericFiles[i]);
    end

    for i=1, #dirDirectories do
        IncludeRecursively(dir..dirDirectories[i].."/") 
    end
    
end

IncludeRecursively("core/");
IncludeRecursively("classes/");
