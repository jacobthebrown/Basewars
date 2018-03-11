BW.shop = {};

local MODULE = BW.shop;

concommand.Add( "create", function( ply, cmd, args ) 
	
	local metaObject = GameObject:GetMetaObject("Object_" .. args[1]);
	
	if (!metaObject) then
		return 
	end

	-- If the owner of the game object should only have one game object of its type.
	if (metaObject.FLAGS && metaObject.FLAGS.UNIQUE) then
		for k, v in pairs (GameObject:GetAllGameObjects()) do
			if (v.entityType == "Object_" .. args[1] && v.owner == ply:SteamID64()) then v:Remove(); end
		end
	end

    local trace = {};
    trace.start = ply:EyePos();
    trace.endpos = trace.start + ply:GetAimVector() * 85;
    trace.filter = ply;
    
    local tr = util.TraceLine(trace);
	local newObject = metaObject:new(ply, tr.HitPos);
	
	GameObject:SendGameDataSingle(ply, newObject);
	
end)
 
concommand.Add( "upgrade", function( ply, cmd, args ) 

	local ent = ply:GetEyeTrace().Entity;

	if (ent.gamedata && ent.gamedata.SkillTree) then
		ent.gamedata:Upgrade();
	end
	
end)