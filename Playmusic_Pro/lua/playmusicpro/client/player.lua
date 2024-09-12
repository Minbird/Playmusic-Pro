print("[Playmusic Pro] Client player...")

PlayMP.Player = {}
PlayMP.Player.Allow_Error_Time = 1.0 -- 허용하는 오차 범위 (초)
PlayMP.Player.Retry_Time = 10
PlayMP.Player.Time_think_Time_Sec = 0.2 -- 플레이어 상태 재갱신 빈도 (초)

PlayMP.Player.Queue = {}
PlayMP.Player.Cur_Play_Num = 0

PlayMP.Player.State = 0
PlayMP.Player.Engine_type = "gmod"
PlayMP.Player.Player_type = "YTDL"

PlayMP.Player.Cur_media_start_time = 0
PlayMP.Player.Cur_play_time = 0
PlayMP.Player.Cur_Media_Length = 0
PlayMP.Player.Real_play_time = 0
PlayMP.Player.Last_Valid_Real_play_time = 0
PlayMP.SeekToTimeThink = 0
PlayMP.Player.Media_Start_Position = 0
PlayMP.timeError = 0

PlayMP.Player.isPending = false
PlayMP.Player.isPlaying = false
PlayMP.Player.isMuted = false
PlayMP.Player.isSeeking = false
PlayMP.Player.isInReady = false
PlayMP.Player.isDownVolumeWithVoiceChat = false
PlayMP.Player.VolumeTo_isWorking = false
PlayMP.Player.Cur_Volume = math.Clamp(GetConVar("playmp_volume"):GetInt() or 20, 0, 100)
PlayMP.Player.Cur_VolumeSFX = GetConVar("volume_sfx"):GetFloat()
-- 현재 플레이어의 볼륨을 캐싱할 변수들 (위 2개)
-- 이 convar는 convars.lua에서 선언되고, player.lua는 항상 convars.lua보다 늦게 인클루드되어야 함.

PlayMP.PlayerURLList = {}
PlayMP.PlayerURLList[2] = PlayMP.urls.embed
PlayMP.PlayerURLList[1] = PlayMP.urls.iframe
PlayMP.PlayerURLList[0] = PlayMP.urls.ytdl_play

PlayMP.SelectorList = {}
PlayMP.SelectorList[2] = PlayMP.selector.embed
PlayMP.SelectorList[1] = PlayMP.selector.iframe
PlayMP.SelectorList[0] = PlayMP.selector.ytdl

PlayMP.Player.Url = PlayMP.urls.ytdl_play
PlayMP.Player.QuerySelector = PlayMP.selector.ytdl

PlayMP.Player.TimeThink_Remover = nil

