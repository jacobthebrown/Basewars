if SERVER then
    
    local function IncludeFromDirectory(dir) 
        
        local dirFiles, dirDirectories = file.Find("basewars/gamemode/" .. dir .. "*", "LUA");
        local sharedFiles = {};
        local serverFiles = {};
       
        for k, fileName in pairs(dirFiles) do
            if (string.match(fileName, "_sv.lua$")) then
                table.insert(serverFiles, dir .. fileName);
            elseif (string.match(fileName, "_sh.lua$")) then
                table.insert(sharedFiles, dir .. fileName);
            end
        end
    
        -- Shared files should be loaded first because they might have dependencies for both the server and client.
        for i=1, #sharedFiles do
            include(sharedFiles[i]);
        end
        for i=1, #serverFiles do
            include(serverFiles[i]);
        end
    
        for i=1, #dirDirectories do
            IncludeFromDirectory(dir..dirDirectories[i].."/") 
        end
    
        
    end
    
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
    
    function ExecuteIncludes() 
    
        IncludeFromDirectory("core/")
        AddCSLuaFileFromDirectory("core/");
        IncludeFromDirectory("classes/")
        AddCSLuaFileFromDirectory("classes/");
        
    end

    ExecuteIncludes()

end

if CLIENT then
        
    
    local function IncludeFromDirectory(dir) 
        
        local dirFiles, dirDirectories = file.Find("basewars/gamemode/" .. dir .. "*", "LUA");
        local sharedFiles = {};
        local clientFiles = {};
       
        for i=1, #dirFiles do
            if (string.match(dirFiles[i], "_cl.lua$")) then
                table.insert(clientFiles, dir .. dirFiles[i]);
            elseif (string.match(dirFiles[i], "_sh.lua$")) then
                table.insert(sharedFiles, dir .. dirFiles[i]);
            end
        end
    
        -- Shared files should be loaded first because they might have dependencies for both the server and client.
        for i=1, #sharedFiles do
            include(sharedFiles[i]);
        end
        for i=1, #clientFiles do
            include(clientFiles[i]);
        end
    
        for i=1, #dirDirectories do
            IncludeFromDirectory(dir..dirDirectories[i].."/") 
        end
    
        
    end
    
    IncludeFromDirectory("core/");
    IncludeFromDirectory("classes/");
    
end