
function isobject(object)
	if (istable(object) && object.edic) then
		return true;
	else
		return false;
	end
end

function playersInSphere(pos, radius)
	
	local players = {};

	
	for k, v in pairs(player.GetAll()) do
		
		if (v:GetPos():DistToSqr(pos) < radius) then
			table.insert(players, v);
		end
		
	end
	
	return players;
	
	
end