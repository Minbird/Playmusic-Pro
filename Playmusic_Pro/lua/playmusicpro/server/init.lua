
local API_KEY = "AIzaSyDVspFpFX5lq9uKg6h1hSknHIG46UDlqa0"
local playerDataSaved = {}
PlayMP.CurrentQueueInfo = {}
PlayMP.CurPlayNum = 0
PlayMP.CurUsersData = {}

util.AddNetworkString("PlayMP:RESETALLDATA")
net.Receive( "PlayMP:RESETALLDATA", function()
	PlayMP:RemoveQueue( 0 )
	PlayMP.CurPlayNum = 0
	print("Notice! All media queue has been deleted from the serverside data!")
end)


function PlayMP:WriteLog( text )

	if PlayMP:GetSetting( "WriteLogs", false, true ) == false then return end

	if not file.IsDir( "Playmusic_Pro_Log", "DATA" ) then 
		file.CreateDir( "Playmusic_Pro_Log" )
	end
	
	local TimeString = os.date( "[%H:%M:%S] " , Timestamp )
	local DateString = os.date( "%Y_%m_%d" , Timestamp )
	
	file.Append( "Playmusic_Pro_Log/" .. DateString .. "_logs.txt", "\n" .. TimeString .. text )
	print( "[PlayM Pro] Logs - ".. TimeString .. text )
		
end


function PlayMP:WriteCache( datacode, name, ch, len, img, imglow )

	if not PlayMP:GetSetting( "SaveCache", false, true ) then return end

	if not file.IsDir( "Playmusic_Pro_Cache", "DATA" ) then 
		file.CreateDir( "Playmusic_Pro_Cache" )
	end
	
	local data = {}
	
	table.insert( data, {
		Name = name,
		Ch = ch,
		Len = len,
		Img = img,
		Imglow = imglow
	} )
	
	if data[1] == nil or data[1] == {} then error("Write Error of cache")return end
	
	
	
	file.Write( "Playmusic_Pro_Cache/" .. datacode .. ".txt", util.TableToJSON(data) )
		
end

function PlayMP:ReadCache(uri)
	
	if uri == nil or uri == "" then return nil end
	local data = file.Read( "Playmusic_Pro_Cache/" .. uri .. ".txt", "DATA" )
	
	if data == nil or data == "" then
		return nil
	end

	return util.JSONToTable(data)[1]

end

util.AddNetworkString("PlayMP:GetCacheSize")
function PlayMP:GetCacheSize(  )
	local files = file.Find( "playmusic_pro_cache/*.txt", "DATA" )
	local size = 0
	--[[if #files > 0 then
		for k, f in ipairs( files ) do
			if f == nil then return end
			--print(file.Size( "Playmusic_Pro_UserData/0.txt", "DATA" ))
			local size2 = file.Size( "playmusic_pro_cache/" .. f, "DATA" )
			size = size + size2
			
		end
		
	end]]
	
	return #files, size
	
end

net.Receive( "PlayMP:GetCacheSize", function( len, ply )

	local f, s = PlayMP:GetCacheSize(  )
		
		net.Start("PlayMP:GetCacheSize")
			net.WriteTable( {f=f,s=s} )
		net.Send(ply)
		
	end)

function PlayMP:ReadSettingData( str, getAll, returnOnlyData )

	if file.Find( "PlayMusicPro3_Setting_Server.txt", "DATA" ) == nil then
		return {}
	else
		local data = file.Read( "PlayMusicPro3_Setting_Server.txt", "DATA" )
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

	if returnOnlyData then
		return PlayMP.CurSettings[str]
	end

	return { UniName = str, Data = PlayMP.CurSettings[str]}
	
end


util.AddNetworkString("player_connect_PlayMP:Playmusic")

net.Receive( "player_connect_PlayMP:Playmusic", function( len, ply )

	PlayMP:NewPlayer( ply )
	
end)

function PlayMP:NewPlayer( ply )

	net.Start("player_connect_PlayMP:Playmusic")
		net.WriteTable( PlayMP.CurrentQueueInfo )
		net.WriteString( PlayMP.CurPlayNum )
		if PlayMP.isPlaying == true then
			net.WriteString( "playing" )
			net.WriteString( tostring(PlayMP.CurPlayTime) )
		end
	net.Send( ply ) 
	
	PlayMP:PlayerDataUpdate(ply)
	PlayMP:updateVoteCount( nil, nil )
	
end


function PlayMP:PlayerDataUpdate(ply)
	local plydata = PlayMP:GetUserInfoBySID(ply:SteamID())
	
	plydata[1].lastConnectTime = os.date( "%m/%d/%y %H:%M:%S" , Timestamp )
	PlayMP:SetUserInfoBySID(ply:SteamID(), plydata)
	
end


function PlayMP:ChangeSetting( str, any )
	
	local data = PlayMP:GetSetting( str, true, false )
	
	data[str] = any
	if isnumber(any) or isstring(any) or isbool(any) then
		PlayMP:WriteLog( "Try to change setting... (" .. str .. ", " .. tostring(Data) .. " >>> " .. tostring(any) .. ")" )
	else
		PlayMP:WriteLog( "Try to change setting... (" .. str .. ")" )
	end
	file.Write( "PlayMusicPro3_Setting_Server.txt", util.TableToJSON(data) )
				
	PlayMP.CurSettings = data
	PlayMP:SettingSendToPlayer()
	
