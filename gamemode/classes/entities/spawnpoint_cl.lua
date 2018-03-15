local Object = {};

--//
--//	Constructs a vending machine object.
--//
function Object:new( metaInstance )
	metaInstance.spawning = metaInstance.spawning or false;
	metaInstance.spawnDuration = metaInstance.spawnDuration or 5;
	
	return GameObject:new(Object, metaInstance);
end

--//
--//
--//
function Object:OnOwnerSpawn()

	local ply = LocalPlayer();

	if (LocalPlayer() == self:GetOwner()) then
		EmitSound( "ambient/levels/citadel/portal_open1_adpcm.wav", ply:GetPos(), ply:EntIndex(), CHAN_AUTO, 1, 120, 0, 50 )
		self.spawning = true;
	end

	--EmitSound( "ambient/levels/citadel/portal_open1_adpcm.wav", ply:GetPos(), ply:EntIndex(), CHAN_AUTO, 1, 120, 0, 100 )
	
	timer.Create( "Timer_SpawnEffectEnd", self.spawnDuration, 1, function() 
		self.spawning = false;		
	end)

end

--//
--//
--//
function Object:OnOwnerSpawnGlobal()

	EmitSound( Sound("ambient/levels/citadel/portal_open1_adpcm.wav"), self.ent:GetPos(), self.ent:EntIndex(), CHAN_AUTO, 1, 75, 0, 50 );
	
end

local clientside_Funnel = nil;
local clientside_Darkness = nil;
function Object:DrawHUD()
	
	if (!self.spawning || LocalPlayer():Alive()) then
		return;
	end
	
	--render.Model( {model="models/effects/portalrift.mdl", pos=Vector(ScrW()/2,ScrH()/2,-100), angle=Angle(0,270,0)}, clientside_Darkness )	
	--render.Model( {model="models/effects/portalfunnel.mdl", pos=Vector(ScrW()/2,ScrH()/2,-100)}, clientside_Funnel )
	
	DrawMaterialOverlay( "models/props_c17/fisheyelens", -0.06 )
	DrawMaterialOverlay( "effects/tp_eyefx/tpeye", -0.06 )
	DrawMaterialOverlay( "effects/tp_eyefx/tpeye2", -0.06 )
	DrawMaterialOverlay( "effects/tp_eyefx/tpeye3", -0.06 )

end

GameObject:Register( "Object_SpawnPoint", Object);