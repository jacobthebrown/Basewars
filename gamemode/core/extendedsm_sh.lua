
AddCSLuaFile()

if ( SERVER ) then

	util.AddNetworkString( "rb655_playsound" )

	concommand.Add( "rb655_playsound_all", function( ply, cmd, args )
		if ( !ply:IsSuperAdmin() or !args[ 1 ] or string.Trim( args[ 1 ] ) == "" ) then return end

		net.Start( "rb655_playsound" )
		net.WriteString( args[ 1 ] or "" )
		net.Broadcast()
	end )

return end

local cl_addTabs = CreateClientConVar( "rb655_create_sm_tabs", "0", true, true )

/*local function removeOldTabls()
	for k, v in pairs( g_SpawnMenu.CreateMenu.Items ) do
		if (v.Tab:GetText() == language.GetPhrase( "spawnmenu.category.npcs" ) or
			v.Tab:GetText() == language.GetPhrase( "spawnmenu.category.entities" ) or
			v.Tab:GetText() == language.GetPhrase( "spawnmenu.category.weapons" ) or
			v.Tab:GetText() == language.GetPhrase( "spawnmenu.category.vehicles" ) or
			v.Tab:GetText() == language.GetPhrase( "spawnmenu.category.postprocess" ) ) then
			g_SpawnMenu.CreateMenu:CloseTab( v.Tab, true )
		end
	end
end

hook.Add( "PopulateContent", "rb655_extended_spawnmenu", function( pnlContent, tree, node )
	removeOldTabls() removeOldTabls() removeOldTabls() -- For some reason it doesn't work with only one call
end )*/

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */

local theSound = nil

function rb655_playsound( snd )

	if ( theSound ) then theSound:Stop() end

	theSound = CreateSound( LocalPlayer(), snd )
	theSound:Play()

end

net.Receive( "rb655_playsound", function( len )
	rb655_playsound( net.ReadString() )
end )

spawnmenu.AddContentType( "sound", function( container, obj )
	if ( !obj.nicename ) then return end
	if ( !obj.spawnname ) then return end

	local icon = vgui.Create( "ContentIcon", container )
	icon:SetContentType( "sound" )
	icon:SetSpawnName( obj.spawnname )
	icon:SetName( obj.nicename )
	icon:SetMaterial( "icon16/sound.png" )

	icon.DoClick = function()
		rb655_playsound( obj.spawnname )
	end

	icon.OpenMenu = function( icon )
		local menu = DermaMenu()
			menu:AddOption( "Copy to clipboard", function() SetClipboardText( obj.spawnname ) end )
			menu:AddOption( "Play on all clients", function() RunConsoleCommand( "rb655_playsound_all", obj.spawnname ) end )
			menu:AddOption( "Stop all sounds", function() RunConsoleCommand( "stopsound" ) end )
			menu:AddSpacer()
			menu:AddOption( "Delete", function() icon:Remove() hook.Run( "SpawnlistContentChanged", icon ) end )
		menu:Open()
	end

	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon

end )

local function OnSndNodeSelected( self, node, name, path, pathid, icon, ViewPanel, pnlContent )

	ViewPanel:Clear( true )

	local Path = node:GetFolder()

	local files = file.Find( Path .. "/*.wav", node:GetPathID() )
	files = table.Add( files, file.Find( Path .. "/*.mp3", node:GetPathID() ) )
	files = table.Add( files, file.Find( Path .. "/*.ogg", node:GetPathID() ) )

	local offset = 0
	local limit = 512
	if ( node.offset ) then offset = node.offset or 0 end

	for k, v in pairs( files ) do
		if ( k > limit + offset ) then
			if ( !node.Done ) then
				offset = offset + limit
				local mats = ( self.Parent or node ):AddNode( ( self.Text or node:GetText() ) .. " (" .. offset .. " - " .. offset + limit .. ")" )
				mats:SetFolder( node:GetFolder() )
				mats.Text = self.Text or node:GetText()
				mats.Parent = self.Parent or node
				mats:SetPathID( node:GetPathID() )
				mats:SetIcon( node:GetIcon() )
				mats.offset = offset
				mats.OnNodeSelected = function( self, node )
					OnSndNodeSelected( self, node, self.Text, node:GetFolder(), node:GetPathID(), node:GetIcon(), ViewPanel, pnlContent )
				end
			end
			node.Done = true
		break end
		if ( k <= offset ) then continue end

		local p = Path .. "/"
		if ( string.StartWith( path, "addons/" ) || string.StartWith( path, "download/" ) ) then
			p = string.sub( p, string.find( p, "/sound/" ) + 1 )
		end

		p = string.sub( p .. v, 7 )

		spawnmenu.CreateContentIcon( "sound", ViewPanel, { spawnname = p, nicename = string.Trim( v ) } )

	end

	pnlContent:SwitchPanel( ViewPanel )

end

local function AddBrowseContentSnd( ViewPanel, node, name, icon, path, pathid, pnlContent )

	if ( !string.EndsWith( path, "/" ) && string.len( path ) > 1 ) then path = path .. "/" end

	local fi, fo = file.Find( path .. "sound", pathid )
	if ( !fo && !fi ) then return end

	local sounds = node:AddFolder( name, path .. "sound", pathid, false, false, "*.*" )
	sounds:SetIcon( icon )

	sounds.OnNodeSelected = function( self, node )
		OnSndNodeSelected( self, node, name, path, pathid, icon, ViewPanel, pnlContent )
	end

end

language.Add( "spawnmenu.category.browsesounds", "Browse Sounds" )