-- 만약 크로미움 플레이어로 실행되면, PlayMP.PlayState 를 계속 실행해야 재생이 올바르게 ㅔ된다. 주로 PlayMP.Player:Do_ready()에서 사용함
local chromium_player = function( url )

    v = PlayMP.Setting:get( "MainPlayerData")

    local main_panel = vgui.Create( "DFrame" )
    main_panel:SetPos( v.X, v.Y )
    main_panel:SetSize( v.W, v.H )
    main_panel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) ) end
    main_panel:SetMouseInputEnabled(false)
    main_panel:SetSizable( true )
    main_panel:ShowCloseButton( false )

    local PlayerHTML = vgui.Create("DHTML", main_panel)
    PlayerHTML:SetPos( 0, 0 )
    PlayerHTML:SetSize( v.W, v.H )
    PlayerHTML:SetPaintedManually(false)
    PlayerHTML:SetMouseInputEnabled(false)
    PlayerHTML:SetEnabled(true)
    PlayerHTML:SetHTML("")

    local playerUrl = ""

    if PlayMP.Player.Player_type == "YTDL" then
        playerUrl = PlayMP.urls.ytdl_play
    elseif PlayMP.Player.Player_type == "embed" then
        playerUrl = PlayMP.urls.embed
    elseif PlayMP.Player.Player_type == "iframe" then
        playerUrl = PlayMP.urls.iframe
    end


    PlayerHTML:OpenURL(playerUrl .. url)

    PlayerHTML:AddFunction("PlayMP", "PlayState", function( player_state )
        if player_state == nil then return end
        if PlayMP.Player.State == player_state then return end

        PlayMP.Player.State = player_state
            
        local stns = {}
        stns[1] = PlayMP:Str( "PS_unstarted" ) -- -1
        stns[2] = PlayMP:Str( "Prepare_Play" ) -- 0
        stns[3] = PlayMP:Str( "Now_Playing" ) -- 1
        stns[4] = PlayMP:Str( "PS_paused" ) -- 2
        stns[5] = PlayMP:Str( "PS_buffering" ) -- 3
        stns[6] = "" -- no use
        stns[7] = PlayMP:Str( "PS_videoCued" ) -- 5
            
        PlayMP.Player.ChangeStateText(stns[tonumber(player_state)+2])
            
        if PlayMP.Player.State == 1 then
            PlayMP.Player.Im_ready()
        end
    end)

    function PlayerHTML:OnDocumentReady( url ) -- volumecontrol
		PlayerHTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.setVolume(]].. 0 .. [[);]])
		PlayerHTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.seekTo(]] .. PlayMP.Player.Cur_play_time .. [[);]])
	end


    PlayerHTML:AddFunction("PlayMP", "CurTime", function( time ) -- time error
        PlayMP.Player.Real_play_time = tonumber(time)
    end)



    PlayerHTML.ConsoleMessage = function(pself, msg, ...) -- for clean console
        if msg then
            if string.find(msg, "XMLHttpRequest") then return end
            if string.find(msg, "Unsafe JavaScript attempt to access") then return end
            if string.find(msg, "seekTo") then return end
            if string.find(msg, "setVolume") then return end
            if string.find(msg, "getPlayerState") then return end
            if string.find(msg, "MinPlaymusic") then return end
        end
    end

    if PlayMP:GetSetting( "Show_MediaPlayer", false, true ) then
		main_panel:SetPos( v.X, v.Y )
		main_panel:SetSize( v.W, v.H )
		main_panel:SetPaintedManually(false)
		PlayerHTML:SetPaintedManually(false)
	else
		main_panel:SetPos( -10, -10 )
		main_panel:SetSize( 1, 1 )
		main_panel:SetPaintedManually(true)
		PlayerHTML:SetPaintedManually(true)
	end

    return main_panel, PlayerHTML

end

-- gmod 내장 플레이어 사용할 때 사용하는 것 모음 주로 PlayMP.Player:Do_ready()에서 사용함
local gmod_player = function( url )

    sound.PlayURL ( PlayMP.urls.ytdl_download .. url .. ".mp3", "noblock", function( station )
        if ( IsValid( station ) ) then
            PlayMP.Player.Player_Station = station
            PlayMP.Player.Player_Station:SetVolume(0) 
            PlayMP.Player.Im_ready()
            return station
        else
            timer.Simple( PlayMP.Player.Retry_Time, function() 
                PlayMP.Player:Reload_Player()
            end) -- 재시도. 아마 플뮤 서버에서 다운로드 중이라 404임. YTDL도 내부적으론 새로고침 함.
        end
    end )

end

-- gmod 내장 플레이어 고질병 대처 방안. 버퍼가 다 안차면 원하는 구간으로 못 옮김. 씨---발 내 6시간
-- 그리고 정확도가 떨어짐. 정확히 될 수도 있고, 10초 이상 차이가 날 수도 있음
function PlayMP.Player.Station_CheckBuffer( time )
    if not PlayMP.Player.Engine_type == "gmod" then return end
    local lastCheck = 0
	local wasValid = false
    hook.Add("Think", "PlayMP_CheckBufferedTime", function()
		local curTime = CurTime()

		if (lastCheck or 0) + 0.1 > curTime then return end

		lastCheck = curTime

        local mp3Channel = PlayMP.Player.Player_Station
		local isValid = mp3Channel and mp3Channel:IsValid()
        local curMediaTime = time

        -- 재생 중이 아닐 땐 삭제
        if not PlayMP.Player.isPlaying then
            hook.Remove("Think", "PlayMP_CheckBufferedTime")
        end

		-- Detect if the audio channel was stopped.
		if wasValid and !isValid then
			hook.Remove("Think", "PlayMP_CheckBufferedTime")
		end

		if isValid then
			-- If our song has buffered enough, now we can seek to our desired time.
			if mp3Channel:GetBufferedTime() >= (curMediaTime or 0) then
				mp3Channel:SetTime(curMediaTime, true)
				hook.Remove("Think", "PlayMP_CheckBufferedTime")
			end

			wasValid = isValid
		end
	end)
