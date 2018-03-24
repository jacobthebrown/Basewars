BW.gui = BW.gui or {};
BW.gui.menufactory = {};
BW.gui.menufactory.__index = BW.gui.menufactory;
local MODULE = BW.gui.menufactory;

--//
--//	Creates the menu, and prescribes it to a series of abstract functions.
--//
function MODULE:Create(object, x, y, width, height, url)
   
   -- Creates the gui element of the menu, setup.
    object.gui = vgui.Create( "DHTML" );
	object.gui:SetPos(x, y);
	object.gui:SetSize(width, height);
	object.settings.init = {x = x, y = y, width = width, height = height, url = url};
	
	-- Add some default functions to the document.
	object.gui.OnDocumentReady = function(url)
		
		if (object.OnDocumentReady) then
			object:OnDocumentReady();
		end
		
		object.gui:AddFunction("menu", "Close", function()
			object:Close();
		end);
		
		object.gui:AddFunction("menu", "Refresh", function()
		    object:Refresh();
		end);
		
		object.gui:AddFunction("menu", "Loaded", function() 
		    if (object.Loaded) then
		        object:Loaded();
		    end
		end);
		
		object.gui:AddFunction("menu", "Buy", function(json) 
			
			local args = util.JSONToTable(json);
		    
		    if (object.Buy) then
		        object:Buy(args);
		    end
		end);
		
		if (object.Loaded) then
		     object:Loaded();
		end
	end
	
	-- Open the target URL.
	object.gui:OpenURL(url);

	-- Prescribes the object to some meta functions of the menu factory.
	setmetatable( object, MODULE );
    
end

--//
--//
--//
function MODULE:Refresh()
	self:Trace();
end

--//
--//
--//
function MODULE:Open(args) 
    
    self.gui:Show();
	self.gui:SetMouseInputEnabled(true);
	gui.EnableScreenClicker(true);
    
    if (args) then
       self.settings.args = args;
    end
    
end

--//
--//
--//
function MODULE:Close() 
    
    self.gui:Remove();
    self.gui:SetMouseInputEnabled(false);
    gui.EnableScreenClicker(false);
    
end
