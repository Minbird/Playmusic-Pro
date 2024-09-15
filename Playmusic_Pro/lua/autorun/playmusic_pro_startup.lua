print("[Playmusic Pro] System startup...")
print("///////////////////////////")
print("// Playmusic Pro StartUp //")
print("// by Minbirdragon       //")
print("///////////////////////////")

if PlayMP and PlayMP.Player and CLIENT then
	PlayMP.Player:Stop()
	hook.Remove("Tick", "MainNotchInfoPanelTimebarTick")
	hook.Remove("Think", "PlayerVideoTitle_TextSliderThink")
	hook.Remove("Think", "PlayerVideoTitle_aniImage_Think")
	hook.Remove("PostCleanupMap", "PlayMP:PostCleanupMap")
	hook.Remove("Tick", "DoNoticeToPlayerOnMenu")

	if IsValid(PlayMP.MenuWindowPanel) then -- 사용자가 메뉴를 열고 있는 경우 창 닫아주기.
		PlayMP.MenuWindowPanel:Clear()
		PlayMP.MainMenuPanel:Remove()
		PlayMP.MainMenuPanel:Close()
	end
	-- PlayMP:OpenSubFrame로 열린 창은 local이므로 오류 발생하지 않음.

	PlayMP.NotchInfoPanel:Clear() -- 이건 항상 유효함 (화면 위 이디케이터)
	PlayMP.NotchInfoPanel:Close()
end


if PlayMP and SERVER then
	hook.Remove("Think", "PMP Video Time Think") -- 혹시 재생 중에 초기화된다면...
end


PlayMP = {}


print("[Playmusic Pro] Start Init...")

PlayMP.info = {}
PlayMP.info.version = "1.02"
PlayMP.info.version_str = "3.0.2"
PlayMP.info.newer_version = "0.0"
PlayMP.info.newer_version_str = "Unknown"
PlayMP.info.is_beta = false

PlayMP.system = {}
PlayMP.system.lang = {}
PlayMP.system.lang.cur_lang = "en"


print("[PlayM Pro] Loading Language Files...")
local folder = "playmusicpro/pm_lang/"
local files = file.Find( folder .. "/" .. "*.lua", "LUA" )
for _, file in ipairs( files ) do
	print("[PlayM Pro] Try add Client side Language File: " .. file)
	AddCSLuaFile( folder .. "/" .. file )
end

print("[PlayM Pro] Loading Options Files...")
local folder = "playmusicpro/pm_options/"
local files = file.Find( folder .. "/" .. "*.lua", "LUA" )
for _, file in ipairs( files ) do
	print("[PlayM Pro] Try add Client side Options File: " .. file)
	AddCSLuaFile( folder .. "/" .. file )
end

include("playmusicpro/share.lua")
include("playmusicpro/shared.lua")

-- server
if SERVER then
	AddCSLuaFile("playmusicpro/client/cl_init.lua")
	AddCSLuaFile("playmusicpro/client/cl_network.lua")
	AddCSLuaFile("playmusicpro/client/player.lua")
	AddCSLuaFile("playmusicpro/logger.lua")
	AddCSLuaFile("playmusicpro/setting.lua")
	AddCSLuaFile("playmusicpro/share.lua")
	AddCSLuaFile("playmusicpro/shared.lua")
	AddCSLuaFile("playmusicpro/vars.lua")
	AddCSLuaFile("playmusicpro/client/convars.lua")
	AddCSLuaFile("playmusicpro/client/font.lua")
	AddCSLuaFile("playmusicpro/client/cl_polys.lua")
	AddCSLuaFile("playmusicpro/client/cl_record.lua")
	AddCSLuaFile("playmusicpro/client/cl_vote.lua")
	AddCSLuaFile("playmusicpro/client/cl_mainmenu.lua")
	AddCSLuaFile("playmusicpro/client/cl_option.lua")
	AddCSLuaFile("playmusicpro/client/user.lua")
	AddCSLuaFile("playmusicpro/client/old_cl_init.lua")
	AddCSLuaFile("playmusicpro/client/ui.lua")

	print("[PlayM Pro] Server side system is loading...")
	print("[PlayM Pro] Init...")
	include("playmusicpro/server/init.lua")
	print("[PlayM Pro] loading vote module...")
	include("playmusicpro/server/sv_vote.lua")
	include("playmusicpro/server/youtube.lua")
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
    include("playmusicpro/client/cl_init.lua")
end


print("[Playmusic Pro] Search for newer version of Playmusic Pro...")
http.Fetch( "https://minbird.github.io/pmproNewerVer", function(data)
	PlayMP.info.newer_version = tonumber(data)
end)

http.Fetch( "https://minbird.github.io/pmproNewerVerV", function(data)
	PlayMP.info.newer_version_str = tostring(data)
end)