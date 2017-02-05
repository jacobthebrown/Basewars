local MODULE = {}

Inventory = {}

MODULE.Name = "Inventory"

function MODULE:Load()
	
end

util.AddNetworkString( "net_openInventory" )
util.AddNetworkString( "net_updateInventory" )
util.AddNetworkString( "net_updateInventory" )
util.AddNetworkString( "net_RemoveItem" )

function Inventory:grabItem(ply, ent)
	
	local callback = function()
	
		ent.Grabbed = true;
		
		if(Inventory:checkWeight(ply, ent:Get_itemID())) then
			
			if ent:IsValid() then
				if Inventory:getEmptySpace(ply) != nil then
					Inventory:insertInv(ply,ent:Get_itemID(),Inventory:getEmptySpace(ply))
					ent:Remove()
				else
					print("Full Inventory")					
					ent.Grabbed = false;			
				end
		
			end
		else
			ent.Grabbed = false;
		end
		
	end
			
	Inventory:fetchInventory(ply,callback)
	
end

function Inventory:cancelGrab(ply,ent)

end

function Inventory:dropItem(ply, pos)

	local dataTable = Inventory:constructTable(ply.data["Inventory"])
	//print(dataTable[pos].ID)	
	//PrintTable(items)	
	
	local itemDetails = Inventory:getItem(ply, pos)					
	
	if itemDetails == nil then return end
	
	local tr = ply:GetEyeTrace()
	
	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 32			
	
	local ent = ents.Create("ent_item")
	ent.model = Model("models/props_junk/PopCan01a.mdl")
	ent:Spawn()
	ent:SetPos(SpawnPos)
	
	ent:receiveData(itemDetails.ID)											
	
	net.Start("net_updateInventory")	
	net.WriteString(Inventory:parseToDB(dataTable))	
	net.Send( ply )
		
	dataTable[pos] = nil		
	Inventory:updateInv(ply, Inventory:parseToDB(dataTable))

end

function Inventory:checkWeight(ply, item)
	
	if (Inventory:getWeight(ply) + items[item].Weight <= 50) then
		
		return true
		
	else
		print("player out of room")
	end
	
end

function Inventory:getWeight(ply)
	return 0
end

function Inventory:getInv(ply)

end

function Inventory:insertInv(ply,item,pos)
	
	if ply:IsValid() then
		
		ply.data["Inventory"] = ply.data["Inventory"] .."\"".. item .."\"," .. pos .. ";"
		
		//PrintTable(Inventory:constructTable(ply.data["Inventory"]))
		
		SQL:modifyPlayerData("Inventory", ply.data["Inventory"], ply:SteamID64())

	end	
	
end

function Inventory:updateInv(ply, data)
	
	if ply:IsValid() then
		
		ply.data["Inventory"] = data
		
		SQL:modifyPlayerData("Inventory", data, ply:SteamID64())

	end	
	
end

function Inventory:fetchInventory(ply,callback)
	
	if ply:IsValid() then
	
		local retrieve = function (data)
			
			ply.data["Inventory"] = data
			callback()
			
		end

		SQL:fetchPlayerData(ply,"Inventory", retrieve)
		
	end
	
end
						

function Inventory:constructTable(data)
	if data != "" then
	
		local decompInv = string.Split(data, ";")
		local compiledInv = {}
		
		table.RemoveByValue( decompInv, "" ) 
		
		for k,v in pairs(decompInv) do
			
			if v != nil and v != "" then
			
				local itemData = string.Split(v, ",")
				local itemPos = tonumber(itemData[2])
				
				compiledInv[itemPos] = {}
				
				compiledInv[itemPos].ID = itemData[1]
				compiledInv[itemPos].pos = tonumber(itemData[2])
				
			end
			
		end
		
		return compiledInv
			
	else
		return nil
	end

end
	
function Inventory:getEmptySpace(ply)
		
	local dataTable = Inventory:constructTable(ply.data["Inventory"])
					
	if dataTable != nil then
	
		for i=1,25 do	
			if (dataTable[i] == nil) then
				return i
			end
		end
	else	
		return 1
	end

end

function Inventory:moveItem(ply, posOld, posNew)

	local dataTable = Inventory:constructTable(ply.data["Inventory"])
	
	local swap1 = nil
	local swap2 = nil
	
	if dataTable != nil then
		for k,v in pairs (dataTable) do
			
			if v.pos == posNew then
				swap1 = v
			end
				
			if v.pos == posOld then
				swap2 = v
			end
			
			if (swap1 != nil) then
				swap1.pos = posOld
			end
			if (swap2 != nil) then
				swap2.pos = posNew
			end
			
		end
	end						
	
	
	
	
	
	
	if dataTable == nil then
		dataTable = {}
	end
	
	net.Start("net_updateInventory")	
	net.WriteString(Inventory:parseToDB(dataTable))	
	net.Send( ply )
		
	Inventory:updateInv(ply, Inventory:parseToDB(dataTable))
	
end
	
function Inventory:parseToDB(dataTable)

	local parsedString = ""

	for k,v in pairs(dataTable) do	
		if v != nil and v.pos != nil and v.ID != nil then
			parsedString = parsedString .. v.ID .. ",".. v.pos .. ";"
		end
	end
	
	return parsedString
	
end
	
function Inventory:getItem(ply, pos)

	local itemTable = Inventory:constructTable(ply.data["Inventory"])
						
	if itemTable != nil && itemTable[pos] != nil then
		return items[string.Trim(itemTable[pos].ID, "\"")]		
	end
									
end
	
net.Receive("net_updateInventory", function ()
	
	local oldpos = net.ReadDouble()
	local newpos = net.ReadDouble()
	local SteamID = net.ReadString()
	
	print(oldpos,newpos,SteamID)
				
	
	for k,v in pairs (player.GetAll()) do
	
		print(0,0,v:SteamID64())	
				
		if tonumber(v:SteamID64()) == tonumber(SteamID) then		
			
			
			local callback = function ()
				Inventory:moveItem(v, oldpos, newpos)
			end
	
			Inventory:fetchInventory(v,callback)
			
		end
	end
	
end)

net.Receive("net_RemoveItem", function ()
	
	local SteamID = net.ReadDouble()
	local pos = net.ReadDouble()	
	
	print(pos,SteamID)
				
			
	for k,v in pairs (player.GetAll()) do
				
		if tonumber(v:SteamID64()) == tonumber(SteamID) then		
			
			
			local callback = function ()
				Inventory:dropItem(v, pos)
			end
	
			Inventory:fetchInventory(v,callback)
			
		end
	end
	
end)
		
		
concommand.Add( "showInventory", function( ply, cmd, args )
				
	local callback = function(data)
		net.Start("net_openInventory")
		net.WriteString(data)
		net.WriteString(ply:SteamID64())
		net.Send( ply )
	end
	
	SQL:fetchPlayerData(ply,"Inventory",callback) 
		
end)

concommand.Add( "swapItems", function( ply, cmd, args )
	
	local callback = function(data)
			
		Inventory:moveItem(ply,tonumber(args[1]),tonumber(args[2]))
		
	end
	
	SQL:fetchPlayerData(ply,"Inventory",callback) 
		
end)

mod.Register(MODULE)