include( 'shared.lua' )

local gamefiles_cl = file.Find( "Basewars/gamemode/classes/cl_*.lua", "LUA" )
for k, v in pairs(gamefiles_cl) do
   include("classes/"..v)
end
local gamefiles_cl = file.Find( "Basewars/gamemode/classes/entities/cl_*.lua", "LUA" )
for k, v in pairs(gamefiles_cl) do
   include("classes/entities/"..v)
end


net.Receive( "Entity_Player_GetWealth", function()
	 local money = net.ReadUInt(32);
	 chat.AddText( "Wealth: " .. tostring(money) );
end )
