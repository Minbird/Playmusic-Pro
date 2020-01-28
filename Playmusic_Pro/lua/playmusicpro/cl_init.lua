
PlayMP.CurVideoLength = 0
PlayMP.CurPlayTime = 0
PlayMP.CurVideoInfo = {}
PlayMP.RealPlayTime = 0
PlayMP.LocalPlayerData = {}

CreateClientConVar("playmp_volume", 15, true, false)

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
	return "Something Error!!"

end

if PlayMP.CurSystemVersion.isBeta and PlayMP.CurSystemVersion.ResetOptionAnytime then
	file.Delete("PlayMusicPro_Setting.txt")
end

if file.Find( "PlayMusicPro_Setting.txt", "DATA" ) == nil then
	file.Append("PlayMusicPro_Setting.txt")
end

function PlayMP:ReadSettingData( str, getAll, returnOnlyData )

	if file.Find( "PlayMusicPro_Setting.txt", "DATA" ) == nil then
		return {}
	else
		local data = file.Read( "PlayMusicPro_Setting.txt", "DATA" )
		if data == nil or data == "" then return {} end
		local table = util.JSONToTable(data)
		
		if getAll then
			return table
		end
		
		for k, v in pairs( table ) do
			if v.UniName == str then
			
				if returnOnlyData then
					return v.Data
				else
					return v
				end
				
			end
		end
				
		return {}
	end
	
end


PlayMP.CurSettings = PlayMP:ReadSettingData( "", true, false )


function PlayMP:GetSetting( str, getAll, returnOnlyData )
		
	if getAll then
		return PlayMP.CurSettings
	end
		
	for k, v in pairs( PlayMP.CurSettings ) do
		if v.UniName == str then
		
			if returnOnlyData then
				return v.Data
			else
				return v 
			end
			
		end
	end
	
end


function PlayMP:ChangeSetting( str, any )
	
	local data = PlayMP:GetSetting( str, true, false )
	if data then
		
		for k, v in pairs( data ) do
			if v.UniName == str then
			
				v.Data = any
				file.Write( "PlayMusicPro_Setting.txt", util.TableToJSON(data) )
				
				PlayMP.CurSettings = data
				return
				
			end
		end
		
		PlayMP:AddSetting( str, any )
		PlayMP.CurSettings = data
		
	else
		error("Failed to change settings: Failed to get client settings. Target:[" .. str .. "]")
	end
	
end


function PlayMP:GetServerSettings()
	net.Start("PlayMP:GetServerSettings")
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

	net.Receive( "PlayMP:GetServerSettings", function()
	
		local data = net.ReadTable()
		
		for k, v in pairs(data) do
			PlayMP:ChangeSetting( v.UniName, v.Data )
		end

	end)
	
	PlayMP:GetServerSettings()
	
