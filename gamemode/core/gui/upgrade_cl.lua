BW.gui = BW.gui or {};
BW.gui.upgrade = BW.gui.upgrade or {};
local MODULE = BW.gui.upgrade;
local MenuFactory = BW.gui.menufactory;

--//
--//	Creates an upgrade menu for the client.
--//
function MODULE:Create(args)
	
	if (self.gui && self.gui:IsValid()) then
		self.gui:Remove();	
	end
	
	self.settings = {};
	self.settings.args = args;
	MenuFactory:Create(MODULE, 0, 0, ScrW(), ScrH(), "http://34.238.255.178:8080/upgrade");
	self:Open();

end

--//
--//	Called when menu is fully loaded.
--//
function MODULE:OnLoaded()
	
	local metatree = self.settings.args.metaobject.upgradetree;
	local currtree = self.settings.args.gameobject.upgrades;
	
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

--//
--//	Called when client attempts to buy something.
--//
function MODULE:Buy(args)

	net.Start("GameObject_Upgrade");
	net.WriteUInt(self.settings.args.gameobject:GetEdic(), 32);
	net.WriteUInt(args.objectid, 8);
	net.SendToServer();
	
	self:Refresh();
	
end

--//
--//	Called when the player is trying to open the menu.
--//
function MODULE:Trace() 
	
    local trace = LocalPlayer():GetEyeTrace().Entity;
    
    if (trace:GetObject() && !trace:IsPlayer()) then
        
        local gameobject = trace:GetObject();
        local metaobject = GameObject:GetMetaObject(gameobject:GetType());
        
        MODULE:Create({metaobject = metaobject, gameobject = gameobject}); 
    end
    
end

--//
--//	Called whenever a player has pressed any button.
--//
function MODULE:PlayerBindPress(bind)
	
	-- If the player has pressed the bind, bound to their alt key
	-- attempt to open the menu.
    if (input.LookupKeyBinding(KEY_LALT) == bind ) then
        MODULE:Trace();
        return true;
    end
   
end
hook.Add("PlayerBindPress", "Hook_PlayerBindPress", MODULE.PlayerBindPress) 
