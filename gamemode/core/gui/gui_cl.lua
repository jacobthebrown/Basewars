BW.gui = BW.gui or {};
BW.gui.scoreboard = BW.gui.scoreboard or nil;


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

surface.CreateFont( "Europa Brush", {
	font = "Europa Brush", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 128,
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

surface.CreateFont( "EuropaBrush3D2D", {
	font = "Europa Brush", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 128,
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

hook.Add( "HUDPaint", "HUD_Paint", function()
	
	--surface.SetFont( "Europa Brush" )
	--
	--local width, height = surface.GetTextSize( "Hello World" );
	--
	--local xPosition = (ScrW()/2 - width/2);
	--local yPosition = ScrH()/2 - height/2 - 10*math.cos(5*CurTime() % 360);
	--
	--surface.SetTextColor( 255, 255, 255, 255 )
	--surface.SetTextPos( xPosition, yPosition )
	--surface.DrawText( "Hello World" )
end )


function GM:ScoreboardHide()
	
	if (BW.gui.scoreboard == nil) then
		ScoreBoardInitialize();
	end
	
	BW.gui.scoreboard:SetMouseInputEnabled(false);
	BW.gui.scoreboard:Hide();
	gui.EnableScreenClicker(false);
	
end
function GM:ScoreboardShow()
	
	local scoreboard = BW.gui.scoreboard;
	
	if (scoreboard == nil) then
		ScoreBoardInitialize();
	end
	
	BW.gui.scoreboard:Show();
	BW.gui.scoreboard:SetMouseInputEnabled(true);
	gui.EnableScreenClicker(true);
	
end

-- SANITIZE THE QUEUE JAVASCRIPT
function ScoreBoardInitialize()
	
	if (BW.gui.scoreboard != nil) then
		BW.gui.scoreboard:Remove();
		BW.gui.scoreboard = nil;
	end	
	

	BW.gui.scoreboard = vgui.Create( "DHTML" )
	BW.gui.scoreboard:SetAllowLua( true )
	BW.gui.scoreboard:SetSize( 512, 512 );
	BW.gui.scoreboard:SetPos(ScrW()/2 - 256, ScrH()/2 - 256)
	BW.gui.scoreboard:SetHTML( [[<meta http-equiv="refresh" content="0; url=https://preview.c9users.io/jacobthebrown/basewars/hello-world.html" />]] )
	
	function BW.gui.scoreboard:OnFinishLoadingDocument() 
		for k, v in pairs ( player.GetAll() ) do
				self:QueueJavascript( string.format("createPlayer('%s', '%d', '%s')",v:GetName(), v:Ping(), v:EntIndex()) )
		end
	end	
	
	local lastPaint = 0;
	function BW.gui.scoreboard:Paint( w, h )
		if (CurTime() >= lastPaint + 1) then
			lastPaint = CurTime();
			for k, v in pairs ( player.GetAll() ) do 
				self:QueueJavascript( string.format("createPlayer('%s', '%d', '%s')",v:GetName(), v:Ping(), v:EntIndex()) )
			end
		end
	end

end
