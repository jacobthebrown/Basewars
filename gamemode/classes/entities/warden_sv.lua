local Object = {};

Object.members = {
	model = "models/props_c17/FurnitureToilet001a.mdl",
	lastCheck = 0;
}
	
--//
--//	Constructs a money printer object.
--//
function Object:new( ply, position, maxBalance, printAmount )
	return GameObject:new(Object, table.Copy(Object.members), ply, position);
end

function Object:OnThink()
    
    if (CurTime() <= self:GetLastCheck() + 0.1) then
        return
    end
    
    self:SetLastCheck(CurTime());
    
    local ent = self:GetEntity();
    
    for k,v in pairs (playersInSphere(ent:GetPos(), 256*256)) do
               
        if (!v:IsPlayer() || v == self:GetOwner()) then
           continue; 
        end

        if (!v:Alive()) then
            continue;
        end

        v:TakeDamage( 1, ent:GetOwner(), self );
    end    
    
end

GameObject:Register( "Object_Warden", Object);

