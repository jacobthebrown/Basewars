local sandbox = false;

--//
--// CREDIT: andrewmcwatters
--// https://gmod.facepunch.com/f/gmodaddon/jcly/Ragdoll-Fade-System-Fade-out-and-remove-client-side-ragdolls/1/
--//

local RagdollEntities = {}
local GibEntities = {};
local function RagdollThink()


	RagdollEntities = table.AddMany( {ents.FindByClass("class C_ClientRagdoll"), ents.FindByClass("gib"), ents.FindByClass("class C_BaseAnimating")} );

	for _, ragdoll in pairs( RagdollEntities ) do

		if ( !ragdoll.m_flFadeTime ) then

			ragdoll.m_flFadeTime	= CurTime() + 10;
			ragdoll.m_angLastAng	= ragdoll:GetAngles()
			ragdoll.m_vecLastPos	= ragdoll:GetPos()
            ragdoll:SetRenderMode( RENDERMODE_TRANSALPHA ) 

		elseif ( CurTime() >= ragdoll.m_flFadeTime ) then

			if ( ragdoll.m_angLastAng == ragdoll:GetAngles() &&
				 ragdoll.m_vecLastPos == ragdoll:GetPos() ) then

				ragdoll.m_bFadeOut		= true

			else

				ragdoll.m_flFadeTime	= nil
				ragdoll.m_bFadeOut		= false

			end

		end

		if ( ragdoll.m_bFadeOut != nil ) then

            local ragdollColor = ragdoll:GetColor();

			if ( ragdoll.m_bFadeOut == true ) then

				ragdollColor.a = ragdollColor.a - 1

			end

			ragdollColor.a = math.Clamp( ragdollColor.a, 0, 255 )

			if ( ragdollColor.a <= 0 ) then

				--ragdoll:Remove()

				return

			end

			ragdoll:SetColor( ragdollColor )

		end

	end

end

hook.Add( "Think", "RagdollThink", RagdollThink )
