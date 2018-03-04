DEFINE_BASECLASS("base_gmodentity")

ENT.timeDelay = 0;
ENT.gamedata = {};

function ENT:Initialize()
	
end

function ENT:Draw()
	self:DrawModel()
	
	render.DrawLine(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()), Color(255,0,0,255), true)
	local vectorOffset = Vector(17,0,50)
	local angleOffset = Angle(0,90,90)
	local scale = 0.1 -- scale
	
	local angle = self:GetAngles()
	
	--render.DrawLine( self:GetPos(), self:GetPos() + 200 * angle:Forward(), Color( 255, 0, 0 ), true )
	--render.DrawLine(self:GetPos(), self:GetPos() + 200 * -angle:Right(), Color( 0, 255, 0 ), true )
	--render.DrawLine( self:GetPos(), self:GetPos() + 200 * angle:Up(), Color( 0, 0, 255 ), true )
	
	cam.Start3D2D(self:LocalToWorld(vectorOffset), self:LocalToWorldAngles(angleOffset), scale)
		draw.DrawText(LocalPlayer():GetName(), "TheDefaultSettings", 0,0, Color(255,0,0), TEXT_ALIGN_CENTER)
		
		if (self.gamedata != nil) then
		    draw.DrawText("Balance: " .. tostring(self.gamedata.balance), "TheDefaultSettings", 0,200, Color(255,0,0), TEXT_ALIGN_CENTER)
		end
		
	cam.End3D2D()
end

hook.Add( "PreDrawHalos", "AddHalos", function()
	
	if (!LocalPlayer():GetEyeTrace().Entity:IsValid()) then
		return;
	end
	
	local traceEntity = LocalPlayer():GetEyeTrace().Entity;

	if (traceEntity != null && traceEntity:GetClass() == "ent_skeleton") then
		halo.Add( { traceEntity }, Color( 218,165,32 ), 1, 1, 2 )
	end
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