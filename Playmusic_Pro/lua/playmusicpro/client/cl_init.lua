include("playmusicpro/share.lua")
include("playmusicpro/vars.lua")
include("playmusicpro/logger.lua")
include("playmusicpro/setting.lua")

include("playmusicpro/client/convars.lua")
include("playmusicpro/client/font.lua")
include("playmusicpro/client/cl_polys.lua")
include("playmusicpro/client/cl_record.lua")
include("playmusicpro/client/cl_vote.lua")
include("playmusicpro/client/player.lua")
include("playmusicpro/client/cl_network.lua")
include("playmusicpro/client/cl_mainmenu.lua")
include("playmusicpro/client/cl_option.lua")
include("playmusicpro/client/user.lua")
include("playmusicpro/client/old_cl_init.lua")
include("playmusicpro/client/ui.lua")

PlayMP.CurLangData = {}
PlayMP.Lang = {}
PlayMP.OptionsData = {} 

function PlayMP.PlayerCommand(ply, text, teamchat, isdead, station, c, args)
	
	if ( ply and LocalPlayer() and ply == LocalPlayer() ) then
	
		if string.Left(string.lower(text), 3) == PlayMP.openmenu.chat_short or string.Left(string.lower(text), 10) == PlayMP.openmenu.chat then
		
			local entName = PlayMP:ExtractCommandArgs(text)
			if entName == nil then return end

			if entName == "open" or entName == "" then
				PlayMP:CreatFrame( "Playmusic Pro", "PlaymusicP_MainMenu" )
				PlayMP:MainMenu()
				return
			end

			if entName == "vol" then
				PlayMP.Player.set_vol( tonumber(entName) )
				return
			end
			
			if string.find(entName,"youtube")!=nil then
				PlayMP:AddQueue( entName, 0, 0, false, PlayMP:GetSetting( "removeOldQueue", false, true ) )
			elseif string.find(entName,"youtu.be")!=nil then
				PlayMP:AddQueue( entName, 0, 0, false, PlayMP:GetSetting( "removeOldQueue", false, true )  )
			else
				PlayMP:Notice( PlayMP:Str( "wrongUrl" ), Color(231, 76, 47), "warning" )
			end
			
		end
	
	end

end

hook.Add("OnPlayerChat", "PlayMP:PlayerCommand", PlayMP.PlayerCommand )

function PlayMP:ExtractCommandArgs(text)

	if string.Left(string.lower(text), 3) == PlayMP.openmenu.chat_short or string.Left(string.lower(text), 10) == PlayMP.openmenu.chat then
		if string.len(text) <= 3 then
			return "", ""
		end
	end

	local exploded = string.Explode(" ", text)
	table.remove(exploded, 1)
	local entName = exploded[1]

	return entName
end

PlayMP.PlayMPMenuBind = PlayMP:GetSetting( "mainMenuBind", false, true )
if PlayMP.PlayMPMenuBind == nil then 
	PlayMP:ChangeSetting( "mainMenuBind", 100 )
	PlayMP.PlayMPMenuBind = 100 
end

PlayMP.UserOnChatNow = false
hook.Add( "StartChat", "OpenedChatBox_PMP", function( isTeamChat )
	PlayMP.UserOnChatNow = true
end )

hook.Add( "FinishChat", "ClosedChatBox_PMP", function()
	PlayMP.UserOnChatNow = false
end)

hook.Add( "Tick", "PMP_KeyDown", function()
	if PlayMP.UserOnChatNow == false then
		if input.IsKeyDown(PlayMP.PlayMPMenuBind) and PlayMP.MainMenuPanel == nil then
			if PlayMP.OpenMenuByKeyPress == nil or PlayMP.OpenMenuByKeyPress == true then return end
			PlayMP.OpenMenuByKeyPress = true
			PlayMP:CreatFrame( "Playmusic Pro", "PlaymusicP_MainMenu" )
			PlayMP:MainMenu()
		elseif input.IsKeyDown(PlayMP.PlayMPMenuBind) and PlayMP.MainMenuPanel then
			if PlayMP.OpenMenuByKeyPress == nil or PlayMP.OpenMenuByKeyPress == true then return end
			PlayMP.OpenMenuByKeyPress = true
			hook.Remove("HUDPaint", "PlaymusicP_MainMenu")
			hook.Remove("Tick", "DoNoticeToPlayerOnMenu")
			PlayMP.MenuWindowPanel:Clear()
			PlayMP.MainMenuPanel:Remove()
			PlayMP.MainMenuPanel:Close()
			PlayMP.MainMenuPanel = nil
		else
			PlayMP.OpenMenuByKeyPress = false
		end
	end
end )

