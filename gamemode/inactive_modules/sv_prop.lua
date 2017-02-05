local MODULE = {}

MODULE.Name = "Permissions"

function MODULE:Load()
	
end


function MODULE:Yep()

end

function PhysGunTest( ply, ent )

end
hook.Add( "PhysgunPickup", "PermissionsTest", PermissionsTest )

mod.Register(MODULE)