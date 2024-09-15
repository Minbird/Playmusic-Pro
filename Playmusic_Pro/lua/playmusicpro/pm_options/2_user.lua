PlayMP:AddSeparator( PlayMP:Str( "User" ), "icon16/user.png" )
		
		PlayMP:AddOption( PlayMP:Str( "Options_myState" ), "myState", "", function( DScrollPanel )  
		
			local MySteamInfo = DScrollPanel:Add( "DPanel" )
			MySteamInfo:SetSize( DScrollPanel:GetWide(), 180 )
			MySteamInfo:Dock( TOP )
			MySteamInfo:SetBackgroundColor( Color(0,0,0,100) )
			
			local UserImage = vgui.Create( "AvatarImage", MySteamInfo )
			UserImage:SetSize( 128, 128 )
			UserImage:SetPos( (MySteamInfo:GetWide() / 2) - 64, 30 )
			UserImage:SetPlayer( LocalPlayer(), 128 )
			
			if PlayMP.LocalPlayerData[1]["power"] then
				PlayMP:AddTextBox( DScrollPanel, 20, TOP, PlayMP:Str( "MyState_Admin" ), 30, 0, "Trebuchet18", Color(180,120,120), Color(0,0,0,100), TEXT_ALIGN_CENTER )
			end
			PlayMP:AddTextBox( DScrollPanel, 60, TOP, PlayMP:Str( "MyState_HelloPlayer", LocalPlayer():Nick() ), 30, 0, "DermaLarge", Color(255,255,255), Color(0,0,0,100), TEXT_ALIGN_CENTER )
			
			if PlayMP.LocalPlayerData[1]["ban"] or PlayMP:GetSetting( "AOAPMP", false, true ) then
				PlayMP:AddTextBox( DScrollPanel, 30, TOP, PlayMP:Str( "MyState_CanTUsePlaymusic" ), 30, 0, "Default_PlaymusicPro_Font", Color(255,255,255), Color(231, 76, 47), TEXT_ALIGN_CENTER )
				PlayMP:AddTextBox( DScrollPanel, 30, TOP, PlayMP:Str( "MyState_CanTUsePlaymusic2" ), DScrollPanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(255,255,255,10), TEXT_ALIGN_CENTER )
				PlayMP:AddTextBox( DScrollPanel, 60, TOP, PlayMP:Str( "MyState_CanTUsePlaymusic3" ), DScrollPanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
			else
				PlayMP:AddTextBox( DScrollPanel, 30, TOP, PlayMP:Str( "MyState_CanUsePlaymusic" ), 30, 0, "Default_PlaymusicPro_Font", Color(255,255,255), Color(42, 205, 114), TEXT_ALIGN_CENTER )
			end
			
			if not PlayMP.LocalPlayerData[1]["qeeue"] or not PlayMP.LocalPlayerData[1]["skip"] or not PlayMP.LocalPlayerData[1]["seekto"] or PlayMP:GetSetting( "AOASkip", false, true ) or PlayMP:GetSetting( "AOACPL", false, true ) or PlayMP:GetSetting( "AOAQueue", false, true ) then
				PlayMP:AddTextBox( DScrollPanel, 30, TOP, PlayMP:Str( "MyState_SomeRestrictions" ), 30, 0, "Default_PlaymusicPro_Font", Color(255,255,255), Color(231, 76, 47), TEXT_ALIGN_CENTER )
				local text = ""
				if not PlayMP.LocalPlayerData[1]["qeeue"] or PlayMP:GetSetting( "AOAQueue", false, true ) then
					text = text .. PlayMP:Str( "CUInfo_AddMusicToQueue" )
				end
				if not PlayMP.LocalPlayerData[1]["skip"] or PlayMP:GetSetting( "AOASkip", false, true ) then
					text = text .. PlayMP:Str( "CUInfo_SkipMusic" )
				end
				if not PlayMP.LocalPlayerData[1]["seekto"] or PlayMP:GetSetting( "AOACPL", false, true ) then
					text = text .. PlayMP:Str( "CUInfo_ChangePlaybackLocations" )
				end
				
				PlayMP:AddTextBox( DScrollPanel, 30, TOP, PlayMP:Str( "MyState_SomeRestrictions2", text ), 30, 0, "Default_PlaymusicPro_Font", Color(255,255,255), Color(231, 76, 47), TEXT_ALIGN_CENTER )
				PlayMP:AddTextBox( DScrollPanel, 30, TOP, PlayMP:Str( "MyState_CanTUsePlaymusic2" ), DScrollPanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(255,255,255,10), TEXT_ALIGN_CENTER )
				PlayMP:AddTextBox( DScrollPanel, 60, TOP, PlayMP:Str( "MyState_SomeRestrictions3" ), DScrollPanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
			end
			
			
			if PlayMP.LocalPlayerData[1]["power"] or LocalPlayer():IsAdmin() then
				PlayMP:AddTextBox( DScrollPanel, 30, TOP, PlayMP:Str( "MyState_CanCtrlPlaymusic" ), 30, 0, "Default_PlaymusicPro_Font", Color(255,255,255), Color(42, 205, 114), TEXT_ALIGN_CENTER )
			end
			
			PlayMP:AddTextBox( DScrollPanel, 60, TOP, PlayMP:Str( "mediaHistory" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
			PlayMP:AddTextBox( DScrollPanel, 30, TOP, PlayMP:Str( "mediaHistoryIsLocal" ), 30, -18, "Default_PlaymusicPro_Font", Color(200,200,200), Color(40, 40, 40), TEXT_ALIGN_LEFT )
			
			if #PlayMP.Client_History.MediaHistory == 0 then
				PlayMP:AddTextBox( DScrollPanel, 300, TOP, PlayMP:Str( "noMediaHistory" ), DScrollPanel:GetWide() * 0.5, 5, "BigTitle_PlaymusicPro_Font", Color(150,150,150), Color(255,255,255,0), TEXT_ALIGN_CENTER )
			end
			
			for k ,v in pairs(PlayMP.Client_History.MediaHistory) do
			
								local VideoInfo = DScrollPanel:Add( "DPanel" )
								VideoInfo:SetSize( DScrollPanel:GetWide(), 120 )
								VideoInfo:Dock( TOP )
								VideoInfo:SetBackgroundColor( Color(40,40,40,255))
							
								if v.thumbnails then
								
									local VideoImage = vgui.Create( "HTML", VideoInfo )
									VideoImage:SetPos( 10, 5 )
									VideoImage:SetSize( 200, 130)
									VideoImage:SetMouseInputEnabled(false)
									VideoImage:SetHTML( "<img src=\"" .. v.thumbnails .. "\" width=\"160\" height=\"90\">" )
									
								else
								
									local VideoImage = DScrollPanel:Add( "DPanel" )
									VideoImage:SetSize( 200, 130)
									VideoImage:SetPos( 10, 5 )
									VideoImage:SetBackgroundColor( Color(80,80,80) )
									
								end
						
								local label = vgui.Create( "DLabel", VideoInfo )
								label:SetSize( VideoInfo:GetWide() - 300, 40 )
								label:SetPos( 195, 3 )
								label:SetFont( "Default_PlaymusicPro_Font" )
								label:SetColor( Color( 230, 230, 230, 255 ) )
								label:SetText( v.title )
								
								local label3 = vgui.Create( "DLabel", VideoInfo )
								label3:SetSize( VideoInfo:GetWide() - 400, 20 )
								label3:SetPos( 195, 40 )
								label3:SetFont( "DermaDefault" )
								label3:SetColor( Color( 150, 150, 150, 255 ) )
								label3:SetText( v.channelTitle )
								
								local label4 = vgui.Create( "DLabel", VideoInfo )
								label4:SetSize( VideoInfo:GetWide() - 400, 20 )
								label4:SetPos( 195, 55 )
								label4:SetFont( "DermaDefault" )
								label4:SetColor( Color( 150, 150, 150, 255 ) )
								
								local dateString = v.DateString
								local datecur = os.time()/86400 - v.Time/86400
								local timecur = os.time() - v.Time
								if datecur <= 1 then
									if timecur < 60 then
										dateString = PlayMP:Str( "PSec", math.Round(timecur) )
									elseif timecur > 60 and timecur < 3600 then
										dateString = PlayMP:Str( "PMin", math.Round(timecur/60) )
									else
										dateString = PlayMP:Str( "PHur", math.Round(timecur/3600) )
									end
								elseif datecur > 1 and datecur < 31 then
									dateString = math.Round(datecur) .. PlayMP:Str( "PDay", math.Round(datecur) )
								end
								
								label4:SetText( dateString )
								
								VideoInfo.OnCursorEntered = function( self, w, h )
									VideoInfo:SetBackgroundColor( Color(50,50,50,255), 0.5 )
									label:SetColor( Color( 255, 255, 255, 255 ) )
								end
								VideoInfo.OnCursorExited = function( self, w, h )
									VideoInfo:SetBackgroundColor( Color(40,40,40,255), 1 ) 
									label:SetColor( Color( 230, 230, 230, 255 ) )
								end
								
								PlayMP:AddActionButton( VideoInfo, "  " .. PlayMP:Str( "Play" ), Color( 60, 60, 60, 255 ), 190, 75, 90, 30, function() PlayMP:OpenWriteQueueInfoPanel( "https://www.youtube.com/watch?v="..v.Uri ) end, "materials/vgui/playmusic_pro/55.png")
								
								PlayMP:AddActionButton( VideoInfo, "  " ..PlayMP:Str( "Save_On_MyPlaylist" ), Color( 42, 205, 114, 255 ), 285, 75, 210, 30, function() 
									local stat = PlayMP:AddLocalPlayList( {
										Title = v.title, 
										Channel = v.channelTitle,
										Uri = v.Uri,
										IsPlayList = false}
									)
													
									if stat == "alreadySaved" then
										PlayMP:Notice( PlayMP:Str( "Already_Saved_OnMyPlylist" ), Color(231, 76, 47), "warning" )
									elseif stat == "writed" then
										PlayMP:Notice( PlayMP:Str( "Saved_OnMyPlylist", v["Title"] ), Color(42, 205, 114), "notice" )
									end
									
								end, "materials/vgui/playmusic_pro/11.png" )
			end
			
			
			
		end)
		
		PlayMP:AddOption( PlayMP:Str( "Options_ClientOptions" ), "ClientOptions", "", function(DScrollPanel)
			
			PlayMP:AddTextBox( DScrollPanel, 48, TOP, PlayMP:Str( "Player" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
			
			PlayMP:AddTextBox( DScrollPanel, 80, TOP, PlayMP:Str( "Player_Engine_ex" ), 30, 0, "Default_PlaymusicPro_Font", Color(255,255,255), Color(40, 40, 40, 0), TEXT_ALIGN_LEFT )
			PlayMP:AddTextBox( DScrollPanel, 55, TOP, PlayMP:Str( "CSet_Player_Engine" ), 40, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
			
				local DComboBox = vgui.Create( "DComboBox", self )
				DComboBox:SetPos( self:GetWide() - 220, 12.5 )
				DComboBox:SetSize( 200, 30 )
				
				local type = {}
				type[0] = PlayMP:Str( "CSet_Player_Engine_Gmod" )
				type[1] = PlayMP:Str( "CSet_Player_Engine_Chromium" )
				
				DComboBox.OnSelect = function( panel, index, value )
				
					if value == type[0] then
						PlayMP:ChangeSetting( "PlayerEngine", 0 )
						PlayMP.Player.Engine_type = "gmod"
					end
					
					if value == type[1] then
						PlayMP:ChangeSetting( "PlayerEngine", 1 )
						PlayMP.Player.Engine_type = "chromium"
					end
					
					-- 재생기 새로고침
					PlayMP.Player:Reload_Player()

				end
				
				local curSet = PlayMP:GetSetting( "PlayerEngine", false, true )
				if curSet == nil then curSet = 0 end
				
				DComboBox:AddChoice( type[0] )
				DComboBox:AddChoice( type[1] )
				DComboBox:SetValue( type[curSet] )
				
				self.Paint = function( self, w, h )
					surface.SetDrawColor( 70, 70, 70, 255 )
					surface.DrawLine( 30, h - 1, w - 30, h - 1 )
				end
			end)


			PlayMP:AddTextBox( DScrollPanel, 80, TOP, PlayMP:Str( "Embed_IframePlayer_ex" ), 30, 0, "Default_PlaymusicPro_Font", Color(255,255,255), Color(40, 40, 40, 0), TEXT_ALIGN_LEFT )
			PlayMP:AddTextBox( DScrollPanel, 55, TOP, PlayMP:Str( "CSet_PlayerType" ), 40, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
			
				local DComboBox = vgui.Create( "DComboBox", self )
				DComboBox:SetPos( self:GetWide() - 220, 12.5 )
				DComboBox:SetSize( 200, 30 )
				
				local type = {}

				type[0] = "YTDL Player"
				type[1] = "Iframe Player"
				type[2] = "Embed Player"
				
				local typeList = {}
				typeList[0] = PlayMP.PlayerURLList[0]
				typeList[1] = PlayMP.PlayerURLList[1]
				typeList[2] = PlayMP.PlayerURLList[2]
				local selectorList = {}
				selectorList[0] = PlayMP.SelectorList[0]
				selectorList[1] = PlayMP.SelectorList[1]
				selectorList[2] = PlayMP.SelectorList[2]
				
				DComboBox.OnSelect = function( panel, index, value )
				
					if value == type[0] then
						PlayMP:ChangeSetting( "PlayerType", 0 )
						PlayMP.Player.Url = typeList[0]
						PlayMP.Player.QuerySelector = selectorList[0]
					end
					
					if value == type[1] then
						PlayMP:ChangeSetting( "PlayerType", 1 )
						PlayMP.Player.Url = typeList[1]
						PlayMP.Player.QuerySelector = selectorList[1]
					end
					
					if value == type[2] then
						PlayMP:ChangeSetting( "PlayerType", 2 )
						PlayMP.Player.Url = typeList[2]
						PlayMP.Player.QuerySelector = selectorList[2]
					end
					
					-- 재생기 새로고침
					if PlayMP.Player.isPlaying != true then return end
					if PlayMP.PlayerMode == "worldScr" then return end
					
					PlayMP.Player:Reload_Player()

				end
				
				local curSet = PlayMP:GetSetting( "PlayerType", false, true )
				if curSet == nil then curSet = 0 end
				
				DComboBox:AddChoice( type[0] )
				DComboBox:AddChoice( type[1] )
				DComboBox:AddChoice( type[2] )
				DComboBox:SetValue( type[curSet] )
				
				self.Paint = function( self, w, h )
					surface.SetDrawColor( 70, 70, 70, 255 )
					surface.DrawLine( 30, h - 1, w - 30, h - 1 )
				end
			end)
				
				
				
			PlayMP:AddCheckBox( DScrollPanel, "", PlayMP:Str( "CSet_SyncPlay_WhenConnectAtHalfway" ), "SyncPlay_WCAH" )
			PlayMP:AddCheckBox( DScrollPanel, "", PlayMP:Str( "CSet_No_Play_Always" ), "No_Play_Always" )
			PlayMP:AddCheckBox( DScrollPanel, function()
				if PlayMP.Player.isPlaying != true then return end
				if PlayMP.PlayerMode == "worldScr" then return end
				
				PlayMP.Player:Reload_Player()

				end, PlayMP:Str( "CSet_Show_MediaPlayer" ), "Show_MediaPlayer" )
			PlayMP:AddTextBox( DScrollPanel, 55, TOP, PlayMP:Str( "CSet_ChangeViewerSet" ), 40, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
				PlayMP:AddActionButton( self, PlayMP:Str( "CSet_ChangeViewerSet_OpenViewer" ), Color( 60, 60, 60, 255 ), w - 120, 12.5, 100, 30, function() if PlayMP.PlayerMode == "worldScr" then return end PlayMP:EditMainPlayer() end)
				self.Paint = function( self, w, h )
					surface.SetDrawColor( 70, 70, 70, 255 )
					surface.DrawLine( 30, h - 1, w - 30, h - 1 )
				end
			end)
			PlayMP:AddCheckBox( DScrollPanel, function()
				if PlayMP:GetSetting( "Show_InfPan_Always", false, true ) then
					PlayMP.NotchInfoPanel_PlayerVideoImage:SetAlpha(255)
					PlayMP.NotchInfoPanel:AlphaTo( 255, 1 )
					PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.55 - ScrW() * 0.2, 20, 1)
				else
					PlayMP.NotchInfoPanel_PlayerVideoImage:SetAlpha(0)
					PlayMP.NotchInfoPanel:AlphaTo( 0, 1 )
					PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.55 - ScrW() * 0.2, 0, 1)
				end
			end, PlayMP:Str( "CSet_Show_InfoPanel_Always" ), "Show_InfPan_Always" )
			--PlayMP:AddCheckBox( DScrollPanel, "", PlayMP:Str( "CSet_No_Show_InfoPanel" ), "No_Show_InfoPanel" )
			PlayMP:AddTextBox( DScrollPanel, 55, TOP, PlayMP:Str( "CSet_VolChangeWhenPlayerStartVChatOri" ), 40, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT)
			local CSet_VolChangeWhenPlayerStartVChatOriLabel = PlayMP:AddTextBox( DScrollPanel, 55, TOP, PlayMP:Str( "CSet_VolChangeWhenPlayerStartVChatOri" ), 40, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT)
				PlayMP:AddTextBox( DScrollPanel, 44, TOP, "", 40, 0, "Trebuchet24", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
					
					local numslider = PlayMP:CreatNumScroll( self, 100, 0, 0, 100, self:GetWide()-200, true)
					numslider:SetNum( PlayMP:GetSetting("VolConWhenPlyStVo", false, true) * 100 )
					CSet_VolChangeWhenPlayerStartVChatOriLabel:SetColor(Color(255,255,255,50))
					local CSet_VolChangeWhenPlayerStartVChatOriLabelPosX, CSet_VolChangeWhenPlayerStartVChatOriLabelPosY = CSet_VolChangeWhenPlayerStartVChatOriLabel:GetPos()
					CSet_VolChangeWhenPlayerStartVChatOriLabel:SetPos(CSet_VolChangeWhenPlayerStartVChatOriLabelPosX+60,CSet_VolChangeWhenPlayerStartVChatOriLabelPosY)
					
					if numslider:GetValue() == 0 then
						CSet_VolChangeWhenPlayerStartVChatOriLabel:SetText(PlayMP:Str( "CSet_MuteWhenPlayerStartVChat" ))
					elseif numslider:GetValue() == 100 then
						CSet_VolChangeWhenPlayerStartVChatOriLabel:SetText(PlayMP:Str( "CSet_NoVolChangeWhenPlayerStartVChat" ))
					else
						CSet_VolChangeWhenPlayerStartVChatOriLabel:SetText(PlayMP:Str( "CSet_VolChangeWhenPlayerStartVChat", numslider:GetValue()/100 ))
					end
					
					numslider.ValueChanged = function( d )
						
						--PlayMP.net.ChangConVar( "playmp_queue_user", math.floor(d) )
						if math.floor(d) == 0 then
							CSet_VolChangeWhenPlayerStartVChatOriLabel:SetText(PlayMP:Str( "CSet_MuteWhenPlayerStartVChat" ))
						elseif math.floor(d) == 100 then
							CSet_VolChangeWhenPlayerStartVChatOriLabel:SetText(PlayMP:Str( "CSet_NoVolChangeWhenPlayerStartVChat" ))
						else
							CSet_VolChangeWhenPlayerStartVChatOriLabel:SetText(PlayMP:Str( "CSet_VolChangeWhenPlayerStartVChat", math.floor(d)/100 ))
						end
						PlayMP:ChangeSetting( "VolConWhenPlyStVo", math.floor(d)/100 )
						CSet_VolChangeWhenPlayerStartVChatOriLabel:SetColor(Color(255,255,255,255))
						CSet_VolChangeWhenPlayerStartVChatOriLabel:ColorTo(Color(255,255,255,50), 1)
					end
					self.Paint = function( self, w, h )
					surface.SetDrawColor( 70, 70, 70, 255 )
					surface.DrawLine( 30, h - 1, w - 30, h - 1 )
				end
			end)
			
			
			PlayMP:AddTextBox( DScrollPanel, 48, TOP, PlayMP:Str( "CSet_Queue" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
			PlayMP:AddCheckBox( DScrollPanel, "", PlayMP:Str( "CSet_Quick_Request" ), "Quick_Request" )
			PlayMP:AddCheckBox( DScrollPanel, nil, PlayMP:Str( "CSet_removeOldMedia" ), "removeOldQueue" )
			--PlayMP:AddCheckBox( DScrollPanel, "", "대기열 50개만 표시해 사용 환경 최적화", "대기열에50개만표시" )
			
			--[[PlayMP:AddTextBox( DScrollPanel, 48, TOP, "PlayX", 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
			if PlayX != nil then
				PlayMP:AddCheckBox( DScrollPanel, "", PlayMP:Str( "CSet_PlayX01" ), "PlayX01" )
			else
				PlayMP:AddTextBox( DScrollPanel, 48, TOP, PlayMP:Str( "CSet_There_Is_No_PlayX" ), DScrollPanel:GetWide() * 0.5, 15, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0, 0, 0, 0), TEXT_ALIGN_CENTER )
			end]] -- PlayX 옵션이 있을 필요가 있나?
			
			PlayMP:AddTextBox( DScrollPanel, 48, TOP, PlayMP:Str( "CSet_Graphics" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
			PlayMP:AddCheckBox( DScrollPanel, "", PlayMP:Str( "CSet_Use_Blur" ), "Use_Blur" )
			PlayMP:AddCheckBox( DScrollPanel, "", PlayMP:Str( "CSet_Use_Animation" ), "Use_Animation" )
			PlayMP:AddTextBox( DScrollPanel, 48, TOP, PlayMP:Str( "System" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
			
			PlayMP:AddTextBox( DScrollPanel, 55, TOP, PlayMP:Str( "CSet_openMenuBind" ), 40, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
				
				local binder = vgui.Create( "DBinder", self )
				binder:SetSize( 200, 30 )
				binder:SetPos( self:GetWide() - 220, 12.5 )
				local bindkey = PlayMP:GetSetting( "mainMenuBind", false, true )
				if bindkey == nil then 
					PlayMP:ChangeSetting( "mainMenuBind", 100 )
					bindkey = 100 
				end
				binder:SetValue( bindkey )

				binder.OnChange = function( self, num )
					if num != nil then
						PlayMP:ChangeSetting( "mainMenuBind", num )
					end
					PlayMP.PlayMPMenuBind = num
					--chat.AddText(input.GetKeyName(num))
				end
				
				self.Paint = function( self, w, h )
					surface.SetDrawColor( 70, 70, 70, 255 )
					surface.DrawLine( 30, h - 1, w - 30, h - 1 )
				end
			end)
			PlayMP:AddTextBox( DScrollPanel, 55, TOP, PlayMP:Str( "CSet_Language" ), 40, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
			
				local DComboBox = vgui.Create( "DComboBox", self )
				DComboBox:SetPos( self:GetWide() - 220, 12.5 )
				DComboBox:SetSize( 200, 30 )
				DComboBox.OnSelect = function( panel, index, value )
				
					if value == ( PlayMP:Str( "CSet_Language_UseSysLag", GetConVarString("gmod_language") ) ) then
						PlayMP:ChangeSetting( "시스템언어", "SystemLang" )
					end
					
					local CurLangName
					
					for k, v in pairs(PlayMP.CurLangData) do
						if v.Lang == value then
							PlayMP:ChangeSetting( "시스템언어", v.LangUni )
							PlayMP:ChangeLang(v.LangUni)
							CurLangName = v.Lang
						end
					end
					
					PlayMP:OpenSubFrame( PlayMP:Str( "Notice" ), "재시작후언어적용알림", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
						PlayMP:AddTextBox( scrpanel, scrpanel:GetTall(), FILL, PlayMP:Str( "CSet_Language_PlzReStartPMP", CurLangName ), scrpanel:GetWide() * 0.5, 40, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
						PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "OK" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
							hook.Remove("HUDPaint", "OpenRequestQueueWindow")
							mainPanel:Close()
						end )
					end)
				end
				
				DComboBox:AddChoice( PlayMP:Str( "CSet_Language_UseSysLag", GetConVarString("gmod_language") ) )
				
				for k, v in pairs(PlayMP.CurLangData) do
					DComboBox:AddChoice( v.Lang )
					if v["LangUni"] == PlayMP.CurLang and PlayMP:GetSetting( "시스템언어", false, true ) != "SystemLang" then
						DComboBox:SetValue( v["Lang"] )
					elseif PlayMP:GetSetting( "시스템언어", false, true ) == "SystemLang" then
						DComboBox:SetValue( PlayMP:Str( "CSet_Language_UseSysLag", GetConVarString("gmod_language") ) )
					end
				end
				
				self.Paint = function( self, w, h )
					surface.SetDrawColor( 70, 70, 70, 255 )
					surface.DrawLine( 30, h - 1, w - 30, h - 1 )
				end
				
			end)
			

			PlayMP:AddCheckBox( DScrollPanel, "", PlayMP:Str( "CSet_NoNoticeUpdate" ), "NoUpdateNotice" )
			
			PlayMP:AddTextBox( DScrollPanel, 48, TOP, PlayMP:Str( "Advanced" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )

			
			PlayMP:AddCheckBox( DScrollPanel, function() 
				PlayMP.do_show_debug_hud_on_screen()

				PlayMP:OpenSubFrame( PlayMP:Str( "Notice" ), "DebugOnlyForDevelopment", 600, 200, function( mainPanel, scrpanel, ButtonPanel )
					PlayMP:AddTextBox( scrpanel, scrpanel:GetTall(), FILL, "Debug mod is only for development! If you found bugs, please report to Github(https://github.com/Minbird/Playmusic-Pro) or Steam Chat(Minbirdragon).", scrpanel:GetWide() * 0.5, 40, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
					PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "OK" ), Color( 70, 70, 70 ), ButtonPanel:GetWide() - 120, 10, 100, 30, function()
						hook.Remove("HUDPaint", "OpenRequestQueueWindow")
						mainPanel:Close()
					end )
				end)
				
			end, "Debug Mode", "디버그모드")
			
		end)