function PlayMP:AddLanguage( name, uniName )
	
	for k, v in pairs(PlayMP.CurLangData) do
		if v.LangUni == uniName then
			v.Data = {}
			return v.Data
		end
	end
	
	table.insert( PlayMP.CurLangData, {
		Lang = name,
		LangUni = uniName
	}
	)
	
	print("[PlayM Pro] Language Loaded: " .. name)
	
	for k, v in pairs(PlayMP.CurLangData) do
		if v.LangUni == uniName then
			v.Data = {}
			return v.Data
		end
	end
	
end


function PlayMP:ChangeLang(uniName)
			
	if uniName == "SystemLang" then
		PlayMP.CurLang = GetConVarString("gmod_language")
	elseif uniName != nil then
		PlayMP.CurLang = uniName
	end
		
	for k, v in pairs(PlayMP.CurLangData) do
		if v.LangUni == PlayMP.CurLang then
			PlayMP.Lang = v.Data
				print("[Playmusic Pro] Changed Language to: " .. v.Lang)
		end
	end
	
end

function PlayMP:Str( tag, ... )

	local f = { ... }
	local s = PlayMP.Lang[tag]
	if s != nil then
		if f != nil then

			return string.format( tostring(s), ... )

		end
		return s
	end
	return tag

end


local files = file.Find( "playmusicpro/pm_lang/*.lua", "LUA" )
if #files > 0 then
	for k, files in ipairs( files ) do
		Msg( "[PlayM Pro] Language File Read: " .. files .. "\n" )
		include( "playmusicpro/pm_lang/" .. files )
	end
else
	error("[PlayM Pro] Language filie read ERROR!")
end


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
	
local curLangSet = PlayMP.Setting:get( "시스템언어" )
		
if curLangSet != nil and curLangSet == "SystemLang" then
	PlayMP.CurLang = GetConVarString("gmod_language")
elseif curLangSet != nil then
	PlayMP.CurLang = curLangSet
else
	PlayMP.CurLang = "en"
end
		
for k, v in pairs(PlayMP.CurLangData) do
	if v.LangUni == PlayMP.CurLang then
		PlayMP.Lang = v.Data
		PlayMP:ChangeLang(PlayMP.CurLang)
	end
	if k == #PlayMP.CurLangData and table.IsEmpty(PlayMP.Lang) then
		PlayMP:ChangeLang("en")
	end
end

local PlayMPMenuBind = PlayMP.Setting:get( "mainMenuBind" )
if PlayMPMenuBind == nil then 
	PlayMP:ChangeSetting( "mainMenuBind", 100 )
	PlayMPMenuBind = 100 
end
		
chat.AddText(Color(255,150,100),PlayMP:Str( "Welcome_Messages1" ),Color(255,255,255),PlayMP:Str( "Welcome_Messages2" ),Color(255,150,100),PlayMP:Str( "Welcome_Messages3", input.GetKeyName(PlayMPMenuBind) ),Color(255,255,255),PlayMP:Str( "Welcome_Messages4" ),Color(255,150,100),PlayMP:Str( "Welcome_Messages5" ),Color(255,255,255),PlayMP:Str( "Welcome_Messages6" ))
chat.AddText(Color(255,255,255),PlayMP:Str( "Welcome_Messages7" ), Color(255,150,100), PlayMP.info.version_str, Color(255,255,255), PlayMP:Str( "Welcome_Messages8" ))
if not PlayMP:GetSetting( "NoUpdateNotice", false, true) and PlayMP.NewerVer != nil then
	if tonumber(PlayMP.info.newer_version) > tonumber(PlayMP.info.version) then
		chat.AddText(Color(255,255,255), PlayMP:Str( "Welcome_Messages9" ), Color(255,150,100), PlayMP:Str( "Welcome_Messages10" ), Color(255,255,255), PlayMP:Str( "Welcome_Messages11" ), Color(255,150,100), PlayMP.info.newer_version_str, Color(255,255,255), PlayMP:Str( "Welcome_Messages12" ))
	end