end


function PlayMP:AddSetting( name, data )

	
	local CurData = PlayMP:GetSetting( str, true, false )

	CurData[name] = data
	
	file.Write( "PlayMusicPro3_Setting_Server.txt", util.TableToJSON(CurData) )

	
	PlayMP.CurSettings = CurData
	
end

local data = file.Read( "PlayMusicPro3_Setting_Server.txt", "DATA" )
if data == nil or data == "" then

	PlayMP:AddSetting( "AOAQueue", false )
	PlayMP:AddSetting( "AOASkip", false )
	PlayMP:AddSetting( "AOACPL", false )
	PlayMP:AddSetting( "RepeatQueue", false )
	PlayMP:AddSetting( "SaveCache", true )
	PlayMP:AddSetting( "AOAPMP", false )
	PlayMP:AddSetting( "WriteLogs", true )
	PlayMP:AddSetting( "RemoveOldMedia", true )
	PlayMP:AddSetting( "UseSkipToVote", false )
	
	PlayMP:AddSetting( "AdminSet_DONOTshowInfoPanel", false )
	
end

	util.AddNetworkString("PlayMP:GetServerSettings")
function PlayMP:SettingSendToPlayer( ply )
	
	net.Start("PlayMP:GetServerSettings")
		net.WriteTable( PlayMP:GetSetting( "", true ) )
	net.Broadcast()
	
end

	net.Receive( "PlayMP:GetServerSettings", function()
		local ply = net.ReadEntity()
		
		PlayMP:SettingSendToPlayer( ply )
	end)
	
	
	util.AddNetworkString("PlayMP:ChangeServerSettings")

	net.Receive( "PlayMP:ChangeServerSettings", function( len, pl )
	
		local ply = net.ReadEntity()
		local v = net.ReadTable()
		
		local plydata = PlayMP:GetUserInfoBySID(pl:SteamID())
		if pl:IsAdmin() or plydata[1].power == true then
			PlayMP:ChangeSetting( v.UniName, v.Data )
		else
			PlayMP:NoticeForPlayer( "Unknown_Error", "red", "warning" , pl )
		end
	end)


	util.AddNetworkString( "PlayMP:NoticeForPlayer" )

function PlayMP:NoticeForPlayer( str, msgtype, type, target, ... )

	net.Start("PlayMP:NoticeForPlayer")
		net.WriteString( str )
		
		if msgtype == "red" then
			net.WriteTable( Color(231, 76, 47) )
			
		elseif msgtype == "green" then
			net.WriteTable( Color(42, 205, 114) )
			
		elseif msgtype == "gray" or msgtype == nil then
			net.WriteTable( Color(50, 50, 50) )
			
		end
		
		net.WriteString( type )
		
		if ... then
			net.WriteTable( ... )
		else
			net.WriteTable( {} )
		end
		
	if target then
		net.Send(target)
	else
		net.Broadcast()
	end
	
end

	util.AddNetworkString("PlayMP:GetQueueData")
	net.Receive( "PlayMP:GetQueueData", function( len, ply )
		
		local getself = net.ReadBool() 
		
		PlayMP:GetQueueData( getself, ply )
		
	end)
	
	function PlayMP:GetQueueData( getself, ply )
	
		net.Start("PlayMP:GetQueueData")
		net.WriteTable( PlayMP.CurrentQueueInfo )
		net.WriteString( tostring(PlayMP.CurPlayNum) )
		--local getself = net.ReadBool() 
		if getself then
			net.Send(ply)
		else
			net.Broadcast()
		end
		
	end

	util.AddNetworkString( "PlayMP:AddQueue" )
	
	PlayMP.QueueLimit = GetConVar( "playmp_queue" ):GetFloat() 
	PlayMP.QueueLimitPerUser = GetConVar( "playmp_queue_user" ):GetFloat() 
	PlayMP.TimeLimit = GetConVar( "playmp_media_time" ):GetFloat() 

function PlayMP:AddQueue( url, startTime, endTime, ply, removeOldMedia )
	
	local uri = PlayMP:UrlProcessing( url )

	
	if uri == "Error" then
		PlayMP:NoticeForPlayer( "IncorrectUrl", "red", "warning" , ply )
		return
	end
	
	PlayMP.QueueLimit = GetConVar( "playmp_queue" ):GetFloat() 
	PlayMP.QueueLimitPerUser = GetConVar( "playmp_queue_user" ):GetFloat() 
	PlayMP.TimeLimit = GetConVar( "playmp_media_time" ):GetFloat() 
	
	if PlayMP.QueueLimit != 0 and table.Count( PlayMP.CurrentQueueInfo ) >= PlayMP.QueueLimit then
		PlayMP:NoticeForPlayer( "TooManyQueue", "red", "warning", ply )
		return
	end
	
	if PlayMP.QueueLimitPerUser != 0 then
		local plycount = 0
		for k, v in pairs(PlayMP.CurrentQueueInfo) do
			if v.PlayUser == ply then plycount = plycount + 1 end
		end
		if PlayMP.QueueLimitPerUser <= plycount then
			PlayMP:NoticeForPlayer( "TooManyQueue", "red", "warning", ply )
			return
		end
	end
	
	
	
	local queue = {}
	queue.Uri = uri
	queue.startTime = startTime
	queue.endTime = endTime
	queue.Ply = ply
	queue.removeOldMedia = removeOldMedia
	
	local er = PlayMP:ReadVideoInfo( uri, startTime, endTime, ply, removeOldMedia )

	if er == "err" then
		PlayMP:NoticeForPlayer( "Error_VideoDataReadError", "red", "warning", ply )
		return 
	elseif er == "isLive" then
		PlayMP:NoticeForPlayer( "CantPlayLiveCont", "red", "warning", ply )
		return 
	elseif er == "ok" then
		http.Fetch( "https://minbird.kr/utils/ytdl?v=" .. uri, function() end, function( message ) PlayMP:WriteLog( message ) end )
		PlayMP:GetQueueData(false)
		PlayMP:Playmusic()
		PlayMP:WriteLog("User '" .. ply:Nick() .. "'(" .. ply:SteamID() .. ") add music to queue! (" .. url .. ")")
	end