surface.CreateFont( "NotchInfoPanel_PlaymusicPro_Font", {
	font = "Arial",
	extended = false,
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

surface.CreateFont( "Default_PlaymusicPro_Font", {
	font = "Arial",
	extended = false,
	size = 18,
	weight = 550,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "OptionsButtonDefault_PlaymusicPro_Font", {
	font = "Arial",
	extended = false,
	size = 22,
	weight = 550,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "ButtonDefault_PlaymusicPro_Font", {
	font = "Arial",
	extended = false,
	size = 18,
	weight = 550,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "BigTitle_PlaymusicPro_Font", {
	font = "Arial",
	extended = false,
	size = 30,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
	
function PlayMP:ChangeServerSettings( UniName )
	net.Start("PlayMP:ChangeServerSettings")
		net.WriteEntity( LocalPlayer() )
		net.WriteTable( PlayMP:GetSetting( UniName, false, false ) )
	net.SendToServer()
end


function PlayMP:AddSetting( name, data )

	
	local CurData = PlayMP:GetSetting( str, true, false )

	table.insert( CurData, {
		Data = data, 
		UniName = name
	} )
	
	file.Write( "PlayMusicPro_Setting.txt", util.TableToJSON(CurData) )

	
	PlayMP.CurSettings = CurData
	
end


local data = file.Read( "PlayMusicPro_Setting.txt", "DATA" )
if data == nil or data == "" then
	PlayMP:AddSetting( "SyncPlay_WCAH", true )
	PlayMP:AddSetting( "No_Play_Always", false )
	PlayMP:AddSetting( "Show_MediaPlayer", false )
	PlayMP:AddSetting( "Show_InfPan_Always", false )
	PlayMP:AddSetting( "No_Show_InfoPanel", true )
	
	PlayMP:AddSetting( "Quick_Request", false )
	--PlayMP:AddSetting( "대기열에50개만표시", true )
	
	PlayMP:AddSetting( "PlayX01", false )
	
	PlayMP:AddSetting( "Use_Blur", true )
	PlayMP:AddSetting( "Use_Animation", true )

	PlayMP:AddSetting( "업뎃알림안함", false )
	PlayMP:AddSetting( "FMem", false )
	
	PlayMP:AddSetting( "SyncMediaAndPlayer", true )
	
	PlayMP:AddSetting( "MainPlayerData",{
			X=10,
			Y=10,
			W=160,
			H=80
		}
	)
	
	PlayMP:AddSetting( "MainMenu_Alpha", 255 )
	
	PlayMP:AddSetting( "시스템언어", "SystemLang" )
	PlayMP:AddSetting( "mainMenuBind", 100 )

end

function PlayMP.GetPlayerVolume()
    return math.Clamp(GetConVar("playmp_volume"):GetInt(), 0, 100)
end

function PlayMP.SetPlayerVolume( vol )
    RunConsoleCommand("playmp_volume", vol)
	
	if PlayMP.PlayerHTML != nil and PlayMP.PlayerHTML:Valid() then
		PlayMP.PlayerHTML:QueueJavascript([[player.setVolume(]] .. PlayMP.GetPlayerVolume() .. [[)]])
	end
end

function PlayMP:Notice( text, color, type )
	PlayMP:DoNoticeToPlayer( text, color, type )
end



function PlayMP:ReadLocalPlayList()

	local CurPlayList = {}

	if file.Find( "PlayMusicPro_MyPlayList.txt", "DATA" ) == nil then
		return {}
	else
		
		local data = file.Read( "PlayMusicPro_MyPlayList.txt", "DATA" )
		if data == nil or data == "" then return {} end
		CurPlayList.table = util.JSONToTable(data)
		if CurPlayList.table == nil or CurPlayList.table == "" then return {} end

		return CurPlayList.table
	end
	
end

function PlayMP:AddLocalPlayList( info )

	if file.Find( "PlayMusicPro_MyPlayList.txt", "DATA" ) == nil then
		file.Append("PlayMusicPro_MyPlayList.txt")
	end
	
	local CurPlayList = PlayMP:ReadLocalPlayList()
	
	
	if table.Count(CurPlayList) == 0 then
		table.insert( CurPlayList, info )
		local data = util.TableToJSON(CurPlayList)
		file.Write( "PlayMusicPro_MyPlayList.txt", data )
		return "writed"
	end
	
	for k, v in pairs( CurPlayList ) do
	
		if v["Uri"] == info.Uri then
		
			return "alreadySaved"
		
		else
		
			if k == table.Count(CurPlayList) then
				table.insert( CurPlayList, info )
				local data = util.TableToJSON(CurPlayList)
				file.Write( "PlayMusicPro_MyPlayList.txt", data )
				return "writed"
			end
			
		end
		
	end
	
end

function PlayMP:RemoveQueue( num )
	net.Start("PlayMP:RemoveQueue")
		net.WriteString( tonumber(num) )
	net.SendToServer()
end

local API_KEY = "AIzaSyBek-uYZyjZfn2uyHwsSQD7fyKIRCeXifU"

function PlayMP:ReadVideoAndWritePlayList( v )

	if v.id.kind == "youtube#playlist" then
		PlayMP:OpenSubFrame( PlayMP:Str( "Notice" ), "알림 - 클립보드에 복사함", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
			PlayMP:AddTextBox( scrpanel, scrpanel:GetTall(), FILL, PlayMP:Str( "Perceive_PlayList" ), scrpanel:GetWide() * 0.5, 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
			PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Just_One_Clip" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 260, 10, 130, 30, function()
				hook.Remove("HUDPaint", "OpenRequestQueueWindow")
				mainPanel:Close()
			end)
			PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Every_Clip_On_Playlist" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
				hook.Remove("HUDPaint", "OpenRequestQueueWindow")
				mainPanel:Close()
				local stat = PlayMP:AddLocalPlayList( {
					Title = v.snippet.title, 
					Uri = v.id.videoId,
					Kind = v.id.kind,
					PlaylistId = v.id.playlistId,
					StartTime = nil,
					EndTime = nil}
				)
				
				return stat
			end)
		end)
	else
		local stat = PlayMP:AddLocalPlayList( {
			Title = v.snippet.title, 
			Uri = v.id.videoId,
			Kind = v.id.kind,
			PlaylistId = v.id.playlistId,
			StartTime = nil,
			EndTime = nil}
		)
	end
	
end

function PlayMP:EditLocalPlayList( uniId, title, startTime, endTime, tag )

	local data = PlayMP:ReadLocalPlayList()
	
	for k, v in pairs( data ) do
		if v["Uri"] == uniId or v["PlaylistId"] == uniId then
			v.Title = title
			v.Channel = tag
			v.StartTime = startTime
			v.EndTime = endTime
			local CurPlayList = util.TableToJSON( data )
			file.Write( "PlayMusicPro_MyPlayList.txt", CurPlayList )
			return true
		end
	end
	
end

function PlayMP:EditLocalPlayListPanel( uniId )
	local data = PlayMP:ReadLocalPlayList()
	
	for k, v in pairs( data ) do
		if v["Uri"] == uniId or v["PlaylistId"] == uniId then
	
		PlayMP:OpenSubFrame( PlayMP:Str( "Edit_PlayLisy" ), "플레이 리스트 수정: " .. v.Title, 600, 280, function( mainPanel, scrpanel, ButtonPanel )
		
			local title = PlayMP:AddTextEntryBox( scrpanel, TOP, PlayMP:Str( "Media_Title" ), v.Title, scrpanel:GetWide(), 40 )
			title:SetText(v.Title)
			local ctitle = PlayMP:AddTextEntryBox( scrpanel, TOP, PlayMP:Str( "Channel" ), v.Title, scrpanel:GetWide(), 40 )
			if v.Channel then
				ctitle:SetText( v.Channel )
			else
				ctitle:SetText( "???" )
			end
			PlayMP:AddTextBox( scrpanel, 40, TOP, PlayMP:Str( "Media_Play_Time" ), scrpanel:GetWide() * 0.5, 15, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_CENTER)
			local startTime = PlayMP:AddTextEntryBox( scrpanel, TOP, PlayMP:Str( "StartTime" ), string.ToMinutesSeconds(v.StartTime), scrpanel:GetWide(), 40 )
			local endTime = PlayMP:AddTextEntryBox( scrpanel, TOP, PlayMP:Str( "EndTime" ), string.ToMinutesSeconds(v.EndTime), scrpanel:GetWide(), 40 )
			startTime:SetText(string.ToMinutesSeconds(v.StartTime))
			endTime:SetText(string.ToMinutesSeconds(v.EndTime))
			
			PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Apply" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 220, 10, 100, 30, function()
				hook.Remove("HUDPaint", "OpenRequestQueueWindow")
				mainPanel:Close()

				local startTimeStr = startTime:GetValue()
				local endTimeStr = endTime:GetValue()
				
				local SS = 0
				local SM = 0

				local ES = 0
				local EM = 0

				local c = 0
				for s in string.gmatch( startTimeStr, "[^%s:]+" ) do
					c = c + 1
					if c == 2 then
						SS = tonumber(s)
					else
						SM = tonumber(s)
					end
				end
				
				local c = 0
				for s in string.gmatch( endTimeStr, "[^%s:]+" ) do
					c = c + 1
					if c == 2 then
						ES = tonumber(s)
					else
						EM = tonumber(s)
					end
				end

				if SS > 0 then
					SM = SM * 60
				end
				
				if ES > 0 then
					EM = EM * 60
				end
				
				if SS != nil and SM != nil and ES != nil and EM != nil then
					PlayMP:EditLocalPlayList( uniId, title:GetValue(), SS + SM, ES + EM, ctitle:GetValue() )
				else
					PlayMP:Notice( PlayMP:Str( "Error_Edit_Playlist_SomethingWrong" ), Color(231, 76, 47), "warning" )
				end
			end )
			PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Cancel" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 110, 10, 100, 30, function()
				hook.Remove("HUDPaint", "OpenRequestQueueWindow")
				mainPanel:Close()
			end )
		end)
		
		end
	end
end

function PlayMP:RemoveLocalPlayList( Uri )

	if file.Find( "PlayMusicPro_MyPlayList.txt", "DATA" ) == nil then
		return "fileNotFound"
	else
		
		local data = PlayMP:ReadLocalPlayList()
		
		if data == "" or data == nil or data == "notFound" then
			return "NoData"
		end
		
		for k, v in pairs( data ) do
			if v["Uri"] == Uri then
				table.remove( data, k )
				local CurPlayList = util.TableToJSON( data )
				file.Write( "PlayMusicPro_MyPlayList.txt", CurPlayList )
				return "removed"
			end
		end
	end
end



function PlayMP:PlayMusic( uri, startTime, endTime )

	if PlayMP:GetSetting( "No_Play_Always", false, true ) then 
		
		return 
	end

	PlayMP:LoadPlayer()
	local vol = 0
	if PlayMP.PlayerIsMuted then vol = 0 else vol = PlayMP.GetPlayerVolume() end
	PlayMP.PlayerHTML:OpenURL("https://minbird.github.io/html/app/Pro_youtube.html?uri=" .. uri .. "?Vol=" .. vol .. "?Seek=" .. startTime )
	if PlayMP:GetSetting( "FMem", false, true) then
		PlayMP.PlayerHTML:QueueJavascript([[player.setPlaybackQuality( "small" );]])
	end
	
	PlayMP.SeekToTimeThink = 0
	
	PlayMP:VideoTimeThink()
	
	PlayMP.VideoStartTime = CurTime()
	
	PlayMP.isPlaying = true
	
end

function PlayMP:PlayerIsReady()
	
end

function PlayMP:StopMusic()

	if PlayMP.PlayerMode != nil and PlayMP.PlayerMode == "worldScr" then
		PlayMP.isPlaying = false
		PlayMP.WorldPlayerHTML:OpenURL("https://minbird.github.io/html/app/player.html")
		hook.Remove( "Think", "PMP Video Time Think")
		return
	end

	if PlayMP.PlayerHTML != nil then
		PlayMP.PlayerHTML:Remove()
	end
	if PlayMP.PlayerMainPanel != nil then
		PlayMP.PlayerMainPanel:Remove()
	end
	hook.Remove( "Think", "PMP Video Time Think")
	
	PlayMP.isPlaying = false
	
end



function PlayMP:LoadPlayer( vMe )

if PlayMP.PlayerMode != nil and PlayMP.PlayerMode == "worldScr" then

	PlayMP.PlayerHTML:AddFunction("PlayMP", "PlayState", function( st )
				if st == nil then 
					return 
				end
				if state != st then
				
					local stns = {}
					stns[1] = "시작되지 않음"
					stns[2] = PlayMP:Str( "Prepare_Play" )
					stns[3] = PlayMP:Str( "Now_Playing" )
					stns[4] = "일시중지"
					stns[5] = "버퍼링"
					stns[6] = "???"
					stns[7] = "동영상 신호"
					
					state = st
					PlayMP:ChangeNowPlayingText(stns[tonumber(st)+2])
				end
			end)
			
	return
else

end

local v = PlayMP:GetSetting( "MainPlayerData", false, true)

if v == nil then
	v = {
			X=10,
			Y=10,
			W=160,
			H=80
		}
	PlayMP:ChangeSetting( "MainPlayerData",v)
	chat.AddText("[Playmusic Pro Error] " ..  PlayMP:Str( "PlayerDataError" ))
	PlayMP:Notice( PlayMP:Str( "PlayerDataError" ), Color(231, 76, 47), "warning" )

end
	

PlayMP.PlayerMainPanel = vgui.Create( "DFrame" )
PlayMP.PlayerMainPanel:SetPos( v.X, v.Y )
PlayMP.PlayerMainPanel:SetSize( v.W, v.H )
PlayMP.PlayerMainPanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) ) end
PlayMP.PlayerMainPanel:SetMouseInputEnabled(false)
PlayMP.PlayerMainPanel:SetSizable( true )
PlayMP.PlayerMainPanel:ShowCloseButton( false )

PlayMP.PlayerHTML = vgui.Create("DHTML", PlayMP.PlayerMainPanel)
PlayMP.PlayerHTML:SetPos( 0, 0 )
PlayMP.PlayerHTML:SetSize( v.W, v.H )
PlayMP.PlayerHTML:SetPaintedManually(false)
PlayMP.PlayerHTML:SetMouseInputEnabled(false)
PlayMP.PlayerHTML:SetEnabled(true)
PlayMP.PlayerHTML:SetHTML("")

local setError = PlayMP:GetSetting( "SyncMediaAndPlayer", false, true)

local state

PlayMP.PlayerHTML:AddFunction("PlayMP", "PlayState", function( st )
	if st == nil then 
		return 
	end
	if state != st then
	
		local stns = {}
		stns[1] = "시작되지 않음"
		stns[2] = PlayMP:Str( "Prepare_Play" )
		stns[3] = PlayMP:Str( "Now_Playing" )
		stns[4] = "일시중지"
		stns[5] = "버퍼링"
		stns[6] = "???"
		stns[7] = "동영상 신호"
		
		state = st
		PlayMP:ChangeNowPlayingText(stns[tonumber(st)+2])
	end
end)

PlayMP.PlayerHTML:AddFunction("PlayMP", "CurTime", function( time )
	PlayMP.RealPlayTime = tonumber(time)
	
	if not setError then return end
	
	if ( PlayMP.RealPlayTime - PlayMP.StartTime > PlayMP.CurPlayTime + 1.5 ) or ( PlayMP.RealPlayTime + 1.5 < PlayMP.CurPlayTime - PlayMP.StartTime ) then
		PlayMP.PlayerHTML:QueueJavascript([[player.seekTo(]] .. PlayMP.CurPlayTime + PlayMP.StartTime .. [[, true)]])
		--PlayMP.timeError = PlayMP.timeError + (curTime - PlayMP.CurPlayTime)
		print("[PlayM Pro] Time error: " .. PlayMP.CurPlayTime - PlayMP.RealPlayTime .. "s! Try set to " .. PlayMP.CurPlayTime + PlayMP.StartTime .. "s...")
		
	end
	
end)

if vMe == nil or vMe != true then
	if PlayMP:GetSetting( "Show_MediaPlayer", false, true ) then
		PlayMP.PlayerMainPanel:SetPos( v.X, v.Y )
		PlayMP.PlayerMainPanel:SetSize( v.W, v.H )
		PlayMP.PlayerMainPanel:SetPaintedManually(false)
		PlayMP.PlayerHTML:SetPaintedManually(false)
	else
		if PlayMP:GetSetting( "디버그모드", false, true) then
			print("Noshow")
		end
		PlayMP.PlayerMainPanel:SetPos( -10, -10 )
		PlayMP.PlayerMainPanel:SetSize( 1, 1 )
		PlayMP.PlayerMainPanel:SetPaintedManually(true)
		PlayMP.PlayerHTML:SetPaintedManually(true)
	end
end

PlayMP.PlayerHTML.ConsoleMessage = function(pself, msg, ...)
	if msg then
		if string.find(msg, "XMLHttpRequest") then return end
		if string.find(msg, "Unsafe JavaScript attempt to access") then return end
		if string.find(msg, "seekTo") then return end
		if string.find(msg, "setVolume") then return end
		if string.find(msg, "getPlayerState") then return end
		if string.find(msg, "MinPlaymusic") then return end
	end
end

if PlayMP:GetSetting( "디버그모드", false, true) then
	print("PlayMP:LoadPlayer() - " .. v.X, v.Y, v.W, v.H)
end

end


function PlayMP:EditMainPlayer()

	hook.Remove("HUDPaint", "PlaymusicP_MainMenu")
	hook.Remove("Tick", "DoNoticeToPlayerOnMenu")
	PlayMP.MenuWindowPanel:Clear()
	PlayMP.MainMenuPanel:Remove()
	PlayMP.MainMenuPanel:Close()
	PlayMP.MainMenuPanel = nil
	
	if PlayMP.PlayerMainPanel != nil then
		PlayMP.PlayerHTML:Remove()
		PlayMP.PlayerMainPanel:Remove()
	end
	
	PlayMP:LoadPlayer( true )
	
	local w, h = PlayMP.PlayerMainPanel:GetSize()
	
	PlayMP.PlayerMainPanel:MakePopup()
	PlayMP.PlayerMainPanel:SetMouseInputEnabled(true)
	PlayMP.PlayerMainPanel:SetPaintedManually(false)
	PlayMP.PlayerHTML:SetPaintedManually(false)
	PlayMP.PlayerHTML:SetPos( 0, 150 )
	
	--[[local panelSizeBut = vgui.Create( "DPanel" )
	panelSizeBut:SetSize( 30, 30 )
	panelSizeBut:SetPos( 0, 0 )

	panelSizeBut:AlphaTo( Color(255,255,255,10) ) ]]
	
	local tself
	
	--[[PlayMP.PlayerMainPanel.OnCursorEntered = function( self, w, h )
		PlayMP.PlayerMainPanel:AlphaTo( Color(255,255,255,50), 1 )
	end
	PlayMP.PlayerMainPanel.OnCursorExited = function( self, w, h )
	end]]
	
	
	local window = vgui.Create( "DFrame" )
	window:SetSize( 600, 140 )
	window:Center()
	window.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) ) end
	window:SetMouseInputEnabled(true)
	window:ShowCloseButton( false )
	window:MakePopup()
	
	local wW, hH
	local xX, yY
	local x, y = PlayMP.PlayerMainPanel:GetPos()
	
	window.Think = function( self )
		
		w, h = PlayMP.PlayerMainPanel:GetSize()
		x, y = PlayMP.PlayerMainPanel:GetPos()
		
		if w > h then
			h = (w / 16) * 9
		else
			w = (h / 9) * 16
		end
		
		if x < 0 then
			x = 0
		elseif x + PlayMP.PlayerMainPanel:GetWide() > ScrW() then
			x = ScrW() - PlayMP.PlayerMainPanel:GetWide()
		elseif y < 0 then
			y = 0
		elseif y + PlayMP.PlayerMainPanel:GetTall() > ScrH() then
			y = ScrH() - PlayMP.PlayerMainPanel:GetTall()
		end
		
		
		
		if w < 73 then
			w = 128
			h = 72
		end
		
		--if w!=wW or h!=hH then
			PlayMP.PlayerMainPanel:SetSize( w, h )
		--elseif x!=xX or y!=yY then
			PlayMP.PlayerMainPanel:SetPos( x, y )
		--end
		
		self:MoveToFront()
		
		--[[draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		
		if x >= 0 and y >= 0 and x <= 30 and y <= 30 then
			--draw.RoundedBox( 0, 0, 0, 30, 30, Color( 255, 255, 255, 255 ) )
			window:SetPos( 0, 0 )
			panelSizeBut:AlphaTo( Color(255,255,255,50), 1 )
			return
		elseif x>=w-30 and y>=0 and x<=w and y<=30 then
			--draw.RoundedBox( 0, w-30, 0, 30, 30, Color( 255, 255, 255, 255 ) )
			window:SetPos( 0, 0 )
			panelSizeBut:AlphaTo( Color(255,255,255,50), 1 )
			return
		elseif x>=0 and y>=h-30 and x<=30 and y<=h then
			--draw.RoundedBox( 0, 0, h-30, 30, 30, Color( 255, 255, 255, 255 ) )
			window:SetPos( 0, 0 )
			panelSizeBut:AlphaTo( Color(255,255,255,50), 1 )
			return
		elseif x>=w-30 and y>=h-30 and x<=w and y<=h then
			--draw.RoundedBox( 0, w-30, h-30, 30, 30, Color( 255, 255, 255, 255 ) )
			window:SetPos( 0, 0 )
			panelSizeBut:AlphaTo( Color(255,255,255,50), 1 )
			return
		end]]
		
	end
	
	PlayMP:AddTextBox( PlayMP.PlayerMainPanel, 40, TOP, PlayMP:Str( "Edit_PlyMainPanel_Explain" ), PlayMP.PlayerMainPanel:GetWide() * 0.5, 15, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_CENTER, function(self, w, h) 
	
	end)
	PlayMP:AddTextBox( window, 40, TOP, PlayMP:Str( "Edit_PlyMainPanel_Explain2" ), window:GetWide() * 0.5, 15, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_CENTER )
	PlayMP:AddActionButton( window, PlayMP:Str( "Apply" ), Color(231, 76, 47), window:GetWide() * 0.5 -50, 80, 100, 30, function()
		
			local x, y = PlayMP.PlayerMainPanel:GetPos()
			local w, h = PlayMP.PlayerMainPanel:GetSize()
			
			if w > h then
				h = (w / 16) * 9
			else
				w = (h / 9) * 16
			end
			
			PlayMP:ChangeSetting( "MainPlayerData", {
					X=x,
					Y=y,
					W=w,
					H=h
				} 
			)
			
			if PlayMP:GetSetting( "디버그모드", false, true) then
				chat.AddText("w:" .. w .. " h:" .. h .. " x:" .. x .. " y:" .. y)
			end

		PlayMP.PlayerHTML:Remove()
		PlayMP.PlayerMainPanel:Close()
		window:Close()
		
		if PlayMP.isPlaying then
			PlayMP:LoadPlayer()
			for k, v in pairs( PlayMP.CurVideoInfo ) do
				if v["QueueNum"] == PlayMP.CurPlayNum then
					local vol = 0
					if PlayMP.PlayerIsMuted then vol = 0 else vol = PlayMP.GetPlayerVolume() end
					PlayMP.PlayerHTML:OpenURL("https://minbird.github.io/html/app/Pro_youtube.html?uri=" .. v.Uri .. "?Vol=" .. vol .. "?Seek=" .. PlayMP.CurPlayTime + v.startTime )
					if PlayMP:GetSetting( "FMem", false, true) then
						PlayMP.PlayerHTML:QueueJavascript([[player.setPlaybackQuality( "small" );]])
					end
				end
			end
		end
		
	end)
	
