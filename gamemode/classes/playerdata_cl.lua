
local timeDelay = 0;
hook.Add( "HUDPaint", "HUDPaint_DrawABox", function()
    
    if (LocalPlayer().gamedata == nil) then
       	--net.Start( "Entity_Player_Client_RequestGameData" );
    	--net.SendToServer();
    	--LocalPlayer().gamedata = {};
    	return;
    end
	draw.DrawText( tostring(LocalPlayer().gamedata.wealth), "TargetID", ScrW() * 0.5, ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

    
end )

--//
--//
--//
local function RecievePlayerData()
	print("poop")
	local gamedata = net.ReadTable();
    
	if (LocalPlayer().gamedata == nil) then
		LocalPlayer().gamedata = gamedata;
		return;
	end

	table.Merge(LocalPlayer().gamedata, gamedata);

end 
net.Receive( "PlayerData_Send", RecievePlayerData)



--print(LocalPlayer():GetEyeTrace().Normal)
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

hook.Add( "RenderScreenspaceEffects", "GameObject_RenderScreenOverlaysAll", function()
	
	if (LocalPlayer().gamedata != nil && LocalPlayer().gamedata.overlays != nil) then
		
		
	end
	
	--ClientsideModel("models/effects/portalfunnel.mdl" )
	
	--render.Model( {model = "models/effects/portalfunnel.mdl", Vector = Vector(1000,1000,1000), Angle = Angle(100,100,100)}, teleport )
	--DrawMaterialOverlay( "models/props_c17/fisheyelens", -0.06 )
	--DrawMaterialOverlay( "effects/tp_eyefx/tpeye", -0.06 )
	--DrawMaterialOverlay( "effects/tp_eyefx/tpeye2", -0.06 )
	--DrawMaterialOverlay( "effects/tp_eyefx/tpeye3", -0.06 )

end )
