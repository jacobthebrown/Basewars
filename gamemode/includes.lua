if SERVER then
    
    local function IncludeFromDirectory(dir) 
        
        local dirFiles, dirDirectories = file.Find("basewars/gamemode/" .. dir .. "*", "LUA");
       
        for k, luaFile in pairs(dirFiles) do
            if (string.match(luaFile, "_sv.lua$") or string.match(luaFile, "_sh.lua$")) then
                include(dir .. luaFile)
                --print(luaFile)
            end
        end
    
        for k, dirFile in pairs(dirDirectories) do
            IncludeFromDirectory(dir..dirFile.."/") 
        end
    
        
    end
    
    local function AddCSLuaFileFromDirectory(dir) 
        
        local dirFiles, dirDirectories = file.Find("basewars/gamemode/" .. dir .. "*", "LUA");
       
        for k, luaFile in pairs(dirFiles) do
            if (string.match(luaFile, "_cl.lua$") or string.match(luaFile, "_sh.lua$")) then
                AddCSLuaFile(dir .. luaFile)
            end
        end
    
        for k, dirFile in pairs(dirDirectories) do
            AddCSLuaFileFromDirectory(dir..dirFile .. "/") 
        end
        
    end
    
    function ExecuteIncludes() 
    
        IncludeFromDirectory("core/")
        IncludeFromDirectory("classes/")
        AddCSLuaFileFromDirectory("core/");
        AddCSLuaFileFromDirectory("classes/");
        
    end

    ExecuteIncludes()

end

if CLIENT then
        
    
    local function IncludeFromDirectory(dir) 
        
        local dirFiles, dirDirectories = file.Find("basewars/gamemode/" .. dir .. "*", "LUA");
       
        for k, luaFile in pairs(dirFiles) do
            if (string.match(luaFile, "_cl.lua$") or string.match(luaFile, "_sh.lua$")) then
                include(dir .. luaFile)
                --print(luaFile)
            end
        end
    
        for k, dirFile in pairs(dirDirectories) do
            IncludeFromDirectory(dir..dirFile.."/") 
        end
    
        
    end
    
    IncludeFromDirectory("core/");
    IncludeFromDirectory("classes/");
    
end