end

PlayMP.PlayerIsMuted = false
function PlayMP:isMuted()

--PlayMP.PlayerHTML:AddFunction( "PlayMP", "isMu", function(d) 
	--	PlayMP.PlayerIsMuted = d
	--end)
	--PlayMP.PlayerHTML:QueueJavascript([[PlayMP.isMu(player.isMuted());]])
	--
	if PlayMP.PlayerIsMuted == true then PlayMP.PlayerIsMuted = false else PlayMP.PlayerIsMuted = true end
	
	return PlayMP.PlayerIsMuted
end


function PlayMP:AddQueue( url, startTime, endTime, isPlaylist )

	if url == nil then return end
	
	local startTime = startTime
	local endTime = endTime

	if startTime == nil then
		startTime = 0
	end
	
	if endTime == nil then
		endTime = 0
	end

	net.Start("PlayMP:AddQueue")
		net.WriteString( url )
		net.WriteString( startTime )
		net.WriteString( endTime )
		net.WriteEntity( LocalPlayer() )
		net.WriteBool( isPlaylist )
	net.SendToServer() 
	
end



function PlayMP:SkipMusic()

	net.Start("PlayMP:SkipMusic")
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
	
end

function PlayMP:VideoTimeThink()

	for k, v in pairs( PlayMP.CurVideoInfo ) do
		if v["QueueNum"] == PlayMP.CurPlayNum then
		
			PlayMP.StartTime = v["startTime"]

			PlayMP.CurVideoLength = v["endTime"] - v["startTime"]
			
			local Tick_TimeThink = CurTime()
			local nowWait = false
			local waitTime = 0
			hook.Add( "Think", "PMP Video Time Think", function()
			
				if PlayMP.PlayerHTML == nil then 
					hook.Remove( "Think", "PMP Video Time Think")
					PlayMP:LoadPlayer()
					return
				end
				
				if 0.2 > CurTime() - Tick_TimeThink then return end
				
				PlayMP.PlayerHTML:RunJavascript([[PlayMP.PlayState(player.getPlayerState());]])
				
				PlayMP.CurPlayTime = (CurTime() - PlayMP.VideoStartTime) + PlayMP.timeError + PlayMP.SeekToTimeThink
				
				if PlayMP.CurPlayTime > PlayMP.RealPlayTime + 10 and nowWait == false then
					if waitTime > 10 then
						nowWait = true
						PlayMP:Notice( PlayMP:Str( "Playerror" ), Color(231, 76, 47), "warning" )
						chat.AddText(PlayMP:Str( "Playerror" ))
					end
					waitTime = waitTime + 0.2
				end
				
				--if PlayMP.PlayerHTML == nil or not PlayMP.PlayerHTML:IsValid() then return end
				
				Tick_TimeThink = CurTime()
					
				local vol = 0
				if PlayMP.PlayerIsMuted then vol = 0 else vol = PlayMP.GetPlayerVolume() end
				
				if PlayMP:GetSetting( "PlayX01", false, true) then
					if PlayX != nil and PlayX.Playing and PlayX.VideoRangeStatus == 1 then
						PlayMP.PlayerHTML:QueueJavascript([[player.setVolume(0)]])
					else
						PlayMP.PlayerHTML:QueueJavascript([[player.setVolume(]] .. vol .. [[)]])
					end
				else
					PlayMP.PlayerHTML:QueueJavascript([[player.setVolume(]] .. vol .. [[)]])
				end
			
				if PlayMP.SeekTo != true then
					PlayMP.PlayerHTML:RunJavascript([[PlayMP.CurTime(player.getCurrentTime());]])
				end
			
				if PlayMP.CurVideoLength < PlayMP.CurPlayTime then
					--PlayMP:StopMusic()
					return
				end
				
			end )
			
		end
	end
