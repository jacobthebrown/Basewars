if SERVER then
    
    local function IncludeFromDirectory(dir) 
        
        
        local files_sv = file.Find("basewars/gamemode/" .. dir .. "*_sv.lua", "LUA");
        local files_sh = file.Find("basewars/gamemode/" .. dir .. "*_sh.lua", "LUA");
       
       
        for k, file in pairs(table.Add(files_sv, files_sh)) do
            include(dir .. file)
        end

        
    end
    
    local function AddCSLuaFileFromDirectory(dir) 
        
        local files_cl = file.Find("basewars/gamemode/" .. dir .. "*_cl.lua", "LUA");
        local files_sh = file.Find("basewars/gamemode/" .. dir .. "*_sh.lua", "LUA");
       
        for k, file in pairs(table.Add(files_cl, files_sh)) do
            AddCSLuaFile(dir .. file)
        end
        
    end
    
    IncludeFromDirectory("core/");
    IncludeFromDirectory("classes/");
    IncludeFromDirectory("classes/entities/");
    AddCSLuaFileFromDirectory("core/");
    AddCSLuaFileFromDirectory("classes/");
    AddCSLuaFileFromDirectory("classes/entities/");


end

if CLIENT then
        
    local function IncludeFromDirectory(dir) 
        
        local files_cl = file.Find("basewars/gamemode/" .. dir .. "*_cl.lua", "LUA");
        local files_sh = file.Find("basewars/gamemode/" .. dir .. "*_sh.lua", "LUA");
       
        for k, file in pairs(table.Add(files_cl, files_sh)) do
            include(dir .. file)
        end
        
    end
    
    IncludeFromDirectory("core/");
    IncludeFromDirectory("classes/");
    IncludeFromDirectory("classes/entities/"); 
    
end