end


-- 클라에서 서버에게 준비 완료라고 전달하는 함수. 동시에 클라에서는 영상 일시정지하고 대기함
function PlayMP.Player:Im_ready()

    if PlayMP.Setting:get( "No_Play_Always" ) then return end

    PlayMP.Player.isLoading = false

    if not PlayMP.Player.isPending then
        return
    end

    PlayMP.net.Im_ready()

    if PlayMP.Player.Engine_type == "chromium" then
        PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.pauseVideo();]])
        PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.setVolume(]] .. 0 .. [[)]])
    else
        PlayMP.Player.Player_Station:SetVolume(0) -- 노래가 재생 시작되진 않지만, 혹시 모르니 볼륨 0
        PlayMP.Player.Player_Station:Pause()
    end
end

PlayMP.AddQueue = function( self, url, startTime, endTime, isPlaylist, removeOldMedia )
	PlayMP.net.addQueue( url, startTime, endTime, isPlaylist, removeOldMedia )
end

-- 미디어의 시작 위치를 설정하는 명령. 단순히 재생 중에 영상 재생위치 변경을 원한다면, PlayMP.Player:Seekto( time )를 사용하시오
function PlayMP.Player.Set_Start_Time( time )
    PlayMP.Player.Media_Start_Position = time
    if PlayMP.Player.Player_HTML != nil and PlayMP.Player.Player_HTML:Valid() then
		PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.seekTo(]] .. time .. [[, true)]])
    else
        if PlayMP.Player.Player_Station == nil or not IsValid(PlayMP.Player.Player_Station) then return end
        PlayMP.Player.Player_Station:SetTime( time, true )
        PlayMP.Player.Station_CheckBuffer( time )
    end
end

-- 모든 유저의 플레이어가 준비되고, 실제로 재생을 시작할 때 실행하는 함수. 보통 서버에서 요청한다. 그 외의 경우는 클라에서 새로고침 할 때...
function PlayMP.Player:Play()

    if PlayMP.Setting:get( "No_Play_Always" ) then return end

    PlayMP.Player.isInReady = false
    PlayMP.Player.isLoading = false

    if not PlayMP.Player.isPlaying then -- 재생 중에 호출될 수도 있음. 재생 중에는 이 변수가 초기화되면 안 됨!
        PlayMP.Player.isPending = false
        PlayMP.Player.isPlaying = true
        PlayMP.Player.Cur_media_start_time = CurTime()
        PlayMP.Player.Cur_play_time = 0

        local data = PlayMP.Player.Get_now_music()
        PlayMP.Player.Set_Start_Time( tonumber(data.startTime) )
        PlayMP.UpdateNotchInfoPanel( data.Title, data.Image )

        PlayMP:AddMediaHistory( {
            thumbnails = data["Image"],
            title = data["Title"],
            channelTitle = data["Channel"],
            Uri = data["Uri"]
        } )
    else
        PlayMP.Player:Seekto(PlayMP.Player.Cur_play_time) -- 만약 재생 중이 호출되었다면, 원래 위치로 되돌아온다.
    end

    if PlayMP.Player.Engine_type == "chromium" then
        if PlayMP.Player.Player_HTML == nil or not PlayMP.Player.Player_HTML:IsValid() then return end
        PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.playVideo();]])

        if PlayMP.Player.isMuted then
            PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.mute();]])
        else
            PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.setVolume(]] .. PlayMP.Player.get_vol() .. [[)]])
        end

    elseif PlayMP.Player.Engine_type == "gmod" then
        if not IsValid(PlayMP.Player.Player_Station) then return end
        PlayMP.Player.Player_Station:Play()
        PlayMP.Player.Player_Station:SetVolume( PlayMP.Player.calculate_sfx_vol(PlayMP.Player.Cur_VolumeSFX, PlayMP.Player.get_vol() )) -- 1이 100%임
        if PlayMP.Player.isMuted then
            PlayMP.Player.Player_Station:SetVolume(0)
        end

    end