end


PlayMP.SeekToTimeThink = 0

function PlayMP:DoSeekToVideo( time )
	net.Start("PlayMP:DoSeekToVideo")
		net.WriteString( time )
		net.WriteEntity( LocalPlayer() )
	net.SendToServer() 
end

	net.Receive( "PlayMP:DoSeekToVideo", function()
	
		local time = net.ReadString()
		PlayMP:Seekto( time )
		
	end)
	
function PlayMP:Seekto( time )
		
	if PlayMP.PlayerHTML != nil and PlayMP.PlayerHTML:Valid() then
			
		PlayMP.SeekTo = true
			
		PlayMP.SeekToTimeThink = PlayMP.SeekToTimeThink - (PlayMP.CurPlayTime - tonumber(time))
			
		PlayMP.PlayerHTML:QueueJavascript([[player.seekTo(]] .. time + PlayMP.StartTime .. [[, true)]])
		PlayMP.SeekTo = false
			
	end
end


	local blur = Material( "pp/blurscreen" )
	local function blurEff( panel, lay, density, alpha )
		
		if not panel then return end -- error!
		local x, y = panel:LocalToScreen(0, 0)

		surface.SetDrawColor( 255, 255, 255, alpha )
		surface.SetMaterial( blur )

		for i = 1, 3 do
			blur:SetFloat( "$blur", ( i / lay ) * density )
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect( -x - 20, -y-2, ScrW() + 40, ScrH() + 40 )
		end
			
	end

