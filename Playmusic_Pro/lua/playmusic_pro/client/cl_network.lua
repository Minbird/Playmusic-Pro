PlayMP.net = {}

-- 주의
-- 아직 여기는 쓰이지 않은 더미 데이터인 경우가 많음
-- 수정하기 너무 빢셈


function PlayMP.net.addQueue( url, startTime, endTime, isPlaylist, removeOldMedia )

    net.Start("PlayMP:AddQueue")
		net.WriteString( url )
		net.WriteString( startTime )
		net.WriteString( endTime )
		net.WriteEntity( LocalPlayer() )
		net.WriteBool( isPlaylist )
		net.WriteBool( removeOldMedia )
	net.SendToServer()
end


function PlayMP.net.skip()
    net.Start("PlayMP:SkipMusic")
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

function PlayMP.net.requestSeek( time )

    net.Start("PlayMP:DoSeekToVideo")
		net.WriteString( time )
		net.WriteEntity( LocalPlayer() )
	net.SendToServer() 
end


function PlayMP.net.GetUserInfoBySID( sid )

	net.Start("PlayMP:GetUserInfoBySID")
		net.WriteString( sid )
	net.SendToServer()
	
end

function PlayMP:SetUserInfoBySID(sid, data)

	net.Start("PlayMP:SetUserInfoBySID")
		net.WriteString( sid )
		net.WriteTable( data )
	net.SendToServer()
	
end


function PlayMP.net.GetQueueData(newPlayer)
	net.Start("PlayMP:GetQueueData")
		net.WriteBool(newPlayer)
		net.WriteEntity(LocalPlayer())
	net.SendToServer()
end


function PlayMP.net.ChangConVar( name, value )

	net.Start("PlayMP:ChangConVar")
		net.WriteString(name)
		net.WriteFloat(tonumber(value))
	net.SendToServer()

end


function PlayMP.net.GetServerSettings( )
	net.Start("PlayMP:GetServerSettings")
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

function PlayMP.net.ChangeServerSettings( key )
	net.Start("PlayMP:ChangeServerSettings")
		net.WriteEntity( LocalPlayer() )
		net.WriteTable( {UniName = key, Data = PlayMP:GetSetting( key )} )
	net.SendToServer()
end

function PlayMP.net.RemoveQueue( num )
	net.Start("PlayMP:RemoveQueue")
		net.WriteString( tonumber(num) )
	net.SendToServer()
end

function PlayMP.net.Im_ready()
	
	if PlayMP.Player.isPending then
		net.Start("PlayMP:PlayerIsReady")
		net.SendToServer()
	end
	
end




net.Receive( "PlayMP:StopMusic", function()
	PlayMP.Player:Stop()
end)

net.Receive( "PlayMP:Playmusic", function()
	PlayMP.Player.Cur_Play_Num = tonumber( net.ReadString() )
	local curmusic = PlayMP.Player.Get_now_music()
	PlayMP.Player:Do_ready( curmusic.Uri )

	if PlayMP.MainMenuPanel != nil and PlayMP.MainMenuPanel:IsValid() then
		PlayMP.PlayerVideoImage:SetHTML( "<img src=\"" .. curmusic.Image .. "\" width=\" " .. ScrW() * 0.8 .. " \" height=\" " .. ScrH() * 0.8 .. "\">" )
		PlayMP.PlayerVideoTitle:SetText( curmusic["Title"] )
		PlayMP.PlayerVideoChannel:SetText( curmusic["Channel"] )
		if PlayMP.CurMenuPage == "queueList" then PlayMP:ChangeMenuWindow( "queueList" ) end
	end

end)

net.Receive( "PlayMP:StartMedia", function( len, ply )
	PlayMP.Player:Play()
end)

net.Receive( "PlayMP:SetUserInfoBySID", function( len, ply )
	local data = net.ReadBool()
end)

net.Receive( "PlayMP:DoSeekToVideo", function()
	
	local time = net.ReadString()
	PlayMP.Player:Seekto( time )
		
end)

net.Receive( "PlayMP:AddQueue", function( )

	local video = net.ReadTable()

	table.insert( PlayMP.Player.Queue, {
		Length = video.Length, 
		Title = video.Title, 
		Channel = video.Channel, 
		BroadCast = video.BroadCast, 
		Image = video.Image,
		ImageLow = video.ImageLow,
		Uri = video.Uri,
		QueueNum = table.Count( PlayMP.Player.Queue ) + 1,
		PlayUser = video.PlayUser,
		startTime = video.startTime,
		endTime = video.endTime,
		removeOldMedia = video.removeOldMedia
	} )

end)

net.Receive( "PlayMP:GetQueueData", function()
	PlayMP.Player.Queue = net.ReadTable()
	PlayMP.Player.Cur_Play_Num = tonumber(net.ReadString())
	if PlayMP.MainMenuPanel != nil then
		if PlayMP.CurMenuPage == "queueList" then
			PlayMP:ChangeMenuWindow( "queueList" )
		end
	end
end)

net.Receive( "PlayMP:NoticeForPlayer", function()
	local tag = net.ReadString() 
	local color = net.ReadTable()
	local type = net.ReadString()
	local data = net.ReadTable()

	if data then
		if istable(data) and #data >= 1 then
		
			PlayMP:Notice( PlayMP:Str( tag, unpack(data) ), color, type )
			
		else
		
			PlayMP:Notice( PlayMP:Str( tag, data ), color, type )
			
		end
	else
		PlayMP:Notice( PlayMP:Str( tag ), color, type )
	end
	
end)

net.Receive( "PlayMP:GetUserInfoBySID2", function( len, ply )
	PlayMP.LocalPlayerData = net.ReadTable()
	if PlayMP.LocalPlayerData == nil then 
		return
	end
end)


net.Receive( "player_connect_PlayMP:Playmusic", function()

	PlayMP.Player.Queue = net.ReadTable()
	PlayMP.Player.Cur_Play_Num = tonumber( net.ReadString() )
	local playing = net.ReadString()
	local pt = tonumber( net.ReadString() )
	
	if pt and playing == "playing" then
		local v = PlayMP.Player.Get_now_music()
		PlayMP.Player.isPlaying = true
		PlayMP.Player.isPending = false
        PlayMP.Player.Player_Frame = nil
        PlayMP.Player.Player_HTML = nil
        PlayMP.Player.Player_Station = nil
        PlayMP.SeekToTimeThink = 0
        PlayMP.Player.Media_Start_Position = 0
        PlayMP.timeError = 0
        PlayMP.Player.Cur_play_time = 0
        PlayMP.Player.Cur_media_start_time = v["startTime"]
        PlayMP.Player.Cur_Media_Length = v["endTime"] - v["startTime"]

        PlayMP:Notice( PlayMP:Str( "StartPlay", v.Title ), Color(60, 60, 60), "notice" )


		PlayMP.Player:Reload_Player()
		PlayMP.Player:Seekto(pt)
	end

end)

timer.Simple( 5, function() 
	if PlayMP.Setting:get("SyncPlay_WCAH") then
		net.Start("player_connect_PlayMP:Playmusic")
		net.SendToServer()
	end
end )