local addon_sounds = {}
local files, folders = file.Find( "addons/*", "GAME" )
for _, addon in SortedPairs( folders ) do

	if ( !file.IsDir( "addons/" .. addon .. "/sound/", "GAME" ) ) then continue end

	table.insert( addon_sounds, addon )

end

hook.Add( "PopulateContent", "SpawnmenuLoadSomeSounds", function( pnlContent, tree, browseNode ) timer.Simple( 0.5, function()

	if ( !IsValid( tree ) || !IsValid( pnlContent ) ) then
		print( "!!! Extended Spawnmenu: FAILED TO INITALIZE PopulateContent HOOK FOR SOUNDS !!!" )
		print( "!!! Extended Spawnmenu: FAILED TO INITALIZE PopulateContent HOOK FOR SOUNDS !!!" )
		print( "!!! Extended Spawnmenu: FAILED TO INITALIZE PopulateContent HOOK FOR SOUNDS !!!" )
		return
	end

	local browseSounds = tree:AddNode( "#spawnmenu.category.browsesounds", "icon16/sound.png" )

	local ViewPanel = vgui.Create( "ContentContainer", pnlContent )
	ViewPanel:SetVisible( false )

	/* --------------------------------------------------------------------------------------- */

	local browseAddonSounds = browseSounds:AddNode( "#spawnmenu.category.addons", "icon16/folder_database.png" )

	for _, addon in SortedPairsByMemberValue( engine.GetAddons(), "title" ) do

		if ( !addon.downloaded ) then continue end
		if ( !addon.mounted ) then continue end
		if ( !table.HasValue( select( 2, file.Find( "*", addon.title ) ), "sound" ) ) then continue end

		AddBrowseContentSnd( ViewPanel, browseAddonSounds, addon.title, "icon16/bricks.png", "", addon.title, pnlContent )
	end

	/* --------------------------------------------------------------------------------------- */

	local browseLegacySounds = browseSounds:AddNode( "#spawnmenu.category.addonslegacy", "icon16/folder_database.png" )

	for _, addon in SortedPairsByValue( addon_sounds ) do

		AddBrowseContentSnd( ViewPanel, browseLegacySounds, addon, "icon16/bricks.png", "addons/" .. addon .. "/", "GAME", pnlContent )

	end

	/* --------------------------------------------------------------------------------------- */

	AddBrowseContentSnd( ViewPanel, browseSounds, "#spawnmenu.category.downloads", "icon16/folder_database.png", "download/", "GAME", pnlContent )

	/* --------------------------------------------------------------------------------------- */

	local browseGameSounds = browseSounds:AddNode( "#spawnmenu.category.games", "icon16/folder_database.png" )

	local games = engine.GetGames()
	table.insert( games, {
		title = "All",
		folder = "GAME",
		icon = "all",
		mounted = true
	} )
	table.insert( games, {
		title = "Garry's Mod",
		folder = "garrysmod",
		mounted = true
	} )

	for _, game in SortedPairsByMemberValue( games, "title" ) do
		if ( !game.mounted ) then continue end
		AddBrowseContentSnd( ViewPanel, browseGameSounds, game.title, "games/16/" .. ( game.icon or game.folder ) .. ".png", "", game.folder, pnlContent )
	end

end ) end )

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */

local function MaterialClick( obj )
	local mat = Material( obj.spawnname )

	if ( !string.GetExtensionFromFilename( obj.spawnname )
	&& !string.find( mat:GetShader(), "LightmappedGeneric" )
	&& !string.find( mat:GetShader(), "WorldVertexTransition" )
	&& !string.find( mat:GetShader(), "Spritecard" )
	&& !string.find( mat:GetShader(), "Water" )
	//&& !string.find( mat:GetShader(), "UnlitGeneric" )
	&& !string.find( mat:GetShader(), "Refract" ) ) then
		return true
	end

	return false
end

spawnmenu.AddContentType( "material", function( container, obj )
	if ( !obj.nicename ) then return end
	if ( !obj.spawnname ) then return end

	local icon = vgui.Create( "ContentIcon", container )
	icon:SetContentType( "material" )
	icon:SetSpawnName( obj.spawnname )
	icon:SetName( obj.nicename )
	if ( string.GetExtensionFromFilename( obj.spawnname ) == "png" ) then
		icon:SetMaterial( obj.spawnname )
	else
		icon.Image:SetImage( obj.spawnname )
	end

	icon.DoClick = function()
		if ( MaterialClick( obj ) ) then
			RunConsoleCommand( "material_override", obj.spawnname )
			spawnmenu.ActivateTool( "material" )
			surface.PlaySound( "garrysmod/ui_click.wav" )
		end
	end

	icon.OpenMenu = function( icon )
		local menu = DermaMenu()
			menu:AddOption( "Copy to Clipboard", function() SetClipboardText( obj.spawnname ) end )

			if ( MaterialClick( obj ) ) then
				menu:AddOption( "Use with Material Tool", function()
					RunConsoleCommand( "material_override", obj.spawnname )
					spawnmenu.ActivateTool( "material" )
				end )
			end

			menu:AddSpacer()
			menu:AddOption( "Delete", function() icon:Remove() hook.Run( "SpawnlistContentChanged", icon ) end )
		menu:Open()
	end

	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon

end )

