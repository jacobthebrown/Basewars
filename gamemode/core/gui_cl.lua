basewars.gui = basewars.gui or {};

surface.CreateFont( "TheDefaultSettings", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 200,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


local blur = Material("pp/blurscreen");

local function drawBlur(panel, amount, passes)
	-- Intensity of the blur.
	amount = amount or 5

	if (false) then
		surface.SetDrawColor(50, 50, 50, amount * 20)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	else
		surface.SetMaterial(blur)
		surface.SetDrawColor(255, 255, 255)

		local x, y = panel:LocalToScreen(0, 0)

		for i = -(passes or 0.2), 1, 0.2 do
			-- Do things to the blur material to make it blurry.
			blur:SetFloat("$blur", i * amount)
			blur:Recompute()

			-- Draw the blur material over the screen.
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
		end
	end
end


local html = html or nil;

concommand.Add( "Derm", function( ply, cmd, args ) 
	
	if (html != nil) then
		--html:Remove();
	end
	
	--Fill the form with a html page
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetSize(512,512)
	DermaPanel:SetPos(ScrW()/2 - 256, ScrH()/2 - 256)
	DermaPanel:MakePopup()
	html = vgui.Create( "DHTML", DermaPanel )
	html:Dock( FILL )
	html:SetHTML( [[
	<meta http-equiv="refresh" content="0; url=https://preview.c9users.io/jacobthebrown/basewars/hello-world.html" />
	]] )
	html:SetAllowLua( true )
	--html:SetAlpha(100);
	html:SetSize( 512, 512 );
	
	function html:OnFinishLoadingDocument() 
		for k, v in pairs ( player.GetAll() ) do 
			html:QueueJavascript( string.format("createPlayer('%s', '%d')",v:GetName(), v:Ping()) )
		end
	end
	
	local lastPaint = 0;
	function html:Paint( w, h )
		drawBlur(self, 2, 2)
		
		if (CurTime() >= lastPaint + 1) then
			lastPaint = CurTime();
			for k, v in pairs ( player.GetAll() ) do 
				html:QueueJavascript( string.format("createPlayer('%s', '%d')",v:GetName(), v:Ping()) )
			end
		end
	end
	function DermaPanel:Paint( w, h )
	end
	
end)

concommand.Add( "Derm_close", function( ply, cmd, args ) 
	
	html:Remove();
	
end)

