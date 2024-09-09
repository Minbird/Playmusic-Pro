print("[Playmusic Pro] System startup...")
print("///////////////////////////")
print("// Playmusic Pro StartUp //")
print("// by Minbirdragon       //")
print("///////////////////////////")

PlayMP = {}


print("[Playmusic Pro] Start Init...")

PlayMP.info = {}
PlayMP.info.version = "1.0"
PlayMP.info.version_str = "3.0.0"
PlayMP.info.newer_version = "0.0"
PlayMP.info.newer_version_str = "Unknown"
PlayMP.info.is_beta = false

PlayMP.system = {}
PlayMP.system.lang = {}
PlayMP.system.lang.cur_lang = "en"


print("[PlayM Pro] Loading Language Files...")
local folder = "playmusic_pro/pm_lang/"
local files = file.Find( folder .. "/" .. "*.lua", "LUA" )
for _, file in ipairs( files ) do
	print("[PlayM Pro] Try add Client side Language File: " .. file)
	AddCSLuaFile( folder .. "/" .. file )
end

print("[PlayM Pro] Loading Options Files...")
local folder = "playmusic_pro/pm_options/"
local files = file.Find( folder .. "/" .. "*.lua", "LUA" )
for _, file in ipairs( files ) do
	print("[PlayM Pro] Try add Client side Options File: " .. file)
	AddCSLuaFile( folder .. "/" .. file )
end

include("playmusic_pro/share.lua")
include("playmusic_pro/shared.lua")

-- server
if SERVER then
	AddCSLuaFile("playmusic_pro/client/cl_init.lua")
	AddCSLuaFile("playmusic_pro/client/cl_network.lua")
	AddCSLuaFile("playmusic_pro/client/player.lua")
	AddCSLuaFile("playmusic_pro/logger.lua")
	AddCSLuaFile("playmusic_pro/setting.lua")
	AddCSLuaFile("playmusic_pro/share.lua")
	AddCSLuaFile("playmusic_pro/shared.lua")
	AddCSLuaFile("playmusic_pro/vars.lua")
	AddCSLuaFile("playmusic_pro/client/convars.lua")
	AddCSLuaFile("playmusic_pro/client/font.lua")
	AddCSLuaFile("playmusic_pro/client/cl_polys.lua")
	AddCSLuaFile("playmusic_pro/client/cl_record.lua")
	AddCSLuaFile("playmusic_pro/client/cl_vote.lua")
	AddCSLuaFile("playmusic_pro/client/cl_mainmenu.lua")
	AddCSLuaFile("playmusic_pro/client/cl_option.lua")
	AddCSLuaFile("playmusic_pro/client/user.lua")
	AddCSLuaFile("playmusic_pro/client/old_cl_init.lua")
	AddCSLuaFile("playmusic_pro/client/ui.lua")

	print("[PlayM Pro] Server side system is loading...")
	print("[PlayM Pro] Init...")
	include("playmusic_pro/server/init.lua")
	print("[PlayM Pro] loading vote module...")
	include("playmusic_pro/server/sv_vote.lua")
	include("playmusic_pro/server/youtube.lua")
	print("[PlayM Pro] Adding resource...")
	resource.AddFile( "materials/vgui/Playmusic_Pro/Search.vmt" )
	resource.AddFile( "materials/vgui/Playmusic_Pro/vol1.vmt" )
	resource.AddFile( "materials/vgui/Playmusic_Pro/vol2.vmt" )
	resource.AddFile( "materials/vgui/Playmusic_Pro/vol3.vmt" )
	resource.AddFile( "materials/vgui/Playmusic_Pro/vol4.vmt" )
	resource.AddSingleFile( "materials/vgui/Playmusic_Pro/11.png" )
	resource.AddSingleFile( "materials/vgui/Playmusic_Pro/22.png" )
	resource.AddSingleFile( "materials/vgui/Playmusic_Pro/33.png" )
	resource.AddSingleFile( "materials/vgui/Playmusic_Pro/44.png" )
	resource.AddSingleFile( "materials/vgui/Playmusic_Pro/55.png" )
	resource.AddSingleFile( "materials/vgui/Playmusic_Pro/mute.png" )
	resource.AddFile( "materials/vgui/Playmusic_Pro/Search.vmt" )
	
	resource.AddFile( "materials/vgui/entities/billboard_pm.vmt" )
	resource.AddFile( "materials/vgui/entities/fence002d_pm.vmt" )
	resource.AddFile( "materials/vgui/entities/tv_pm.vmt" )
	resource.AddFile( "materials/vgui/entities/billboard_pm.png" )
	resource.AddFile( "materials/vgui/entities/fence002d_pm.png" )
	resource.AddFile( "materials/vgui/entities/tv_pm.png" )
	
	print("[PlayM Pro] Adding workshop resource...")
	resource.AddWorkshop( "1909043673" ) -- missing texture...

end


-- client
if CLIENT then
    include("playmusic_pro/client/cl_init.lua")
end


print("[Playmusic Pro] Search for newer version of Playmusic Pro...")
http.Fetch( "https://minbird.github.io/pmproNewerVer", function(data)
	PlayMP.info.newer_version = tonumber(data)
end)

http.Fetch( "https://minbird.github.io/pmproNewerVerV", function(data)
	PlayMP.info.newer_version_str = tostring(data)
end)