local function OnMatNodeSelected( self, node, name, path, pathid, icon, ViewPanel, pnlContent )

	ViewPanel:Clear( true )

	local Path = node:GetFolder()

	local files = file.Find( Path .. "/*.vmt", node:GetPathID() )
	files = table.Add( files, file.Find( Path .. "/*.png", node:GetPathID() ) )

	local offset = 0
	local limit = 512
	if ( node.offset ) then offset = node.offset or 0 end

	for k, v in pairs( files ) do
		if ( k > limit + offset ) then
			if ( !node.Done ) then
				offset = offset + limit
				local mats = ( self.Parent or node ):AddNode( ( self.Text or node:GetText() ) .. " (" .. offset .. " - " .. offset + limit .. ")" )
				mats:SetFolder( node:GetFolder() )
				mats.Text = self.Text or node:GetText()
				mats.Parent = self.Parent or node
				mats:SetPathID( node:GetPathID() )
				mats:SetIcon( node:GetIcon() )
				mats.offset = offset
				mats.OnNodeSelected = function( self, node )
					OnMatNodeSelected( self, node, self.Text, node:GetFolder(), node:GetPathID(), node:GetIcon(), ViewPanel, pnlContent )
				end
			end
			node.Done = true
		break end
		if ( k <= offset ) then continue end

		local p = Path .. "/"
		if ( string.StartWith( path, "addons/" ) || string.StartWith( path, "download/" ) ) then
			p = string.sub( p, string.find( p, "/materials/" ) + 1 )
		end

		p = string.sub( p .. v, 11 )

		if ( string.GetExtensionFromFilename( p ) == "vmt" ) then
			p = string.StripExtension( p )
			v = string.StripExtension( v )
		end

		if ( Material( p ):GetShader() == "Spritecard" ) then continue end

		spawnmenu.CreateContentIcon( "material", ViewPanel, { spawnname = p, nicename = v } )
	end

	pnlContent:SwitchPanel( ViewPanel )

end

local function AddBrowseContentMaterial( ViewPanel, node, name, icon, path, pathid, pnlContent )

	if ( !string.EndsWith( path, "/" ) && string.len( path ) > 1 ) then path = path .. "/" end

	local fi, fo = file.Find( path .. "materials", pathid )
	if ( !fi && !fo ) then return end

	local materials = node:AddFolder( name, path .. "materials", pathid, false, false, "*.*" )
	materials:SetIcon( icon )

	materials.OnNodeSelected = function( self, node )
		OnMatNodeSelected( self, node, name, path, pathid, icon, ViewPanel, pnlContent )
	end

end

language.Add( "spawnmenu.category.browsematerials", "Browse Materials" )

local addon_mats = {}
local files, folders = file.Find( "addons/*", "GAME" )
for _, addon in SortedPairs( folders ) do

	if ( !file.IsDir( "addons/" .. addon .. "/materials/", "GAME" ) ) then continue end

	table.insert( addon_mats, addon )

end

hook.Add( "PopulateContent", "SpawnmenuLoadSomeMaterials", function( pnlContent, tree, browseNode ) timer.Simple( 0.5, function()

	if ( !IsValid( tree ) || !IsValid( pnlContent ) ) then
		print( "!!! Extended Spawnmenu: FAILED TO INITALIZE PopulateContent HOOK FOR MATERIALS!!!" )
		print( "!!! Extended Spawnmenu: FAILED TO INITALIZE PopulateContent HOOK FOR MATERIALS!!!" )
		print( "!!! Extended Spawnmenu: FAILED TO INITALIZE PopulateContent HOOK FOR MATERIALS!!!" )
		return
	end

	local browseMaterials = tree:AddNode( "#spawnmenu.category.browsematerials", "icon16/picture_empty.png" )

	local ViewPanel = vgui.Create( "ContentContainer", pnlContent )
	ViewPanel:SetVisible( false )

	/* --------------------------------------------------------------------------------------- */

	local browseAddonMaterials = browseMaterials:AddNode( "#spawnmenu.category.addons", "icon16/folder_database.png" )

	for _, addon in SortedPairsByMemberValue( engine.GetAddons(), "title" ) do

		if ( !addon.downloaded ) then continue end
		if ( !addon.mounted ) then continue end
		if ( !table.HasValue( select( 2, file.Find( "*", addon.title ) ), "materials" ) ) then continue end

		AddBrowseContentMaterial( ViewPanel, browseAddonMaterials, addon.title, "icon16/bricks.png", "", addon.title, pnlContent )

	end

	/* --------------------------------------------------------------------------------------- */

	local browseLegacyMaterials = browseMaterials:AddNode( "#spawnmenu.category.addonslegacy", "icon16/folder_database.png" )

	for _, addon in SortedPairsByValue( addon_mats ) do

		AddBrowseContentMaterial( ViewPanel, browseLegacyMaterials, addon, "icon16/bricks.png", "addons/" .. addon .. "/", "GAME", pnlContent )

	end

	/* --------------------------------------------------------------------------------------- */

	AddBrowseContentMaterial( ViewPanel, browseMaterials, "#spawnmenu.category.downloads", "icon16/folder_database.png", "download/", "GAME", pnlContent )

	/* --------------------------------------------------------------------------------------- */

	local browseGameMaterials = browseMaterials:AddNode( "#spawnmenu.category.games", "icon16/folder_database.png" )

	local games = engine.GetGames()
	table.insert( games, {
		title = "All",
		folder = "GAME",
		icon = "all",
		mounted = true
	} )
	table.insert( games, {
		title = "Garry's Mod",
		folder = "garrysmod",
		mounted = true
	} )

	for _, game in SortedPairsByMemberValue( games, "title" ) do
		if ( !game.mounted ) then continue end
		AddBrowseContentMaterial( ViewPanel, browseGameMaterials, game.title, "games/16/" .. ( game.icon or game.folder ) .. ".png", "", game.folder, pnlContent )
	end

end ) end )

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */

