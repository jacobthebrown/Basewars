util = {}

function util.getNameBySteamID(SteamID)

	for k,v in pairs (player.GetAll()) do
	
		if v:SteamID64()==SteamID then
		
			return v:GetName()
			
		end
		
	end

end