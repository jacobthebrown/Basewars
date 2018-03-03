basewars.util.ents = basewars.util.ents or {};

local ENTFUNC = basewars.util.ents;

function ENTFUNC:SendGameDataSingle(ent, tbl) 
    
	net.Start("Entity_SendGameDataSingle");
	net.WriteEntity(ent);
	net.WriteTable(tbl);
	net.Broadcast();
	
end

function ENTFUNC:SendGameDataMany(tbl) 
    
	net.Start("Entity_SendGameDataMany");
	net.WriteTable(tbl);
	net.Broadcast();
	
end