end




--- for debug!!
-- only for develop 변수는 왜 이렇게 많은지 아오

local debug_text = ""
local debug_text_add = function( name, value )
	debug_text = debug_text .. name .. " = " .. tostring(value) .. "\n"
end

PlayMP.do_show_debug_hud_on_screen = function()
	if PlayMP:GetSetting( "디버그모드", false, true) then
		hook.Add("HUDPaint", "PlayMProDebug", function()
			debug_text_add("PlayMP.Player.Allow_Error_Time", PlayMP.Player.Allow_Error_Time)
			debug_text_add("PlayMP.Player.Retry_Time", PlayMP.Player.Retry_Time)
			debug_text_add("PlayMP.Player.Time_think_Time_Sec", PlayMP.Player.Time_think_Time_Sec)
			debug_text_add("PlayMP.Player.Cur_Play_Num", PlayMP.Player.Cur_Play_Num)
			debug_text_add("PlayMP.Player.State", PlayMP.Player.State)
			debug_text_add("PlayMP.Player.Engine_type", PlayMP.Player.Engine_type)
			debug_text_add("PlayMP.Player.Player_type", PlayMP.Player.Player_type)
			debug_text_add("PlayMP.Player.Cur_media_start_time", PlayMP.Player.Cur_media_start_time)
			debug_text_add("PlayMP.Player.Cur_play_time", PlayMP.Player.Cur_play_time)
			debug_text_add("PlayMP.Player.Cur_Media_Length", PlayMP.Player.Cur_Media_Length)
			debug_text_add("PlayMP.Player.Real_play_time", PlayMP.Player.Real_play_time)
			debug_text_add("PlayMP.Player.Last_Valid_Real_play_time", PlayMP.Player.Last_Valid_Real_play_time)
			debug_text_add("PlayMP.SeekToTimeThink", PlayMP.SeekToTimeThink)
			debug_text_add("PlayMP.Player.Media_Start_Position", PlayMP.Player.Media_Start_Position)
			debug_text_add("PlayMP.timeError", PlayMP.timeError)
			debug_text_add("PlayMP.Player.isPending", PlayMP.Player.isPending)
			debug_text_add("PlayMP.Player.isPlaying", PlayMP.Player.isPlaying)
			debug_text_add("PlayMP.Player.isMuted", PlayMP.Player.isMuted)
			debug_text_add("PlayMP.Player.isSeeking", PlayMP.Player.isSeeking)
			debug_text_add("PlayMP.Player.isInReady", PlayMP.Player.isInReady)
			debug_text_add("PlayMP.Player.isDownVolumeWithVoiceChat", PlayMP.Player.isDownVolumeWithVoiceChat)
			debug_text_add("PlayMP.Player.VolumeTo_isWorking", PlayMP.Player.VolumeTo_isWorking)
			debug_text_add("PlayMP.Player.Cur_Volume", PlayMP.Player.Cur_Volume)
			debug_text_add("PlayMP.Player.Url", PlayMP.Player.Url)
			debug_text_add("PlayMP.Player.QuerySelector", PlayMP.Player.QuerySelector)
			debug_text_add("PlayMP.Player.TimeThink_Remover", PlayMP.Player.TimeThink_Remover)
			debug_text_add("PlayMP.Player.Cur_VolumeSFX", PlayMP.Player.Cur_VolumeSFX)
			debug_text_add("PlayMP.Player.Player_HTML", PlayMP.Player.Player_HTML)
			debug_text_add("PlayMP.Player.Player_Station", PlayMP.Player.Player_Station)
			debug_text_add("PlayMP.CurLang", PlayMP.CurLang)
			draw.DrawText( debug_text, "DebugOverlay", 2, 15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			debug_text = ""
		end)
	else
		hook.Remove("HUDPaint", "PlayMProDebug")
	end
end

PlayMP.do_show_debug_hud_on_screen()