hook.Add( "PopulateContent", "rb655_extended_spawnmenu_entities", function( pnlContent, tree, node )
	if ( !cl_addTabs:GetBool() ) then return end

	local node_w = tree:AddNode( "#spawnmenu.category.entities", "icon16/bricks.png" )

	node_w.PropPanel = vgui.Create( "ContentContainer", pnlContent )
	node_w.PropPanel:SetVisible( false )

	function node_w:DoClick()
		pnlContent:SwitchPanel( self.PropPanel )
	end

	local Categorised = {}

	local SpawnableEntities = list.Get( "SpawnableEntities" )
	if ( SpawnableEntities ) then
		for k, v in pairs( SpawnableEntities ) do
			v.Category = v.Category or "Other"
			Categorised[ v.Category ] = Categorised[ v.Category ] or {}
			table.insert( Categorised[ v.Category ], v )
		end
	end

	for CategoryName, v in SortedPairs( Categorised ) do

		local node = node_w:AddNode( CategoryName, "icon16/bricks.png" )

		local CatPropPanel = vgui.Create( "ContentContainer", pnlContent )
		CatPropPanel:SetVisible( false )

		local Header = vgui.Create("ContentHeader", node_w.PropPanel )
		Header:SetText( CategoryName )
		node_w.PropPanel:Add( Header )

		for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
			local t = {
				nicename	= ent.PrintName or ent.ClassName,
				spawnname	= ent.ClassName,
				material	= "entities/" .. ent.ClassName .. ".png",
				admin		= ent.AdminOnly
			}
			spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", CatPropPanel, t )
			spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", node_w.PropPanel, t )
		end

		function node:DoClick()
			pnlContent:SwitchPanel( CatPropPanel )
		end

	end
end )

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */

hook.Add( "PopulateContent", "rb655_extended_spawnmenu_post_processing", function( pnlContent, tree, node )
	if ( !cl_addTabs:GetBool() ) then return end

	local node_w = tree:AddNode( "#spawnmenu.category.postprocess", "icon16/picture.png" )

	node_w.PropPanel = vgui.Create( "ContentContainer", pnlContent )
	node_w.PropPanel:SetVisible( false )

	function node_w:DoClick()
		pnlContent:SwitchPanel( self.PropPanel )
	end

	// Get the table

	local Categorised = {}
	local PostProcess = list.Get( "PostProcess" )

	if ( PostProcess ) then
		for k, v in pairs( PostProcess ) do
			v.category = v.category or "Other"
			v.name = k
			Categorised[ v.category ] = Categorised[ v.category ] or {}
			table.insert( Categorised[ v.category ], v )
		end
	end

	// Put table into panels

	for CategoryName, v in SortedPairs( Categorised ) do

		local node = node_w:AddNode( CategoryName, "icon16/picture.png" )

		local CatPropPanel = vgui.Create( "ContentContainer", pnlContent )
		CatPropPanel:SetVisible( false )

		local Header = vgui.Create( "ContentHeader", node_w.PropPanel )
		Header:SetText( CategoryName )
		node_w.PropPanel:Add( Header )

		for k, pp in SortedPairsByMemberValue( v, "PrintName" ) do
			if ( pp.func ) then pp.func( CatPropPanel ) pp.func( node_w.PropPanel ) continue end

			local t = {
				name = pp.name,
				icon = pp.icon
			}

			spawnmenu.CreateContentIcon( "postprocess", CatPropPanel, t )
			spawnmenu.CreateContentIcon( "postprocess", node_w.PropPanel, t )
		end

		function node:DoClick()
			pnlContent:SwitchPanel( CatPropPanel )
		end
	end

end )

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */

hook.Add( "PopulateContent", "rb655_extended_spawnmenu_npcs", function( pnlContent, tree, node )
	if ( !cl_addTabs:GetBool() ) then return end

	local node_w = tree:AddNode( "#spawnmenu.category.npcs", "icon16/monkey.png" )

	node_w.PropPanel = vgui.Create( "ContentContainer", pnlContent )
	node_w.PropPanel:SetVisible( false )

	function node_w:DoClick()
		pnlContent:SwitchPanel( self.PropPanel )
	end

	local NPCList = list.Get( "NPC" )
	local Categories = {}

	for k, v in pairs( NPCList ) do
		local Category = v.Category or "Other"
		local Tab = Categories[ Category ] or {}

		Tab[ k ] = v

		Categories[ Category ] = Tab
	end

	for CategoryName, v in SortedPairs( Categories ) do

		local node = node_w:AddNode( CategoryName, "icon16/monkey.png" )

		local CatPropPanel = vgui.Create( "ContentContainer", pnlContent )
		CatPropPanel:SetVisible( false )

		local Header = vgui.Create("ContentHeader", node_w.PropPanel )
		Header:SetText( CategoryName )
		node_w.PropPanel:Add( Header )

		for name, ent in SortedPairsByMemberValue( v, "Name" ) do
			local t = {
				nicename	= ent.Name or name,
				spawnname	= name,
				material	= "entities/" .. name .. ".png",
				weapon		= ent.Weapons,
				admin		= ent.AdminOnly
			}
			spawnmenu.CreateContentIcon( "npc", CatPropPanel, t )
			spawnmenu.CreateContentIcon( "npc", node_w.PropPanel, t )
		end

		function node:DoClick()
			pnlContent:SwitchPanel( CatPropPanel )
		end

	end
end )

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */

