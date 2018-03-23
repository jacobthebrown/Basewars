local Entity = FindMetaTable("Entity")

--//
--//    Returns the GameObject attached to this source entity.
--//
function Entity:GetObject() 

    -- Grab entitie's edic.
    local edic = self:GetNWInt("EdicID", nil);

    -- If entity has no edic, return nil.
    if (!edic) then
        return nil;
    end

    -- If self.gameobject is valid, return or go and find the object.
    return self.gameobject or GameObject:GetGameObject(edic);
end 

--//
--//    Sets the GameObject attached to this source entity.
--//
function Entity:SetObject(ObjectOrEdic)
    
    if (isobject(ObjectOrEdic)) then
        self:SetNWInt('EdicID', ObjectOrEdic.edic); 
        self.gameobject = ObjectOrEdic;
    elseif (isnumber(ObjectOrEdic)) then
        self:SetNWInt('EdicID', ObjectOrEdic);
        self.gameobject = GameObject:GetGameObject(ObjectOrEdic);
    else
        error("Tried to set an entities object as null.")
    end

end 

--//
--//    Returns the GameObject ID attached to this source entity.
--//
function Entity:GetEdic()
    return self:GetNWInt( "EdicID", nil );
end 

--//
--//    Sets the GameObject ID attached to this source entity.
--//
--function Entity:SetEdic(edic) 
--    self:SetNWInt('EdicID', edic);
--end 