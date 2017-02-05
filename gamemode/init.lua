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
//	include( 'sv_hooks.lua' )
include( 'sv_internal.lua' )
include( 'sh_concommands.lua' )
include( 'sh_modules.lua' )
include( 'sh_items.lua' )
------------------------------------------


function InitStrings()
	util.AddNetworkString( "Prop_Permissions" )
end
hook.Add( "Initialize", "InitStringss", InitStrings )

function playerData(ply)

	ply.data = {}
	Inventory:fetchInventory(ply,callback)	

end
hook.Add( "PlayerSpawn", "playerDataGeneration", playerData )