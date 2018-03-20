--BW.gui = BW.gui or {};
--BW.gui.scoreboard = BW.gui.scoreboard or nil;
--BW.gui.shop = nil;
--local MODULE = BW.gui;


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

--hook.Add( "HUDPaint", "HUD_Paint", function()
--	
--	--surface.SetFont( "Europa Brush" )
--	--
--	--local width, height = surface.GetTextSize( "Hello World" );
--	--
--	--local xPosition = (ScrW()/2 - width/2);
--	--local yPosition = ScrH()/2 - height/2 - 10*math.cos(5*CurTime() % 360);
--	--
--	--surface.SetTextColor( 255, 255, 255, 255 )
--	--surface.SetTextPos( xPosition, yPosition )
--	--surface.DrawText( "Hello World" )
--end )
--
---- SANITIZE THE QUEUE JAVASCRIPT
--function ScoreBoardInitialize()
--	
--	if (MODULE.scoreboard != nil) then
--		MODULE.scoreboard:Remove();
--		MODULE.scoreboard = nil;
--	end	
--	
--
--	MODULE.scoreboard = vgui.Create( "DHTML" )
--	MODULE.scoreboard:SetAllowLua( true )
--	MODULE.scoreboard:SetSize( 512, 512 );
--	MODULE.scoreboard:SetPos(ScrW()/2 - 256, ScrH()/2 - 256)
--	MODULE.scoreboard:SetHTML( [[<meta http-equiv="refresh" content="0; url=https://preview.c9users.io/jacobthebrown/basewars/hello-world.html" />]] )
--	
--	function MODULE.scoreboard:OnFinishLoadingDocument() 
--		for k, v in pairs ( player.GetAll() ) do
--				self:QueueJavascript( string.format("createPlayer('%s', '%s', '%d')", v:EntIndex(), v:GetName(), v:Ping()) )
--		end
--	end	
--	
--	local lastPaint = 0;
--	function MODULE.scoreboard:Paint( w, h )
--		if (CurTime() >= lastPaint + 1) then
--			lastPaint = CurTime();
--			for k, v in pairs ( player.GetAll() ) do 
--				self:QueueJavascript( string.format("createPlayer('%s', '%s', '%d')", v:EntIndex(), v:GetName(), v:Ping()) )
--			end
--		end
--	end
--
--end
--
---- SANITIZE THE QUEUE JAVASCRIPT
--function OpenShop()
--	
--
--	
--	if (MODULE.shop == nil) then
--		--MODULE.shop:Remove();
--		--MODULE.shop = nil;
--		MODULE.shop = vgui.Create( "DHTML" )
--		MODULE.shop:SetAllowLua( true )
--		MODULE.shop:SetSize( ScrW()/2, 512 );
--		MODULE.shop:SetPos(ScrW()/2 - ScrW()/4, ScrH()/2 - 256)
--		MODULE.shop:SetHTML( [[<meta http-equiv="refresh" content="0; url=http://107.22.133.201:8080/shop" />]] )
--	end	
--	
--	MODULE.shop:QueueJavascript("$('buybutton').focusout();")
--	
--
--	
--	function MODULE.shop:OnFinishLoadingDocument()
--
--	end	
--	
--	function MODULE.shop:Paint( w, h )
--	
--	
--	end
--
--	MODULE.shop:AddFunction( "game", "buy", function( objecttype )
--		LocalPlayer():ConCommand( "create "..objecttype )
--	end )
--
--	MODULE.shop:AddFunction( "game", "hasLoaded", function()
--		for k,v in pairs (GameObject.registry) do
--			MODULE.shop:QueueJavascript( string.format("CreateItem('%s', '%s', '%d')", v:GetType(), v:GetType(), 100) );
--		end
--	end )
--
--end