local ChangeNowPlayingTextText = ""
function PlayMP:ChangeNowPlayingText(text)
	if PlayMP.nowplayingTextLabel == nil then return end
	if PlayMP.MainNotchInfoPanel == nil then return end
	
	if ChangeNowPlayingTextText == text then return end
	ChangeNowPlayingTextText = text
	
	surface.SetFont( "DebugFixed" )
	local w, h = surface.GetTextSize( text )
	PlayMP.nowplayingTextLabel:SetSize( w, h )
	PlayMP.nowplayingTextLabel:SetText( text )
	
	PlayMP.PlayerVideoTitlePanel:SetPos( 24 + w, 0 )
	PlayMP.PlayerVideoTitlePanel:SetSize( PlayMP.MainNotchInfoPanel:GetWide() - (24 + w), PlayMP.MainNotchInfoPanel:GetTall() )
	
	PlayMP.timebarBack:SetPos( 10, PlayMP.PlayerVideoTitlePanel:GetTall() - 5 )
	PlayMP.timebarBack:SetSize( PlayMP.PlayerVideoTitlePanel:GetWide() - 20, 3 )
	
	local curtime = PlayMP.CurPlayTime / PlayMP.CurVideoLength
	PlayMP.timebar:SetPos( 10, PlayMP.PlayerVideoTitlePanel:GetTall() - 5 )
	PlayMP.timebar:SetSize( (PlayMP.PlayerVideoTitlePanel:GetWide() - 20) * curtime, 3 )
end
	
function PlayMP:ShowNotchInfoPanel( boo, text )

	if boo then
		
		local ivbasGener = PlayMP:GetSetting( "DONOTshowInfoPanel", false, true )
	
		if PlayMP.NotchInfoPanel != nil and PlayMP.NotchInfoPanel:Valid() then
			hook.Remove("Think", "PlayerVideoTitle_TextSliderThink")
			hook.Remove("Tick", "MainNotchInfoPanelTimebarTick")
			PlayMP.NotchInfoPanel:Clear()
			PlayMP.NotchInfoPanel:Close()
		end
	
		PlayMP.NotchInfoPanel = vgui.Create( "DFrame" )
		PlayMP.NotchInfoPanel:SetSize( ScrW() * 0.4, 50 )
		if ivbasGener then
			PlayMP.NotchInfoPanel:SetPos(ScrW() * 0.5 - ScrW() * 0.2, 0)
			PlayMP.NotchInfoPanel:SetAlpha(0)
		else
			PlayMP.NotchInfoPanel:SetPos(ScrW() * 0.5 - ScrW() * 0.2, 20)
		end
		PlayMP.NotchInfoPanel:SetTitle( "" )
		PlayMP.NotchInfoPanel:SetDraggable( false )
		PlayMP.NotchInfoPanel:SetSkin( "Default" )
		PlayMP.NotchInfoPanel:ShowCloseButton( false )
		PlayMP.NotchInfoPanel.Paint = function(self, w, h)
			draw.RoundedBox( 0, 2, 2, w - 4, h - 4, Color( 0, 0, 0, 255 ) )
		end
		
		PlayMP.MainNotchInfoPanel = vgui.Create( "DPanel", PlayMP.NotchInfoPanel )
		PlayMP.MainNotchInfoPanel:SetPos( 5, 5 )
		PlayMP.MainNotchInfoPanel:SetSize( PlayMP.NotchInfoPanel:GetWide() - 10, PlayMP.NotchInfoPanel:GetTall() - 10 )
		PlayMP.MainNotchInfoPanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20, 255 ) ) end
		
		PlayMP.NotchInfoPanel_PlayerVideoImage = vgui.Create( "HTML", PlayMP.MainNotchInfoPanel )
		PlayMP.NotchInfoPanel_PlayerVideoImage:SetPos( -10, PlayMP.MainNotchInfoPanel:GetTall() * -0.6)
		PlayMP.NotchInfoPanel_PlayerVideoImage:SetSize( PlayMP.MainNotchInfoPanel:GetWide() + 30, PlayMP.MainNotchInfoPanel:GetTall() * 2)
		PlayMP.NotchInfoPanel_PlayerVideoImage:SetMouseInputEnabled(false)
		
		local matGradientLeft = CreateMaterial("gradient-l", "UnlitGeneric", {["$basetexture"] = "vgui/gradient-l", ["$vertexalpha"] = "1", ["$vertexcolor"] = "1", ["$ignorez"] = "1", ["$nomip"] = "1"})
		local PlayerVideoImagePanel = vgui.Create( "DPanel", PlayMP.MainNotchInfoPanel )
		PlayerVideoImagePanel:SetPos( 0, 0 )
		PlayerVideoImagePanel:SetSize( PlayMP.MainNotchInfoPanel:GetWide(), PlayMP.MainNotchInfoPanel:GetTall() )
		
		if PlayMP:GetSetting( "Use_Blur", false, true) then
			PlayerVideoImagePanel.Paint = function( self, w, h ) 
				blurEff(self, 1, 1, 255)
				surface.SetDrawColor(0, 0, 0, 255)
				surface.SetMaterial(matGradientLeft)
				surface.DrawTexturedRect( -20, 0, w - 20, h)
				
				surface.DrawTexturedRectRotated( w/2 + 20, h/2, w - 20, h , 180)
			end
		else
			PlayerVideoImagePanel.Paint = function( self, w, h ) 
				surface.SetDrawColor(0, 0, 0, 255)
				surface.SetMaterial(matGradientLeft)
				surface.DrawTexturedRect( -20, 0, w - 20, h)
				
				surface.DrawTexturedRectRotated( w/2 + 20, h/2, w - 20, h , 180)
			end
		end
		
		local nowplaying = PlayMP:Str( "Now_Playing" )
		local prepareplay = PlayMP:Str( "Prepare_Play" )
		
		local nowplayingText = nowplaying
		
		if PlayMP.isPlaying != true then
			nowplayingText = prepareplay
		end
		
		surface.SetFont( "DebugFixed" )
		local w, h = surface.GetTextSize( nowplayingText )
		
		PlayMP.nowplayingTextLabel = vgui.Create( "DLabel", PlayMP.MainNotchInfoPanel )
		PlayMP.nowplayingTextLabel:SetPos( 20, PlayMP.MainNotchInfoPanel:GetTall() / 2 - h / 2 )
		PlayMP.nowplayingTextLabel:SetFont( "DebugFixed" )
		PlayMP.nowplayingTextLabel:SetSize( w, h )
		PlayMP.nowplayingTextLabel:SetColor( Color( 255, 255, 255, 255 ) )
		PlayMP.nowplayingTextLabel:SetText( nowplayingText )
		
		local aniIamge = vgui.Create( "DPanel", PlayMP.MainNotchInfoPanel )
		aniIamge:SetPos( 2, PlayMP.MainNotchInfoPanel:GetTall() * 0.5 - 10 )
		aniIamge:SetSize( 16, 16 )
		local pos1 = 1
		local pos2 = 2
		local pos3 = 3
		aniIamge.Paint = function()
		
			draw.RoundedBox( 0, 4, 18 - (18 / pos1)+1, 2, 18 / pos1 - 1, Color(255,150,100,255/pos1) )
			draw.RoundedBox( 0, 8, 18 - (18 / pos2)+1, 2, 18 / pos2 - 1, Color(255,150,100,255/pos2) )
			draw.RoundedBox( 0, 12, 18 - (18 / pos3)+1, 2, 18 / pos3 - 1, Color(255,150,100,255/pos3) )
		
		end
		--aniIamge:SetImage( "image/ani1.png" )
		
		local text = text
		
		if text == nil then
			text = PlayMP:Str( "Unknown_Error" )
		end
		
		PlayMP.PlayerVideoTitlePanel = vgui.Create( "DPanel", PlayMP.MainNotchInfoPanel )
		PlayMP.PlayerVideoTitlePanel:SetPos( 24 + w, 0 )
		PlayMP.PlayerVideoTitlePanel:SetSize( PlayMP.MainNotchInfoPanel:GetWide() - (24 + w), PlayMP.MainNotchInfoPanel:GetTall() )
		PlayMP.PlayerVideoTitlePanel.Paint = function()end
		
		--[[surface.SetFont( "NotchInfoPanel_PlaymusicPro_Font" )
		local w, h = surface.GetTextSize( text )
		
		PlayMP.PlayerVideoTitle = vgui.Create( "DLabel", PlayMP.PlayerVideoTitlePanel )
		PlayMP.PlayerVideoTitle:SetPos( PlayMP.PlayerVideoTitlePanel:GetWide() / 2 - w / 2, PlayMP.PlayerVideoTitlePanel:GetTall() / 2 - h / 2 )
		PlayMP.PlayerVideoTitle:SetFont( "NotchInfoPanel_PlaymusicPro_Font" )
		PlayMP.PlayerVideoTitle:SetSize( w, h )
		PlayMP.PlayerVideoTitle:SetColor( Color( 255, 255, 255, 255 ) )
		PlayMP.PlayerVideoTitle:SetText( text )]]
		
		local aniImage_Think = {}
		
		aniImage_Think.aniImage = CurTime()

		
		local asdfasdf = (PlayMP.PlayerVideoTitlePanel:GetTall() / 2 - h / 2)
		
		hook.Add( "Think", "PlayerVideoTitle_aniImage_Think", function()
				
				if aniImage_Think.aniImage + 0.1 < CurTime() then
			
				if PlayMP.isPlaying == nil or PlayMP.isPlaying == false then
					nowplayingText = prepareplay
					--PlayMP:ChangeNowPlayingText(nowplayingText)
					--aniIamge:SetPos( 2, PlayMP.MainNotchInfoPanel:GetTall() / 2 - 8 )
					return
				else
					nowplayingText = nowplaying
					--PlayMP:ChangeNowPlayingText(nowplayingText)
					--aniIamge:SetPos( 2, PlayMP.MainNotchInfoPanel:GetTall() / 2 - 8 )
				end
				
				aniImage_Think.aniImage = CurTime()
				
				pos1 = pos1 + 0.2
				pos2 = pos2 + 0.2
				pos3 = pos3 + 0.2

				if pos1 > 2.8 then
					pos1 = 1
				end
				if pos2 > 2.8 then
					pos2 = 1
				end
				if pos3 > 2.8 then
					pos3 = 1
				end
				
				
				
				--aniIamge:SetImage( "image/ani" .. aniImage_Think.aniTime .. ".png" )
			end
		end)
		
		--[[if w > PlayMP.PlayerVideoTitlePanel:GetWide() then
			
			PlayMP.PlayerVideoTitle2 = vgui.Create( "DLabel", PlayMP.PlayerVideoTitlePanel )
			PlayMP.PlayerVideoTitle2:SetPos( 5, PlayMP.PlayerVideoTitlePanel:GetWide() / 2 - h / 2 )
			PlayMP.PlayerVideoTitle2:SetFont( "NotchInfoPanel_PlaymusicPro_Font" )
			PlayMP.PlayerVideoTitle2:SetSize( w, h )
			PlayMP.PlayerVideoTitle2:SetColor( Color( 255, 255, 255, 255 ) )
			PlayMP.PlayerVideoTitle2:SetText( text )
			
			local PlayerVideoTitle_TextSliderThink = {}
			
			PlayerVideoTitle_TextSliderThink.Pos = 5
			PlayerVideoTitle_TextSliderThink.Pos2 = w + 100
			PlayerVideoTitle_TextSliderThink.Think_TimeThink = CurTime()
			PlayerVideoTitle_TextSliderThink.StopTime = 0
			
			hook.Add( "Think", "PlayerVideoTitle_TextSliderThink", function()
			
				if 0.05 + PlayerVideoTitle_TextSliderThink.StopTime > CurTime() - PlayerVideoTitle_TextSliderThink.Think_TimeThink then return end
				PlayerVideoTitle_TextSliderThink.Think_TimeThink = CurTime()
				
				PlayerVideoTitle_TextSliderThink.Pos = PlayerVideoTitle_TextSliderThink.Pos - 1
				PlayerVideoTitle_TextSliderThink.Pos2 = PlayerVideoTitle_TextSliderThink.Pos2 - 1
				PlayerVideoTitle_TextSliderThink.StopTime = 0
				
				if PlayerVideoTitle_TextSliderThink.Pos == 5 then
					PlayerVideoTitle_TextSliderThink.StopTime = 5
					PlayerVideoTitle_TextSliderThink.Pos2 = w + 100
				elseif PlayerVideoTitle_TextSliderThink.Pos2 == 5 then
					PlayerVideoTitle_TextSliderThink.StopTime = 5
					PlayerVideoTitle_TextSliderThink.Pos = w + 100
				end
				
				PlayMP.PlayerVideoTitle:SetPos( PlayerVideoTitle_TextSliderThink.Pos, asdfasdf )
				PlayMP.PlayerVideoTitle2:SetPos( PlayerVideoTitle_TextSliderThink.Pos2, asdfasdf )
				
			end)
			
		end]]
		
		--PlayMP.UpdateNotchInfoPanel( text, "" )
		
		PlayMP.timebarBack = vgui.Create( "DPanel", PlayMP.PlayerVideoTitlePanel )
		PlayMP.timebarBack:SetPos( 10, PlayMP.PlayerVideoTitlePanel:GetTall() - 5 )
		PlayMP.timebarBack:SetSize( PlayMP.PlayerVideoTitlePanel:GetWide() - 20, 3 )
		PlayMP.timebarBack:SetBackgroundColor( Color( 200, 200, 200, 50 ) )
		
		
		PlayMP.timebar = vgui.Create( "DPanel", PlayMP.PlayerVideoTitlePanel )
		PlayMP.timebar:SetPos( 10, PlayMP.PlayerVideoTitlePanel:GetTall() - 5 )
		PlayMP.timebar:SetSize( 0, 3 )
		PlayMP.timebar:SetBackgroundColor( Color(255, 255, 255, 150) )
		
		local timeTick = CurTime()
		hook.Add("Tick", "MainNotchInfoPanelTimebarTick", function()
			if timeTick + 0.5 > CurTime() then return end
			if PlayMP.CurPlayTime != nil and PlayMP.CurVideoLength != nil then
				local curtime = PlayMP.CurPlayTime / PlayMP.CurVideoLength
				if curtime > 1 then curtime = 1 end
				PlayMP.timebar:SetSize( (PlayMP.PlayerVideoTitlePanel:GetWide() - 20) * curtime, 3 )
			end
		end)
		
		local ivbas = PlayMP:GetSetting( "Show_InfPan_Always", false, true )
		if ivbas != true or ivbasGener == true then
			PlayMP.NotchInfoPanel_PlayerVideoImage:SetAlpha(0)
			PlayMP.NotchInfoPanel:AlphaTo( 0, 1 )
			PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2, 0, 1)
		end
		
	else
	
		if PlayMP.NotchInfoPanel != nil and PlayMP.NotchInfoPanel:Valid() then
			hook.Remove("Tick", "MainNotchInfoPanelTimebarTick")
			hook.Remove("Think", "PlayerVideoTitle_TextSliderThink")
			PlayMP.NotchInfoPanel:Clear()
			PlayMP.NotchInfoPanel:Close()
		end
		
	end
