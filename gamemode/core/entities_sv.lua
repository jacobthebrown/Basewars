basewars.util.ents = basewars.util.ents or {};

local ENTFUNC = basewars.util.ents;

function ENTFUNC:SendGameDataSingle(ent, tbl) 
    
	net.Start("GameObject_SendGameDataSingle");
	net.WriteEntity(ent);
	net.WriteTable(tbl);
	net.Broadcast();
	
end

function ENTFUNC:SendGameDataMany(tbl) 
    
	net.Start("GameObject_SendGameDataMany");
	net.WriteTable(tbl);
	net.Broadcast();
	
end