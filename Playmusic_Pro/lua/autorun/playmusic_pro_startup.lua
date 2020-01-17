
print("[PlayM Pro] Start Up System! \n 시스템을 시작합니다!")
print("[PlayM Pro] Thanks for using PlayMusic Pro. \n 플레이뮤직 Pro를 이용해주셔서 감사합니다.")

if PlayMP then -- 초기화

	hook.Remove( "Think", "PMP Video Time Think")

	if CLIENT then
		hook.Remove("Think", "PlayerVideoTitle_TextSliderThink")
		hook.Remove("Tick", "MainNotchInfoPanelTimebarTick")
		hook.Remove( "Think", "PlayerVideoTitle_aniImage_Think")
		hook.Remove( "Tick", "PMP_KeyDown")
		hook.Remove( "Tick", "Menu Time Seekto bar Think")
	
		if PlayMP.PlayerHTML != nil then
			PlayMP.PlayerHTML:Remove()
		end
		
		if PlayMP.PlayerMainPanel != nil then
			PlayMP.MainMenuCtrlPanel:Clear()
			PlayMP.PlayerMainPanel:Remove()
			PlayMP.PlayerMainPanel:Close()
		end
		if MenuWindowPanel != nil then
			PlayMP.MenuWindowPanel:Clear()
			PlayMP.MainMenuPanel:Remove()
			PlayMP.MainMenuPanel:Close()
			PlayMP.MainMenuPanel = nil
		end
		if PlayMP.NotchInfoPanel != nil then
			PlayMP.NotchInfoPanel:Clear()
			PlayMP.NotchInfoPanel:Close()
		end
	
	end

	if SERVER then
		PrintMessage( HUD_PRINTTALK, "[Playmusic Pro] 플레이 뮤직 프로가 초기화되었습니다." )
	end

end

PlayMP = {}

PlayMP.CurSystemVersion = {}
PlayMP.CurSystemVersion.isBeta = true
PlayMP.CurSystemVersion.ResetOptionAnytime = false
PlayMP.CurSystemVersion.Ver = "2.0.0 - 5 (beta)"
PlayMP.CurSystemVersion.VerE = "0.14"
PlayMP.NewerVer = "unknown"
PlayMP.NewerVerE = 0
PlayMP.SysStartTime = CurTime()
PlayMP.CurLangData = {}
PlayMP.Lang = {}
print("///////////////////////////")
print("// Playmusic Pro StartUp //")
print("///////////////////////////")
print("[PlayM Pro] Loading...")
print("[PlayM Pro] Loading Main Files...")
print("[PlayM Pro] Try add Client side File: playmusicpro/cl_init.lua")
AddCSLuaFile("playmusicpro/cl_init.lua")
print("[PlayM Pro] Try add Client side File: playmusicpro/cl_polys.lua")
AddCSLuaFile("playmusicpro/cl_polys.lua")
print("[PlayM Pro] Try add Client side File: playmusicpro/init.lua")
AddCSLuaFile("playmusicpro/init.lua")
print("[PlayM Pro] Try add Client side File: playmusicpro/cl_mainmenu.lua")
AddCSLuaFile("playmusicpro/cl_mainmenu.lua")
print("[PlayM Pro] Try add Client side File: playmusicpro/cl_option.lua")
AddCSLuaFile("playmusicpro/cl_option.lua")

print("[PlayM Pro] Loading Entities...")
print("[PlayM Pro] Try add Client side File: entities/tv.lua")
AddCSLuaFile("entities/tv.lua")
print("[PlayM Pro] Try add Client side File: entities/billboard.lua")
AddCSLuaFile("entities/billboard.lua")

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

print("[PlayM Pro] Checking Newer Version...")
http.Fetch( "https://minbird.github.io/pmproNewerVer", function(data)
	PlayMP.NewerVerE = tonumber(data)
	
end)

http.Fetch( "https://minbird.github.io/pmproNewerVerV", function(data)
	PlayMP.NewerVer = tostring(data)
end)

