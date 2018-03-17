BW.gui = BW.gui or {};
BW.gui.upgrade = {};
local MODULE = BW.gui.upgrade;
local MenuFactory = BW.gui.menufactory;

function MODULE:Open(args)
	
	--local metatree = metaobject.upgradetree;
	--local currtree = gameobject.upgrades;
	
	if (self.gui == nil) then
		local x, y = (ScrW()/2) - (ScrW()/4), (ScrH()/2 - 256);
		local width, height = (ScrW()/2), 512;
		self.gui = MenuFactory:Create(MODULE, "http://107.22.133.201:8080/upgrade", x, y, width, height);
	end
	
	MenuFactory.Open(MODULE, args);

end

function MODULE:Loaded()
	
	local metatree = self.settings.args.metaobject.upgradetree;
	local currtree = self.settings.args.gameobject.upgrades;
	
	for k,v in pairs (metatree or {}) do
	    local identity = k;
	    local name = v.name;
	    local desc = v.desc;
	    local enabled = true;
	    
	    print(currtree[k]);
	    PrintTable(currtree);
	    
	    if (currtree[k]) then
	        enabled = false;
	    end
	    
		MODULE_GUI:QueueJavascript(string.format("CreateItem('%s', '%s', '%s', '%d', %s)", identity, name, desc, 100, enabled));
	end
end

function MODULE:Buy(args)
	net.Start("GameObject_Upgrade");
	net.WriteUInt(gameobject:GetIndex(), 32);
	net.WriteUInt(upgradeID, 8);
	net.SendToServer();
	
	self:Refresh();
end

function MODULE:GUICheck() 
    local trace = LocalPlayer():GetEyeTrace().Entity;
    
    if (trace:GetObject()) then
        
        local gameobject = trace:GetObject();
        local metaobject = GameObject:GetMetaObject(gameobject:GetType());
        
        MODULE:Open({metaobject = metaobject, gameobject = gameobject}); 
    end
    
end

function MODULE:PlayerBindPress(bind)

    if (bind == "lastinv") then
        MODULE:GUICheck();
        return true;
    end
   
end
hook.Add("PlayerBindPress", "Hook_PlayerBindPress", MODULE.PlayerBindPress) 
