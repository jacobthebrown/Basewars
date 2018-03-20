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

	
	MODULE:Create();
	MODULE.gui:SetMouseInputEnabled(true);
	gui.EnableScreenClicker(true);
	
end

function MODULE:Create(args)
	
	if (self.gui) then
		self:Open();
		return;
		--self.gui:Remove();	
	end
	
	self.settings = {};
	self.settings.args = args;
	MenuFactory:Create(MODULE, 0, 0, ScrW(), ScrH(), "http://54.88.44.238:8080/shop");
	self:Open();

end

function MODULE:Loaded()
	
	for k,v in pairs (GameObject.registry) do

	    local query = string.format("CreateItem('menudock-general', '%s', '%s', '%s', '%d', %s)", v:GetType(), v:GetType(), "Some really cool entity!", 100, true);
	    
	    print(query);
	    
		self.gui:QueueJavascript(query);
	end
end

function MODULE:Buy(args)
	PrintTable(args)
	LocalPlayer():ConCommand( "create "..args["objectid"] )
end

function MODULE:GUICheck() 
end

function MODULE:PlayerBindPress(bind)
end
hook.Add("PlayerBindPress", "Hook_PlayerBindPress", MODULE.PlayerBindPress) 
