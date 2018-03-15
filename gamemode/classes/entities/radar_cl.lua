local Object = {};

Object.members = {
	lastScanned = "",
	scanDuration = "",
	targetPlayer = ""
};

--//
--//	Constructs a money printer object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

--//
--//	Event: When a scan call is broadcasted out to the server.
--//
function Object:ScanPlayer(args)
	

	local ply = args[1];
	self:SetTargetPlayer(ply);
	
	EmitSound( "vo/npc/male01/headsup02.wav", ply:GetPos(), ply:EntIndex(), CHAN_AUTO, 1, 120, 0, 100 )
	EmitSound( Sound('npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav'), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 );

	timer.Create( "Timer_RadarScan", self:GetScanDuration(), 1, function() 
		self:SetTargetPlayer(nil);		
	end)

end

--//
--//	Function for rendering the object to the client.
--//
function Object:Draw()

	local ply = self:GetTargetPlayer();
	local displayText = "";

	if (ply) then
		displayText = "Scanning: "..ply:GetName();
	else
		displayText = "Not Scanning";
	end

	local vectorTranslation = self:GetEntity():LocalToWorld(Vector(17, 0, 64));
	local angleTranslation = self:GetEntity():LocalToWorldAngles(Angle(0, 90, 90));
	local scale = 0.1;
	
	cam.Start3D2D(vectorTranslation, angleTranslation, scale);

		surface.SetDrawColor(255, 255, 255, 255);
		draw.DrawText(displayText, "EuropaBrush3D2D", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER);
		
	cam.End3D2D();

end

--//
--//	Function for rendering the object, globally to the client.
--//
function Object:DrawGlobal()

	if (self.targetPlayer == nil) then
		return;
	end

	cam.Start3D2D(self.targetPlayer:GetPos() + Vector(0,0,300), Angle(0,180 + (180 * CurTime()) % 360, 90) , 1);
		
		cam.IgnoreZ( true )
		draw.DrawText("SCANNED!", "TheDefaultSettings", 5, 5, Color(0,0,0), TEXT_ALIGN_CENTER)
		draw.DrawText("SCANNED!", "TheDefaultSettings", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER)
		cam.IgnoreZ( false )
		
	cam.End3D2D();
	
	cam.Start3D2D(self.targetPlayer:GetPos() + Vector(0,0,300), Angle(0, (180 * CurTime()) % 360,90) , 1);
		
		cam.IgnoreZ( true )
		draw.DrawText("SCANNED!", "TheDefaultSettings", 5, 5, Color(0,0,0), TEXT_ALIGN_CENTER)
		draw.DrawText("SCANNED!", "TheDefaultSettings", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER)
		cam.IgnoreZ( false )
		
	cam.End3D2D();
	
end

GameObject:Register( "Object_Radar", Object)