end



function PlayMP:AddPlaylistQueue( id, ply, nextPageTokenOld )

	local url = "https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&maxResults=50&playlistId=" .. id .. "&key=AIzaSyDVspFpFX5lq9uKg6h1hSknHIG46UDlqa0"

	if nextPageTokenOld != nil then
		url = "https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&maxResults=50&playlistId=" .. id .. "&key=AIzaSyDVspFpFX5lq9uKg6h1hSknHIG46UDlqa0&pageToken=" .. nextPageTokenOld
	end

	http.Fetch(url, function(data,code,headers)
		
		local strJson = data
		local json = util.JSONToTable(strJson)
		if json == nil then return end
		
		local nextPageToken = "no"
		
		if json["nextPageToken"] then
			nextPageToken = json["nextPageToken"]
		end
		
		
		for k, v in pairs(json.items) do
			print(k, v["contentDetails"]["videoId"])
			--if k > 1 then
				PlayMP:AddQueue( v["contentDetails"]["videoId"], 0, 0, ply )
					
				if k == 50 and nextPageToken != "no" then
					PlayMP:AddPlaylistQueue( id, ply, nextPageToken )
				end
			--end
		end
		
	end)
	
end


	net.Receive( "PlayMP:AddQueue", function()
		local url = net.ReadString()
		local startTime = net.ReadString()
		local endTime = net.ReadString()
		local ply = net.ReadEntity()
		local isPlaylist = net.ReadBool()
		local removeOldMedia = net.ReadBool()
		
		local plydata = PlayMP:GetUserInfoBySID(ply:SteamID())
		
		if PlayMP:GetSetting( "AOAPMP", false, true ) and ply:IsAdmin() != true and plydata[1].power == false then PlayMP:NoticeForPlayer( "MyState_CanTUsePlaymusic", "red", "warning" ) return end
		if plydata[1].ban then PlayMP:NoticeForPlayer( "MyState_CanTUsePlaymusic", "red", "warning" ) return end

		--[[if PlayMP:GetSetting( "AOAQueue", false, true ) == true and ply:IsAdmin() != false and plydata.power == false then
			PlayMP:NoticeForPlayer( "AllowOnlyAdmin_Queue", "red", "warning" )
			return
		end
		
		if plydata.qeeue == false and ply:IsAdmin() == false and plydata.power == false then
			PlayMP:NoticeForPlayer( "AllowOnlyAdmin_Queue", "red", "warning" )
			return
		end]]
		
		if PlayMP:GetSetting( "AOAQueue", false, true ) and ply:IsAdmin() != true and plydata[1].power == false  then
			PlayMP:NoticeForPlayer( "AllowOnlyAdmin_Queue", "red", "warning" )
			return
		elseif plydata[1].qeeue == false and ply:IsAdmin() == false and plydata[1].power == false then
			PlayMP:NoticeForPlayer( "AllowOnlyAdmin_Queue", "red", "warning" )
			return
		end
		
		
		--if isPlaylist then
		--	PlayMP:AddPlaylistQueue( url, ply )
		--end
		
		if startTime == "" then
			startTime = 0
		end
		
		if endTime == "" then
			endTime = 0
		end
		
		PlayMP:AddQueue( url, tonumber(startTime), tonumber(endTime), ply, removeOldMedia )
	end)
	
	
	
	util.AddNetworkString( "PlayMP:SkipMusic" )
	
