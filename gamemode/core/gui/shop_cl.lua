BW.gui = BW.gui or {};
BW.gui.shop = BW.gui.shop or {};
local MODULE = BW.gui.shop;
local MenuFactory = BW.gui.menufactory;

function GM:ScoreboardHide()

	if (!MODULE.gui) then
		return;
	end

	MODULE.gui:Hide();
	MODULE.gui:SetMouseInputEnabled(false);
	gui.EnableScreenClicker(false);
	
end

function GM:ScoreboardShow()
	MODULE:Trace();
	MODULE.gui:SetMouseInputEnabled(true);
	gui.EnableScreenClicker(true);
	
end

function MODULE:Create(args)
	
	if (self.gui) then
		self.gui:Remove();	
	end
	
	self.settings = {};
	self.settings.args = args;
	MenuFactory:Create(MODULE, 0, 0, ScrW(), ScrH(), "http://54.88.44.238:8080/shop");
	self:Open();

end

function MODULE:Loaded()
	
	for k,v in pairs (self.settings.args.registry) do
		
		PrintTable(v)
		
		if (v.FLAGS && v.FLAGS.UNBUYABLE) then
			continue;
		end
		
	    local query = string.format("CreateItem('menudock-general', '%s', '%s', '%s', '%d', %s)", v:GetType(), v:GetType(), "Some really cool entity!", 100, true);
		self.gui:QueueJavascript(query);
		
	end
	
	local lastPaint = 0;
	function self.gui:Paint( w, h )
		if (CurTime() >= lastPaint + 0.5) then
			lastPaint = CurTime();
			for k, v in pairs ( player.GetAll() ) do 
				self:QueueJavascript( string.format("UpdatePlayer('%s', '%s', '%s', '%d')", v:EntIndex(), v:GetName(), "Title", v:Ping()) )
			end
		end
	end
	
end

function MODULE:Buy(args)
	PrintTable(args)
	LocalPlayer():ConCommand( "create "..args["objectid"] )
end

function MODULE:Trace()
		MODULE:Create({registry = GameObject.registry});
end

function MODULE:PlayerBindPress(bind)
end
hook.Add("PlayerBindPress", "Hook_PlayerBindPress", MODULE.PlayerBindPress) 
