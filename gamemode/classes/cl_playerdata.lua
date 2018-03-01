ClassPlayerData = {};
ClassPlayerData.__index = ClassPlayerData;

function ClassPlayerData:new( ply )

	if (ply == nil || !ply:IsValid() || !ply:IsPlayer()) then
		return nil;
	end
	
	local metaPlayerData = {
        money = 0,
        nickname = ply:Nick(),
        player = ply,
        entities = {}
	}
	setmetatable( metaPlayerData, ClassPlayerData ) 
	
	return metaPlayerData;

end

function ClassPlayerData:SetMoney(quantity)

    if ( self.player:IsValid() && isnumber(amount) ) then
        self.money = quantity;
    else
        print("No player data exists, no money given");
    end
        
end

setmetatable( ClassPlayerData, {__call = ClassPlayerData.new } )

net.Receive( "Entity_Player_Server_SendGameData", function( msgLength, ply )

	if (LocalPlayer().gamedata == nil) then
	    LocalPlayer().gamedata = {};
    end
    
	LocalPlayer().gamedata.money = net.ReadUInt(32);
end )


local timeDelay = 0;
hook.Add( "HUDPaint", "HUDPaint_DrawABox", function()
    
    if (LocalPlayer().gamedata == nil) then
       	net.Start( "Entity_Player_Client_RequestGameData" );
    	net.SendToServer();
    	LocalPlayer().gamedata = {};
    	
    	return;
    end
    
    --[[
	surface.SetFont( "Trebuchet18" )
	surface.SetTextColor( 255, 255, 255, 255 )
    
    local eyedEnt = LocalPlayer():GetEyeTrace().Entity;
    if(eyedEnt.gamedata != nil && timeDelay < CurTime()) then
        
        print("Grabbed " .. CurTime())
        timeDelay = CurTime() + 1;
        
        net.Start( "Entity_RequestGameData" );
        net.WriteEntity(eyedEnt)
    	net.SendToServer();
    end
    
    if (eyedEnt.gamedata != nil) then
       	surface.SetTextPos( 128, 156 )
	    surface.DrawText( eyedEnt.gamedata.balance or "Null" ) 
    end
    ]]--
    

	surface.SetTextPos( 128, 128 )
	surface.DrawText( LocalPlayer().gamedata.money or "Null" )
    
	surface.SetDrawColor( 0, 0, 0, 128 )
	surface.DrawRect( 0, 0, 256, 128 )
end )