function PlayMP:SkipMusic( ply )

	--for k, v in pairs(PlayMP.CurrentQueueInfo) do
	
		--if v["QueueNum"] == PlayMP.CurPlayNum then
			--local PlayUser = v["PlayUser"]

			
			--if PlayUser:SteamID() == ply:SteamID() then
			
				local plydata = PlayMP:GetUserInfoBySID(ply:SteamID())

				if plydata[1].ban then PlayMP:NoticeForPlayer( "MyState_CanTUsePlaymusic", "red", "warning" ) return end
				
				if PlayMP:GetSetting( "UseSkipToVote", false, true ) then
					PlayMP:VoteSkipMusic(ply)
					return
				end
				
				if PlayMP:GetSetting( "AOAPMP", false, true ) and ply:IsAdmin() != true and plydata[1].power == false then 
					PlayMP:NoticeForPlayer( "MyState_CanTUsePlaymusic", "red", "warning" ) 
					return 
				end
			
				if ply:IsAdmin() then
					timer.Simple(1, function()
						if PlayMP:GetSetting( "RemoveOldMedia", false, true ) or tobool(PlayMP.CurrentQueueInfo[PlayMP.CurPlayNum].removeOldMedia) then
							PlayMP:RemoveQueue( PlayMP.CurPlayNum )
						else
							PlayMP:EndMusic()
						end
					end)
				elseif PlayMP:GetSetting( "AOASkip", false, true ) and ply:IsAdmin() != true and plydata[1].power == false  then
					PlayMP:NoticeForPlayer( "AllowOnlyAdmin_Skip", "red", "warning" )
				elseif plydata[1].skip == false and ply:IsAdmin() == false and plydata[1].power == false then
					PlayMP:NoticeForPlayer( "AllowOnlyAdmin_Skip", "red", "warning" )
				else
					if PlayMP:GetSetting( "RemoveOldMedia", false, true ) or tobool(PlayMP.CurrentQueueInfo[PlayMP.CurPlayNum].removeOldMedia) then
						PlayMP:RemoveQueue( PlayMP.CurPlayNum )
					else
						PlayMP:EndMusic()
					end
				end
			
			--end
			
		--end
	--end
	
end
	
	net.Receive( "PlayMP:SkipMusic", function()
		local ply = net.ReadEntity()
		
		PlayMP:SkipMusic( ply )
	end)
	
	
function PlayMP:VoteSkipMusic( ply )
	PlayMP:RecieveVoteRequest( ply )
end
	
	
	
util.AddNetworkString("PlayMP:GetUserInfoBySID")

function PlayMP:GetUserInfoBySID(target)

	local target = util.SteamIDTo64( target ) 

	local dir = "Playmusic_Pro_UserData/"
	
	if not file.IsDir( "Playmusic_Pro_UserData", "DATA" ) then 
		file.CreateDir( "Playmusic_Pro_UserData" )
	end

	if file.Find( dir .. tostring(target) .. ".txt", "DATA" ) == nil then
		file.Append(tostring(target) .. ".txt", "Playmusic_Pro_UserData")
	end
	
		local data = file.Read( dir .. tostring(target) .. ".txt", "DATA" )
		if data == nil or data == "" then
			local Table = {}
			-- 파일에 실제로 저장되는 값
			table.insert( Table, {
				qeeue = true,
				skip = true,
				seekto = true,
				power = false,
				ban = false
			})

			--[[ 서버 내부에서 처리를 위해 저장하는 값
			table.RemoveByValue( playerDataSaved, target )
			table.insert( playerDataSaved, {
				qeeue = true,
				skip = true,
				seekto = true,
				power = false,
				ban = false,
				ply = target
			})]]
			
			file.Write( dir .. tostring(target) .. ".txt", util.TableToJSON(Table) )
			return Table
		else
			local table = util.JSONToTable(data)
			return table
		end
	
end

	net.Receive( "PlayMP:GetUserInfoBySID", function( len, ply )
		local sid = net.ReadString()

		--local data = PlayMP:GetUserInfoBySID(ply:SteamID()) -- 왜 이렇게 했지?
		local data = PlayMP:GetUserInfoBySID(sid)
		
		net.Start("PlayMP:GetUserInfoBySID")
			net.WriteTable( data )
		net.Send(ply)
		
	end)
	
	
util.AddNetworkString("PlayMP:SetUserInfoBySID")
util.AddNetworkString("PlayMP:GetUserInfoBySID2")
	
function PlayMP:SetUserInfoBySID(target, data)

	local dir = "Playmusic_Pro_UserData/"
	
	local ply = player.GetBySteamID( target ) 
	local target = util.SteamIDTo64( target ) 
	
	if target == "0" then
		print("[PlayM Pro] Error occurred while set user info by sid because target is bot or wrong steamID.")
	end

	if file.Find( dir .. tostring(target) .. ".txt", "DATA" ) == nil then
		file.Append(tostring(target) .. ".txt", "Playmusic_Pro_UserData")
	end

	file.Write( dir .. tostring(target) .. ".txt", util.TableToJSON(data) )
	
	--[[table.RemoveByValue( playerDataSaved, target ) -- 서버 테이블에 저장된 유저 데이터를 삭제한다
	table.insert( playerDataSaved, data) -- 새로 인서트한다.

	PrintTable(playerDataSaved)]]
	
	if ply != nil and ply != false and ply:IsPlayer() then
		net.Start("PlayMP:GetUserInfoBySID2")
			net.WriteTable( data )
		net.Send(ply)
	end
		
	return true
	
end

util.AddNetworkString("PlayMP:SendUserInfoAll")
function PlayMP:SendUserInfoAll( ply )

	local dir = "Playmusic_Pro_UserData/"

	local data, data2 = file.Find( dir .. "*.txt", "DATA" )

	if ply != nil and ply != false and ply:IsPlayer() then
		net.Start("PlayMP:SendUserInfoAll")
			net.WriteTable( data )
		net.Send(ply)
	end
	
end

