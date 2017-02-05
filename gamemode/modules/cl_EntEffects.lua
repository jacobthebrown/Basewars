local MODULE = {}

MODULE.Name = "Entity Effects"

function MODULE:Load()

end

local HideElements = {
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
}

function MODULE:EntityDrawHalos()
	local LocalTable = ents.FindInSphere( LocalPlayer():GetPos(), 256 ) 
	local ply_trace = LocalPlayer():GetEyeTrace()

	for place,ent in pairs(LocalTable) do
	
		if (ply_trace.Entity == ent) && ent.EnableGlow == true then
			local GlowTable = {ent}
			halo.Add( GlowTable, ent.GlowColor, 1, 1, 2, true, false ) 
		end
	end
	

end
hook.Add( "PreDrawHalos", "ENT_ShouldDraw", ENT_DrawHalos )