basewars = basewars or {};
basewars.util = basewars.util or {};

include("shared.lua")
include("includes.lua")

net.Receive( "Entity_Player_GetWealth", function()
	 local money = net.ReadUInt(32);
	 chat.AddText( "Wealth: " .. tostring(money) );
end )