local MODULE = {}

MODULE.Name = "Sandbox Config"

function MODULE:Load()
	
end

hook.Add( "HUDShouldDraw", "HideElements", function( name )
	if ( HideElements[ name ] ) then
		return false
	end
end )


function ShouldOpenContext()
	return false
end
hook.Add( "ContextMenuOpen", "AllowOpen", ShouldOpenContext)

mod.Register(MODULE)