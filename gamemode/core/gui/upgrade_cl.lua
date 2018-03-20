BW.gui = BW.gui or {};
BW.gui.upgrade = BW.gui.upgrade or {};
local MODULE = BW.gui.upgrade;
local MenuFactory = BW.gui.menufactory;

function MODULE:Create(args)
	
	--local metatree = metaobject.upgradetree;
	--local currtree = gameobject.upgrades;
	
	--if (self.gui == nil) then
		--local x, y = (ScrW()/2) - (ScrW()/4), (ScrH()/2 - 256);
		--local width, height = (ScrW()/2), 512;
	--end
	
	if (self.gui) then
		self.gui:Remove();	
	end
	
	self.settings = {};
	self.settings.args = args;
	MenuFactory:Create(MODULE, 0, 0, ScrW(), ScrH(), "http://54.88.44.238:8080/upgrade");
	self:Open();

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
	    
	    local query = string.format("CreateItem('upgradepanel', '%s', '%s', '%s', '%d', %s)", identity, name, desc, 100, enabled);
	    
		self.gui:QueueJavascript(query);
	end
end

function MODULE:Buy(args)
	
	net.Start("GameObject_Upgrade");
	net.WriteUInt(self.settings.args.gameobject:GetEdic(), 32);
	net.WriteUInt(args.upgradeid, 8);
	net.SendToServer();
	
	self:Refresh();
	
end

function MODULE:GUICheck() 
    local trace = LocalPlayer():GetEyeTrace().Entity;
    
    if (trace:GetObject()) then
        
        local gameobject = trace:GetObject();
        local metaobject = GameObject:GetMetaObject(gameobject:GetType());
        
        MODULE:Create({metaobject = metaobject, gameobject = gameobject}); 
    end
    
end

function MODULE:PlayerBindPress(bind)

    if (bind == "lastinv") then
        MODULE:GUICheck();
        return true;
    end
   
end
hook.Add("PlayerBindPress", "Hook_PlayerBindPress", MODULE.PlayerBindPress) 