end

function PlayMP.Player:Stop()

    if PlayMP.Player.Player_HTML != nil and PlayMP.Player.Player_HTML:Valid() then
        PlayMP.Player.Player_HTML:Remove()
        PlayMP.Player.Player_Frame:Remove()
    end

    if PlayMP.Player.Player_Station != nil and PlayMP.Player.Player_Station:IsValid() then
        PlayMP.Player.Player_Station:Stop()
        PlayMP.Player.Player_Station = nil
    end

    PlayMP.Player:Remove_TimeThink()

    PlayMP.Player.State = 0
    --PlayMP.Player.Cur_Play_Num = PlayMP.Player.Cur_Play_Num - 1
    PlayMP.Player.isPending = false
    PlayMP.Player.isPlaying = false
    PlayMP.Player.isMuted = false
    PlayMP.Player.isSeeking = false
    PlayMP.Player.isInReady = false
    PlayMP.Player.isDownVolumeWithVoiceChat = false
    PlayMP.Player.VolumeTo_isWorking = false

    if PlayMP.Player.Cur_Play_Num < 0 then PlayMP.Player.Cur_Play_Num = 0 end
    PlayMP.Player.ChangeStateText(PlayMP:Str( "Prepare_Play" ))

end

-- 클라가 서버에서 재생 중지 요청하는 함수.
function PlayMP:RemoveQueue( num )
	PlayMP.net.RemoveQueue( num )
end



function PlayMP.Player.Get_now_music()
    return PlayMP.Player.Queue[PlayMP.Player.Cur_Play_Num]
end


function PlayMP.Player:Remove_TimeThink()
    if PlayMP.Player.TimeThink_Remover == nil then return end
    PlayMP.Player.TimeThink_Remover()
    PlayMP.Player.TimeThink_Remover = nil
end