end

function PlayMP:GetUserInfoBySID(sid)

	net.Start("PlayMP:GetUserInfoBySID")
		net.WriteString( sid )
	net.SendToServer()
	
end

--[[net.Receive( "PlayMP:GetUserInfoBySID", function( len, ply )
	data = net.ReadTable()
	return data
end)]]


function PlayMP:SetUserInfoBySID(sid, data)

	net.Start("PlayMP:SetUserInfoBySID")
		net.WriteString( sid )
		net.WriteTable( data )
	net.SendToServer()
	
end

net.Receive( "PlayMP:SetUserInfoBySID", function( len, ply )

	local data = net.ReadBool()
		
end)


PlayMP:ShowNotchInfoPanel( true, "PlayMusic Pro" )

function PlayMP.UpdateNotchInfoPanel( text, img )

	if PlayMP.InfoPanelPlayerVideoTitle != nil then 
		--PlayMP.InfoPanelPlayerVideoTitle:Clear()
		PlayMP.InfoPanelPlayerVideoTitle:Remove()
	end
	
	if PlayMP.InfoPanelPlayerVideoTitle2 != nil then 
		--PlayMP.InfoPanelPlayerVideoTitle2:Clear()
		PlayMP.InfoPanelPlayerVideoTitle2:Remove() 
		hook.Remove("Think", "PlayerVideoTitle_TextSliderThink")
	end
	
	surface.SetFont( "NotchInfoPanel_PlaymusicPro_Font" )
	local w, h = surface.GetTextSize( text )
		
	PlayMP.InfoPanelPlayerVideoTitle = vgui.Create( "DLabel", PlayMP.PlayerVideoTitlePanel )
	PlayMP.InfoPanelPlayerVideoTitle:SetPos( PlayMP.PlayerVideoTitlePanel:GetWide() / 2 - w / 2, PlayMP.PlayerVideoTitlePanel:GetTall() / 2 - h / 2 )
	PlayMP.InfoPanelPlayerVideoTitle:SetFont( "NotchInfoPanel_PlaymusicPro_Font" )
	PlayMP.InfoPanelPlayerVideoTitle:SetSize( w, h )
	PlayMP.InfoPanelPlayerVideoTitle:SetColor( Color( 255, 255, 255, 255 ) )
	PlayMP.InfoPanelPlayerVideoTitle:SetText( text )
	
	local asdfasdf = (PlayMP.PlayerVideoTitlePanel:GetTall() / 2 - h / 2)
	
	if w > PlayMP.PlayerVideoTitlePanel:GetWide() then
			
		PlayMP.InfoPanelPlayerVideoTitle2 = vgui.Create( "DLabel", PlayMP.PlayerVideoTitlePanel )
		PlayMP.InfoPanelPlayerVideoTitle2:SetPos( 5, PlayMP.PlayerVideoTitlePanel:GetWide() / 2 - h / 2 )
		PlayMP.InfoPanelPlayerVideoTitle2:SetFont( "NotchInfoPanel_PlaymusicPro_Font" )
		PlayMP.InfoPanelPlayerVideoTitle2:SetSize( w, h )
		PlayMP.InfoPanelPlayerVideoTitle2:SetColor( Color( 255, 255, 255, 255 ) )
		PlayMP.InfoPanelPlayerVideoTitle2:SetText( text )
			
		local PlayerVideoTitle_TextSliderThink = {}
			
		PlayerVideoTitle_TextSliderThink.Pos = 5
		PlayerVideoTitle_TextSliderThink.Pos2 = w + 100
		PlayerVideoTitle_TextSliderThink.Think_TimeThink = CurTime()
		PlayerVideoTitle_TextSliderThink.StopTime = 0
			
		hook.Add( "Think", "PlayerVideoTitle_TextSliderThink", function()
			
			if 0.05 + PlayerVideoTitle_TextSliderThink.StopTime > CurTime() - PlayerVideoTitle_TextSliderThink.Think_TimeThink then return end
			PlayerVideoTitle_TextSliderThink.Think_TimeThink = CurTime()
			
			PlayerVideoTitle_TextSliderThink.Pos = PlayerVideoTitle_TextSliderThink.Pos - 1
			PlayerVideoTitle_TextSliderThink.Pos2 = PlayerVideoTitle_TextSliderThink.Pos2 - 1
			PlayerVideoTitle_TextSliderThink.StopTime = 0
				
			if PlayerVideoTitle_TextSliderThink.Pos == 5 then
				PlayerVideoTitle_TextSliderThink.StopTime = 5
				PlayerVideoTitle_TextSliderThink.Pos2 = w + 100
			elseif PlayerVideoTitle_TextSliderThink.Pos2 == 5 then
				PlayerVideoTitle_TextSliderThink.StopTime = 5
				PlayerVideoTitle_TextSliderThink.Pos = w + 100
			end
				
			PlayMP.InfoPanelPlayerVideoTitle:SetPos( PlayerVideoTitle_TextSliderThink.Pos, asdfasdf )
			PlayMP.InfoPanelPlayerVideoTitle2:SetPos( PlayerVideoTitle_TextSliderThink.Pos2, asdfasdf )
				
		end)
			
	end
	
	PlayMP.NotchInfoPanel_PlayerVideoImage:SetHTML( "<img src=\"" .. img .. "\" width=\" " .. PlayMP.NotchInfoPanel:GetWide() + 10 .. " \" height=\" " .. PlayMP.NotchInfoPanel:GetWide() / 16 * 9 + 10 .. "\">" )

