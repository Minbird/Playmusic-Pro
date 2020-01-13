PlayMP.Home_Data = {}

PlayMP.Home_Data.Doshow = false

if PlayMP.Home_Data.Doshow then

PlayMP:AddSeparator( "홈" )

PlayMP:AddOption( "장르별 추천", "home", "", function( DScrollPanel )




	--[[if PlayMP.Home_Data.sections != nil then 

		for k, v in pairs(PlayMP.Home_Data.sections) do

			if v["localizations"] then
				if v["localizations"]["ko"] then
					chat.AddText(tostring(v.localizations.ko.title))
					
					local VideoInfo = DScrollPanel:Add( "DPanel" )
					VideoInfo:SetSize( DScrollPanel:GetWide(), 120 )
					VideoInfo:Dock( TOP )
					VideoInfo.Paint = function( self, w, h )
						surface.SetDrawColor( 60, 60, 60, 255 )
						surface.DrawLine( 10, h - 1, w - 10, h - 1 )
					end
					
					local label = vgui.Create( "DLabel", VideoInfo )
					label:SetSize( VideoInfo:GetWide() - 300, 40 )
					label:SetPos( 185, 3 )
					label:SetFont( "Default_PlaymusicPro_Font" )
					label:SetColor( Color( 255, 255, 255, 255 ) )
					label:SetText( tostring(v["localizations"]["ko"]["title"]) )
					
					local VideoImage = vgui.Create( "HTML", VideoInfo )
					VideoImage:SetPos( 10, 5 )
					VideoImage:SetSize( 200, 130)
					VideoImage:SetMouseInputEnabled(false)
					VideoImage:SetHTML( "<img src=\"" .. PlayMP.Home_Data.PlaylistImage[k] .. "\" width=\"160\" height=\"90\">" )
					
					PlayMP:AddActionButton( VideoInfo, "자세히", Color(70, 70, 70), VideoInfo:GetWide() - 100, 13, 80, 30, function() 
								PlayMP:OpenSubFrame( tostring(v["localizations"]["ko"]["title"]), "ㅁㄴㅇㄹ", 600, 600, function( mainPanel, scrpanel, ButtonPanel )
								
									PlayMP:AddActionButton( ButtonPanel, "닫기", Color(70, 70, 70), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
										hook.Remove("HUDPaint", "OpenRequestQueueWindow")
										mainPanel:Close()
									end)
									
									PlayMP:AddTextBox( scrpanel, 50, TOP, tostring(v["localizations"]["ko"]["title"]), scrpanel:GetWide() * 0.5, scrpanel:GetTall() * 0.5 - 24, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_CENTER )
									
									for k, v in pairs(json.items) do
										--v.contentDetails.videoId
										
										http.Fetch("https://www.googleapis.com/youtube/v3/videos?part=snippet&id=" .. v.contentDetails.videoId .. "&key=AIzaSyBek-uYZyjZfn2uyHwsSQD7fyKIRCeXifU", function(data,code,headers)
											local strJson = data
											local json = util.JSONToTable(strJson)
											
											local snippet = json["items"][1]["snippet"]
											
											local title = snippet["title"]
											
											local image = nil
											local Imagedefault = snippet["thumbnails"]
											image = Imagedefault["maxres"]
													
											if image == nil then
												image = Imagedefault["medium"]
											end
													
											image = image["url"]
											
											local VideoInfoInPlayList = scrpanel:Add( "DPanel" )
											VideoInfoInPlayList:SetSize( scrpanel:GetWide(), 120 )
											VideoInfoInPlayList:Dock( TOP )
											VideoInfoInPlayList.Paint = function( self, w, h )
												surface.SetDrawColor( 60, 60, 60, 255 )
												surface.DrawLine( 10, h - 1, w - 10, h - 1 )
											end
											
											local label = vgui.Create( "DLabel", VideoInfoInPlayList )
											label:SetSize( VideoInfoInPlayList:GetWide() - 300, 40 )
											label:SetPos( 185, 3 )
											label:SetFont( "Default_PlaymusicPro_Font" )
											label:SetColor( Color( 255, 255, 255, 255 ) )
											label:SetText( tostring(title) )
											
											local VideoImage = vgui.Create( "HTML", VideoInfoInPlayList )
											VideoImage:SetPos( 10, 5 )
											VideoImage:SetSize( 200, 130)
											VideoImage:SetMouseInputEnabled(false)
											VideoImage:SetHTML( "<img src=\"" .. image .. "\" width=\"160\" height=\"90\">" )

										end)
										
									end
									
								end)
							end)
					
				end
			end
		end
	
		return 
	end]]
	
	local localizationsPlayList = {}
	
	local function AddLocalPlayList( loc, playlists )
		
		table.insert( localizationsPlayList, {
			Loc = loc,
			Playlists = playlists,
		} )
		
	end
	
	AddLocalPlayList( "ko", "PLFgquLnL59anNXuf1M87FT1O169Qt6-Lp" ) -- ko 한국
	AddLocalPlayList( "en", "PLFgquLnL59akA2PflFpeQG9L01VFg90wS" ) -- en 영/미
	AddLocalPlayList( "zh-CN", "PLFgquLnL59alOwE-wZfEygqgABT2yRD9V" ) -- zh-TW / zh-CN 중국
	AddLocalPlayList( "th", "PLFgquLnL59akG4grfATTl1bALQ9wdNL3h" ) -- th 
	AddLocalPlayList( "vi", "PLFgquLnL59anY3ZwTGcV_5ROFhyGF1U4l" ) -- vi 베트남
	AddLocalPlayList( "ru", "PLFgquLnL59anbRi80QEZdeALImKQzNnOl" ) -- ru 러시아
	AddLocalPlayList( "ja", "PLFgquLnL59amuJEYnzXUxiZw5UXCVhWkn" ) -- ja 일본
	AddLocalPlayList( "fr", "PLFgquLnL59anhpY5GjP1IPYrDF7UtL7gv" ) -- fr 프랑스
	
	AddLocalPlayList( "global", "PLS_oEMUyvA728OZPmF9WPKjsGtfC75LiN" )
	AddLocalPlayList( "global", "PL_BvOIu0q-_jfyQ3WDkkNBXgN1gls-NA7" )
	AddLocalPlayList( "global", "PLTDluH66q5mpm-Bsq3GlwjMOHITt2bwXE" )
	AddLocalPlayList( "global", "PLq-ZRVZ1W4Fesh7aKXj8np40uUZJTGBmR" )
	AddLocalPlayList( "global", "PLLMA7Sh3JsOQQFAtj1no-_keicrqjEZDm" )
	AddLocalPlayList( "global", "PLcRN7uK9CFpPkvCc-08tWOQo6PAg4u0lA" )
	AddLocalPlayList( "global", "PLVXq77mXV53-Np39jM456si2PeTrEm9Mj" )
	AddLocalPlayList( "global", "PLSgXDprPMQWsmUquReC4feckOMPU1Zwf5" )
	AddLocalPlayList( "global", "PLUg_BxrbJNY5gHrKsCsyon6vgJhxs72AH" )
	AddLocalPlayList( "global", "PLXYM8jyeq3cfzuIzL0x0rEYxuMCl3dRqh" )
	AddLocalPlayList( "global", "PLTAOP-hZyrHtWfeOJVAvoN5OnuzNNQ0Yw" )
	AddLocalPlayList( "global", "PLvX6nQlsZUNV3OpELfqw-hi2IybBKHVXe" )
	AddLocalPlayList( "global", "PLA-94DyrXTGigxYXPXnRXDDSZ-K0sJxMn" )
	
	local function ShowVideoInfo( tabledata, scrpanel, vt )
	
		local json = {}
	
		for k, v in pairs(tabledata.items) do
										--v.contentDetails.videoId
										
			http.Fetch("https://www.googleapis.com/youtube/v3/videos?part=snippet&id=" .. v.contentDetails.videoId .. "&key=AIzaSyBek-uYZyjZfn2uyHwsSQD7fyKIRCeXifU", function(data,code,headers)
			local strJson = data
			json = util.JSONToTable(strJson)
											
			local snippet = json["items"][1]["snippet"]
											
			local title = snippet["title"]
											
			local image = nil
			local Imagedefault = snippet["thumbnails"]
			image = Imagedefault["maxres"]
													
			if image == nil then
				image = Imagedefault["medium"]
			end
													
			image = image["url"]
											
			local VideoInfoInPlayList = scrpanel:Add( "DPanel" )
			VideoInfoInPlayList:SetSize( scrpanel:GetWide(), 120 )
			VideoInfoInPlayList:Dock( TOP )
			VideoInfoInPlayList.Paint = function( self, w, h )
				surface.SetDrawColor( 60, 60, 60, 255 )
				surface.DrawLine( 10, h - 1, w - 10, h - 1 )
			end
											
			local label = vgui.Create( "DLabel", VideoInfoInPlayList )
			label:SetSize( VideoInfoInPlayList:GetWide() - 300, 40 )
			label:SetPos( 185, 3 )
			label:SetFont( "Default_PlaymusicPro_Font" )
			label:SetColor( Color( 255, 255, 255, 255 ) )
			label:SetText( tostring(title) )
											
			local VideoImage = vgui.Create( "HTML", VideoInfoInPlayList )
			VideoImage:SetPos( 10, 5 )
			VideoImage:SetSize( 200, 130)
			VideoImage:SetMouseInputEnabled(false)
			VideoImage:SetHTML( "<img src=\"" .. image .. "\" width=\"160\" height=\"90\">" )
			
			PlayMP:AddActionButton( VideoInfoInPlayList, "재생", Color( 60, 60, 60, 255 ), VideoInfoInPlayList:GetWide() - 100, 50, 80, 30, function() PlayMP:OpenWriteQueueInfoPanel( "https://www.youtube.com/watch?v=" .. v.contentDetails.videoId ) end)
			
			if k == table.Count(tabledata.items) then
			
				local nextPageTokenPanel = scrpanel:Add( "DPanel" )
				nextPageTokenPanel:SetSize( scrpanel:GetWide(), 70 )
				nextPageTokenPanel:Dock( TOP )
				nextPageTokenPanel.Paint = function( self, w, h )
					surface.SetDrawColor( 60, 60, 60, 255 )
					surface.DrawLine( 10, h - 1, w - 10, h - 1 )
				end
				
				if tabledata["nextPageToken"] != nil then

					PlayMP:AddActionButton( nextPageTokenPanel, "+ 항목 더보기", Color( 60, 60, 60, 255 ), nextPageTokenPanel:GetWide() * 0.5 - 70, 10, 140, 30, function()
								nextPageTokenPanel:Clear()
								http.Fetch("https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&maxResults=10&playlistId=" .. vt .. "&key=AIzaSyBek-uYZyjZfn2uyHwsSQD7fyKIRCeXifU&pageToken=" .. tabledata["nextPageToken"], function(data,code,headers) -- 정보를 가져오기
									local strJson = data
									json = util.JSONToTable(strJson)
									if json == nil then return end
									if json.error then
										PlayMP:Notice( "Playmusic Pro Warning! ErrorCode: " .. json["error"]["code"] .. "\nMessage: " .. json["error"]["message"] , Color(231, 76, 47), "warning" )
										error( "Playmusic Pro Warning! ErrorCode: " .. json["error"]["code"] .. "\nMessage: " .. json["error"]["message"] ) 
										return
									end
									ShowVideoInfo( json, scrpanel, vt )
								end)
							end)
							
						end
						
			end -- 토큰 끝

		end)
										
	end
	
	end -- showvideoinfo
	
	
	

	http.Fetch("https://www.googleapis.com/youtube/v3/channelSections?channelId=UC-9-kyTW8ZkZNDHQJ6FgpwQ&part=contentDetails,localizations&key=AIzaSyBek-uYZyjZfn2uyHwsSQD7fyKIRCeXifU", function(data,code,headers) -- 정보를 가져오기
		local strJson = data
		local json = util.JSONToTable(strJson)
		PlayMP.Home_Data.sections = json.items
		if json == nil then return end
		if json.error then
			PlayMP:Notice( "Playmusic Pro Warning! ErrorCode: " .. json["error"]["code"] .. "\nMessage: " .. json["error"]["message"] , Color(231, 76, 47), "warning" )
			error( "Playmusic Pro Warning! ErrorCode: " .. json["error"]["code"] .. "\nMessage: " .. json["error"]["message"] ) 
			return
		end
		
		local surlang = "ko"
		
		for k, v in pairs(json.items) do
		
			local playlistData = v["contentDetails"]["playlists"]
		
			local doRead = false
		
			for k, v in pairs(localizationsPlayList) do
				if v.Loc == "global" or v.Loc == surlang then
					
					if playlistData != nil and tostring(v.Playlists) == tostring(playlistData[1]) then 
						doRead = true
					end
					
				end
			end
			
			if doRead then

			--if v["localizations"] then
				--if v["localizations"][surlang] then
					--chat.AddText(tostring(v["localizations"][surlang]["title"]))
					
					local VideoInfo = DScrollPanel:Add( "DPanel" )
					VideoInfo:SetSize( DScrollPanel:GetWide(), 120 )
					VideoInfo:Dock( TOP )
					VideoInfo.Paint = function( self, w, h )
						surface.SetDrawColor( 60, 60, 60, 255 )
						surface.DrawLine( 10, h - 1, w - 10, h - 1 )
					end
					
					local label = vgui.Create( "DLabel", VideoInfo )
					label:SetSize( VideoInfo:GetWide() - 300, 40 )
					label:SetPos( 185, 3 )
					label:SetFont( "Default_PlaymusicPro_Font" )
					label:SetColor( Color( 255, 255, 255, 255 ) )
					
					local localizationsTitle = "nil"
					
					if v["localizations"][surlang] == nil then
						localizationsTitle = tostring(v["localizations"]["en"]["title"])
					else
						localizationsTitle = tostring(v["localizations"][surlang]["title"])
					end
					
					label:SetText( localizationsTitle )
					
					if v["contentDetails"]["playlists"] != nil and v["contentDetails"]["playlists"][1] then
					
						--if PlayMP.Home_Data.playlistItems != nil then return end
					
						http.Fetch("https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&maxResults=10&playlistId=" .. tostring(v["contentDetails"]["playlists"][1]) .. "&key=AIzaSyBek-uYZyjZfn2uyHwsSQD7fyKIRCeXifU", function(data,code,headers)
						
							local strJson = data
							local json = util.JSONToTable(strJson)
							PlayMP.Home_Data.playlistItems = json.items
							if json == nil then return end
							if json.error then
								PlayMP:Notice( "Playmusic Pro Warning! ErrorCode: " .. json["error"]["code"] .. "\nMessage: " .. json["error"]["message"] , Color(231, 76, 47), "warning" )
								error( "Playmusic Pro Warning! ErrorCode: " .. json["error"]["code"] .. "\nMessage: " .. json["error"]["message"] ) 
								return
							end
							
							http.Fetch("https://www.googleapis.com/youtube/v3/videos?part=snippet&id=" .. json.items[1]["contentDetails"]["videoId"] .. "&key=AIzaSyBek-uYZyjZfn2uyHwsSQD7fyKIRCeXifU", function(data,code,headers)
								local strJson = data
								local json = util.JSONToTable(strJson)
											
								local snippet = json["items"][1]["snippet"]
								
								local image = nil
								local Imagedefault = snippet["thumbnails"]
								image = Imagedefault["maxres"]
													
								if image == nil then
									image = Imagedefault["medium"]
								end
													
								image = image["url"]
								
								local VideoImage = vgui.Create( "HTML", VideoInfo )
								VideoImage:SetPos( 10, 5 )
								VideoImage:SetSize( 200, 130)
								VideoImage:SetMouseInputEnabled(false)
								VideoImage:SetHTML( "<img src=\"" .. image .. "\" width=\"160\" height=\"90\">" )
								
							end)
							
							PlayMP:AddActionButton( VideoInfo, "모두 재생", Color( 60, 60, 60, 255 ), VideoInfo:GetWide() - 100, 50, 80, 30, function() PlayMP:OpenWriteQueueInfoPanelPlayList( playlistData[1] ) end)
						
							PlayMP:AddActionButton( VideoInfo, "자세히", Color(70, 70, 70), VideoInfo:GetWide() - 100, 13, 80, 30, function() 
								PlayMP:OpenSubFrame( localizationsTitle, "ㅁㄴㅇㄹ", 600, 600, function( mainPanel, scrpanel, ButtonPanel )
								
									PlayMP:AddActionButton( ButtonPanel, "닫기", Color(70, 70, 70), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
										hook.Remove("HUDPaint", "OpenRequestQueueWindow")
										mainPanel:Close()
									end)
									
									PlayMP:AddTextBox( scrpanel, 50, TOP, localizationsTitle, scrpanel:GetWide() * 0.5, scrpanel:GetTall() * 0.5 - 24, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_CENTER )
									
									ShowVideoInfo( json, scrpanel, tostring(v["contentDetails"]["playlists"][1]) )
									
								end)
							end)
						
						end)
						
					end
					
				--end
			--end
			
		end
		
		end
		
	end)

end)

end