hook.Add( "PopulateContent", "rb655_extended_spawnmenu_vehicles", function( pnlContent, tree, node )
	if ( !cl_addTabs:GetBool() ) then return end

	local node_w = tree:AddNode( "#spawnmenu.category.vehicles", "icon16/car.png" )

	node_w.PropPanel = vgui.Create( "ContentContainer", pnlContent )
	node_w.PropPanel:SetVisible( false )

	function node_w:DoClick()
		pnlContent:SwitchPanel( self.PropPanel )
	end

	local Categorised = {}
	local Vehicles = list.Get( "Vehicles" )
	if ( Vehicles ) then
		for k, v in pairs( Vehicles ) do
			v.Category = v.Category or "Other"
			Categorised[ v.Category ] = Categorised[ v.Category ] or {}
			v.ClassName = k
			v.PrintName = v.Name
			v.ScriptedEntityType = "vehicle"
			table.insert( Categorised[ v.Category ], v )
		end
	end

	for CategoryName, v in SortedPairs( Categorised ) do

		local node = node_w:AddNode( CategoryName, "icon16/car.png" )

		local CatPropPanel = vgui.Create( "ContentContainer", pnlContent )
		CatPropPanel:SetVisible( false )

		local Header = vgui.Create("ContentHeader", node_w.PropPanel )
		Header:SetText( CategoryName )
		node_w.PropPanel:Add( Header )

		for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
			local t = {
				nicename	= ent.PrintName or ent.ClassName,
				spawnname	= ent.ClassName,
				material	= "entities/" .. ent.ClassName .. ".png",
				admin		= ent.AdminOnly
			}
			spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", node_w.PropPanel, t )
			spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", CatPropPanel, t )
		end

		function node:DoClick()
			pnlContent:SwitchPanel( CatPropPanel )
		end

	end

end )

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */

hook.Add( "PopulateContent", "rb655_extended_spawnmenu_weapons", function( pnlContent, tree, node )
	if ( !cl_addTabs:GetBool() ) then return end

	local node_w = tree:AddNode( "#spawnmenu.category.weapons", "icon16/gun.png" )

	node_w.PropPanel = vgui.Create( "ContentContainer", pnlContent )
	node_w.PropPanel:SetVisible( false )

	function node_w:DoClick()
		pnlContent:SwitchPanel( self.PropPanel )
	end

	local Weapons = list.Get( "Weapon" )
	local Categorised = {}

	for k, weapon in pairs( Weapons ) do
		if ( !weapon.Spawnable && !weapon.AdminSpawnable ) then continue end

		Categorised[ weapon.Category ] = Categorised[ weapon.Category ] or {}
		table.insert( Categorised[ weapon.Category ], weapon )
	end

	for CategoryName, v in SortedPairs( Categorised ) do
		local node = node_w:AddNode( CategoryName, "icon16/gun.png" )

		local CatPropPanel = vgui.Create( "ContentContainer", pnlContent )
		CatPropPanel:SetVisible( false )

		local Header = vgui.Create("ContentHeader", node_w.PropPanel )
		Header:SetText( CategoryName )
		node_w.PropPanel:Add( Header )

		for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
			local t = {
				nicename	= ent.PrintName or ent.ClassName,
				spawnname	= ent.ClassName,
				material	= "entities/" .. ent.ClassName .. ".png",
				admin		= ent.AdminOnly
			}
			spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "weapon", CatPropPanel, t )
			spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "weapon", node_w.PropPanel, t )
		end

		function node:DoClick()
			pnlContent:SwitchPanel( CatPropPanel )
		end

	end

end )


AddCSLuaFile()

if ( SERVER ) then return end

language.Add( "spawnmenu.category.addonslegacy_c", "Addons - Legacy ( Info Inside )" )
language.Add( "spawnmenu.category.addonslegacy", "Addons - Legacy" )
language.Add( "spawnmenu.category.downloads", "Downloads" )

local function AddRecursive( pnl, folder )
	local files, folders = file.Find( folder .. "*", "GAME" )

	for k, v in pairs( files or {} ) do
		if ( !string.EndsWith( v, ".mdl" ) ) then continue end

		local cp = spawnmenu.GetContentType( "model" )
		if ( cp ) then
			local mdl = folder .. v
			mdl = string.sub( mdl, string.find( mdl, "models/" ), string.len( mdl ) )
			mdl = string.gsub( mdl, "models/models/", "models/" )
			cp( pnl, { model = mdl } )
		end
	end

	for k, v in pairs( folders or {} ) do AddRecursive( pnl, folder .. v .. "/" ) end
end

local function CountRecursive( folder )
	local files, folders = file.Find( folder .. "*", "GAME" )
	local val = 0

	for k, v in pairs( files or {} ) do if ( string.EndsWith( v, ".mdl" ) ) then val = val + 1 end end
	for k, v in pairs( folders or {} ) do val = val + CountRecursive( folder .. v .. "/" ) end
	return val
end

// Calculate this as soon as we start, so the spawnmenu loading times are better.
local files, folders = file.Find( "addons/*", "GAME" )
local addons = {}
for _, f in pairs( folders ) do

	if ( !file.IsDir( "addons/" .. f .. "/models/", "GAME" ) ) then continue end

	local count = CountRecursive( "addons/" .. f .. "/models/", "GAME" )
	if ( count == 0 ) then continue end

	table.insert( addons, {
		name = f,
		count = count,
		path = "addons/" .. f .. "/models/"
	} )

end

