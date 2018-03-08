basewars.gui = basewars.gui or {};
basewars.gui.scoreboard = basewars.gui.scoreboard or nil;


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

function GM:ScoreboardHide()
	
	if (basewars.gui.scoreboard == nil) then
		ScoreBoardInitialize();
	end
	
	basewars.gui.scoreboard:SetMouseInputEnabled(false);
	basewars.gui.scoreboard:Hide();
	gui.EnableScreenClicker(false);
	
end
function GM:ScoreboardShow()
	
	local scoreboard = basewars.gui.scoreboard;
	
	if (scoreboard == nil) then
		ScoreBoardInitialize();
	end
	
	basewars.gui.scoreboard:Show();
	basewars.gui.scoreboard:SetMouseInputEnabled(true);
	gui.EnableScreenClicker(true);
	
end

-- SANITIZE THE QUEUE JAVASCRIPT
function ScoreBoardInitialize()
	
	if (basewars.gui.scoreboard != nil) then
		basewars.gui.scoreboard:Remove();
		basewars.gui.scoreboard = nil;
	end	
	

	basewars.gui.scoreboard = vgui.Create( "DHTML" )
	basewars.gui.scoreboard:SetAllowLua( true )
	basewars.gui.scoreboard:SetSize( 512, 512 );
	basewars.gui.scoreboard:SetPos(ScrW()/2 - 256, ScrH()/2 - 256)
	basewars.gui.scoreboard:SetHTML( [[<meta http-equiv="refresh" content="0; url=https://preview.c9users.io/jacobthebrown/basewars/hello-world.html" />]] )
	
	function basewars.gui.scoreboard:OnFinishLoadingDocument() 
		for k, v in pairs ( player.GetAll() ) do
				self:QueueJavascript( string.format("createPlayer('%s', '%d', '%s')",v:GetName(), v:Ping(), v:EntIndex()) )
		end
	end	
	
	local lastPaint = 0;
	function basewars.gui.scoreboard:Paint( w, h )
		if (CurTime() >= lastPaint + 1) then
			lastPaint = CurTime();
			for k, v in pairs ( player.GetAll() ) do 
				self:QueueJavascript( string.format("createPlayer('%s', '%d', '%s')",v:GetName(), v:Ping(), v:EntIndex()) )
			end
		end
	end

end
