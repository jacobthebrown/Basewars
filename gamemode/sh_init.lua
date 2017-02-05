-- These files get sent to the client

include( 'shared.lua' )
include( 'sv_hooks.lua' )
include( 'sv_internal.lua' )
include( 'sh_concommands.lua' )

--
-- Make BaseClass available
--
DeriveGamemode( "sandbox" )