-- 미디어 재생 전 플레이어를 준비하는 함수. 아직 실제로 재생이 되면 안 됨.
function PlayMP.Player:Do_ready( url )

    if PlayMP.Setting:get( "No_Play_Always" ) then return end

    PlayMP.Player.isInReady = true

    if not PlayMP.Player.isPlaying then
        PlayMP.Player.isPending = true
        PlayMP.Player.Player_Frame = nil
        PlayMP.Player.Player_HTML = nil
        PlayMP.Player.Player_Station = nil
        PlayMP.SeekToTimeThink = 0
        PlayMP.Player.Media_Start_Position = 0
        PlayMP.timeError = 0
        PlayMP.Player.Cur_play_time = 0
        local v = PlayMP.Player.Get_now_music()
        PlayMP.Player.Cur_media_start_time = v["startTime"]
        PlayMP.Player.Cur_Media_Length = v["endTime"] - v["startTime"]

        PlayMP:Notice( PlayMP:Str( "StartPlay", v.Title ), Color(60, 60, 60), "notice" )
    end

    -- 미디어 재생정보는 네트워크 리시브 하면서 바로 처리함. 특히 재생 번호
    if PlayMP.Player.Player_HTML != nil and PlayMP.Player.Player_HTML:Valid() then -- 중복되면 안되니까 삭제해야 함
        PlayMP.Player.Player_HTML:Remove()
        PlayMP.Player.Player_Frame:Remove()
    end

    if IsValid(PlayMP.Player.Player_Station) then
        PlayMP.Player.Player_Station:Stop()
    end

    local curSet = PlayMP:GetSetting( "PlayerType", false, true )
    local curSet_Engine = PlayMP:GetSetting( "PlayerEngine", false, true )

    local PlayerTypeList = {}
    PlayerTypeList[0] = "YTDL"
    PlayerTypeList[1] = "iframe"
    PlayerTypeList[2] = "embed"

    local PlayerEngineList = {}
    PlayerEngineList[0] = "gmod"
    PlayerEngineList[1] = "chromium"

    -- 플레이어 타입을 갱신한다.
    PlayMP.Player.Engine_type = PlayerEngineList[tonumber(curSet_Engine)]
    PlayMP.Player.Player_type = PlayerTypeList[tonumber(curSet)]

	if curSet == nil then curSet = 0 end
	local typeList = {}
	typeList[0] = PlayMP.PlayerURLList[0]
	typeList[1] = PlayMP.PlayerURLList[1]
	typeList[2] = PlayMP.PlayerURLList[2]
	local selectorList = {}
	selectorList[0] = PlayMP.SelectorList[0]
	selectorList[1] = PlayMP.SelectorList[1]
	selectorList[2] = PlayMP.SelectorList[2]
	PlayMP.Player.Url = typeList[curSet]
	PlayMP.Player.QuerySelector = selectorList[curSet]

    if PlayMP.Player.Engine_type == 'chromium' then
        print(url)
        PlayMP.Player.Player_Frame, PlayMP.Player.Player_HTML = chromium_player(url)
    else
        PlayMP.Player.Player_Station = gmod_player(url)
    end
    
    PlayMP.Player:Video_Time_Think() -- 플레이어의 생태를 확인하고, 재생 준비 되었는지 확인해야하기 때문에 지금 호출
end


-- 미디어 재생 위치 수정
function PlayMP.Player:Seekto( time )

    if time == nil then return end

    PlayMP.Player.isSeeking = true

    PlayMP.SeekToTimeThink = PlayMP.SeekToTimeThink - (PlayMP.Player.Cur_play_time - tonumber(time))
		
	if PlayMP.Player.Engine_type == "chromium" then
		PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.seekTo(]] .. time + PlayMP.Player.Media_Start_Position .. [[, true)]])
        PlayMP.Player.isSeeking = false
    elseif PlayMP.Player.Engine_type == "gmod" then
        --PlayMP.Player.Player_Station:SetTime( time + PlayMP.Player.Media_Start_Position, true )
        PlayMP.Player.Station_CheckBuffer( time + PlayMP.Player.Media_Start_Position )
    end
end


function PlayMP:DoSeekToVideo( time )
	PlayMP.net.requestSeek( time )
end


-- change player state text in UI and Menu
function PlayMP.Player.ChangeStateText( text )
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

    local curtime = PlayMP.Player.Cur_play_time / PlayMP.Player.Cur_Media_Length
	PlayMP.timebar:SetPos( 10, PlayMP.PlayerVideoTitlePanel:GetTall() - 5 )
	PlayMP.timebar:SetSize( (PlayMP.PlayerVideoTitlePanel:GetWide() - 20) * curtime, 3 )
end


-- 볼륨 가져오기
function PlayMP.Player.get_vol()
    --return math.Clamp(GetConVar("playmp_volume"):GetInt(), 0, 100) -- getconvar는 느리니까, 캐싱해서 사용하세욧!!! 이라고 gmod wiki에 있었음
    return math.Clamp(PlayMP.Player.Cur_Volume, 0, 100)
end

-- 볼륨 설정하기 1에서 100까지
function PlayMP.Player:set_vol( vol )
    RunConsoleCommand("playmp_volume", vol) -- for data save

    if PlayMP.Player.Engine_type == "chromium" then
	    if PlayMP.Player.Player_HTML == nil or not PlayMP.Player.Player_HTML:Valid() then return end
	    PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.setVolume(]] .. PlayMP.Player.get_vol() .. [[)]])
    
    elseif PlayMP.Player.Engine_type == "gmod" then
        if PlayMP.Player.Player_Station == nil or not IsValid(PlayMP.Player.Player_Station) then return end
        PlayMP.Player.Player_Station:SetVolume( PlayMP.Player.calculate_sfx_vol(PlayMP.Player.Cur_VolumeSFX, vol) ) -- effect sound 볼륨 가져오기. 크로미움 플레이어와 볼륨 격차 줄이기 위해...
    end
