BW.shop = {};

local MODULE = BW.shop;

net.Receive("GameObject_Upgrade", function(len, ply)

	
	local edic = net.ReadUInt(32);
	local upgradeID = net.ReadUInt(8);
	
	local gameobject = GameObject:GetGameObject(edic);
	
	if (gameobject && gameobject.Upgrade) then
		gameobject:Upgrade(upgradeID);	
	else
		error("Object was deleted before it could be upgraded or never existed.");
	end
	
end)

concommand.Add( "create", function( ply, cmd, args ) 
	
	local metaObject = GameObject:GetMetaObject("Object_" .. args[1]) or GameObject:GetMetaObject(args[1]);
	
	if (!metaObject) then
		return
	end

	-- If the owner of the game object should only have one game object of its type.
	if (metaObject.FLAGS && metaObject.FLAGS.UNIQUE) then
		for k, v in pairs (GameObject:GetAllGameObjects()) do
			if (v:GetType() == metaObject:GetType() && v.owner == ply:SteamID64()) then v:Remove(); end
		end
	end

    local trace = {};
    trace.start = ply:EyePos();
    trace.endpos = trace.start + ply:GetAimVector() * 85;
    trace.filter = ply;
    
    local tr = util.TraceLine(trace);
	local newObject = metaObject:new(ply, tr.HitPos);
	
end)