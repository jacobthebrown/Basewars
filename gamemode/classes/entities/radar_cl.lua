Object_Radar = {};
Object_Radar.__index = Object_Radar;
GameObject:Register( "Object_Radar", Object_Radar)
local Object = Object_Radar;

--//
--//	Constructs a money printer object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

--//
--//	Function for rendering the object to the client.
--//
function Object:Draw()

	local vectorOffset = Vector(17,0,50)
	local angleOffset = Angle(0,90,90)
	local scale = 0.1
	
	cam.Start3D2D(self.ent:LocalToWorld(vectorOffset), self.ent:LocalToWorldAngles(angleOffset), scale);

		surface.SetDrawColor(255, 255, 255, 255);
		surface.DrawRect(25, 25, 100, 100);
		
		draw.DrawText("Type: " .. tostring(self.entityType), "TheDefaultSettings", 0, 100, Color(255,255,255), TEXT_ALIGN_CENTER);
		draw.DrawText("Scanning: " .. tostring(self.targetPlayer), "TheDefaultSettings", 0, 200, Color(255,255,255), TEXT_ALIGN_CENTER);
		
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
	
	cam.Start3D2D( self.targetPlayer:GetPos(), Angle(180,180,180), 1);
		
		cam.IgnoreZ( true )
			surface.SetDrawColor( 0, 0, 0, 200 )
			draw.NoTexture()
			draw.Circle( 0, 0, 200, math.sin( CurTime() ) * 20 + 25 )
		cam.IgnoreZ( false )
		
	cam.End3D2D();
	
end

--//
--//	Event: When a scan call is broadcasted out to the server.
--//
function Object:ScanPlayer(args)
	
	local ply = args[1];
	self.targetPlayer = ply;

	EmitSound( "vo/npc/male01/headsup02.wav", ply:GetPos(), ply:EntIndex(), CHAN_AUTO, 1, 120, 0, 100 )
	EmitSound( Sound('npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav'), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 );
	
	timer.Create( "Timer_RadarScan", self.scanDuration, 1, function() 
		self.targetPlayer = nil;		
	end)
	
end

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

--//
--// Garbage collects the object.
--//
function Object:Remove() 
	GameObject:RemoveGameObject(self);
end