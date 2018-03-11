local timeDelay = 0;
hook.Add( "HUDPaint", "HUDPaint_DrawABox", function()
    
    if (LocalPlayer().gamedata == nil) then
       	--net.Start( "Entity_Player_Client_RequestGameData" );
    	--net.SendToServer();
    	--LocalPlayer().gamedata = {};
    	return;
    end
	draw.DrawText( "Wealth: "..tostring(LocalPlayer().gamedata.wealth), "TargetID", 50, ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	draw.DrawText( "Health: "..tostring(LocalPlayer():Health()), "TargetID", 50, 15 + ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	draw.DrawText( "Armor: "..tostring(LocalPlayer():Armor()), "TargetID", 50, 30 + ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

    local eyeTrace = LocalPlayer():GetEyeTrace().Entity;
    
    if (eyeTrace.gamedata && eyeTrace.gamedata.health) then
	    draw.DrawText( "Object Health: "..tostring(eyeTrace.gamedata:GetHealth()), "TargetID", 50, 45 + ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	    draw.DrawText( "Object Owner: "..tostring(eyeTrace.gamedata:GetOwner()), "TargetID", 50, 60 + ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
    end
    
end )

--print(LocalPlayer():GetEyeTrace().Normal)`
--
--c_Model = ents.CreateClientProp()
--c_Model:SetPos( LocalPlayer():EyePos() + LocalPlayer():GetEyeTrace().Normal * 400 )
--c_Model:SetModel( "models/effects/portalfunnel.mdl" )
--c_Model:SetAngles(LocalPlayer():GetEyeTrace().Normal:Angle() + Angle(0,90,90));
--c_Model:SetParent( LocalPlayer() )
--c_Model:Spawn()
--
--t_Model = ents.CreateClientProp()
--t_Model:SetPos( LocalPlayer():EyePos() + LocalPlayer():GetEyeTrace().Normal * 300 )
--t_Model:SetModel( "models/effects/portalrift.mdl" )
--t_Model:SetAngles(LocalPlayer():GetEyeTrace().Normal:Angle() + Angle(0,90,90));
--t_Model:SetParent( LocalPlayer() )
--t_Model:Spawn()