end

-- volue_sfx에 따라 gmod audio channel 볼륨 조정. 크로미움 플레이어와의 격차 줄이기 위해... 
-- volume_sfx는 항상 0~1 사이, vol은 항상 0~100 사이여야 함!
function PlayMP.Player.calculate_sfx_vol(volume_sfx, vol)
    local vol = vol/100
    if volume_sfx == 0 then
        return 0  -- volume_sfx가 0일 경우 예외 처리
    else
        return vol / volume_sfx * 0.5 -- 2배 줄여야 데시벨이 맞음.
    end
end

-- 위 set_vol이나 사용자가 직접 콘솔에서 볼륨 조절할 때마다 캐싱하는 콜백함수.
cvars.AddChangeCallback("playmp_volume", function(convar_name, value_old, value_new)
    PlayMP.Player.Cur_Volume = math.Clamp(value_new, 0, 100)
end)

-- 사용자가 게리모드 옵션에서 sound effect volume을 조절하면 캐싱하는 콜백함수.
cvars.AddChangeCallback("volume_sfx", function(convar_name, value_old, value_new)
    PlayMP.Player.Cur_VolumeSFX = math.Clamp(value_new, 0, 1)
    if IsValid(PlayMP.Player.Player_Station) then
        PlayMP.Player.Player_Station:SetVolume( PlayMP.Player.calculate_sfx_vol(PlayMP.Player.Cur_VolumeSFX, PlayMP.Player.get_vol()) )
    end
end)


-- 플레이어를 새로고침합니다.
function PlayMP.Player:Reload_Player()
    if not PlayMP.Player.isPlaying then return end
    if PlayMP.Player.isPending then return end
    PlayMP.Player.isLoading = true

    local cur_music = PlayMP.Player.Get_now_music()

    PlayMP.Player:Do_ready( cur_music.Uri )
	PlayMP.Player:Play() -- Play는 항상 시작 위치에서 시작하므로, Seekto를 나중에 호출해야 함
    PlayMP.Player:Seekto( PlayMP.Player.Cur_play_time )
end


-- 플뮤 재생 시간과 실제 재생 시간 오차 수정
function PlayMP.Player:set_time_error()
    local setError = PlayMP:GetSetting( "SyncMediaAndPlayer", false, true)
    if not setError then return end

    local curPlayTime = PlayMP.Player.Real_play_time
    local playmp_playtime = PlayMP.Player.Cur_play_time + PlayMP.Player.Media_Start_Position

    if curPlayTime == nil then return end -- nil일 경우도 있음

    if ( curPlayTime > playmp_playtime + PlayMP.Player.Allow_Error_Time ) or ( curPlayTime + PlayMP.Player.Allow_Error_Time < playmp_playtime ) then

        if PlayMP.Player.isLoading then return end
        if PlayMP.Player.isInReady then return end
        PlayMP.timeError = PlayMP.timeError - (playmp_playtime - curPlayTime)
        
        print("[PlayM Pro] Time error: " .. playmp_playtime - curPlayTime .. "s! Try set to " .. curPlayTime .. "s...")
        --print("[PlayM Pro] Time error: " .. PlayMP.Player.Cur_play_time - PlayMP.Player.Real_play_time .. "s! Try set to " .. PlayMP.Player.Cur_play_time + PlayMP.Player.Cur_media_start_time .. "s...")
    end
    PlayMP.Player.Last_Valid_Real_play_time = PlayMP.Player.Real_play_time
end


