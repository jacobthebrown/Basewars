local Object = {};
Object.members = {
    player = nil,
    settings,
    wealth = 0
};

Object.FLAGS = { UNBUYABLE = true };

--//
--//    Constructs a new object to store player data.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

GameObject:Register( "Object_Player", Object);

hook.Add( "HUDPaint", "HUDPaint_HUD", function()
    
    if (LocalPlayer():GetObject()) then

    	draw.DrawText( "Wealth: "..tostring(LocalPlayer():GetObject().wealth), "TargetID", 50, ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
    	draw.DrawText( "Health: "..tostring(LocalPlayer():Health()), "TargetID", 50, 15 + ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
    	draw.DrawText( "Armor: "..tostring(LocalPlayer():Armor()), "TargetID", 50, 30 + ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
    
        local eyeTrace = LocalPlayer():GetEyeTrace().Entity;
        
        if (eyeTrace:GetObject() && !eyeTrace:IsPlayer()) then
    	    draw.DrawText( "Object Health: "..tostring(eyeTrace:GetObject():GetHealth()), "TargetID", 50, 45 + ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
    	    draw.DrawText( "Object Owner: "..tostring(eyeTrace:GetObject():GetOwner()), "TargetID", 50, 60 + ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
        end
    end
    
end )



--//
--// We want to be sure the first frame has rendered before we let the server know we've spawned.
--//

hook.Add("Initialize", "Initialize_BeginLoadout", function() 
    local function PlayerFullyLoaded(ply)
    	
        hook.Remove( "PostRender", "PlayerInitialSpawn_PlayerFullyLoaded" );
    	
        timer.Simple(3,function() 
            net.Start("GameObject_PlayerFullyLoaded")
            net.SendToServer();
        end)
    
    end
    hook.Add( "PostRender", "PlayerInitialSpawn_PlayerFullyLoaded", PlayerFullyLoaded )
end)

local hide = {
	CHudHealth = true,
	CHudBattery = true
}
hook.Add( "HUDShouldDraw", "HideHUD", function(name)    -- http://wiki.garrysmod.com/page/HUD_Element_List
	if ( hide[ name ] ) then
		return false
	end
end)

