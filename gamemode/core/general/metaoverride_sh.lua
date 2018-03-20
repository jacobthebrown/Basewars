local Entity = FindMetaTable("Entity")

--//
--//    Returns the GameObject attached to this source entity.
--//
function Entity:GetObject() 

    if (!self.GameObjectID) then
        return nil;
    end
    return GameObject:GetGameObject(self.GameObjectID);
end 

--//
--//    Sets the GameObject attached to this source entity.
--//
function Entity:SetObject(object)
    if (!object) then
        self.GameObjectID = object;      
    else
        self.GameObjectID = object:GetEdic(); 
    end

end 

--//
--//    Returns the GameObject ID attached to this source entity.
--//
function Entity:GetObjectID() 
    return self.GameObjectID;
end 

--//
--//    Sets the GameObject ID attached to this source entity.
--//
function Entity:SetObjectID(objectID) 
    self.GameObjectID = objectID; 
end 