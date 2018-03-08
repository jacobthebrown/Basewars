Object_Radar = {};
Object_Radar.__index = Object_Radar;
GameObject:Register( "Object_Radar", Object_Radar)
local Object = Object_Radar;

--//
--//	Constructs a radar object for the server.
--//
function Object:new( ply, position, scanDuration )
	
	local metaProperties = {
		entityType = "Object_Radar",
		propModel = "models/props_rooftop/roof_dish001.mdl",
		owner = ply or nil,
		ent = nil,
		lastScanned = 0,
		scanDuration = scanDuration or 10,
		targetPlayer = nil
		
	}
	
	return GameObject:new(Object, metaProperties, ply, position);
end

--//
--//	The function given to the physical entity to be called on ENT:Use.
--//
function Object:Use(ply, ent)	
    
end

--//
--// Garbage collects the object.
--//
function Object:Remove() 
	GameObject:RemoveGameObject(self);
	self.ent:Remove();
end

--//
--//	Reforms a scan on a target player.
--//
function Object:ScanPlayer(targetPlayer)
	
	print("Scanning Player")
	
	GameObject:TriggerEvent(self.ent, self, "ScanPlayer", { targetPlayer });
	
	timer.Create( "Timer_RadarScan", self.scanDuration, 1, function() 
		self.targetPlayer = nil;		
	end)
end

--[[
--		
--		Console Command Functions.
--
--]]
local scanningRadars = {};
concommand.Add( "radar_Scan", function( ply, cmd, args ) 
	
	local gameObject = nil;

	for k, v in pairs (GameObject:GetAllGameObjects()) do
		if (v.entityType == "Object_Radar" && v.owner == ply) then
			gameObject = v;
			break;
		end
	end
	
	if (gameObject == nil) then
		return;
	end
	
	for k, v in pairs (player.GetAll()) do
		if (v:GetName() == args[1] ) then
			gameObject:ScanPlayer(v);
			return;
		end
	end

end)



