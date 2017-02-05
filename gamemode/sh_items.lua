items = {}

function items.Register(item)
	items[item.ID] = item
end


if SERVER then

	local gamefiles_sv, dir = file.Find( "Acquire/gamemode/items/*.lua", "LUA" )

		for k, v in pairs(gamefiles_sv) do
		   include("items/"..v)
		end
		
		local gamefiles_cl, dir = file.Find( "Acquire/gamemode/items/cl_*.lua", "LUA" )
	
		for k, v in pairs(gamefiles_cl) do

		   AddCSLuaFile("items/"..v)
		   
		end
		
end

if CLIENT then

	local gamefiles_cl, dir = file.Find( "Acquire/gamemode/items/cl_*.lua", "LUA" )

	for k, v in pairs(gamefiles_cl) do
	   include("items/"..v)
	end

end