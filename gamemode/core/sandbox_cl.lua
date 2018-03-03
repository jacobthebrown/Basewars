local function removeSandboxTabs()

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
hook.Add("SpawnMenuOpen", "blockmenutabs", removeSandboxTabs)