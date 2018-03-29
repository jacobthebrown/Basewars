local Object = {};
   
--//
--//	Constructs a soda object.
--//
function Object:new( metaInstance )
	return GameObject:new(Object, metaInstance);
end

--//
--//	Event: Triggered when the client drinks a soda.
--//
function Object:Draw()

	render.SetColorMaterial()

	local pos = LocalPlayer():GetEyeTrace().HitPos


	render.DrawWireframeSphere( self:GetEntity():GetPos(), 256, 10, 10, Color( 255, 255, 255, 255 ) );


end

GameObject:Register( "Object_Warden", Object);