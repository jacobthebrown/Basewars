local timeDelay = 0;
hook.Add( "HUDPaint", "HUDPaint_DrawABox", function()
    
    if (LocalPlayer().gamedata == nil) then
       	--net.Start( "Entity_Player_Client_RequestGameData" );
    	--net.SendToServer();
    	--LocalPlayer().gamedata = {};
    	
    	return;
    end

	surface.SetTextPos( 128, 128 )
	surface.DrawText( LocalPlayer().gamedata.money or "Null" )
    
	surface.SetDrawColor( 0, 0, 0, 128 )
	surface.DrawRect( 0, 0, 256, 128 )
end )