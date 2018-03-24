BW.gui = BW.gui or {};
BW.gui.upgrade = BW.gui.upgrade or {};
local MODULE = BW.gui.upgrade;
local MenuFactory = BW.gui.menufactory;

function MODULE:Create(args)
	
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
	
	PrintTable(self.settings.args.gameobject)
	
	for k,v in pairs (metatree) do
	    local identity = k;
	    local name = v.name;
	    local desc = v.desc;
	    local enabled = true;

	    if (currtree[k]) then
	        enabled = false;
	    end
	    
	    local query = string.format("CreateItem('%s', '%s', '%s', '%d', %s)", identity, name, desc, 100, enabled);
	    
		self.gui:QueueJavascript(query);
	end
end

function MODULE:Buy(args)
	
	PrintTable(args);
	
	net.Start("GameObject_Upgrade");
	net.WriteUInt(self.settings.args.gameobject:GetEdic(), 32);
	net.WriteUInt(args.objectid, 8);
	net.SendToServer();
	
	self:Refresh();
	
end

function MODULE:Trace() 
    local trace = LocalPlayer():GetEyeTrace().Entity;
    
    if (trace:GetObject()) then
        
        local gameobject = trace:GetObject();
        local metaobject = GameObject:GetMetaObject(gameobject:GetType());
        
        MODULE:Create({metaobject = metaobject, gameobject = gameobject}); 
    end
end

function MODULE:PlayerBindPress(bind)

    if (bind == "lastinv" || (bind == "")) then
        MODULE:Trace();
        return true;
    end
   
end
hook.Add("PlayerBindPress", "Hook_PlayerBindPress", MODULE.PlayerBindPress) 
