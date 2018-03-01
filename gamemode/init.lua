-- These files get sent to the client

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )
include( 'sandbox_overrides.lua')

local gamefiles_sv = file.Find( "Basewars/gamemode/classes/sv_*.lua", "LUA" )
for k, v in pairs(gamefiles_sv) do
   include("classes/"..v)
end

local gamefiles_cl = file.Find( "Basewars/gamemode/classes/cl_*.lua", "LUA" )
for k, v in pairs(gamefiles_cl) do
   AddCSLuaFile("classes/"..v)
end

local gamefiles_sv = file.Find( "Basewars/gamemode/classes/entities/sv_*.lua", "LUA" )
for k, v in pairs(gamefiles_sv) do
   include("classes/entities/"..v)
end

local gamefiles_cl = file.Find( "Basewars/gamemode/classes/entities/cl_*.lua", "LUA" )
for k, v in pairs(gamefiles_cl) do
   AddCSLuaFile("classes/entities/"..v)
end

print("<--------------------Initializing Gamemode------------------------>")

function InitializeNetworkStrings()
	--util.AddNetworkString( "Prop_Permissions" )
	util.AddNetworkString( "Entity_RequestGameData" );
	util.AddNetworkString( "Entity_SendGameData" );
	util.AddNetworkString( "Entity_MoneyPrinter_GetBalance" );
	util.AddNetworkString( "Entity_Player_GetWealth");
	util.AddNetworkString( "Entity_Player_Client_RequestGameData");
	util.AddNetworkString( "Entity_Player_Server_SendGameData");

end
hook.Add( "Initialize", "Hook_InitializeNetworkStrings", InitializeNetworkStrings )

function GM:PlayerLoadout( ply )
	ply:Give( "weapon_physgun" );
	ply:Give( "gmod_tool" );

	-- Prevent default Loadout.
	return true;
end

function InitializePlayerData(ply)
	ply.gamedata = ClassPlayerData(ply);
end
hook.Add( "PlayerInitialSpawn", "Hook_InitializePlayerData", InitializePlayerData )

function CleanUpPlayerData(ply) 
	
end
hook.Add("PlayerDisconnected", "Hook_CleanUpPlayerData", CleanUpPlayerData)



