local API_KEY = "AIzaSyBek-uYZyjZfn2uyHwsSQD7fyKIRCeXifU"

PlayMP:AddSeparator( PlayMP:Str( "Music" ) )
	
	PlayMP:AddOption( PlayMP:Str( "Options_queueList" ), "queueList", "", function( DScrollPanel )
		
		local queueRequestButtonPanel = vgui.Create( "DPanel", PlayMP.MenuWindowPanel )
			queueRequestButtonPanel:SetSize( PlayMP.MenuWindowPanel:GetWide(), 50 )
			queueRequestButtonPanel:Dock( TOP )
			queueRequestButtonPanel.Paint = function( self, w, h )
				--PlayMP:blurEff(self, 2, 5, 255)
				draw.RoundedBox( 0, 0, 0, w, h, Color(40,40,40,200) )
			end
			PlayMP:AddActionButton( queueRequestButtonPanel, PlayMP:Str( "Request_Queue" ), Color( 42, 205, 114 ), queueRequestButtonPanel:GetWide() - 120, 10, 110, 30, function()  
			
				PlayMP:OpenWriteQueueInfoPanel("", true)

			end)
			
			local InfoHelpPanel = vgui.Create( "DPanel",PlayMP.MenuWindowPanel )
			InfoHelpPanel:SetSize( PlayMP.MenuWindowPanel:GetWide(), 50 )
			InfoHelpPanel:Dock( TOP )
			InfoHelpPanel:SetBackgroundColor( Color(0,0,0,0) )
			
			local Title = vgui.Create( "DLabel", InfoHelpPanel )
			Title:SetFont( "Default_PlaymusicPro_Font" )
			Title:SetSize( InfoHelpPanel:GetWide() / 2, 40 )
			Title:SetPos( 20, 10 )
			Title:SetColor( Color( 255, 255, 255, 255 ) )
			Title:SetText( PlayMP:Str( "Music_Name" ) )
					
			local Length = vgui.Create( "DLabel", InfoHelpPanel )
			Length:SetFont( "Default_PlaymusicPro_Font" )
			Length:SetSize( 90, 40 )
			Length:SetPos( Title:GetWide() + 20 , 10 )
			Length:SetColor( Color( 255, 255, 255, 255 ) )
			Length:SetText( PlayMP:Str( "PlayTime" ) )
			Length:SetMouseInputEnabled( true )
					
			local PlayUser = vgui.Create( "DLabel", InfoHelpPanel )
			PlayUser:SetFont( "Default_PlaymusicPro_Font" )
			PlayUser:SetSize( InfoHelpPanel:GetWide(), 40 )
			PlayUser:SetPos( Title:GetWide() + Length:GetWide() + 40, 10 )
			PlayUser:SetColor( Color( 255, 255, 255, 255 ) )
			PlayUser:SetText(  PlayMP:Str( "Request_Player" ) )
			PlayUser:SetMouseInputEnabled( true )
			
			if LocalPlayer():IsAdmin() or PlayMP.LocalPlayerData[1]["power"] then
			
				PlayMP:AddActionButton( InfoHelpPanel, PlayMP:Str( "Remove_All_Music_On_Queue" ), Color( 231, 76, 47 ), InfoHelpPanel:GetWide() - 120, 10, 100, 30, function()
				
					local function waitServer()
					PlayMP:OpenSubFrame( PlayMP:Str( "Notice" ), "알림 - 재생중인 노래 삭제?", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
						PlayMP:AddTextBox( scrpanel, scrpanel:GetTall() - 100, BOTTOM, PlayMP:Str( "Wait_Server" ), scrpanel:GetWide() * 0.5, scrpanel:GetTall() * 0.5 - 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
						local loadAnima = PlayMP.GetLoadingAni()
												
											local loadAnimaHTML = vgui.Create( "HTML", scrpanel )
											loadAnimaHTML:Dock(TOP)
											loadAnimaHTML:SetPos( scrpanel:GetWide() * 0.5 -27.5, 10 )
											loadAnimaHTML:SetSize( 100, 100)
											loadAnimaHTML:SetMouseInputEnabled(false)
											loadAnimaHTML:SetHTML( loadAnima )
											net.Receive( "PlayMP:GetQueueData", function()
												hook.Remove("HUDPaint", "OpenRequestQueueWindow")
												mainPanel:Close()
												PlayMP.CurVideoInfo = net.ReadTable()
												PlayMP.CurPlayNum = tonumber(net.ReadString())
												PlayMP:ChangeMenuWindow( "queueList" )
											end)
											
											timer.Simple( 5, function()
											if mainPanel:IsValid() then
											
												hook.Remove("HUDPaint", "OpenRequestQueueWindow")
												mainPanel:Close()
												
											end
											
											PlayMP:OpenSubFrame( PlayMP:Str( "Notice" ), "알림 - 재생중인 노래 삭제?", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
												PlayMP:AddTextBox( scrpanel, scrpanel:GetTall(), FILL, PlayMP:Str( "Receive_No_Reply" ), scrpanel:GetWide() * 0.5, scrpanel:GetTall() * 0.5 - 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
												PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Close" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
													hook.Remove("HUDPaint", "OpenRequestQueueWindow")
													mainPanel:Close()
												end)
											end)
	
										end)
											
										end)
									end		
									
					PlayMP:OpenSubFrame( PlayMP:Str( "Notice" ), "알림 - 재생중인 노래 삭제?", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
						PlayMP:AddTextBox( scrpanel, scrpanel:GetTall(), FILL, PlayMP:Str( "Relly_You_Delete_Every_Music_On_Queue" ), scrpanel:GetWide() * 0.5, scrpanel:GetTall() * 0.5 - 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
							PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Remove" ), Color( 231, 76, 47 ), ButtonPanel:GetWide() - 240, 10, 100, 30, function()
								hook.Remove("HUDPaint", "OpenRequestQueueWindow")
								mainPanel:Close()
								PlayMP:RemoveQueue( 0 )
								--waitServer()
								--PlayMP:GetQueueData(false)
							end)
							PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Cancel" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
								hook.Remove("HUDPaint", "OpenRequestQueueWindow")
								mainPanel:Close()
							end)
					end)

										
				end)
			
			end
			
			DScrollPanel:SetPos( 0, 100 )
			DScrollPanel:SetSize( DScrollPanel:GetWide(), DScrollPanel:GetTall() - 100 )
	
			
			if table.Count(PlayMP.CurVideoInfo) == 0 then
				PlayMP:Notice( PlayMP:Str( "There_Is_No_Music_On_Queue" ), Color(231, 76, 47), "warning" )
				PlayMP:AddTextBox( DScrollPanel, 300, TOP, PlayMP:Str( "ThereIsNoQueueText" ), DScrollPanel:GetWide() * 0.5, 5, "BigTitle_PlaymusicPro_Font", Color(150,150,150), Color(255,255,255,0), TEXT_ALIGN_CENTER )
			else
			
				local only50 = PlayMP:GetSetting( "대기열에50개만표시", false, true )
				local playingMPanel
				
				local function ScrollToChildPMP(playingMPanel)
					timer.Simple( 0.1, function()
						if DScrollPanel:IsValid() and playingMPanel != nil and playingMPanel:IsValid() then
							DScrollPanel:ScrollToChild( playingMPanel )
						end
					end)
				end
			
				for k, v in pairs(PlayMP.CurVideoInfo) do
				
					if v == nil or v["QueueNum"] == nil or PlayMP.CurPlayNum == nil then 
						PlayMP:Notice( PlayMP:Str( "Error_Queue_SomethingWrong" ), Color(231, 76, 47), "warning" )
						PlayMP:AddTextBox( DScrollPanel, 450, TOP, PlayMP:Str( "Error_Queue_SomethingWrong_Explain" ), DScrollPanel:GetWide()/2, 15, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_CENTER, function( self, w, h )
							PlayMP:AddActionButton( self, PlayMP:Str( "ReTry" ), Color( 60, 60, 60, 255 ), w/2 - 100, 300, 200, 30, function()
								PlayMP:ChangeMenuWindow( "queueList" )
							end)
							
							PlayMP:AddActionButton( self, PlayMP:Str( "ReSet_Data_On_Client" ), Color( 60, 60, 60, 255 ), w/2 - 100, 340, 200, 30, function()
								PlayMP.CurVideoInfo = {}
								PlayMP.CurPlayNum = 0
								PlayMP:GetQueueData(true)
							end)
							
							PlayMP:AddActionButton( self, PlayMP:Str( "ReSet_Data_On_Server" ), Color( 60, 60, 60, 255 ), w/2 - 100, 380, 200, 30, function()
								PlayMP:OpenSubFrame( PlayMP:Str( "ReSet_Data_On_Server" ), "알림 - 서버 전체 초기화", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
									PlayMP:AddTextBox( scrpanel, scrpanel:GetTall(), FILL, PlayMP:Str( "ReSet_Data_On_Server_Question" ), scrpanel:GetWide() * 0.5, 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
									PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "ReSet" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 260, 10, 130, 30, function()
										hook.Remove("HUDPaint", "OpenRequestQueueWindow")
										mainPanel:Close()
										net.Start("PlayMP:RESETALLDATA")
										net.SendToServer()
										PlayMP:GetQueueData(false)
									end)
									PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Cancel" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
										hook.Remove("HUDPaint", "OpenRequestQueueWindow")
										mainPanel:Close()
									end)
								end)
							end)
							
						end)
					return end
					--if tonumber(v["QueueNum"]) + 2 < PlayMP.CurPlayNum then
					
					--else
					
						--[[if only50 and k == 50 then
						
							PlayMP:AddTextBox( DScrollPanel, 40, TOP, "더 이상은 무리..!", DScrollPanel:GetWide()/2, 15, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_CENTER )
							PlayMP:AddTextBox( DScrollPanel, 80, TOP, "사용자의 깔끔한 사용 환경을 위해, " .. table.Count(PlayMP.CurVideoInfo) - PlayMP.CurPlayNum - k .. "개가 더 있지만\n여기에 표시하지 않았습니다.", DScrollPanel:GetWide()/2, 15, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_CENTER, function( self, w, h )
								PlayMP:AddActionButton( self, "설정에서 변경", Color( 60, 60, 60, 255 ), w - 210, 40, 200, 30, function()
									PlayMP:ChangeMenuWindow( "ClientOptions" )
								end)
							end)
						
							return
						
						end]]
					
						local queueListInfoPanelBase = DScrollPanel:Add( "DPanel" )
						--queueListInfoPanelBase:SetSize( DScrollPanel:GetWide(), 120 )
						queueListInfoPanelBase:Dock( TOP )
						queueListInfoPanelBase:SetBackgroundColor( Color(0,0,0,0) )
						
						if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
							playingMPanel = queueListInfoPanelBase
							queueListInfoPanelBase:SetSize( DScrollPanel:GetWide(), 120 )
						else
							queueListInfoPanelBase:SetSize( DScrollPanel:GetWide(), 60 )
						end
						
						local queueListInfoPanel = vgui.Create( "DPanel", queueListInfoPanelBase )
						--queueListInfoPanel:SetSize( DScrollPanel:GetWide() - 4, 56 )
						if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
							queueListInfoPanel:SetSize( DScrollPanel:GetWide() - 4, 116 )
						else
							queueListInfoPanel:SetSize( DScrollPanel:GetWide() - 4, 56 )
						end
						queueListInfoPanel:SetPos( 2, 2 )
						queueListInfoPanel:SetBackgroundColor( Color(40,40,40,230) )
						
						--[[local curtime = CurTime()
						queueListInfoPanel.Paint = function( self, w, h )
					
							surface.SetDrawColor( 70, 70, 70, 255 )
							surface.DrawLine( 30, h - 1, w - 30, h - 1 )
							
						end]]
						
						local QueueNum = vgui.Create( "DLabel", queueListInfoPanel )
						QueueNum:SetFont( "DermaDefault" )

						if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
							queueListInfoPanelBase:SetBackgroundColor( Color( 42, 205, 114, 255) )
							QueueNum:SetColor( Color( 42, 205, 114, 255) )
							QueueNum:SetText( PlayMP:Str( "Now_Playing_MainPanelMusic" ) )
							DScrollPanel:ScrollToChild( queueListInfoPanel )
							QueueNum:SetSize( queueListInfoPanel:GetWide() - 150, 20 )
							QueueNum:SetPos( 5, 10 )
							local function colorbrth()
								queueListInfoPanelBase:AlphaTo( 200, 1, 0, function() queueListInfoPanelBase:AlphaTo( 255, 1, 0, function() colorbrth() end) end)
							end
							colorbrth()
						else
							QueueNum:SetColor( Color( 255, 255, 255, 255 ) )
							QueueNum:SetText( "    #" .. v["QueueNum"] )
							QueueNum:SetSize( queueListInfoPanel:GetWide() - 150, 20 )
							QueueNum:SetPos( 5, 5 )
						end

						local Title = vgui.Create( "DLabel", queueListInfoPanel )
						Title:SetFont( "Default_PlaymusicPro_Font" )
						if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
							Title:SetColor( Color( 42, 205, 114, 255) )
							Title:SetSize( queueListInfoPanel:GetWide() / 2, 20 )
							Title:SetPos( 10, 30 )
						else
							Title:SetColor( Color( 255, 255, 255, 255 ) )
							Title:SetSize( queueListInfoPanel:GetWide() / 2, 18 )
							Title:SetPos( 22, 19 )
						end
						Title:SetText( "  " .. v["Title"] )
						Title:SetMouseInputEnabled( true )
						
						local Length = vgui.Create( "DLabel", queueListInfoPanel )
						Length:SetFont( "Default_PlaymusicPro_Font" )
						if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
							Length:SetSize( 100, 20 )
							Length:SetPos( Title:GetWide() , 30 )
						else
							Length:SetSize( 100, 20 )
							Length:SetPos( Title:GetWide() , 18 )
						end
						Length:SetColor( Color( 255, 255, 255, 255 ) )
						Length:SetText( "     " .. string.ToMinutesSeconds( v["endTime"] - v["startTime"] ) )
						Length:SetMouseInputEnabled( true )

						local playerNick = ""
						surface.SetFont( "Default_PlaymusicPro_Font" )
						if not v["PlayUser"]:IsPlayer() or not v["PlayUser"]:IsValid() then
							playerNick = PlayMP:Str( "UnknownPlayer" )
						else
							playerNick = v["PlayUser"]:Nick()
						end
						local w, h = surface.GetTextSize( playerNick )
						
						
						local button = {}
						
						local PlayUserButtonBack = vgui.Create( "DPanel", queueListInfoPanel )
						if k == PlayMP.CurPlayNum then
							PlayUserButtonBack:SetSize( 32 + w + 20, 42 )
							PlayUserButtonBack:SetPos( Title:GetWide() + Length:GetWide() + 25, 25 )
						else
							PlayUserButtonBack:SetSize( 42, 42 )
							PlayUserButtonBack:SetPos( Title:GetWide() + Length:GetWide() + 25, 7 )
						end

						PlayUserButtonBack:SetBackgroundColor( Color(255,255,255,10) )
						
						if v["PlayUser"]:IsPlayer() and v["PlayUser"]:IsValid() then
							local PlayUserImage = vgui.Create( "AvatarImage", PlayUserButtonBack )
							PlayUserImage:SetSize( 32, 32 )
							PlayUserImage:SetPos( 5,5 )
							PlayUserImage:SetPlayer( v["PlayUser"], 32 )
						end
						
						local PlayUser
						if k == PlayMP.CurPlayNum then
							PlayUser = vgui.Create( "DLabel", PlayUserButtonBack )
							PlayUser:SetFont( "Default_PlaymusicPro_Font" )
							PlayUser:SetSize( w, 18 )
							PlayUser:SetPos( 42, 13 )
							PlayUser:SetColor( Color( 230, 230, 230, 255 ) )
							PlayUser:SetText( playerNick )
							PlayUser:SetMouseInputEnabled( true )
						end
						
						local PlayUserButton = vgui.Create( "DLabel", PlayUserButtonBack )
						PlayUserButton:SetFont( "Default_PlaymusicPro_Font" )
						PlayUserButton:Dock(FILL)
						PlayUserButton:SetColor( Color( 255, 255, 255, 255 ) )
						PlayUserButton:SetText( "" )
						PlayUserButton:SetMouseInputEnabled( true )
						PlayUserButton.OnCursorEntered = function( self, w, h )
							PlayUserButtonBack:SetBackgroundColor( Color(255,255,255,50) )
							if PlayUser != nil then
								PlayUser:SetColor( Color( 255, 255, 255, 255 ) )
							end
						end
						PlayUserButton.OnCursorExited = function( self, w, h )
							PlayUserButtonBack:SetBackgroundColor( Color(255,255,255,10) )
							if PlayUser != nil then
								PlayUser:SetColor( Color( 230, 230, 230, 255 ) )
							end
						end
						PlayUserButton.DoClick = function()
							local tall = 300
							if LocalPlayer():IsAdmin() or PlayMP.LocalPlayerData[1]["power"] then tall = 666 end
							PlayMP:OpenSubFrame( PlayMP:Str( "Player_Info" ), "상세 정보", 600, tall, function( mainPanel, scrpanel, ButtonPanel )
								if not v["PlayUser"]:IsPlayer() or not v["PlayUser"]:IsValid() then
									PlayMP:AddTextBox( scrpanel, 30, TOP, PlayMP:Str( "NodataforPlayer" ), scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(255,255,255,10), TEXT_ALIGN_CENTER )
									PlayMP:AddTextBox( scrpanel, 30, TOP, PlayMP:Str( "Playerhasleftthegame" ), scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
								else
									PlayMP:AddTextBox( scrpanel, 30, TOP, PlayMP:Str( "NickName" ), scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(255,255,255,10), TEXT_ALIGN_CENTER )
									PlayMP:AddTextBox( scrpanel, 30, TOP, v["PlayUser"]:Nick(), scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
									PlayMP:AddTextBox( scrpanel, 30, TOP, "SteamID", scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(255,255,255,10), TEXT_ALIGN_CENTER )
									PlayMP:AddTextBox( scrpanel, 40, TOP, v["PlayUser"]:SteamID(), 15, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
										PlayMP:AddActionButton( self, PlayMP:Str( "Copy_On_Clipboard" ), Color( 60, 60, 60, 255 ), w - 170, 5, 160, 30, function()
											SetClipboardText(v["PlayUser"]:SteamID())
											PlayMP:Notice( PlayMP:Str( "Done_Copy_PlySID" ), Color(42, 205, 114), "notice" )
										end)
									end)
									PlayMP:AddTextBox( scrpanel, 30, TOP, PlayMP:Str( "Player_Profile" ), scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(255,255,255,10), TEXT_ALIGN_CENTER )
									PlayMP:AddTextBox( scrpanel, 40, TOP, PlayMP:Str( "Player_Profile_Open" ), 15, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
										PlayMP:AddActionButton( self, PlayMP:Str( "Open" ), Color( 60, 60, 60, 255 ), w - 110, 5, 100, 30, function()
											v["PlayUser"]:ShowProfile() 
										end)
									end)
								end
								
								PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Close" ), Color(231, 76, 47), ButtonPanel:GetWide() - 90, 10, 80, 30, function() 
									hook.Remove("HUDPaint", "OpenRequestQueueWindow")
									mainPanel:Close() 
								end)
								
								if LocalPlayer():IsAdmin() or PlayMP.LocalPlayerData[1]["power"] then
									net.Receive( "PlayMP:GetUserInfoBySID", function( len, ply )
										local data = net.ReadTable()

										
										PlayMP:AddTextBox( scrpanel, 48, TOP, PlayMP:Str( "Music" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
										local check1 = PlayMP:AddCheckBox( scrpanel, nil, PlayMP:Str( "AdminSet_Qeeue" ), nil, true, data[1], "qeeue" )
										local check2 = PlayMP:AddCheckBox( scrpanel, nil, PlayMP:Str( "AdminSet_Skip" ), nil, true, data[1], "skip" )
										local check3 = PlayMP:AddCheckBox( scrpanel, nil, PlayMP:Str( "AdminSet_seekTo" ), nil, true, data[1], "seekto" )
										local check4 = PlayMP:AddCheckBox( scrpanel, nil, PlayMP:Str( "AdminSet_Ban" ), nil, true, data[1], "ban" )
										
										PlayMP:AddTextBox( scrpanel, 48, TOP, PlayMP:Str( "Admin" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
										local check5 = PlayMP:AddCheckBox( scrpanel, nil, PlayMP:Str( "AdminSet_AdminLicense" ), nil, true, data[1], "power" )
										
										PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "AdminSet_SyncData" ), Color(42, 205, 114), ButtonPanel:GetWide() - 280, 10, 180, 30, function() PlayMP:SetUserInfoBySID(v["PlayUser"]:SteamID(), data) end)
									end)
									PlayMP:GetUserInfoBySID(v["PlayUser"]:SteamID())
								end
								
							end)
						end
						
						local abX
						local abY
						local abW
						local abT
						if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
							--abXYWT = 20, 65, 250, 30
							abX = 20
							abY = 65
							abW = 250
							abT = 30
						else
							--abXYWT = queueListInfoPanel:GetWide() - 130, 13, 30, 30
							abX = queueListInfoPanel:GetWide() - 130
							abY = 11
							abW = 34
							abT = 34
						end
						local abD = PlayMP:AddActionButton( queueListInfoPanel, "  " ..PlayMP:Str( "Save_On_MyPlaylist" ), Color( 42, 205, 114, 255 ), abX, abY, abW, abT, function() 
							
							local v = v
							local stat = PlayMP:AddLocalPlayList( {
								Title = v["Title"], 
								Channel = v["Channel"],
								Uri = v["Uri"],
								IsPlayList = false}
							)
											
							if stat == "alreadySaved" then
								PlayMP:Notice( PlayMP:Str( "Already_Saved_OnMyPlylist" ), Color(231, 76, 47), "warning" )
							elseif stat == "writed" then
								PlayMP:Notice( PlayMP:Str( "Saved_OnMyPlylist", v["Title"] ), Color(42, 205, 114), "notice" )
							end
							
						end, "materials/vgui/playmusic_pro/11.png" )
						if tonumber(v["QueueNum"]) != PlayMP.CurPlayNum then
							abD:SetText( "" )
						end
						
						
						if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
							--abXYWT = 280, 65, 150, 30
							abX = 280
							abY = 65
							abW = 150
							abT = 30
						else
							--abXYWT = queueListInfoPanel:GetWide() - 90, 13, 30, 30
							abX = queueListInfoPanel:GetWide() - 90
							abY = 11
							abW = 34
							abT = 34
						end
						local abD = PlayMP:AddActionButton( queueListInfoPanel, "  " ..PlayMP:Str( "Info_Details" ), Color( 60, 60, 60, 255 ), abX, abY, abW, abT, function() 
							PlayMP:OpenSubFrame( PlayMP:Str( "Info_Details" ), "상세 정보", 600, 360, function( mainPanel, scrpanel, ButtonPanel )
							
								PlayMP:AddTextBox( scrpanel, 30, TOP, "Title", scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(255,255,255,10), TEXT_ALIGN_CENTER )
								PlayMP:AddTextBox( scrpanel, 60, TOP, v["Title"], scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
								PlayMP:AddTextBox( scrpanel, 30, TOP, "Channel", scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(255,255,255,10), TEXT_ALIGN_CENTER )
								PlayMP:AddTextBox( scrpanel, 30, TOP, v["Channel"], scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
								PlayMP:AddTextBox( scrpanel, 30, TOP, "Real Playback Time", scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(255,255,255,10), TEXT_ALIGN_CENTER )
								PlayMP:AddTextBox( scrpanel, 30, TOP, v["Length"], scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
								PlayMP:AddTextBox( scrpanel, 30, TOP, "URL", scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(255,255,255,10), TEXT_ALIGN_CENTER )
								PlayMP:AddTextBox( scrpanel, 30, TOP, "https://www.youtube.com/watch?v=" .. v["Uri"], scrpanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
								
								
								PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Close" ), Color(231, 76, 47), ButtonPanel:GetWide() - 90, 10, 80, 30, function() 
									hook.Remove("HUDPaint", "OpenRequestQueueWindow")
									mainPanel:Close() 
								end)
								
								PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Copy_On_Clipboard" ), Color(70, 70, 70), ButtonPanel:GetWide() - 300, 10, 200, 30, function() 
								
									hook.Remove("HUDPaint", "OpenRequestQueueWindow")
									mainPanel:Close()
								
									SetClipboardText( table.ToString(v, "Queue Info", true) ) 
									
									PlayMP:OpenSubFrame( PlayMP:Str( "Notice" ), "알림 - 클립보드에 복사함", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
										PlayMP:AddTextBox( scrpanel, scrpanel:GetTall(), FILL, PlayMP:Str( "Copy_On_Clipboard_ExPlain" ), scrpanel:GetWide() * 0.5, scrpanel:GetTall() * 0.5 - 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
										PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "OK" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
											hook.Remove("HUDPaint", "OpenRequestQueueWindow")
											mainPanel:Close()
										end )
										
									end)
									
									
								end)
								
								
							end)
						end, "materials/vgui/playmusic_pro/22.png" )
						if tonumber(v["QueueNum"]) != PlayMP.CurPlayNum then
							abD:SetText( "" )
						end
						
						if LocalPlayer():IsAdmin() or PlayMP.LocalPlayerData[1]["power"] or v["PlayUser"] == LocalPlayer() then
							if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
								--abXYWT = 280, 65, 150, 30
								abX = queueListInfoPanel:GetWide() - 140
								abY = 70
								abW = 120
								abT = 30
							else
								--abXYWT = queueListInfoPanel:GetWide() - 50, 13, 30, 30
								abX = queueListInfoPanel:GetWide() - 50
								abY = 11
								abW = 34
								abT = 34
							end
							local abD = PlayMP:AddActionButton( queueListInfoPanel, "  " ..PlayMP:Str( "Remove" ), Color( 231, 76, 47 ), abX, abY, abW, abT, function()
							
								local function waitServer()
									PlayMP:OpenSubFrame( PlayMP:Str( "Notice" ), "알림 - 재생중인 노래 삭제?", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
										PlayMP:AddTextBox( scrpanel, scrpanel:GetTall() - 100, BOTTOM, PlayMP:Str( "Wait_Server" ), scrpanel:GetWide() * 0.5, scrpanel:GetTall() * 0.5 - 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
										local loadAnima = PlayMP.GetLoadingAni()
											
										local loadAnimaHTML = vgui.Create( "HTML", scrpanel )
										loadAnimaHTML:Dock(TOP)
										loadAnimaHTML:SetPos( scrpanel:GetWide() * 0.5 -27.5, 10 )
										loadAnimaHTML:SetSize( 100, 100)
										loadAnimaHTML:SetMouseInputEnabled(false)
										loadAnimaHTML:SetHTML( loadAnima )
										net.Receive( "PlayMP:GetQueueData", function()
											hook.Remove("HUDPaint", "OpenRequestQueueWindow")
											mainPanel:Close()
											PlayMP.CurVideoInfo = net.ReadTable()
											PlayMP.CurPlayNum = tonumber(net.ReadString())
											PlayMP:ChangeMenuWindow( "queueList" )
										end)
										
										timer.Simple( 5, function()
											if mainPanel:IsValid() then
											
												hook.Remove("HUDPaint", "OpenRequestQueueWindow")
												mainPanel:Close()
												
											end
											
											PlayMP:OpenSubFrame( PlayMP:Str( "Notice" ), "알림 - 재생중인 노래 삭제?", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
												PlayMP:AddTextBox( scrpanel, scrpanel:GetTall(), FILL, PlayMP:Str( "Receive_No_Reply" ), scrpanel:GetWide() * 0.5, scrpanel:GetTall() * 0.5 - 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
												PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Close" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
													hook.Remove("HUDPaint", "OpenRequestQueueWindow")
													mainPanel:Close()
												end)
											end)
	
										end)
										
									end)
								end
							
								if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
									PlayMP:OpenSubFrame( PlayMP:Str( "Notice" ), "알림 - 재생중인 노래 삭제?", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
										PlayMP:AddTextBox( scrpanel, scrpanel:GetTall(), FILL, PlayMP:Str( "Remove_Media_Now_Playing" ), scrpanel:GetWide() * 0.5, scrpanel:GetTall() * 0.5 - 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
										PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Remove" ), Color( 231, 76, 47 ), ButtonPanel:GetWide() - 240, 10, 100, 30, function()
											hook.Remove("HUDPaint", "OpenRequestQueueWindow")
											mainPanel:Close()
											net.Start("PlayMP:RemoveQueue")
												net.WriteString(tonumber(v["QueueNum"]) )
											net.SendToServer()
											--PlayMP:GetQueueData(false)
											--waitServer()
											
										end )
										PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Cancel" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
											hook.Remove("HUDPaint", "OpenRequestQueueWindow")
											mainPanel:Close()
										end )
										
									end)
								else
									net.Start("PlayMP:RemoveQueue")
										net.WriteString(tonumber(v["QueueNum"]) )
									net.SendToServer()
									--PlayMP:GetQueueData(false)
									--waitServer()
									
								end

								PlayMP:ChangeMenuWindow( "queueList" )
							end, "materials/vgui/playmusic_pro/33.png" )
			
							if tonumber(v["QueueNum"]) != PlayMP.CurPlayNum then
								abD:SetText( "" )
							end
							
						end
						
						--print( tonumber(v["QueueNum"]) >= table.Count(PlayMP.CurVideoInfo) ,tonumber(v["QueueNum"]), table.Count(PlayMP.CurVideoInfo) )
						if tonumber(v["QueueNum"]) >= table.Count(PlayMP.CurVideoInfo) then
							ScrollToChildPMP(playingMPanel)
						end
						
						if k == #PlayMP.CurVideoInfo then
							PlayMP:AddTextBox( DScrollPanel, 60, TOP, PlayMP:Str( "ThereIsEndOfQueueText" ), queueListInfoPanel:GetWide() * 0.5, 5, "BigTitle_PlaymusicPro_Font", Color(255,255,255), Color(255,255,255,0), TEXT_ALIGN_CENTER )
							PlayMP:AddTextBox( DScrollPanel, 30, TOP, PlayMP:Str( "ThereIsEndOfQueueText2", #PlayMP.CurVideoInfo ), queueListInfoPanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,5), TEXT_ALIGN_CENTER )
						end
					
					--end
					
				end
				
			end
		
		end)
		
		PlayMP:AddOption( PlayMP:Str( "Options_myPlayList" ), "myPlayList", "", function( DScrollPanel )

			local SearchPanel = vgui.Create( "Panel", PlayMP.MenuWindowPanel )
			SearchPanel:SetSize( PlayMP.MenuWindowPanel:GetWide(), 50 )
			SearchPanel:Dock( TOP )
			SearchPanel.Paint = function( self, w, h )
				draw.RoundedBox( 20, 10, 5, w - 20, h - 10, Color(100,100,100,255) )
			end
			
			local TextEntry = vgui.Create( "DTextEntry", SearchPanel )
			TextEntry:SetPos( 50, 5 )
			TextEntry:SetSize( SearchPanel:GetWide() - 50, 40 )
			TextEntry:SetDrawBackground(false)
			TextEntry:SetCursorColor(Color( 255, 255, 255, 255 ))
			TextEntry:SetFont( "Default_PlaymusicPro_Font" )
			TextEntry:SetTextColor( Color( 255, 255, 255, 255 ) )
			TextEntry:SetPlaceholderText( PlayMP:Str( "Search_On_MyPlylist" ) )
			
			TextEntry:RequestFocus() 
			
			DScrollPanel:SetPos( 0, 90 )
			DScrollPanel:SetSize( DScrollPanel:GetWide(), DScrollPanel:GetTall() - 90 )
			
			local SearchIcon = vgui.Create( "DImage", SearchPanel )
			SearchIcon:SetPos( 10, 5 )
			SearchIcon:SetSize( 40, 40 )
			SearchIcon:SetImage( "vgui/playmusic_pro/search.vmt" )
			
			local MyPlayList = PlayMP:ReadLocalPlayList()
			
			if MyPlayList == nil then
				MyPlayList = {}
			end
			
			if #MyPlayList == 0 then 
				PlayMP:AddTextBox( DScrollPanel, 300, TOP, PlayMP:Str( "ThereIsNoPlaylistText" ), DScrollPanel:GetWide() * 0.5, 5, "BigTitle_PlaymusicPro_Font", Color(150,150,150), Color(255,255,255,0), TEXT_ALIGN_CENTER )
			end


			PlayMP:AddTextBox( PlayMP.MenuWindowPanel, 40, TOP, PlayMP:Str( "Plylist_Count", table.Count(MyPlayList) ), 15, 15, "Default_PlaymusicPro_Font", Color( 150, 150, 150 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
				--PlayMP:AddActionButton( self, "플레이 리스트 등록", Color( 60, 60, 60, 255 ), w - 170, 5, 160, 30, function()  end)
			end)
			
			TextEntry.OnChange = function( self )
			
				DScrollPanel:Clear()
				
				local targetCount = 0
				
				for k, v in pairs(MyPlayList) do
				
					local channelTag = ""
					if v.Channel then channelTag = v.Channel end
					local target = string.find( string.lower(v.Title), string.lower(self:GetValue()), 1, true ) or string.find( string.lower(channelTag), string.lower(self:GetValue()), 1, true )
					
					if target then
					
						targetCount = targetCount + 1
						
						local InfoHelpPanelBack = DScrollPanel:Add( "DPanel" )
						InfoHelpPanelBack:SetSize( DScrollPanel:GetWide(), 60 )
						InfoHelpPanelBack:Dock( TOP )
						InfoHelpPanelBack:SetBackgroundColor( Color(255,255,255,0) )

						local InfoHelpPanel = vgui.Create( "DPanel", InfoHelpPanelBack )
						InfoHelpPanel:SetSize( DScrollPanel:GetWide() - 19, 56 )
						InfoHelpPanel:SetPos( 4, 2 )
						InfoHelpPanel:SetBackgroundColor( Color(40,40,40,255) )
							
						local Title = vgui.Create( "DLabel", InfoHelpPanel )
						Title:SetFont( "Default_PlaymusicPro_Font" )
						Title:SetSize( InfoHelpPanel:GetWide() / 2, 40 )
						Title:SetPos( 25, 8 )
						Title:SetColor( Color( 200, 200, 200, 255 ) )
						Title:SetText( v.Title )
						
						local CTitle = vgui.Create( "DLabel", InfoHelpPanel )
						CTitle:SetFont( "Default_PlaymusicPro_Font" )
						CTitle:SetSize( InfoHelpPanel:GetWide() / 2 - 230, 40 )
						CTitle:SetPos( InfoHelpPanel:GetWide() / 2 + 45, 8 )
						CTitle:SetColor( Color( 150, 150, 150, 255 ) )
						if v.Channel then
							CTitle:SetText( v.Channel )
						else
							CTitle:SetText( "???" )
							CTitle:SetColor( Color( 150, 100, 80, 255 ) )
						end
						
						InfoHelpPanel.OnCursorEntered = function( self, w, h )
							InfoHelpPanel:SetBackgroundColor( Color(50,50,50,255), 0.5 )
							Title:SetColor( Color( 255, 255, 255, 255 ) )
						end
						InfoHelpPanel.OnCursorExited = function( self, w, h )
							InfoHelpPanel:SetBackgroundColor( Color(40,40,40,255), 1 ) 
							Title:SetColor( Color( 200, 200, 200, 255 ) )
						end
					
						PlayMP:AddActionButton( InfoHelpPanel, "", Color( 60, 60, 60, 255 ), InfoHelpPanel:GetWide() - 90, 11, 34, 34, function() PlayMP:OpenWriteQueueInfoPanel( "https://www.youtube.com/watch?v=" .. v.Uri, false, v.StartTime, v.EndTime ) end, "materials/vgui/playmusic_pro/55.png")
						PlayMP:AddActionButton( InfoHelpPanel, "", Color(231, 76, 47), InfoHelpPanel:GetWide() - 50, 11, 34, 34, function() 
							PlayMP:OpenSubFrame( PlayMP:Str( "RemoveMusicFromPlayList" ), "알림 - 삭제 여부 확인", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
								PlayMP:AddTextBox( scrpanel, scrpanel:GetTall(), FILL, v.Title .. "\n " .. PlayMP:Str( "AreYouSureRemoveThisMusic" ), 0, 20, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_CENTER, function( TextBox, w, t, label ) label:SetWrap( false ) end)
								PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Remove" ), Color(231, 76, 47), ButtonPanel:GetWide() - 230, 10, 100, 30, function()
								
								local stat = PlayMP:RemoveLocalPlayList( v.Uri ) 
							
									if stat == "removed" then
										PlayMP:ChangeMenuWindow( "myPlayList" )
									end
									
									hook.Remove("HUDPaint", "OpenRequestQueueWindow")
									mainPanel:Close()
								end )
								
								PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Cancel" ), Color(70, 70, 70), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
									hook.Remove("HUDPaint", "OpenRequestQueueWindow")
									mainPanel:Close()
								end)	
							end)
						end, "materials/vgui/playmusic_pro/33.png")
						
						PlayMP:AddActionButton( InfoHelpPanel, "", Color( 60, 60, 60, 255 ), InfoHelpPanel:GetWide() - 130, 11, 34, 34, function() PlayMP:EditLocalPlayListPanel( v.Uri ) end, "materials/vgui/playmusic_pro/44.png")
						
					end

					if tonumber(k) == table.Count(MyPlayList) then
						if tonumber(targetCount) == 0 then
							--PlayMP:AddTextBox( DScrollPanel, 40, TOP, PlayMP:Str( "There_Is_No_Result", self:GetValue() ), 15, 15, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT )
							PlayMP:AddTextBox( DScrollPanel, 300, TOP, PlayMP:Str( "There_Is_No_Result", self:GetValue() ), DScrollPanel:GetWide() * 0.5, 5, "BigTitle_PlaymusicPro_Font", Color(150,150,150), Color(255,255,255,0), TEXT_ALIGN_CENTER )
						end
					end
					
				end
				
			end


			
			if MyPlayList == "notFound" or MyPlayList == "NoData" then
			
				PlayMP:Notice( PlayMP:Str( "There_Is_No_Playlist" ), Color(231, 76, 47), "warning" )
			
				local Title = vgui.Create( "DLabel", DScrollPanel )
				Title:SetFont( "Default_PlaymusicPro_Font" )
				Title:SetSize( DScrollPanel:GetWide() / 2, 40 )
				Title:SetPos( 10, 0 )
				Title:SetColor( Color( 255, 255, 255, 255 ) )
				Title:SetText( PlayMP:Str( "There_Is_No_Playlist" ) )
				
				PlayMP:AddTextBox( DScrollPanel, 300, TOP, PlayMP:Str( "ThereIsNoPlaylistText" ), DScrollPanel:GetWide() * 0.5, 5, "BigTitle_PlaymusicPro_Font", Color(150,150,150), Color(255,255,255,0), TEXT_ALIGN_CENTER )
				
				return
			end
		
			for k, v in pairs(MyPlayList) do
			
				local InfoHelpPanelBack = DScrollPanel:Add( "DPanel" )
				InfoHelpPanelBack:SetSize( DScrollPanel:GetWide(), 60 )
				InfoHelpPanelBack:Dock( TOP )
				InfoHelpPanelBack:SetBackgroundColor( Color(255,255,255,0) )
			
				local InfoHelpPanel = vgui.Create( "DPanel", InfoHelpPanelBack )
				InfoHelpPanel:SetSize( DScrollPanel:GetWide() - 19, 56 )
				InfoHelpPanel:SetPos( 4, 2 )
				InfoHelpPanel:SetBackgroundColor( Color(40,40,40,255) )
				
				local Title = vgui.Create( "DLabel", InfoHelpPanel )
				Title:SetFont( "Default_PlaymusicPro_Font" )
				Title:SetSize( InfoHelpPanel:GetWide() / 2, 40 )
				Title:SetPos( 25, 10 )
				Title:SetColor( Color( 200, 200, 200, 255 ) )
				Title:SetText( v.Title )
				
				local CTitle = vgui.Create( "DLabel", InfoHelpPanel )
				CTitle:SetFont( "Default_PlaymusicPro_Font" )
				CTitle:SetSize( InfoHelpPanel:GetWide() / 2 - 230, 40 )
				CTitle:SetPos( InfoHelpPanel:GetWide() / 2 + 45, 8 )
				CTitle:SetColor( Color( 150, 150, 150, 255 ) )
				if v.Channel then
					CTitle:SetText( v.Channel )
				else
					CTitle:SetText( "???" )
					CTitle:SetColor( Color( 150, 100, 80, 255 ) )
				end
				
				InfoHelpPanel.OnCursorEntered = function( self, w, h )
					InfoHelpPanel:SetBackgroundColor( Color(50,50,50,255), 0.5 )
					Title:SetColor( Color( 255, 255, 255, 255 ) )
				end
				InfoHelpPanel.OnCursorExited = function( self, w, h )
					InfoHelpPanel:SetBackgroundColor( Color(40,40,40,255), 1 ) 
					Title:SetColor( Color( 200, 200, 200, 255 ) )
				end

				PlayMP:AddActionButton( InfoHelpPanel, "", Color( 60, 60, 60, 255 ), InfoHelpPanel:GetWide() - 90, 11, 34, 34, function() PlayMP:OpenWriteQueueInfoPanel( "https://www.youtube.com/watch?v=" .. v.Uri, false, v.StartTime, v.EndTime ) end, "materials/vgui/playmusic_pro/55.png")
				PlayMP:AddActionButton( InfoHelpPanel, "", Color(231, 76, 47), InfoHelpPanel:GetWide() - 50, 11, 34, 34, function() 
					PlayMP:OpenSubFrame( PlayMP:Str( "RemoveMusicFromPlayList" ), "알림 - 삭제 여부 확인", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
						PlayMP:AddTextBox( scrpanel, scrpanel:GetTall(), FILL, v.Title .. "\n " .. PlayMP:Str( "AreYouSureRemoveThisMusic" ), 0, 20, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_CENTER,function( TextBox, w, t, label ) label:SetWrap( false ) end)
						PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Remove" ), Color(231, 76, 47), ButtonPanel:GetWide() - 230, 10, 100, 30, function()
						
						local stat = PlayMP:RemoveLocalPlayList( v.Uri ) 
					
							if stat == "removed" then
								PlayMP:ChangeMenuWindow( "myPlayList" )
							end
							
							hook.Remove("HUDPaint", "OpenRequestQueueWindow")
							mainPanel:Close()
						end )
						
						PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Cancel" ), Color(70, 70, 70), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
							hook.Remove("HUDPaint", "OpenRequestQueueWindow")
							mainPanel:Close()
						end)
									
					end)
					
					
					
				end, "materials/vgui/playmusic_pro/33.png")
				
				PlayMP:AddActionButton( InfoHelpPanel, "", Color( 60, 60, 60, 255 ), InfoHelpPanel:GetWide() - 130, 11, 34, 34, function() PlayMP:EditLocalPlayListPanel( v.Uri ) end, "materials/vgui/playmusic_pro/44.png")
			
			end
		
		end)
		
		PlayMP:AddOption( PlayMP:Str( "Options_search" ), "search", "", function( DScrollPanel )
		
			local SearchPanel = vgui.Create( "DPanel", PlayMP.MenuWindowPanel )
			SearchPanel:SetSize( PlayMP.MenuWindowPanel:GetWide(), 50 )
			SearchPanel:Dock( TOP )
			SearchPanel.Paint = function( self, w, h ) 
				draw.RoundedBox( 20, 10, 5, w - 20, h - 10, Color(100,100,100,255) )
			end
			
			PlayMP.VideoListPanel = vgui.Create( "DPanel", PlayMP.MenuWindowPanel )
			PlayMP.VideoListPanel:SetSize( PlayMP.MenuWindowPanel:GetWide(), PlayMP.MenuWindowPanel:GetTall() - 250 )
			PlayMP.VideoListPanel:SetPos( 0, 50 )
			PlayMP.VideoListPanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) end
			PlayMP:AddTextBox( PlayMP.VideoListPanel, 300, TOP, PlayMP:Str( "Search_On_Youtube" ), PlayMP.VideoListPanel:GetWide() * 0.5, 5, "BigTitle_PlaymusicPro_Font", Color(150,150,150), Color(255,255,255,0), TEXT_ALIGN_CENTER )
			
			local TextEntry = vgui.Create( "DTextEntry", SearchPanel )
			TextEntry:SetPos( 50, 5 )
			TextEntry:SetSize( SearchPanel:GetWide() - 50, 40 )
			TextEntry:SetDrawBackground(false)
			TextEntry:SetCursorColor(Color( 255, 255, 255, 255 ))
			TextEntry:SetFont( "Default_PlaymusicPro_Font" )
			TextEntry:SetTextColor( Color( 255, 255, 255, 255 ) )
			TextEntry:SetPlaceholderText( PlayMP:Str( "Search_On_Youtube" ) )
			
			TextEntry:RequestFocus() 
			
			local SearchIcon = vgui.Create( "DImage", SearchPanel )
			SearchIcon:SetPos( 10, 5 )
			SearchIcon:SetSize( 40, 40 )
			SearchIcon:SetImage( "vgui/playmusic_pro/search.vmt" )
			
			--local suggestions = {}
			TextEntry.OnEnter = function( self )
				PlayMP:SearchVideo( self:GetValue() )
				--table.insert( suggestions, self:GetValue() )
			end
			
			--[[function TextEntry:GetAutoComplete( text )
				return suggestions
			end]]
			
			function PlayMP:SearchVideo( str )
			
				local searchVideo = {}
				searchVideo.str = ""
			

				PlayMP.VideoListPanel:Clear()
				
				PlayMP.VideoListPanel = vgui.Create( "DPanel", PlayMP.MenuWindowPanel )
				PlayMP.VideoListPanel:SetSize( PlayMP.MenuWindowPanel:GetWide(), PlayMP.MenuWindowPanel:GetTall() - 200 )
				PlayMP.VideoListPanel:SetPos( 0, 50 )
				PlayMP.VideoListPanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) end
				
				local DScrollPanel = vgui.Create( "DScrollPanel", PlayMP.VideoListPanel )
				DScrollPanel:SetSize( PlayMP.VideoListPanel:GetWide(), PlayMP.VideoListPanel:GetTall() )
				DScrollPanel:SetPos( 0, 0 )
				DScrollPanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) end
				DScrollPanel:SetPadding( 10 )
				
				local sbar = DScrollPanel:GetVBar()
				function sbar:Paint( w, h )
					draw.RoundedBox( 5, 3, 15, w - 6, h - 30, Color( 70, 70, 70 ) )
				end
				function sbar.btnUp:Paint( w, h )
					--draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100 ) )
				end
				function sbar.btnDown:Paint( w, h )
					--draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100 ) )
				end
				function sbar.btnGrip:Paint( w, h )
					draw.RoundedBox( 5, 3, 0, w - 6, h, Color( 120, 120, 120 ) )
				end
				
				local loadAnima = PlayMP.GetLoadingAni()
					
				local loadAnimaHTML = vgui.Create( "HTML", DScrollPanel )
				loadAnimaHTML:SetPos( DScrollPanel:GetWide() * 0.5 -27.5, 10 )
				loadAnimaHTML:SetSize( 100, 100)
				loadAnimaHTML:SetMouseInputEnabled(false)
				loadAnimaHTML:SetHTML( loadAnima )
			
				local videoResults = {}
				
				function videoResults:ShowVideoInfo( isValue, data ) -- 정보를 표시
					if isValue then
					
						for k, v in pairs( data.items ) do
						
							if v.id.kind == "youtube#video" or v.id.kind == "youtube#playlist" then
							
								loadAnimaHTML:Remove()
							
								local VideoInfo = DScrollPanel:Add( "DPanel" )
								VideoInfo:SetSize( DScrollPanel:GetWide(), 120 )
								VideoInfo:Dock( TOP )
								--[[VideoInfo.Paint = function( self, w, h )
									surface.SetDrawColor( 60, 60, 60, 255 )
									surface.DrawLine( 10, h - 1, w - 10, h - 1 )
								end]]
								VideoInfo:SetBackgroundColor( Color(40,40,40,255))
							
								if v.snippet.thumbnails then
								
									local VideoImage = vgui.Create( "HTML", VideoInfo )
									VideoImage:SetPos( 10, 5 )
									VideoImage:SetSize( 200, 130)
									VideoImage:SetMouseInputEnabled(false)
									VideoImage:SetHTML( "<img src=\"" .. v.snippet.thumbnails.medium.url .. "\" width=\"160\" height=\"90\">" )
									
								end
						
								local label = vgui.Create( "DLabel", VideoInfo )
								label:SetSize( VideoInfo:GetWide() - 300, 40 )
								label:SetPos( 185, 3 )
								label:SetFont( "Default_PlaymusicPro_Font" )
								label:SetColor( Color( 230, 230, 230, 255 ) )
								label:SetText( v.snippet.title )
							
								local label2 = vgui.Create( "DLabel", VideoInfo )
								label2:SetSize( VideoInfo:GetWide() - 400, 40 )
								label2:SetPos( 185, 30 )
								label2:SetFont( "Default_PlaymusicPro_Font" )
								label2:SetColor( Color( 150, 150, 150, 255 ) )
								label2:SetText( v.snippet.description )
								
								VideoInfo.OnCursorEntered = function( self, w, h )
									VideoInfo:SetBackgroundColor( Color(50,50,50,255), 0.5 )
									label:SetColor( Color( 255, 255, 255, 255 ) )
									label2:SetColor( Color( 170, 170, 170, 255 ) )
								end
								VideoInfo.OnCursorExited = function( self, w, h )
									VideoInfo:SetBackgroundColor( Color(40,40,40,255), 1 ) 
									label:SetColor( Color( 230, 230, 230, 255 ) )
									label2:SetColor( Color( 150, 150, 150, 255 ) )
								end
								
								
								if v.id.kind == "youtube#video" then -- read error logs no.2 and no.3
									PlayMP:AddActionButton( VideoInfo, "  " .. PlayMP:Str( "Save_On_MyPlaylist" ), Color( 60, 60, 60, 255 ), VideoInfo:GetWide() - 320, 70, 200, 30, function() 
										local v = v
										local stat = PlayMP:ReadVideoAndWritePlayList( v )
											
										if stat == "alreadySaved" then
											PlayMP:Notice( PlayMP:Str( "Already_Saved_OnMyPlylist" ), Color(231, 76, 47), "warning" )
										elseif stat == "writed" then
											PlayMP:Notice( PlayMP:Str( "Saved_OnMyPlylist", v.snippet.title ), Color(42, 205, 114), "notice" )
										end
										
									end, "materials/vgui/playmusic_pro/11.png" )
								end
								
								local Videoid = ""
								
								if v.id.kind == "youtube#video" then
									Videoid = "https://www.youtube.com/watch?v=" .. v.id.videoId
								else
									Videoid = "https://www.youtube.com/watch?list=" .. v.id.playlistId
								end
								
								if v.id.kind == "youtube#video" then
									PlayMP:AddActionButton( VideoInfo, "  " .. PlayMP:Str( "Play" ), Color( 60, 60, 60, 255 ), VideoInfo:GetWide() - 110, 70, 90, 30, function() PlayMP:OpenWriteQueueInfoPanel( Videoid ) end, "materials/vgui/playmusic_pro/55.png")
								else
									PlayMP:AddActionButton( VideoInfo, "  " .. PlayMP:Str( "Play" ), Color( 60, 60, 60, 255 ), VideoInfo:GetWide() - 110, 70, 90, 30, function() PlayMP:OpenWriteQueueInfoPanelPlayList( v.id.playlistId ) end, "materials/vgui/playmusic_pro/55.png")
								end
								
								if k == table.Count(data.items) then
									if data.nextPageToken != nil then
									
										local nextPageTokenPanel = DScrollPanel:Add( "DPanel" )
										nextPageTokenPanel:SetSize( DScrollPanel:GetWide(), 70 )
										nextPageTokenPanel:Dock( TOP )
										nextPageTokenPanel.Paint = function( self, w, h )
											surface.SetDrawColor( 60, 60, 60, 255 )
											surface.DrawLine( 10, h - 1, w - 10, h - 1 )
										end

										PlayMP:AddActionButton( nextPageTokenPanel, PlayMP:Str( "Show_More" ), Color( 60, 60, 60, 255 ), nextPageTokenPanel:GetWide() * 0.5 - 70, 10, 140, 30, function()
											nextPageTokenPanel:Clear()
											http.Fetch("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=" .. 20 .. "&q=" .. searchVideo.str .. "&key=" .. API_KEY .. "&pageToken=" .. data.nextPageToken, function(data,code,headers) -- 정보를 가져오기
												local strJson = data
												json = util.JSONToTable(strJson)
												if json == nil then return end
												if json.error then
													local message = json["error"]["message"]
													if json["error"]["code"] == "403" then
														message = PlayMP:Str( "GOOGLEAPI_Error01" )
													end
													PlayMP:Notice( "Playmusic Pro Warning! ErrorCode: " .. json["error"]["code"] .. "\nMessage: " .. message , Color(231, 76, 47), "warning" )
													error( "Playmusic Pro Warning! ErrorCode: " .. json["error"]["code"] .. "\nMessage: " .. message ) 
													return
												end
												videoResults:ShowVideoInfo( true, json )
											end)
										end)

									end
								end

							end
						end
						
						
						
					else -- 검색 결과가 없다면
					
						PlayMP:AddTextBox( DScrollPanel, 300, TOP, PlayMP:Str( "There_Is_No_Result", str ), DScrollPanel:GetWide() * 0.5, 5, "BigTitle_PlaymusicPro_Font", Color(150,150,150), Color(255,255,255,0), TEXT_ALIGN_CENTER )
						
						
						
					end
					
				end
	
	
				local exploded = string.Explode(" ", str )
				for k, v in pairs(exploded) do
					local v = v
					local sstart, send = string.find(v, string.PatternSafe( "%" ), 1, false)
					if sstart then
						v = string.sub( v, 1, sstart - 1 ) .. "%25" .. string.sub( v, send + 1 )
					end
					searchVideo.str = searchVideo.str .. "%20" .. v
				end
				
				
				http.Fetch("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=" .. 20 .. "&q=" .. searchVideo.str .. "&key=" .. API_KEY, function(data,code,headers) -- 정보를 가져오기
				
					local strJson = data
					json = util.JSONToTable(strJson)
				
					if json == nil then return end
				
				
					if json.error then
						local message = json["error"]["message"]
						if json["error"]["code"] == "403" then
							message = PlayMP:Str( "GOOGLEAPI_Error01" )
						end
						PlayMP:Notice( "Playmusic Pro Warning! ErrorCode: " .. json["error"]["code"] .. "\nMessage: " .. message , Color(231, 76, 47), "warning" )
						return
					end
				
				
					if table.Count( json.items ) == 0 then -- 검색 결과가 없는 경우
				
						videoResults:ShowVideoInfo( false )
					
					else -- 검색 결과가 있다면 출력
						
						videoResults:ShowVideoInfo( true, json )
				
					end
				
				end)
			end
			
		end)