-- 플레이어의 상태를 지속 확인하는 함수.
function PlayMP.Player:Video_Time_Think()

    PlayMP.Player:Remove_TimeThink()
    
    local Tick_TimeThink = CurTime()
    local nowWait = false
    local waitTime = 0
    local Muted = false


    -- 크로미움인 경우
    if PlayMP.Player.Engine_type == "chromium" then
        hook.Add( "Think", "PMP Video Time Think", function()
            
            if PlayMP.Player.Time_think_Time_Sec > CurTime() - Tick_TimeThink then return end

            PlayMP.Player.Cur_play_time = (CurTime() - PlayMP.Player.Cur_media_start_time) + PlayMP.SeekToTimeThink + PlayMP.timeError

            if PlayMP.Player.Player_HTML == nil or not PlayMP.Player.Player_HTML:Valid() then
                return
            end
            
            PlayMP.Player.Player_HTML:RunJavascript([[PlayMP.PlayState(]] .. PlayMP.Player.QuerySelector .. [[.getPlayerState());]])
            
            Tick_TimeThink = CurTime()

            if not PlayMP.Player.isSeeking then
                PlayMP.Player.Player_HTML:RunJavascript([[PlayMP.CurTime(]] .. PlayMP.Player.QuerySelector .. [[.getCurrentTime());]])
            end

            PlayMP.Player:set_time_error()
            
            if PlayMP.Player.isDownVolumeWithVoiceChat then return end
            if PlayMP.Player.VolumeTo_isWorking then return end
            local vol = 0
            if PlayMP.Player.isMuted then vol = 0 else vol = PlayMP.Player.get_vol() end
            
            PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.setVolume(]] .. vol .. [[)]])
            
        end )

    -- 게리 내장인 경우
    else
        hook.Add( "Think", "PMP Video Time Think", function()
            
            if PlayMP.Player.Time_think_Time_Sec > CurTime() - Tick_TimeThink then return end

            PlayMP.Player.Cur_play_time = (CurTime() - PlayMP.Player.Cur_media_start_time) + PlayMP.SeekToTimeThink + PlayMP.timeError

            local isValid = IsValid(PlayMP.Player.Player_Station)

            if not isValid  then
                return 
            end

            PlayMP.Player.State = PlayMP.Player.Player_Station:GetState() -- 값이 유튜브 플레이어와 동일함.
            
            Tick_TimeThink = CurTime()

            local stns = {}
            stns[1] = PlayMP:Str( "PS_unstarted" ) -- -1
            stns[2] = PlayMP:Str( "Prepare_Play" ) -- 0
            stns[3] = PlayMP:Str( "Now_Playing" ) -- 1
            stns[4] = PlayMP:Str( "PS_paused" ) -- 2
            stns[5] = PlayMP:Str( "PS_buffering" ) -- 3
            stns[6] = "" -- no use
            stns[7] = PlayMP:Str( "PS_videoCued" ) -- 5
            PlayMP.Player.ChangeStateText(stns[tonumber(PlayMP.Player.State)+2])

            PlayMP.Player.Real_play_time = PlayMP.Player.Player_Station:GetTime()

            if PlayMP.Player.State != 1 then return end

            PlayMP.Player:set_time_error()
            
            if PlayMP.Player.isDownVolumeWithVoiceChat then return end
            if PlayMP.Player.VolumeTo_isWorking then return end
            local vol = 0
            if PlayMP.Player.isMuted then vol = 0 else vol = PlayMP.Player.get_vol() end

            PlayMP.Player.Player_Station:SetVolume( PlayMP.Player.calculate_sfx_vol(PlayMP.Player.Cur_VolumeSFX, PlayMP.Player.get_vol()) ) -- 1이 100% 볼륨
            
        end )
    end


    local remover = function()
        hook.Remove( "Think", "PMP Video Time Think")
        PlayMP.Player.TimeThink_Remover = nil
    end

    PlayMP.Player.TimeThink_Remover = remover

    return remover
	
end



-- 플레이어 보이스에 따라 음악 볼륨 조절하는 구간..
local VolConWhenPlyStVo = PlayMP:GetSetting( "VolConWhenPlyStVo", false, true)
if not isnumber(VolConWhenPlyStVo) then
	VolConWhenPlyStVo = 0.15
	PlayMP:ChangeSetting("VolConWhenPlyStVo", VolConWhenPlyStVo)
