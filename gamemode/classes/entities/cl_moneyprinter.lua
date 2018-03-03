net.Receive( "Entity_MoneyPrinter_GetBalance", function()
	 local money = net.ReadUInt(32);
	 chat.AddText( "Money Printer Balance: " .. tostring(money) );
end )


net.Receive( "Entity_SendGameData", function( msgLength )
	
	local targetEntity, gamedata = net.ReadEntity(), net.ReadTable();
	PrintTable(gamedata);
	print(gamedata)
    targetEntity.gamedata = gamedata;
        
end )

hook.Add( "PostDrawOpaqueRenderables", "example", function()

		
	local trace = LocalPlayer():GetEyeTrace()
	local angle = trace.HitNormal:Angle()

	render.DrawLine( trace.HitPos, trace.HitPos + 8 * angle:Forward(), Color( 255, 0, 0 ), true )
	render.DrawLine( trace.HitPos, trace.HitPos + 8 * -angle:Right(), Color( 0, 255, 0 ), true )
	render.DrawLine( trace.HitPos, trace.HitPos + 8 * angle:Up(), Color( 0, 0, 255 ), true )

	cam.Start3D2D( trace.HitPos, angle, 1 )
		surface.SetDrawColor( 255, 165, 0, 255 )
		surface.DrawRect( 0, 0, 8, 8 )
		render.DrawLine( Vector( 0, 0, 0 ), Vector( 8, 8, 8 ), Color( 100, 149, 237, 255 ), true )
	cam.End3D2D()
end )