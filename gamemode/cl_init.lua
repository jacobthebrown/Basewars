include( 'shared.lua' )

local gamefiles_cl = file.Find( "Basewars/gamemode/classes/cl_*.lua", "LUA" )
for k, v in pairs(gamefiles_cl) do
   include("classes/"..v)
end
local gamefiles_cl = file.Find( "Basewars/gamemode/classes/entities/cl_*.lua", "LUA" )
for k, v in pairs(gamefiles_cl) do
   include("classes/entities/"..v)
end


net.Receive( "Entity_Player_GetWealth", function()
	 local money = net.ReadUInt(32);
	 chat.AddText( "Wealth: " .. tostring(money) );
end )

local function removeOldTabls()

    local tabstoremove = {language.GetPhrase("spawnmenu.category.npcs"),
    language.GetPhrase("spawnmenu.category.entities"),
    --language.GetPhrase("spawnmenu.category.weapons"),
    language.GetPhrase("spawnmenu.category.vehicles"),
    language.GetPhrase("spawnmenu.category.postprocess"),
    language.GetPhrase("spawnmenu.category.dupes"),
    language.GetPhrase("spawnmenu.category.saves")}
    if !LocalPlayer():IsAdmin() then
    	for k, v in pairs( g_SpawnMenu.CreateMenu.Items ) do
    		 if table.HasValue(tabstoremove, v.Tab:GetText()) then
    			g_SpawnMenu.CreateMenu:CloseTab( v.Tab, true )
    			removeOldTabls()
    		end
    	end
    end
end


hook.Add("SpawnMenuOpen", "blockmenutabs", removeOldTabls)