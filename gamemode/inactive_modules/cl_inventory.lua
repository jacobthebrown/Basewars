local MODULE = {}

MODULE.Name = "Inventory"

function MODULE:Load()

end

Inventory = {}

Inventory.GUI = {}

Inventory.GUI.slots = {}

function Inventory:openInventory(data,SteamID)

	Inventory.GUI.backgroundPanel = vgui.Create("DPanel")
	Inventory.GUI.backgroundPanel:SetPos(0,0)
	Inventory.GUI.backgroundPanel:SetSize(ScrW(),ScrH())


	//Creates frame for the inventory.
	Inventory.GUI.inventoryFrame = vgui.Create( "DFrame" , Inventory.GUI.backgroundPanel )
	// Sets the frame size.
	Inventory.GUI.inventoryFrame:SetSize( 400, 500 )
	// Declaring variable for frame size.
	local frame_x,frame_y = Inventory.GUI.inventoryFrame:GetSize()
	//Sets position
	Inventory.GUI.inventoryFrame:SetPos( ScrW()/4 - (frame_x/2), ScrH()/2 - (frame_y/2) )
	// Sets inventory title
	Inventory.GUI.inventoryFrame:SetTitle( "Inventory" )
	// Sets visibility.
	Inventory.GUI.inventoryFrame:SetVisible( true )
	// Makes undraggable.
	Inventory.GUI.inventoryFrame:SetDraggable( false )
	// Show close options.
	Inventory.GUI.inventoryFrame:ShowCloseButton( true )
	// Opens inventory
	Inventory.GUI.inventoryFrame:MakePopup()

	//

	local inventorySpread = constructInventory(data)

	local mainPanel = vgui.Create("DPanel", Inventory.GUI.inventoryFrame)
	mainPanel:SetPos(10,40)
	mainPanel:SetSize(380,450)
	--mainPanel:SetZPos(-1)

	Inventory.GUI.previewInv = vgui.Create( "DPanel")
	Inventory.GUI.previewInv :SetSize(64,64)
	Inventory.GUI.previewInv :SetDrawOnTop(true)
	Inventory.GUI.previewInv :Hide()

	Inventory:LoadSlots(data,Inventory.GUI.inventoryFrame,mainPanel)

	Inventory.GUI.inventoryFrame.Think = function ()

		if !(input.IsMouseDown(MOUSE_LEFT)) and not (gui.IsGameUIVisible() && gui.IsConsoleVisible())  then

		local downInitiated = false

		for k,v in pairs (Inventory.GUI.slots) do
			if v.isDown == true then
				downInitiated = true
			end
		end

			if (vgui.GetHoveredPanel().isSlot == true and downInitiated) then

				local lastDown = nil

				for k,v in pairs (Inventory.GUI.slots) do

					if v.isDown == true then
						lastDown = v
					end

					v.isDown = false
					v.lastDropped = false
				end

				vgui.GetHoveredPanel().lastDropped = true
				Inventory.GUI.previewInv:Hide()

				local firstpos = nil
				local lastpos = nil

				for k,v in pairs (Inventory.GUI.slots) do

					if v == lastDown then
						firstpos = tonumber(v.pos)
					end
					if v.lastDropped then
						lastpos = tonumber(v.pos)
					end
				end

				if (firstpos != lastpos) and (firstpos != nil) and (lastpos != nil) then

					--print("lastDown", firstpos)
					--print("lastDropped", lastpos)

					net.Start( "net_updateInventory")
					net.WriteDouble(firstpos)
					net.WriteDouble(lastpos)
					net.WriteString(SteamID)
					net.SendToServer()

				end


			else
				Inventory.GUI.previewInv:Hide()
			end

			local backgroundDropInit = false

			if vgui.GetHoveredPanel() == Inventory.GUI.backgroundPanel and downInitiated and not backgroundDropInit then

				local lastDown = nil
				backgroundDropInit = true

				for k,v in pairs (Inventory.GUI.slots) do

					if v.isDown == true then
						lastDown = v
					end

				end

				if lastDown.occupied != nil then
					net.Start( "net_RemoveItem")
					net.WriteDouble(SteamID)
					net.WriteDouble(lastDown.pos)
					net.SendToServer()

					lastDown.occupied = nil

				end

			end
		end
	end

	--inventoryFrame.Think = function ()
	--	local currentPanel vgui.GetHoveredPanel()
	--	if input.IsMouseDown(MOUSE_LEFT) && currentPanel.isSlot == true then
	--		for k,v in pairs (slots) do
	--			if v == currentPanel then
	--				v.isDown = true
	--				previewInv:Show()
	--				previewInv:SetPos(gui.MouseX(),gui.MouseY())
	--			end
	--
	--		end
	--	else
	--		previewInv:Hide()
	--	end
	--
	--end

	net.Receive("net_updateInventory", function ()

	local invData = net.ReadString()
	--print("done1!!!!!!!!!!!!!!!!!!!!!", invData)
	if (Inventory.GUI != nil) then
		Inventory.GUI.stringData = invData
		Inventory:updateContents(invData)
		--print("done2", Inventory.GUI.inventoryFrame )
	end

	end)


	Inventory.GUI.inventoryFrame.OnClose = function ()

		Inventory.GUI.backgroundPanel:Hide()
		Inventory.GUI.previewInv:Hide()

	end

	Inventory.GUI.previewInv.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 55, 55, 55, 255 ) )

	end

	Inventory.GUI.inventoryFrame.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 55, 55, 55, 255 ) )

	end

	Inventory.GUI.backgroundPanel.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 155, 155, 155, 150 ) )

	end

	mainPanel.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 155, 155, 155, 255 ) )


	end


