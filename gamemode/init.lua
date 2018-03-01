-- These files get sent to the client

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hooks.lua" )
AddCSLuaFile( "cl_gui.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_concommands.lua" )
AddCSLuaFile( "sh_modules.lua" )
AddCSLuaFile( "sh_items.lua" )

print("<--------------------Initializing Gamemode------------------------>")

include( 'shared.lua' )
--include( 'sv_hooks.lua' )
include( 'sv_utility.lua' )
include( 'sh_concommands.lua' )
include( 'sh_modules.lua' )
include( 'sh_items.lua' )
include( 'classes/playerdata.lua');

function InitializeNetworkStrings()
	--util.AddNetworkString( "Prop_Permissions" )
end
hook.Add( "Initialize", "Hook_InitializeNetworkStrings", InitializeNetworkStrings )

function InitializePlayerData(ply)
	console.log("Init player data")
	ply.gamedata = PlayerData(ply);
	
	ply.gamedata:MakeSpeak();
	
end
hook.Add( "PlayerInitialSpawn", "Hook_InitializePlayerData", InitializePlayerData )