end



	function PlayMP.PlayerCommand(ply, text, teamchat, isdead, station, c, args)
	
		if ( ply and LocalPlayer() and ply == LocalPlayer() ) then
		
			if string.Left(text, 3) == "!pm" then
			
				local entName = PlayMP:ExtractCommandArgs(text)

				
				if entName == nil then return end
				
				if entName == "open" or entName == "" then
					PlayMP:CreatFrame( "Playmusic Pro", "PlaymusicP_MainMenu" )
					PlayMP:MainMenu()
					return
				end
				
				if string.find(entName,"youtube")!=nil then
					PlayMP:AddQueue( entName )
				elseif string.find(entName,"youtu.be")!=nil then
					PlayMP:AddQueue( entName )
				else
					PlayMP:Notice( PlayMP:Str( "wrongUrl" ), Color(231, 76, 47), "warning" )
				end
				
			end
		
		end
	
	end
	
	hook.Add("OnPlayerChat", "PlayMP:PlayerCommand", PlayMP.PlayerCommand )
	
	function PlayMP:ExtractCommandArgs(text)
	
		if string.Left(text, 3) == "!pm" then
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
	
	hook.Add( "Tick", "PMP_KeyDown", function()
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
	end )



net.Receive( "PlayMP:NoticeForPlayer", function()
	local tag = net.ReadString() 
	local color = net.ReadTable()
	local type = net.ReadString()
	local data = net.ReadTable()
	
	if data then
		PlayMP:Notice( PlayMP:Str( tag, data[1] ), color, type )
	else
		PlayMP:Notice( PlayMP:Str( tag ), color, type )
	end
	
end)

net.Receive( "PlayMP:StopMusic", function()

	PlayMP:StopMusic()

end)

net.Receive( "PlayMP:AddQueue", function( )

	local video = net.ReadTable()

	table.insert( PlayMP.CurVideoInfo, {
		Length = video.Length, 
		Title = video.Title, 
		Channel = video.Channel, 
		BroadCast = video.BroadCast, 
		Image = video.Image,
		ImageLow = video.ImageLow,
		Uri = video.Uri,
		QueueNum = table.Count( PlayMP.CurVideoInfo ) + 1,
		PlayUser = video.PlayUser,
		startTime = video.startTime,
		endTime = video.endTime
		
		
	} )

end)

net.Receive( "PlayMP:Playmusic", function()

	--PlayMP.CurVideoInfo = net.ReadTable()
	
	PlayMP:ReceiveMusicDataAndPlay( tonumber( net.ReadString() ) )

	
end)

function PlayMP:ReceiveMusicDataAndPlay( num, curvinfo, time )

	PlayMP.CurPlayNum = num
	if curvinfo then
		PlayMP.CurVideoInfo = curvinfo
	end
	
	for k, v in pairs( PlayMP.CurVideoInfo ) do
		if v["QueueNum"] == PlayMP.CurPlayNum then
			local image
			if PlayMP:GetSetting( "FMem", false, true) then
				image = v["ImageLow"]
			else
				image = v["Image"]
			end
			PlayMP.timeError = 0
			--PlayMP:ShowNotchInfoPanel( true, v["Title"] )

			if time then
				PlayMP:PlayMusic( v["Uri"], time, v.endTime )
				PlayMP.timeError = time
			else
				PlayMP:PlayMusic( v["Uri"], v.startTime, v.endTime )
			end
			PlayMP:Notice( PlayMP:Str( "StartPlay", v["Title"] ), Color(60, 60, 60), "notice" )
			
			local function ChangeState()
				if PlayMP.CurVideoInfo then
					--for k, v in pairs( PlayMP.CurVideoInfo ) do
						--if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
							PlayMP.PlayerVideoImage:SetHTML( "<img src=\"" .. image .. "\" width=\" " .. ScrW() * 0.8 .. " \" height=\" " .. ScrH() * 0.8 .. "\">" )
							PlayMP.PlayerVideoTitle:SetText( v["Title"] )
							PlayMP.PlayerVideoChannel:SetText( v["Channel"] )
							--PlayMP.NotchInfoPanel_PlayerVideoImage:SetHTML( "<img src=\"" .. image .. "\" width=\" " .. PlayMP.NotchInfoPanel:GetWide() + 10 .. " \" height=\" " .. PlayMP.NotchInfoPanel:GetWide() / 16 * 9 + 10 .. "\">" )
						--end
					--end
				end
			end
			
			if PlayMP.MainMenuPanel == nil then
				--for k, v in pairs( PlayMP.CurVideoInfo ) do
					--if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
						--local image
						--if PlayMP:GetSetting( "FMem", false, true) then
							--image = v["ImageLow"]
						--else
							--image = v["Image"]
						--end
						--PlayMP.NotchInfoPanel_PlayerVideoImage:SetHTML( "<img src=\"" .. image .. "\" width=\" " .. PlayMP.NotchInfoPanel:GetWide() + 10 .. " \" height=\" " .. PlayMP.NotchInfoPanel:GetWide() / 16 * 9 + 10 .. "\">" )
					--end
				--end
			elseif PlayMP.MainMenuPanel:IsValid() then
				ChangeState()
				
				if PlayMP.CurMenuPage == "queueList" then
					PlayMP:ChangeMenuWindow( "queueList" )
				end
			end
			
			PlayMP.UpdateNotchInfoPanel( v["Title"], image )
			
		end
	end
	