end

local PlayerStartVoice_PlayMP_StartPlayer = 0
hook.Add( "PlayerStartVoice", "PlayerStartVoice_PlayMP", function( ply ) 
	if ply == LocalPlayer() then return end
	PlayerStartVoice_PlayMP_StartPlayer = PlayerStartVoice_PlayMP_StartPlayer + 1
	if PlayerStartVoice_PlayMP_StartPlayer == 1 then
        PlayMP.Player.isDownVolumeWithVoiceChat = true
		PlayMP:VolumeToWithNoChangeSetting( PlayMP.Player.get_vol() * PlayMP:GetSetting( "VolConWhenPlyStVo", false, true), 0.2, PlayMP:GetPlayerVolume() )
	end
end)
hook.Add( "PlayerEndVoice", "PlayerEndVoice_PlayMP", function( ply )
	if ply == LocalPlayer() then return end
	PlayerStartVoice_PlayMP_StartPlayer = PlayerStartVoice_PlayMP_StartPlayer - 1
	if PlayerStartVoice_PlayMP_StartPlayer == 0 then
		PlayMP:VolumeToWithNoChangeSetting( PlayMP.Player.get_vol(), 0.8, PlayMP.Player.get_vol() * PlayMP:GetSetting( "VolConWhenPlyStVo", false, true)  )
        PlayMP.Player.isDownVolumeWithVoiceChat = false
    end
end)

PlayMP.Player.VolumeTo_isWorking = false
function PlayMP:VolumeToWithNoChangeSetting( vol, ti, startVol )

    if not PlayMP.Player.isPlaying then return end

	if PlayMP.Player.VolumeTo_isWorking then
		hook.Remove( "Think", "VolumeToWithNoChangeSetting" )
	end

	PlayMP.Player.VolumeTo_isWorking = true
	
	if ti then

		local curVol = startVol
		local volTo = vol
		local volTonNum = (curVol - vol) * -1
		local curTime = CurTime()
		local chTime = 0
		hook.Add( "Think", "VolumeToWithNoChangeSetting", function() 

            if not PlayMP.Player.isPlaying then 
                hook.Remove( "Think", "VolumeToWithNoChangeSetting" ) 
                return
            end

			chTime = (CurTime() - curTime)/ti

            if PlayMP.Player.Engine_type == "chromium" then
			    PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.setVolume(]] .. curVol + (volTonNum * chTime) .. [[)]])
			else
                PlayMP.Player.Player_Station:SetVolume( PlayMP.Player.calculate_sfx_vol(PlayMP.Player.Cur_VolumeSFX, (curVol + (volTonNum * chTime)) ) )
            end

			if chTime >= 1 then
				PlayMP.Player.VolumeTo_isWorking = false
                if PlayMP.Player.Engine_type == "chromium" then
				    PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.setVolume(]] .. vol .. [[)]])
                else
                    PlayMP.Player.Player_Station:SetVolume( PlayMP.Player.calculate_sfx_vol(PlayMP.Player.Cur_VolumeSFX, vol ) )
                end
				hook.Remove( "Think", "VolumeToWithNoChangeSetting" )
			end
		end )
	else
		if PlayMP.Player.Engine_type == "chromium" then
            PlayMP.Player.Player_HTML:QueueJavascript(PlayMP.Player.QuerySelector .. [[.setVolume(]] .. vol .. [[)]])
        else
            PlayMP.Player.Player_Station:SetVolume( PlayMP.Player.calculate_sfx_vol(PlayMP.Player.Cur_VolumeSFX, vol ) )
        end
		PlayMP.Player.VolumeTo_isWorking = false
	end
	
end

hook.Add("PostCleanupMap", "PlayMP:PostCleanupMap", function()
    if PlayMP.Player.Engine_type == "gmod" then -- 크로미움 플레이어인 경우 이걸 할 필요 없음
        PlayMP.Player:Reload_Player()
        PlayMP.Logger.log("Gmod Audio Channel is dead! Trying reload player...", "INFO")
    end
end)