function PlayMP.GetPlayerVolume()
    return PlayMP.Player.get_vol()
end

-- 메뉴 창에서 새 알림 인디케이더 카운터임
PlayMP.noticecountOnInternet = 0
http.Fetch( "https://minbird.github.io/pmproNewNotice", function(data)
	local a = util.JSONToTable(data)
	PlayMP.noticecountOnInternet = a["NoticeCount"]
end)


-- 플레이리스트 읽어들이기
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


-- 플레이리스트 추가임
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


timer.Simple( 1, function()
    PlayMP.User.Get_my_data()
end)



function PlayMP:Notice( text, color, type )
	PlayMP:DoNoticeToPlayer( text, color, type )
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



function PlayMP:RemoveCache()
	net.Start("PlayMP:RemoveCache")
	net.SendToServer()
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