end

net.Receive( "PlayMP:GetQueueData", function()
	PlayMP.CurVideoInfo = net.ReadTable()
	PlayMP.CurPlayNum = tonumber(net.ReadString())
	if PlayMP.MainMenuPanel != nil then
		if PlayMP.CurMenuPage == "queueList" then
			PlayMP:ChangeMenuWindow( "queueList" )
		end
	end
end)

function PlayMP:GetQueueData(getself)
	net.Start("PlayMP:GetQueueData")
		net.WriteBool(getself)
		net.WriteEntity(LocalPlayer())
	net.SendToServer()
end


include("cl_mainmenu.lua")

local function changePlayMode( mode )
	
	if PlayMP.PlayerMainPanel != nil then
			PlayMP.PlayerMainPanel:Remove()
			PlayMP.PlayerMainPanel = nil
		end
	
	if mode == "worldScr" then
		if PlayMP.WorldPlayerHTML != nil and PlayMP.WorldPlayerHTML:IsValid() then
			
			PlayMP.PlayerHTML = PlayMP.WorldPlayerHTML
			
			local setError = PlayMP:GetSetting( "SyncMediaAndPlayer", false, true)

			PlayMP.PlayerHTML:AddFunction("PlayMP", "CurTime", function( time )
				PlayMP.RealPlayTime = tonumber(time)
				
				if not setError then return end
				
				if ( PlayMP.RealPlayTime - PlayMP.StartTime > PlayMP.CurPlayTime + 1.5 ) or ( PlayMP.RealPlayTime + 1.5 < PlayMP.CurPlayTime - PlayMP.StartTime ) then
					PlayMP.PlayerHTML:QueueJavascript([[player.seekTo(]] .. PlayMP.CurPlayTime + PlayMP.StartTime .. [[, true)]])
					--PlayMP.timeError = PlayMP.timeError + (curTime - PlayMP.CurPlayTime)
					print("[PlayM Pro] Time error: " .. PlayMP.CurPlayTime - PlayMP.RealPlayTime .. "s! Try set to " .. PlayMP.CurPlayTime + PlayMP.StartTime .. "s...")

				end
				

				
			end)
			
		else
			return "error"
		end
	end
	
	PlayMP:LoadPlayer()
	
	if PlayMP.isPlaying then
		for k, v in pairs( PlayMP.CurVideoInfo ) do
			if v["QueueNum"] == PlayMP.CurPlayNum then
				local vol = 0
				if PlayMP.PlayerIsMuted then vol = 0 else vol = PlayMP.GetPlayerVolume() end
				PlayMP.PlayerHTML:OpenURL("https://minbird.github.io/html/app/Pro_youtube.html?uri=" .. v.Uri .. "?Vol=" .. vol .. "?Seek=" .. PlayMP.CurPlayTime + v.startTime )
				if PlayMP:GetSetting( "FMem", false, true) then
					PlayMP.PlayerHTML:QueueJavascript([[player.setPlaybackQuality( "small" );]])
				end
			end
		end
		
	else
	
		PlayMP.WorldPlayerHTML:OpenURL("https://minbird.github.io/html/app/player.html")
		
	end
	
	timer.Simple( 0.1, function()
		if mode == "worldScr" then
			if not PlayMP.isPlaying then 
				PlayMP.ChangeStrOnWorldVideoViewer("")
			end
		else
			PlayMP.ChangeStrOnWorldVideoViewer(PlayMP:Str( "Enable_The_Player" ))
		end
	end)
	
	return "complete"
end

function PlayMP.ChangeStrOnWorldVideoViewer(str)

	local str = str

	if not isstring(str) then
		str = "Error"
	end
	
	
	if PlayMP.WorldPlayerHTML == nil or not PlayMP.WorldPlayerHTML:IsValid() then return end

	PlayMP.WorldPlayerHTML:QueueJavascript([[
		
		var str1 = document.getElementById('text1');
		str1.firstChild.data = ']] .. str ..  [[';
			
	]])


end

function PlayMP:GetUserInfoAll()
	net.Start("PlayMP:SendUserInfoAll")
	net.SendToServer()

end

function PlayMP:GetCacheSize()
	net.Start("PlayMP:GetCacheSize")
	net.SendToServer()
end

function PlayMP:RemoveCache()
	net.Start("PlayMP:RemoveCache")
	net.SendToServer()
end

function PlayMP:ChangConVar( name, value )

	net.Start("PlayMP:ChangConVar")
		net.WriteString(name)
		net.WriteFloat(tonumber(value))
	net.SendToServer()

end

net.Receive( "PlayMP:ChangePlayerMode", function( len, ply )
	
	local mode = net.ReadString()
	
	 PlayMP:ChangePlayerMode( mode )
		
end)

function PlayMP:ChangePlayerMode( mode, panel )


	chat.AddText(PlayMP:Str( "Changed_PlayMode" ))
	
	if mode == "nomal" then
		chat.AddText(PlayMP:Str( "PMod_Now_NomalMode" ))
		PlayMP.PlayerMode = nil
		PlayMP.WorldPlayerHTML:OpenURL("https://minbird.github.io/html/app/player.html")
		changePlayMode( PlayMP.PlayerMode )
		return
	end
	
	if PlayMP.PlayerMode != nil and PlayMP.PlayerMode == "worldScr" then
		--if PlayMP.worldScrIsCreate == nil or PlayMP.worldScrIsCreate == false then
			PlayMP.PlayerMode = nil
		--end
		
		chat.AddText(PlayMP:Str( "PMod_Now_NomalMode" ))
		PlayMP.WorldPlayerHTML:OpenURL("https://minbird.github.io/html/app/player.html")

	else
		PlayMP.PlayerMode = "worldScr"
		chat.AddText(PlayMP:Str( "PMod_Now_WorldViewerMode" ))
		
		if PlayMP.isPlaying then
			PlayMP.ChangeStrOnWorldVideoViewer(PlayMP:Str( "Loading_Player" ))
		end

		--PlayMP.LoadWorldPlayer()
		--PlayMP.PlayerHTML = PlayMP.WorldPlayerHTML
	end

	changePlayMode( PlayMP.PlayerMode )


end

net.Receive( "player_connect_PlayMP:Playmusic", function()


	PlayMP.CurVideoInfo = net.ReadTable()
	local pn = tonumber( net.ReadString() )
	local playing = net.ReadString()
	local pt = tonumber( net.ReadString() )
	if pt and playing == "playing" then
		PlayMP:ReceiveMusicDataAndPlay( pn, nil, pt )
	else
		PlayMP.CurPlayNum = pn
	end

end)

timer.Simple( 1, function()

		net.Start("PlayMP:GetUserInfoBySID")
			net.WriteString( LocalPlayer():SteamID() )
		net.SendToServer()
	
		net.Receive( "PlayMP:GetUserInfoBySID", function( len, ply )
			PlayMP.LocalPlayerData = net.ReadTable()
			if PlayMP.LocalPlayerData == nil then 
				return
			end
		end)

end)

net.Receive( "PlayMP:GetUserInfoBySID2", function( len, ply )
			PlayMP.LocalPlayerData = net.ReadTable()
			if PlayMP.LocalPlayerData == nil then 
				return
			end
		end)

net.Start("player_connect_PlayMP:Playmusic")
net.SendToServer()