local Object = {};

Object.members = {
	model = "models/props_wasteland/laundry_basket001.mdl",
	lastScanned = 0,
	scanDuration = 10,
	targetPlayer = nil
};

Object.FLAGS = { UNIQUE = true };

--//
--//	Constructs a radar object for the server.
--//
function Object:new( ply, position )
	return GameObject:new(Object, clone(Object.members), ply, position, Angle(0,0,0));
end

--//
--//	Reforms a scan on a target player.
--//
function Object:ScanPlayer(targetPlayer)
	
	
	if (CurTime() <= self:GetLastScanned() + self:GetScanDuration()) then
		return;
	end
	
	self:SetLastScanned(CurTime());

	GameObject:TriggerEventGlobal(self, "ScanPlayer", { targetPlayer });
	
	timer.Create( "Timer_RadarScan", self:GetScanDuration(), 1, function() 
		self.targetPlayer = nil;		
	end)
end

--[[
--		
--		Console Command Functions.
--
--]]
concommand.Add( "radar_Scan", function( ply, cmd, args ) 
	
	local gameObject = nil;

	for k, v in pairs (GameObject:GetAllGameObjects()) do
		if (v:GetType() == "Object_Radar" && v:GetOwner() == ply) then
			gameObject = v;
			break;
		end
	end
	
	if (!gameObject) then
		return;
	end
	
	for k, v in pairs (player.GetAll()) do
		if (v:GetName() == args[1] ) then
			gameObject:ScanPlayer(v);
			return;
		end
	end

end)

GameObject:Register( "Object_Radar", Object)