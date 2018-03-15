BW.gui.upgrade = {};
local MODULE = BW.gui.upgrade;
local MODULE_GUI = BW.gui.upgrade.derma;

-- SANITIZE THE QUEUE JAVASCRIPT
function MODULE:Open(metaobject, gameobject)
	
	local metatree = metaobject.upgradetree;
	local currentupgrades = gameobject.upgrades;
	
	if (MODULE_GUI == nil) then
		MODULE_GUI = vgui.Create( "DHTML" )
		MODULE_GUI:SetAllowLua( true )
		MODULE_GUI:SetSize( ScrW()/2, 512 );
		MODULE_GUI:SetPos(ScrW()/2 - ScrW()/4, ScrH()/2 - 256)
		MODULE_GUI:OpenURL( "http://107.22.133.201:8080/upgrade")
	else
    	MODULE_GUI:Show();
    	MODULE_GUI:SetMouseInputEnabled(true);
    	gui.EnableScreenClicker(true);
	end	
	

		
		function MODULE_GUI:Paint( w, h )
		    
		   if (!input.IsKeyDown( KEY_LALT )) then
	        	MODULE_GUI:SetMouseInputEnabled(false);
	        	MODULE_GUI:Hide();
	        	gui.EnableScreenClicker(false);
		   end
		    
		end
	
		MODULE_GUI:AddFunction( "game", "Close", function( objecttype )
		    
	    	MODULE_GUI:SetMouseInputEnabled(false);
	    	MODULE_GUI:Hide();
	    	gui.EnableScreenClicker(false);
	    	
		end )


		MODULE_GUI:AddFunction( "game", "buy", function( upgradeID )
			print("bought an upgrade!")
			
	        net.Start("GameObject_Upgrade");
	    	
	    	net.WriteUInt(gameobject:GetIndex(), 32);
	    	net.WriteUInt(upgradeID, 8);
	    	
	        net.SendToServer();
	        
	        MODULE_GUI:SetMouseInputEnabled(false);
	    	MODULE_GUI:Hide();
	    	gui.EnableScreenClicker(false);
	        	
		end )
		
	    MODULE_GUI:AddFunction( "game", "FullyLoaded", function(args)
	        
	    	for k,v in pairs (metatree or {}) do
	    	    local identity = k;
	    	    local name = v.name;
	    	    local desc = v.desc;-- objectname, displayname, price, desc)
	    	    local enabled = "true";
	    	    
	    	    print(currentupgrades[k]);
	    	    PrintTable(currentupgrades);
	    	    
	    	    if (currentupgrades[k]) then
	    	        enabled = "false";
	    	    end
	    	    
	    		MODULE_GUI:QueueJavascript( string.format("CreateItem('%s', '%s', '%s', '%d', '%s',)", identity, name, desc, 100, enabled) );
	    	end
	    end)	
	
	MODULE_GUI.OnDocumentReady = function(panel, url)
		
		if (url == "http://107.22.133.201:8080/upgrade") then
			print("yep")	
		end
		
	    print(url)
		
		MODULE_GUI:QueueJavascript("$('buybutton').focusout();")
		MODULE_GUI:QueueJavascript("ui.refresh()");
		
	end
	
end



concommand.Remove( "lastinv" )

function MODULE:GUICheck() 
    local trace = LocalPlayer():GetEyeTrace().Entity;
    
    if (trace:GetObject()) then
        
        local gameobject = trace:GetObject();
        local metaobject = GameObject:GetMetaObject(gameobject:GetType());
        
        MODULE:Open(metaobject, gameobject); 
    end
    
end

concommand.Add("bw_ugprade", MODULE.GUICheck)

function MODULE:PlayerBindPress( bind )

    if (bind == "lastinv") then
        MODULE:GUICheck();
        return true;
    end
   
end
hook.Add("PlayerBindPress", "Hook_PlayerBindPress", MODULE.PlayerBindPress) 