hook.Add( "PopulateContent", "LegacyAddonProps", function( pnlContent, tree, node )

	if ( !IsValid( node ) || !IsValid( pnlContent ) ) then
		print( "!!! Extended Spawnmenu: FAILED TO INITALIZE PopulateContent HOOK FOR LEGACY ADDONS!!!" )
		print( "!!! Extended Spawnmenu: FAILED TO INITALIZE PopulateContent HOOK FOR LEGACY ADDONS!!!" )
		print( "!!! Extended Spawnmenu: FAILED TO INITALIZE PopulateContent HOOK FOR LEGACY ADDONS!!!" )
		return
	end

	local ViewPanel = vgui.Create( "ContentContainer", pnlContent )
	ViewPanel:SetVisible( false )

	local LegacyAddons = node:AddNode( "#spawnmenu.category.addonslegacy_c", "icon16/folder_database.png" )
	LegacyAddons.DoClick = function()

		ViewPanel:Clear( true )

		local it = vgui.Create( "rb655_addonInfo" )
		ViewPanel:Add( it )
		
		it.m_DragSlot = nil -- Don't allow to drag!

		pnlContent:SwitchPanel( ViewPanel )

	end

	for _, f in SortedPairsByMemberValue( addons, "name" ) do

		local models = LegacyAddons:AddNode( f.name .. " (" .. f.count .. ")", "icon16/bricks.png" )
		models.DoClick = function()

			ViewPanel:Clear( true )
			AddRecursive( ViewPanel, f.path )
			pnlContent:SwitchPanel( ViewPanel )

		end

	end
	
	/* -------------------------- DOWNLOADS -------------------------- */

	local fi, fo = file.Find( "download/models", "GAME" )
	if ( !fi && !fo ) then return end

	local Downloads = node:AddFolder( "#spawnmenu.category.downloads", "download/models", "GAME", false, false, "*.*" )
	Downloads:SetIcon( "icon16/folder_database.png" )

	Downloads.OnNodeSelected = function( self, node )
		ViewPanel:Clear( true )

		local path = node:GetFolder()
	
		if ( !string.EndsWith( path, "/" ) && string.len( path ) > 1 ) then path = path .. "/" end
		local path_mdl = string.sub( path, string.find( path, "/models/" ) + 1 )

		for k, v in pairs( file.Find( path .. "/*.mdl", node:GetPathID() ) ) do
			
			local cp = spawnmenu.GetContentType( "model" )
			if ( cp ) then
				cp( ViewPanel, { model = path_mdl .. "/" .. v } )
			end
		
		end
		
		pnlContent:SwitchPanel( ViewPanel )
	end

end )

/* -------------------------------------------------------------------------- The addon info -------------------------------------------------------------------------- */

surface.CreateFont( "AddonInfo_Header", {
	font	= "Helvetica",
	size	= ScreenScale( 24 ),
	weight	= 1000
} )

surface.CreateFont( "AddonInfo_Text", {
	font	= "Helvetica",
	size 	= ScreenScale( 9 ),
	weight	= 1000
} )

surface.CreateFont( "AddonInfo_Small", {
	font	= "Helvetica",
	size 	= ScreenScale( 8 )
} )

