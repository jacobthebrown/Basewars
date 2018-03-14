Object_Radar = {};
Object_Radar.__index = Object_Radar;
Object_Radar.members = {"lastScanned", "scanDuration", "targetPlayer"};
GameObject:Register( "Object_Radar", Object_Radar)
local Object = Object_Radar;

Object.FLAGS = { UNIQUE = true };

--//
--//	Constructs a radar object for the server.
--//
function Object:new( ply, position, scanDuration )
	
	local metaProperties = {
		propModel = "models/props_wasteland/laundry_basket001.mdl",
		lastScanned = 0,
		scanDuration = scanDuration or 10,
		targetPlayer = nil
	}
	
	return GameObject:new(Object, metaProperties, ply, position, Angle(0,0,0));
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