net.Receive( "PlayMP:SendUserInfoAll", function( len, ply )
		
	PlayMP:SendUserInfoAll( ply )
		
end)
	
	concommand.Add( "pmpro_addadmin", function( ply, cmd, args, str )
		if ply == nil or not ply:IsPlayer() then
			local plydata = PlayMP:GetUserInfoBySID(str)
			if plydata == nil then
				print( "[PlayM Pro] Error occurred while adding user to admin..." )
				return
			end
			plydata[1]["power"] = true
			PlayMP:SetUserInfoBySID(str, plydata)
			print( "[PlayM Pro] Added user(" .. str .. ") to Admin..." )
		end
	end )
	
	
	net.Receive( "PlayMP:SetUserInfoBySID", function( len, ply )
		local target = net.ReadString()
		local data = net.ReadTable()
		
		local plydata = PlayMP:GetUserInfoBySID(ply:SteamID())
		if ply:IsAdmin() or plydata[1].power == true then
			local stat = PlayMP:SetUserInfoBySID(target, data)
			
			net.Start("PlayMP:SetUserInfoBySID")
				net.WriteBool( stat )
			net.Send(ply)
		else
			PlayMP:NoticeForPlayer( "Unknown_Error", "red", "warning" , ply )
		end
		
	end)
	
	

util.AddNetworkString("PlayMP:DoSeekToVideo")

PlayMP.SeekToTimeThink = 0

local function DoSeekToVideo( time, ply )

	local plydata = PlayMP:GetUserInfoBySID(ply:SteamID())
	
	if PlayMP:GetSetting( "AOAPMP", false, true ) and ply:IsAdmin() != true and plydata[1].power == false then PlayMP:NoticeForPlayer( "MyState_CanTUsePlaymusic", "red", "warning" ) return end
	if plydata[1].ban then PlayMP:NoticeForPlayer( "MyState_CanTUsePlaymusic", "red", "warning" ) return end

	if PlayMP:GetSetting( "AOACPL", false, true ) and ply:IsAdmin() != true and plydata[1].power == false  then
		PlayMP:NoticeForPlayer( "AllowOnlyAdmin_Loca", "red", "warning" )
		return
	end
	
	if plydata[1].seekto == false and ply:IsAdmin() == false and plydata[1].power == false then
		PlayMP:NoticeForPlayer( "AllowOnlyAdmin_Loca", "red", "warning" )
		return
	end
	
	if PlayMP.CurPlayTime == nil then return end

	local time = tonumber(time)
	
	--PlayMP.SeekToTimeThink = PlayMP.SeekToTimeThink - (CurTime() - PlayMP.VideoStartTime - tonumber(time))
	PlayMP.SeekToTimeThink = PlayMP.SeekToTimeThink - (PlayMP.CurPlayTime - tonumber(time))
	
	net.Start("PlayMP:DoSeekToVideo")
		net.WriteString( tostring(time) )
	net.Broadcast()
	
end

	net.Receive( "PlayMP:DoSeekToVideo", function()
		local time = net.ReadString()
		local ply = net.ReadEntity()
		DoSeekToVideo( time, ply )
	end)


