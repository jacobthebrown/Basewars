--
--
--local function removeSandboxTabs()
--
--    local tabstoremove = {language.GetPhrase("spawnmenu.category.npcs"),
--    language.GetPhrase("spawnmenu.category.entities"),
--    --language.GetPhrase("spawnmenu.category.weapons"),
--    language.GetPhrase("spawnmenu.category.vehicles"),
--    language.GetPhrase("spawnmenu.category.postprocess"),
--    language.GetPhrase("spawnmenu.category.dupes"),
--    language.GetPhrase("spawnmenu.category.saves")}
--    if !LocalPlayer():IsAdmin() then
--    	for k, v in pairs( g_SpawnMenu.CreateMenu.Items ) do
--    		 if table.HasValue(tabstoremove, v.Tab:GetText()) then
--    			g_SpawnMenu.CreateMenu:CloseTab( v.Tab, true )
--    			removeSandboxTabs()
--    		end
--    	end
--    end
--end
--hook.Add("SpawnMenuOpen", "blockmenutabs", removeSandboxTabs)--


concommand.Add( "getPose", function( ply, cmd, args ) 
	
	local ent = ply:GetEyeTrace().Entity
	
    for i=0, ent:GetNumPoseParameters() - 1 do
    	local min, max = ent:GetPoseParameterRange( i )
    	print( ent:GetPoseParameterName( i ) .. ' ' .. min .. " / " .. max )
    end

end)

--  aim_pitch -15 / 15
--  aim_yaw -60 / 60

concommand.Add( "setPose", function( ply, cmd, args ) 
	
	local ent = ply:GetEyeTrace().Entity
	
    ent:SetPoseParameter("aim_yaw", args[1]);

end)

hook.Add( "PostDrawOpaqueRenderables", "grem", function()


    for k,v in pairs (ents.GetAll()) do
        
        if (v:GetModel() != "models/combine_turrets/floor_turret.mdl") then
            continue;
        end
        
	    --render.DrawLine( v:GetPos(), LocalPlayer():GetPos(), Color( 255, 255, 0 ), true )

        local deltaX = LocalPlayer():GetPos().x - v:GetPos().x;
        local deltaY = LocalPlayer():GetPos().y - v:GetPos().y;
        local rad = math.atan2(deltaY, deltaX);
        
        
        local boosted = ( (rad * 180 / math.pi)  - v:GetAngles().yaw);
        local boostedInverse = (rad * 180 / math.pi)  + v:GetAngles().yaw;
        
        --if (boosted)
        
        if (boosted <= -180) then
            boosted = -1 * (boosted + 180);
        end
        if (boosted >= 180) then
            boosted = -1 * (boosted - 180);
        end
        
        local boosted_bounded = math.min(math.max(-60, boosted), 60);



        --print(v:GetAngles().yaw .. "\n")
        print("Raw: " .. (rad * 180 / math.pi) .. " | Angle: " .. v:GetAngles().yaw .. " | Boosted: " .. boosted .. " | Boosted Inverse: " .. boostedInverse)
        --print("\n" .. (rad * 180 / math.pi) .. "\n")
        --print(boosted_bounded)
          v:SetPoseParameter("aim_yaw", boosted_bounded);
	    --render.DrawLine( v:GetPos(), v:LocalToWorld(Vector(1,1,0) * 100), Color( 255, 255, 0 ), true )


    end
	
end )