local function GetWorkshopLeftovers()

	local subscriptions = {}

	for id, t in pairs( engine.GetAddons() ) do
		subscriptions[ tonumber( t.wsid ) ] = true
	end

	local t = {}
	for id, fileh in pairs( file.Find( "addons/*.gma", "GAME" ) ) do
		local a = string.StripExtension( fileh )
		a = string.Explode( "_", a )
		a = tonumber( a[ #a ] )
		if ( !subscriptions[ a ] ) then
			table.insert( t, fileh )
		end
	end
	
	return t

end

local function GetSize( b )
	b = math.floor( b / 1024 )

	if ( b < 1024 ) then
		return b .. " KB"
	end
	
	b = math.floor( b / 1024 )
	
	if ( b < 1024 ) then
		return b .. " MB"
	end

	b = math.floor( b / 1024 )
	
	return b .. " GB"
end

local function DrawText( txt, font, x, y, clr )
	draw.SimpleText( txt, font, x, y, clr )

	surface.SetFont( font )
	return surface.GetTextSize( txt )
end

local PANEL = {}

function PANEL:Init()
	self.But = vgui.Create( "DButton", self )
	self.But:SetText( "Show me my addon stats!" )
	self.But.DoClick = function()
		self:Compute()
		self.But:Remove()
	end
	self.Computed = false
end

function PANEL:Compute()

	self.WorkshopSize = 0
	for id, fle in pairs( file.Find( "addons/*.gma", "GAME" ) ) do
		self.WorkshopSize = self.WorkshopSize + ( file.Size( "addons/" .. fle, "GAME" ) or 0 )
	end
	
	self.WorkshopWaste = 0
	self.WorkshopWasteFiles = {}
	for id, fle in pairs( GetWorkshopLeftovers() ) do
		self.WorkshopWaste = self.WorkshopWaste + ( file.Size( "addons/" .. fle, "GAME" ) or 0 )
		table.insert( self.WorkshopWasteFiles, { "addons/" .. fle, ( file.Size( "addons/" .. fle, "GAME" ) or 0 ) } )
	end

	// -------------------------------------------

	local files, folders = file.Find( "addons/*", "MOD" )
	
	self.LegacyWithModels = {}
	for k, v in pairs( folders or {} ) do
		if ( file.IsDir( "addons/" .. v .. "/models/", "MOD" ) ) then
			table.insert( self.LegacyWithModels, "addons/" .. v .. "/" )
		end
	end
	
	self.LegacyEmpty = {}
	for k, v in pairs( folders or {} ) do
		local a, b = file.Find( "addons/" .. v .. "/*", "MOD" )
		if ( table.Count( b or {} ) < 1 ) then
			table.insert( self.LegacyEmpty, "addons/" .. v .. "/" )
		end
	end

	self.LegacyIncorrect = {}
	for k, v in pairs( folders or {} ) do
		if ( !file.IsDir( "addons/" .. v .. "/models/", "MOD" ) && !file.IsDir(  "addons/" .. v .. "/materials/", "MOD" ) && !file.IsDir(  "addons/" .. v .. "/lua/", "MOD" ) && !file.IsDir(  "addons/" .. v .. "/sound/", "MOD" ) ) then
			table.insert( self.LegacyIncorrect, "addons/" .. v .. "/" )
		end
	end
	
	// -------------------------------------------
	
	local files = file.Find( "cache/*", "MOD" )
	self.CacheSize = 0
	for k, v in pairs( files or {} ) do
		self.CacheSize = self.CacheSize + ( file.Size( "cache/" .. v, "MOD" ) or 0 )
	end

	local files = file.Find( "cache/lua/*", "MOD" )  -- Too many files to count actual size!
	self.LuaCacheSize = #files * 1400
	self.LuaCacheFiles = #files

	local files = file.Find( "cache/workshop/*", "MOD" )  -- Too many files to count actual size!
	self.WSCacheSize = #files * 110000
	self.WSCacheFiles = #files
	
	local files = file.Find( "downloads/server/*", "MOD" )
	self.WorkshopServerSize = 0
	for k, v in pairs( files or {} ) do
		self.WorkshopServerSize = self.WorkshopServerSize + ( file.Size( "downloads/server/" .. v, "MOD" ) or 0 )
	end
	
	self.Computed = true

end

function PANEL:Paint( w, h )
	
	if ( !self.Computed ) then
		self:SetSize( self:GetParent():GetWide(), 50 )
		self.But:SetSize( self:GetParent():GetWide(), 20 )
		
		draw.SimpleText( "WARNING: This WILL freeze your Game/PC if you have a lot of addons.", "AddonInfo_Text", self:GetParent():GetWide() / 2, 32, color_white, 1, 1 )
		
		return
	end
	
	local txtW = self:GetParent():GetWide()
	local txtH = 0

	local tW, tH = DrawText( "Workshop Addons", "AddonInfo_Header", 0, txtH, color_white )
	txtH = txtH + tH

	// -------------------------------------------
	
	local tW, tH = DrawText( "Used Size:  ", "AddonInfo_Text", 0, txtH, color_white )
	local maxW = tW
	txtH = txtH + tH

	local tW, tH = DrawText( "Wasted Space:  ", "AddonInfo_Text", 0, txtH, color_white )
	maxW = math.max( maxW, tW )
	txtH = txtH + tH

	local tW, tH = DrawText( "Total Size:  ", "AddonInfo_Text", 0, txtH, color_white )
	maxW = math.max( maxW, tW )
	txtH = txtH - tH * 2
	
	// -------------------------------------------
	
	local tW, tH = DrawText( GetSize( ( self.WorkshopSize - self.WorkshopWaste ) or 0 ), "AddonInfo_Text", maxW, txtH, Color( 220, 220, 220 ) )
	txtH = txtH + tH

	local tW, tH = DrawText( GetSize( self.WorkshopWaste or 0 ), "AddonInfo_Text", maxW, txtH, Color( 220, 220, 220 ) )
	txtH = txtH + tH

	local tW, tH = DrawText( GetSize( self.WorkshopSize or 0 ), "AddonInfo_Text", maxW, txtH, Color( 220, 220, 220 ) )
	txtH = txtH + tH * 2
	
	// -------------------------------------------
	
	local tW, tH = DrawText( "Files that aren't used: ( Safe to delete )", "AddonInfo_Text", 0, txtH, color_white )
	txtH = txtH + tH
	
	local localH = 0
	local localW = 0
	for id, t in pairs( self.WorkshopWasteFiles or {} ) do
		local tW, tH = DrawText( GetSize( t[ 2 ] ) .. "    ", "AddonInfo_Small", 0, txtH + localH, Color( 220, 220, 220 ) )
		localH = localH + tH
		localW = math.max( localW, tW )
	end

	for id, t in pairs( self.WorkshopWasteFiles or {} ) do
		local tW, tH = DrawText( t[ 1 ], "AddonInfo_Small", localW, txtH, color_white )
		txtH = txtH + tH
	end

	// -------------------------------------------
	
	local tW, tH = DrawText( "Legacy Addons", "AddonInfo_Header", 0, txtH + ScreenScale( 8 ), color_white )
	txtH = txtH + tH + ScreenScale( 8 )

	// -------------------------------------------
	
	local tW, tH = DrawText( "Legacy Addons with models:", "AddonInfo_Text", 0, txtH, color_white )
	txtH = txtH + tH
	
	if ( table.Count( self.LegacyWithModels or {} ) > 0 ) then
		for id, name in pairs( self.LegacyWithModels or {} ) do
			local tW, tH = DrawText( name, "AddonInfo_Small", 0, txtH, color_white )
			txtH = txtH + tH
		end
	else
		local tW, tH = DrawText( "None.", "AddonInfo_Small", 0, txtH, color_white )
		txtH = txtH + tH
	end
	
	if ( !system.IsWindows() ) then
		txtH = txtH + tH
		
		local tW, tH = DrawText( "OSX AND LINUX USERS BEWARE:", "AddonInfo_Text", 0, txtH, color_white )
		txtH = txtH + tH
		local tW, tH = DrawText( "MAKE SURE ALL FILE AND FOLDER NAMES", "AddonInfo_Text", 0, txtH, color_white )
		txtH = txtH + tH
		local tW, tH = DrawText( "IN ALL ADDONS ARE LOWERCASE ONLY", "AddonInfo_Text", 0, txtH, color_white )
		txtH = txtH + tH
		local tW, tH = DrawText( "INCLUDING ALL SUB FOLDERS", "AddonInfo_Text", 0, txtH, color_white )
		txtH = txtH + tH
	end
	
	txtH = txtH + tH

	// -------------------------------------------
	
	local tW, tH = DrawText( "Empty Legacy Addons: ( Safe to delete )", "AddonInfo_Text", 0, txtH, color_white )
	txtH = txtH + tH
	
	if ( table.Count( self.LegacyEmpty or {} ) > 0 ) then
		for id, name in pairs( self.LegacyEmpty or {} ) do
			local tW, tH = DrawText( name, "AddonInfo_Small", 0, txtH, color_white )
			txtH = txtH + tH
		end
	else
		local tW, tH = DrawText( "None.", "AddonInfo_Small", 0, txtH, color_white )
		txtH = txtH + tH
	end
	
	txtH = txtH + tH
	
	// -------------------------------------------
	
	local tW, tH = DrawText( "Incorrectly installed Legacy Addons:", "AddonInfo_Text", 0, txtH, color_white )
	txtH = txtH + tH
	
	if ( table.Count( self.LegacyIncorrect or {} ) > 0 ) then
		for id, name in pairs( self.LegacyIncorrect or {} ) do
			local tW, tH = DrawText( name, "AddonInfo_Small", 0, txtH, color_white )
			txtH = txtH + tH
		end
	else
		local tW, tH = DrawText( "None.", "AddonInfo_Small", 0, txtH, color_white )
		txtH = txtH + tH
	end
	
	// -------------------------------------------
	
	local tW, tH = DrawText( "Cache Sizes", "AddonInfo_Header", 0, txtH + ScreenScale( 8 ), color_white )
	txtH = txtH + tH + ScreenScale( 8 )
	
	local localH = 0
	local localW = 0
	
	// -----------------------
	
	local tW, tH = DrawText( GetSize( self.CacheSize or 0 ) .. "    ", "AddonInfo_Small", 0, txtH + localH, Color( 220, 220, 220 ) )
	localH = localH + tH
	localW = math.max( localW, tW )
	
	local tW, tH = DrawText( "~" .. GetSize( self.LuaCacheSize or 0 ) .. "    ", "AddonInfo_Small", 0, txtH + localH, Color( 220, 220, 220 ) )
	localH = localH + tH
	localW = math.max( localW, tW )
	
	local tW, tH = DrawText( "~" .. GetSize( self.WSCacheSize or 0 ) .. "    ", "AddonInfo_Small", 0, txtH + localH, Color( 220, 220, 220 ) )
	localH = localH + tH
	localW = math.max( localW, tW )

	local tW, tH = DrawText( GetSize( self.WorkshopServerSize or 0 ) .. "    ", "AddonInfo_Small", 0, txtH + localH, Color( 220, 220, 220 ) )
	localH = localH + tH
	localW = math.max( localW, tW )

	// -----------------------
	
	local tW, tH = DrawText( "Download cache", "AddonInfo_Small", localW, txtH, color_white )
	txtH = txtH + tH
	
	local tW, tH = DrawText( "Lua cache", "AddonInfo_Small", localW, txtH, color_white )
	txtH = txtH + tH

	local tW, tH = DrawText( "Workshop cache", "AddonInfo_Small", localW, txtH, color_white )
	txtH = txtH + tH

	local tW, tH = DrawText( "Workshop Addons from servers", "AddonInfo_Small", localW, txtH, color_white )
	txtH = txtH + tH

	// -------------------------------------------

	self:SetSize( txtW, txtH )
end

vgui.Register( "rb655_addonInfo", PANEL, "Panel" )

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */

-- I spent too much time on this than I care to admit

hook.Add( "PopulatePropMenu", "rb655_LoadLegacySpawnlists", function()

	local sid = 0//table.Count( spawnmenu.GetPropTable() )

	local added = false

	for id, spawnlist in pairs( file.Find( "settings/spawnlist/*.txt", "MOD" ) ) do
		local content = file.Read( "settings/spawnlist/" .. spawnlist, "MOD" )
		if ( !content ) then continue end

		/*local is = string.find( content, "TableToKeyValues" )
		if ( is != nil ) then continue end
		
		for id, t in pairs( spawnmenu.GetPropTable() ) do -- This somehow freezes the game when opening Q menu => FUCK THIS SHIT
			if ( t.name == "Legacy Spawnlists" ) then
				added = true
				sid = t.id
			end
		end
		
		if ( !added ) then	
			spawnmenu.AddPropCategory( "rb655_legacy_spawnlists", "Legacy Spawnlists", {}, "icon16/folder.png", sid, 0 )
			added = true
		end*/
		
		content = util.KeyValuesToTable( content )

		if ( !content.entries or content.contents ) then continue end
		
		local contents = {}
			
		for id, ply in pairs( content.entries ) do
			if ( type( ply ) == "table" ) then ply = ply.model end 
			table.insert( contents, { type = "model", model = ply } )
		end
		
		if ( !content.information ) then content.information = { name = spawnlist } end

		spawnmenu.AddPropCategory( "settings/spawnlist/" .. spawnlist, content.information.name, contents, "icon16/page.png", sid + id, sid )

	end

end )

if (CLIENT) then
   
   print("yep")
    
end
