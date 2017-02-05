mod = {}
local modules = {}

function mod.Register(module)
	modules[module.Name] = module
end

function mod.Loaded(module)
	MsgC( Color( 252, 175, 62 ), "Module Loaded: ".. module.Name .."\n" )
	module:Load()
end

function mod.Get(name)
	return modules[name]
end

------------------------------------------

if SERVER then

	local gamefiles_sv, dir = file.Find( "Acquire/gamemode/modules/sv_*.lua", "LUA" )

	for k, v in pairs(gamefiles_sv) do
	   include("modules/"..v)
	   --print("Including: modules/"..v)
	   --print( file.Exists( "Acquire/gamemode/modules/"..v, "LUA" ) )
	end
	
	for k, v in pairs(modules) do
		mod.Loaded(v)
	end
	
	local gamefiles_cl, dir = file.Find( "Acquire/gamemode/modules/cl_*.lua", "LUA" )
	
	for k, v in pairs(gamefiles_cl) do

	   AddCSLuaFile("modules/"..v)
	end
	
end


if CLIENT then

	local gamefiles_cl, dir = file.Find( "Acquire/gamemode/modules/cl_*.lua", "LUA" )

	for k, v in pairs(gamefiles_cl) do
	   include("modules/"..v)
	end
	
	for k, v in pairs(modules) do
		mod.Loaded(v)
	end

end

