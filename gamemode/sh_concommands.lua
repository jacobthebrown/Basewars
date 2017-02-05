concommand.Add( "GetTrace", function( ply, cmd, args )
	
	if args[1] == "1" then
		print(ply:GetEyeTrace().HitPos)
	end
	if args[1] == "2" then
		print(ply:GetEyeTrace().Entity:GetClass())
	end
end)

concommand.Add( "modifyPlayer", function( ply, cmd, args )

	SQL:modifyPlayerData(args[1], args[2], ply:SteamID64())
	
end)

concommand.Add( "DeletePlayer", function( ply, cmd, args )

	if args[1] == nil then
		SQL:deletePlayer("Players","SteamID", ply:SteamID64())
	else
		SQL:deletePlayer("Players","SteamID", args[1])
	end

end)

concommand.Add( "CreatePlayer", function( ply, cmd, args )
		
	SQL:CreatePlayer(ply:SteamID64() )
		
end)

if SERVER then
	concommand.Add( "spawn_item", function( ply, cmd, args )

		local itemDetails = items[args[1]]
		
		local tr = ply:GetEyeTrace()
		
		if ( !tr.Hit ) then return end
	
		local SpawnPos = tr.HitPos + tr.HitNormal * 32
		
		local ent = ents.Create("ent_item")
		ent.model = Model("models/props_junk/PopCan01a.mdl")
		ent:Spawn()
		ent:SetPos(SpawnPos)
		
		ent:receiveData(args[1])

	end)
end