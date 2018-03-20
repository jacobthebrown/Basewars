BW.gui = BW.gui or {};
BW.gui.menufactory = {};
BW.gui.menufactory.__index = BW.gui.menufactory;
local MODULE = BW.gui.menufactory;


function MODULE:Create(object, x, y, width, height, url)
   
    object.gui = vgui.Create( "DHTML" );
	object.gui:SetPos(x, y);
	object.gui:SetSize(width, height);
	object.settings.init = {x = x, y = y, width = width, height = height, url = url};
	
	object.gui.OnDocumentReady = function(url) 
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
	
	object.gui:OpenURL(url);


	
	
	--object.gui.Paint = object.Paint;
	
	setmetatable( object, MODULE );
    
end

function MODULE:Refresh()
	--if (self && self.settings) then
	--    --self.gui:OpenURL(self.settings.url);
	--end
	--
	--if (args) then
	--   self.settings.args = args;
	--end
end

function MODULE:Open(args) 
    
    self.gui:Show();
	self.gui:SetMouseInputEnabled(true);
	gui.EnableScreenClicker(true);
    
    if (args) then
       self.settings.args = args;
    end
    
end

function MODULE:Close() 
    
    self.gui:Remove();
    self.gui:SetMouseInputEnabled(false);
    gui.EnableScreenClicker(false);
    
end

function MODULE:Paint(w, h)
	if (!input.IsKeyDown( KEY_LALT )) then
	 	--self:Close();
	end
end