timer.Simple( 1, function()

	if SERVER then


		print("[PlayM Pro] Server side system is loading...")
		print("[PlayM Pro] Loading Init...")
		include("playmusicpro/init.lua")
		resource.AddFile( "vgui/Playmusic_Pro/Search.vmt" )
		resource.AddFile( "vgui/Playmusic_Pro/vol1.vmt" )
		resource.AddFile( "vgui/Playmusic_Pro/vol2.vmt" )
		resource.AddFile( "vgui/Playmusic_Pro/vol3.vmt" )
		resource.AddFile( "vgui/Playmusic_Pro/vol4.vmt" )
		resource.AddFile( "vgui/Playmusic_Pro/11.png" )
		resource.AddFile( "vgui/Playmusic_Pro/22.png" )
		resource.AddFile( "vgui/Playmusic_Pro/33.png" )
		resource.AddFile( "vgui/Playmusic_Pro/44.png" )
		resource.AddFile( "vgui/Playmusic_Pro/55.png" )
		resource.AddFile( "vgui/Playmusic_Pro/mute.png" )
		
	end
	


	if CLIENT then
	
		print("[PlayM Pro] Loading cl_Init...")
		include("playmusicpro/cl_init.lua")
		print("[PlayM Pro] Loading cl_polys.lua...")
		include("playmusicpro/cl_polys.lua")
		
		local files = file.Find( "playmusicpro/pm_lang/*.lua", "LUA" )
		if #files > 0 then
			for k, files in ipairs( files ) do
				Msg( "[PlayM Pro] Language File Read: " .. files .. "\n" )
				include( "playmusicpro/pm_lang/" .. files )
				--[[local data = file.Read( "playmusicpro/pm_lang/" .. files, "LUA" )
				data = util.JSONToTable(data)
				table.insert( PlayMP.CurLangData, {
					Lang = data.Lang,
					LangUni = files,
					Data = data
				}
				)]]
			end
		else
			error("[PlayM Pro] Language filie read ERROR!")
		end
		
		PlayMP.OptionsData = {} 



		local option = file.Find( "playmusicpro/pm_options/*.lua", "LUA" )
		if #option > 0 then
			for k, file in ipairs( option ) do
				Msg( "[PlayM Pro] Option File Read: " .. file .. "\n" )
				local func = CompileFile( "playmusicpro/pm_options/" .. file )
				
				table.insert( PlayMP.OptionsData, {
					Func = func,
				}
				)
	
			end
		else
			error("[PlayM Pro] Options not found!")
		end
	
		local curLangSet = PlayMP:GetSetting( "시스템언어", false, false )
		
		if curLangSet != nil and curLangSet.Data == "SystemLang" then
			PlayMP.CurLang = GetConVarString("gmod_language")
		elseif curLangSet != nil then
			PlayMP.CurLang = curLangSet.Data
		else
			PlayMP.CurLang = "en"
		end
		
		for k, v in pairs(PlayMP.CurLangData) do
			if v.LangUni == PlayMP.CurLang then
				PlayMP.Lang = v.Data
			end
			if k == #PlayMP.CurLangData and table.IsEmpty(PlayMP.Lang) then
				PlayMP:ChangeLang("en")
			end
		end
		
		--include( "playmusicpro/pm_lang/" .. PlayMP.CurLang .. ".lua" )
		
		chat.AddText(Color(255,150,100),PlayMP:Str( "Welcome_Messages1" ),Color(255,255,255),PlayMP:Str( "Welcome_Messages2" ),Color(255,150,100),PlayMP:Str( "Welcome_Messages3" ),Color(255,255,255),PlayMP:Str( "Welcome_Messages4" ),Color(255,150,100),PlayMP:Str( "Welcome_Messages5" ),Color(255,255,255),PlayMP:Str( "Welcome_Messages6" ))
		chat.AddText(Color(255,255,255),PlayMP:Str( "Welcome_Messages7" ), Color(255,150,100), PlayMP.CurSystemVersion.Ver, Color(255,255,255), PlayMP:Str( "Welcome_Messages8" ))
		if not PlayMP:GetSetting( "NoUpdateNotice", false, true) and PlayMP.NewerVer != nil then
			if tonumber(PlayMP.NewerVerE) > tonumber(PlayMP.CurSystemVersion.VerE) then
				chat.AddText(Color(255,255,255), PlayMP:Str( "Welcome_Messages9" ), Color(255,150,100), PlayMP:Str( "Welcome_Messages10" ), Color(255,255,255), PlayMP:Str( "Welcome_Messages11" ), Color(255,150,100), PlayMP.NewerVer, Color(255,255,255), PlayMP:Str( "Welcome_Messages12" ))
			end
		end
		
		if PlayMP.CurSystemVersion.isBeta then
			chat.AddText(Color(255,0,0),PlayMP:Str( "SysNowInBeta" ))
		end
	
	end

	print("[PlayM Pro] System is Ready! (Loading Time: " .. CurTime() - PlayMP.SysStartTime - 1 .."s)")
	print("[PlayM Pro] System Version is " .. PlayMP.CurSystemVersion.Ver)
	if PlayMP.NewerVerE != nil and tonumber(PlayMP.NewerVerE) > tonumber(PlayMP.CurSystemVersion.VerE) then
		print("[PlayM Pro] There is Newer Versioncan install! (" .. PlayMP.NewerVer .. ")")
	elseif PlayMP.NewerVerE != nil and tonumber(PlayMP.NewerVerE) <= tonumber(PlayMP.CurSystemVersion.VerE) then
		print("[PlayM Pro] It's A Latest Version of PlayMusic Pro that is installed.")
	end

end)