end

net.Receive("net_openInventory", function ()

	local invData = net.ReadString()
	local SteamID = net.ReadString()
	Inventory.GUI.stringData = invData
	Inventory:openInventory(Inventory.GUI.stringData, SteamID)

end)


function Inventory:updateContents(data)

	local inventorySpread = constructInventory(data)
	local slots = Inventory.GUI.slots
	local changedSlots = {}

	for i=1,25 do

		changedSlots[i] = false

	end

	for k,v in pairs (inventorySpread) do
		changedSlots[v.pos] = true
		--print("changedSlots", v.pos)
	end


	for k,v in pairs (inventorySpread) do

		for k_slot,v_slot in pairs (slots) do

			if (v.pos == v_slot.pos) and changedSlots[v_slot.pos] then
				v_slot.occupied = v.ID
			end
			if not changedSlots[v_slot.pos] then
				v_slot.Reload(nil)
			end
		end
	end

end

function Inventory:LoadSlots(dataTable,frame,panel)

	local slotsSize = {5,5}
	local count_X = 0
	local count_Y = 0
	local count_POS = 0
	local lastDropped = ""

	for i=1,slotsSize[2] do

		count_Y = count_Y + 1

		for i=1,slotsSize[1] do

			count_X = count_X + 1
			count_POS = count_POS + 1
			local i = vgui.Create( "DButton", panel )
			i:SetText( "" )
			i:SetPos( (72*count_X) - 72 + 15, (72*count_Y) - 64 + 15 )
			i:SetSize( 64, 64 )
			i.BoxColor = Color( 41, 128, 185, 250 )
			i.pos = count_POS
			i.slotX, i.slotY = count_X,count_Y
			i.occupied = nil
			i.isSlot = true
			i.isDown = false
			i.lastDropped = false
			Inventory.GUI.slots[i.pos] = i

			if count_X == 5 then count_X = 0 end

			i.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, i.BoxColor ) -- Draw a blue button
				draw.DrawText( i.pos, "TargetID", 32,0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
				draw.DrawText( i.slotX .." , " .. i.slotY, "TargetID", 32,50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

				Inventory.GUI.previewInv:SetPos(gui.MouseX(),gui.MouseY())

				if i.occupied != nil then
					draw.DrawText( i.occupied, "TargetID", 32,25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
				end
			end
			i.OnMousePressed = function ()
				if !(gui.IsGameUIVisible()) then
					i.isDown = true
					Inventory.GUI.previewInv:Show()
				end
			end
			i.Reload = function (ID)
				i.occupied = ID or nil
			end
		end
	end

	Inventory:updateContents(dataTable,Inventory.GUI.slots)

end

function constructInventory(data)

	local decompInv = string.Split(data, ";")
	local compiledInv = {}

	table.RemoveByValue( decompInv, "" )

	for k,v in pairs(decompInv) do

		compiledInv[k] = {}

		local itemData = string.Split(v, ",")

		local toNumber = itemData[2]

		compiledInv[k].ID = itemData[1]
		compiledInv[k].pos = tonumber(itemData[2])
		//compiledInv[k].y = tonumber(itemData[3])

	end

	return compiledInv

end

//mod.Register(MODULE)