function PlayMP:ReadVideoInfo( uri, startTime, endTime, ply, removeOldMedia )

	PlayMP.videoReadError = false
	PlayMP.IsliveBroadcast = false
	
	if PlayMP:ReadCache(uri) then
		local cache = PlayMP:ReadCache(uri)
		local endTime = endTime
		local startTime = startTime
	
			if endTime > cache.Len or endTime == 0 then
				endTime = cache.Len
			end
			
			if cache.Len != nil and startTime > endTime or startTime > cache.Len then
				startTime = 0
			end
			
			if PlayMP.TimeLimit!= 0 and PlayMP.TimeLimit < tonumber(cache.Len) then
				PlayMP:NoticeForPlayer( "ThisMeidaIsTooLong", "red", "warning", ply )
				return
			end
		
			local video = {
				Length = cache.Len, 
				Title = cache.Name, 
				Channel = cache.Ch, 
				BroadCast = "none", 
				Image = cache.Img,
				ImageLow = cache.Imglow,
				Uri = uri,
				QueueNum = table.Count( PlayMP.CurrentQueueInfo ) + 1,
				PlayUser = ply,
				startTime = startTime,
				endTime = endTime,
				removeOldMedia = removeOldMedia}
			
			net.Start("PlayMP:AddQueue")
				net.WriteTable( video )
			net.Broadcast()
		
			table.insert( PlayMP.CurrentQueueInfo, video )
			
			PlayMP:Playmusic()
			PlayMP:WriteLog("User '" .. ply:Nick() .. "'(" .. ply:SteamID() .. ") add music to queue! (" .. uri .. ")")
			PlayMP:NoticeForPlayer( "QueueAdded", "green", "notice", ply, {cache.Name} )
			http.Fetch( "https://minbird.kr/utils/ytdl?v=" .. uri, function() end, function( message ) PlayMP:WriteLog( message ) end )
			return
	end

	local video = {}

	http.Fetch("https://www.googleapis.com/youtube/v3/videos?part=snippet,contentDetails&id=" .. uri .. "&key=" .. API_KEY, function(data,code,headers)
			
		local strJson = data
		local json = util.JSONToTable(strJson)
			
		if json["items"][1] == nil then
			PlayMP:NoticeForPlayer( "Error_VideoDataReadError", "red", "warning", ply )
			PlayMP.videoReadError = true
			return "err"
		end
		
		if json.error then
			local message = json["error"]["message"]
			if json["error"]["code"] == "403" then
				message = "Request refused by Google server. Please try again later."
			end
			PlayMP:NoticeForPlayer( PlayMP:Str( "GOOGLEAPI_Error02", json["error"]["code"], message), "red", "warning" )
			return "err"
		end

		local contentDetails = json["items"][1]["contentDetails"]
			
		local strVideoDuration = contentDetails["duration"]
			

		video.Sec = string.match(strVideoDuration, "M([^<]+)S")
		if video.Sec == nil then
			video.Sec = string.match(strVideoDuration, "H([^<]+)S")
			if video.Sec == nil then
				video.Sec = string.match(strVideoDuration, "PT([^<]+)S")
				if video.Sec == nil then
					video.Sec = 0
				end
			end
		end
		
		video.Min = string.match(strVideoDuration, "H([^<]+)M")
		if video.Min == nil then
			video.Min = string.match(strVideoDuration, "PT([^<]+)M")
			if video.Min == nil then
				video.Min = 0
			end
		end
			
		video.Hour = string.match(strVideoDuration, "PT([^<]+)H")
		if video.Hour == nil then
			video.Hour = 0
		end
		
		video.VideoLength = video.Sec + video.Min * 60 + video.Hour * 3600 + 1
		
			if PlayMP.TimeLimit != 0 and PlayMP.TimeLimit < video.VideoLength then
				PlayMP:NoticeForPlayer( "ThisMeidaIsTooLong", "red", "warning", ply )
				return
			end
		
		--http.Fetch("https://www.googleapis.com/youtube/v3/videos?part=snippet&id=" .. uri .. "&key=" .. API_KEY, function(data,code,headers)
				
			local strJson = data
			local json = util.JSONToTable(strJson)
					
			if json["items"][1] == nil then
				PlayMP:NoticeForPlayer( "Error_VideoDataReadError", "red", "warning", ply )
				PlayMP.videoReadError = true
				return "err"
			end
					
			local snippet = json["items"][1]["snippet"]
					
			video.titleText = snippet["title"]
			video.ChannelTitle = snippet["channelTitle"]
			video.IsliveBroadcast = snippet["liveBroadcastContent"]
			
			if video.titleText == nil or video.titleText == "" then 
				PlayMP:NoticeForPlayer( "Error_VideoDataReadError", "red", "warning", ply )
				PlayMP.videoReadError = true
				return "err" 
			end
			if video.ChannelTitle == nil or video.ChannelTitle == "" then
				PlayMP:NoticeForPlayer( "Error_VideoDataReadError", "red", "warning", ply )
				PlayMP.videoReadError = true
				return "err"
			end
			if video.IsliveBroadcast == "live" then
				PlayMP.IsliveBroadcast = true
				PlayMP:NoticeForPlayer( "CantPlayLiveCont", "red", "warning", ply )
				return "isLive" 
			end
					
			local Imagedefault = snippet["thumbnails"]
			video.ImageUrl = Imagedefault["maxres"]
			video.ImageUrlLow = Imagedefault["default"]
					
			if video.ImageUrl == nil then
				video.ImageUrl = Imagedefault["medium"]
			end
					
			video.ImageUrl = video.ImageUrl["url"]
			video.ImageUrlLow = video.ImageUrlLow["url"]
			
			if PlayMP.videoReadError or PlayMP.IsliveBroadcast then
				PlayMP:NoticeForPlayer( "Error_unknownError", "red", "warning" )
				PlayMP.IsliveBroadcast = false
				PlayMP.videoReadError = false
				return "err"
			end
			
			print("endTime = " .. endTime .. " / video.VideoLength = " .. video.VideoLength )
			
			if endTime > video.VideoLength or endTime == 0 then
				endTime = video.VideoLength
			end
			
			if video.VideoLength != nil and startTime > endTime or startTime > video.VideoLength then
				startTime = 0
			end
			
			PlayMP:WriteCache( uri, video.titleText, video.ChannelTitle, video.VideoLength, video.ImageUrl, video.ImageUrlLow )
		
			local video = {
				Length = video.VideoLength, 
				Title = video.titleText, 
				Channel = video.ChannelTitle, 
				BroadCast = video.IsliveBroadcast, 
				Image = video.ImageUrl,
				ImageLow = video.ImageUrlLow,
				Uri = uri,
				QueueNum = table.Count( PlayMP.CurrentQueueInfo ) + 1,
				PlayUser = ply,
				startTime = startTime,
				endTime = endTime,
				removeOldMedia = removeOldMedia}
			
			net.Start("PlayMP:AddQueue")
				net.WriteTable( video )
			net.Broadcast()
		
			table.insert( PlayMP.CurrentQueueInfo, video )
			
			
			if PlayMP.videoReadError then
				PlayMP:NoticeForPlayer( "Error_VideoDataReadError", "red", "warning", ply )
			elseif PlayMP.IsliveBroadcast then
				PlayMP:NoticeForPlayer( "CantPlayLiveCont", "red", "warning", ply )
			else
				PlayMP:NoticeForPlayer( "QueueAdded", "green", "notice", ply, {video.Title} )
				http.Fetch( "https://minbird.kr/utils/ytdl?v=" .. uri, function() end, function( message ) PlayMP:WriteLog( message ) end )
				PlayMP:Playmusic()
				PlayMP:WriteLog("User '" .. ply:Nick() .. "'(" .. ply:SteamID() .. ") add music to queue! (" .. uri .. ")")
			end
			
			PlayMP.videoReadError = false
			PlayMP.IsliveBroadcast = false

	end,nil)
		
end


	PlayMP.isPlaying = false
	util.AddNetworkString( "PlayMP:Playmusic" )

PlayMP.isPending = false
function PlayMP:Playmusic()

	if PlayMP.isPlaying == true then return end
	
	if PlayMP.CurrentQueueInfo == nil or PlayMP.CurrentQueueInfo[PlayMP.CurPlayNum + 1] == nil or PlayMP.CurrentQueueInfo[PlayMP.CurPlayNum + 1]["QueueNum"] == "err" then
		PlayMP:NoticeForPlayer( "Error_unknownError", "red", "warning" )
		--PlayMP:EndMusic() stack overflow!?!?
		if PlayMP.CurrentQueueInfo != nil and PlayMP.CurrentQueueInfo[PlayMP.CurPlayNum + 2] != nil and PlayMP.CurrentQueueInfo[PlayMP.CurPlayNum + 2]["QueueNum"] == "err" then
			PlayMP.CurPlayNum = PlayMP.CurPlayNum + 1 -- jump to next media if no problems
			PlayMP:Playmusic()
		else -- serious error has occurred... it probably cause serious problem for server or client! or.. causing stack overflow.. sometimes?
			PlayMP.CurrentQueueInfo = {}
			PlayMP.CurPlayNum = 0
			PlayMP:GetQueueData( false )
		end
		return 
	end
	
	PlayMP:voteActivate(PlayMP:GetSetting( "UseSkipToVote", false, true ))
	
	PlayMP.VideoStartTime = CurTime() + 2 -- 클라이언트 오차를 고려해 여유 시간을 둔다.

	PlayMP.CurPlayNum = PlayMP.CurPlayNum + 1
	
	PlayMP.isPlaying = true
	
	PlayMP.SeekToTimeThink = 0
	
	PlayMP.isPending = true
	
	net.Start("PlayMP:Playmusic")
		--net.WriteTable( PlayMP.CurrentQueueInfo )
		net.WriteString( PlayMP.CurPlayNum )
	net.Broadcast()
	
	PlayMP:clearVoteCount()
	
	print("[PlayM Pro] Playback Pending...")
	
	local pendingTimeCount = 0
	local function CheakPlayer()
		if PlayMP.isPending then
			pendingTimeCount = pendingTimeCount + 1
		end
		
		if pendingTimeCount == 5 then
			timer.Remove( "PendingTimePlayMP" )
			pendingTimeCount = 0
			PlayMP:StartMedia()
			print("[PlayM Pro] Starting, but some user(s) not ready to start playing!")
		end
		
	end
	timer.Create( "PendingTimePlayMP", 1, 0, function() CheakPlayer() end )
	
end



function PlayMP:EndMusic()

	hook.Remove("Think", "PMP Video Time Think")
	PlayMP.isPlaying = false
	
	PlayMP:StopMusic()
	PlayMP:clearVoteCount()
	
	--PlayMP:GetSetting( "RemoveOldMedia", false, true )
	
	if table.Count( PlayMP.CurrentQueueInfo ) == PlayMP.CurPlayNum then
		if PlayMP:GetSetting( "RepeatQueue", false, true ) then
			PlayMP.CurPlayNum = 0
			PlayMP:Playmusic()
		else
			PlayMP:NoticeForPlayer( "MusicStoped", "red", "warning" )
			return
		end
	else
		PlayMP:Playmusic()
	end
	
end


	util.AddNetworkString( "PlayMP:StopMusic" )
function PlayMP:StopMusic()
	net.Start("PlayMP:StopMusic")
	net.Broadcast()
end
	



function PlayMP:VideoTimeThink()

	for k, v in pairs( PlayMP.CurrentQueueInfo ) do
		if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
		
			local PlayLength = v["Length"]
			local startTime = v["startTime"]
			local endTime = v["endTime"]
			local length = endTime - startTime
			
			PlayMP.CurPlayLength = length + 3
			PlayMP.CurPlayTime = 0
			
			hook.Add( "Think", "PMP Video Time Think", function()
			
				--if PlayMP.CurPlayLength < CurTime() - PlayMP.VideoStartTime + PlayMP.SeekToTimeThink then
				if PlayMP.CurPlayTime > PlayMP.CurPlayLength then
					if PlayMP:GetSetting( "RemoveOldMedia", false, true ) or tobool(PlayMP.CurrentQueueInfo[PlayMP.CurPlayNum].removeOldMedia) then
						PlayMP:RemoveQueue( PlayMP.CurPlayNum )
					else
						PlayMP:EndMusic()
					end
				end
				
				PlayMP.CurPlayTime = (CurTime() - PlayMP.VideoStartTime) + PlayMP.SeekToTimeThink
				
			end )
			
		end
	end
	
end



	util.AddNetworkString( "PlayMP:RemoveQueue" )
function PlayMP:RemoveQueue( num )

	if not isnumber( num ) then return end
	
	if num == 0 then
		table.Empty( PlayMP.CurrentQueueInfo )
		PlayMP.CurPlayNum = 0
		PlayMP:StopMusic()
		PlayMP.isPlaying = false
		PlayMP:GetQueueData( false )
		return
	end
	
	local curm = false
	
	table.remove( PlayMP.CurrentQueueInfo, num )
	
	if num == PlayMP.CurPlayNum then
		curm = true
	end
	
	if num <= PlayMP.CurPlayNum then
		PlayMP.CurPlayNum = PlayMP.CurPlayNum - 1
	end
	
	for k, v in pairs(PlayMP.CurrentQueueInfo) do
		if k >= num and tonumber(v["QueueNum"]) != 1 then
			v["QueueNum"] = tonumber(v["QueueNum"]) - 1
		end
	end
	PlayMP:GetQueueData( false )
	
	if curm then
		PlayMP:EndMusic()
	end

end
net.Receive( "PlayMP:RemoveQueue", function( len, ply )
		
	local num = tonumber(net.ReadString())
		
	PlayMP:RemoveQueue( num )
		
end)




function PlayMP:UrlProcessing( str )

		if string.find(str,"youtube")!=nil then
			str = string.match(str,"[?&]v=([^?]*)")
			local str_exploded = string.Explode( "&", str ) -- 만약 여러 파라미터가 있으면... 아마 video id가 항상 맨 앞이었던 거 같은데
			str = str_exploded[1] or str
		elseif string.find(str,"youtu.be")!=nil then
			str = string.match(str,"https://youtu.be/([^?]*)")
			local str_exploded = string.Explode( "?", str ) -- 만약 여러 파라미터가 있으면... 단축 url은 파라미터 모두 무시함
			str = str_exploded[1] or str
		end

	
	if str == nil or str == "" then
		return "Error"
	else
		print(str)
		return str
	end
end

util.AddNetworkString( "PlayMP:ChangePlayerMode" )
function PlayMP:ChangePlayerMode( target, mode )
	net.Start("PlayMP:ChangePlayerMode")
	
	if mode == "worldScr" then
		net.WriteString("worldScr")
	elseif mode == "nomal" then
		net.WriteString("nomal")
	end
	
	if target then
		net.Send(target)
	else
		net.Broadcast()
	end
end

util.AddNetworkString( "PlayMP:RemoveCache" )
net.Receive( "PlayMP:RemoveCache", function()

	local files = file.Find( "playmusic_pro_cache/*.txt", "DATA" )
	if #files > 0 then
		for k, f in ipairs( files ) do
			if f == nil then return end

			file.Delete( "Playmusic_Pro_Cache/" .. f )
			print("Delete Playmusic_Pro_Cache/" .. f .. "...")
			
		end
		
	end

end)

util.AddNetworkString( "PlayMP:ChangConVar" )
net.Receive( "PlayMP:ChangConVar", function( len, ply )

	local name = net.ReadString()
	local value = net.ReadFloat()
	
	local plydata = PlayMP:GetUserInfoBySID(ply:SteamID())
	if ply:IsAdmin() or plydata[1].power == true then
		GetConVar(name):SetFloat(value)
	end

end)

local PlayMPpendingUsersCount = 0
local PlayMPpendingUsers = {}
local FirstTime
util.AddNetworkString( "PlayMP:PlayerIsReady" )
net.Receive( "PlayMP:PlayerIsReady", function( len, ply )

	if PlayMP.isPending then
	
		local steamID = ply:SteamID()
		local alreadyReady = false
		
		if table.IsEmpty(PlayMPpendingUsers) then
			FirstTime = CurTime()
			table.insert( PlayMPpendingUsers, {ID = steamID} )
			PlayMPpendingUsersCount = PlayMPpendingUsersCount + 1
			print("[PlayM Pro] User " .. ply:Nick() .. " is ready to play media! (ID: " .. steamID .. ", Count: ".. PlayMPpendingUsersCount .."/" .. #player.GetHumans() ..", CurTime: " .. CurTime() - FirstTime .."s )")
		
		else
			for k, v in pairs(PlayMPpendingUsers) do

				if v.ID == steamID then
					alreadyReady = true
				end
				
				if k == #PlayMPpendingUsers then
					if alreadyReady == false then
						table.insert( PlayMPpendingUsers, {ID = steamID} )
						PlayMPpendingUsersCount = PlayMPpendingUsersCount + 1
						print(HUD_PRINTTALK, "[PlayM Pro] 2: User " .. ply:Nick() .. " is ready to play media! (ID: " .. steamID .. ", Count: ".. PlayMPpendingUsersCount .."/" .. #player.GetHumans() ..", CurTime: " .. CurTime() - FirstTime .."s )")
					end
				end
				
			end
		end
		
		--player.GetCount() 
		if #player.GetHumans() <= PlayMPpendingUsersCount then
			PlayMP:StartMedia()
		end
	
	elseif PlayMP.isPending == false and PlayMP.isPlaying then
	
		net.Start("PlayMP:StartMedia")
		net.Send(ply)
		
	end

end)

util.AddNetworkString( "PlayMP:StartMedia" )
function PlayMP:StartMedia()

	PlayMP.isPending = false
	PlayMPpendingUsersCount = 0
	table.Empty(PlayMPpendingUsers)
	
	net.Start("PlayMP:StartMedia")
	net.Broadcast()
	
	print("[PlayM Pro] All players ready! Starting.")
	
	PlayMP:VideoTimeThink()

end

