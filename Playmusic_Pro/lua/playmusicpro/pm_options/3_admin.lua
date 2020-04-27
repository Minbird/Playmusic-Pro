if LocalPlayer():IsAdmin() or PlayMP.LocalPlayerData[1]["power"] then
		
	PlayMP:AddSeparator( PlayMP:Str( "Admin" ), "icon16/cog.png" )
	PlayMP:AddOption( PlayMP:Str( "AdminSet_UserAdmin" ), "userAdministration", "", function( DScrollPanel )
	
		if not LocalPlayer():IsAdmin() and not PlayMP.LocalPlayerData[1]["power"] then
			PlayMP:AddTextBox( DScrollPanel, 60, TOP, PlayMP:Str( "Unknown_Error" ), DScrollPanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
			return
		end
	
		local matGradientLeft = CreateMaterial("gradient-l", "UnlitGeneric", {["$basetexture"] = "vgui/gradient-l", ["$vertexalpha"] = "1", ["$vertexcolor"] = "1", ["$ignorez"] = "1", ["$nomip"] = "1"})
	
		local AdminInfoPanel = DScrollPanel:Add( "DPanel" )
		AdminInfoPanel:SetSize( DScrollPanel:GetWide(), 100 )
		AdminInfoPanel:Dock( TOP )
		AdminInfoPanel.Paint = function( self, w, h )
			surface.SetDrawColor(30, 30, 30, 255)
			surface.SetMaterial(matGradientLeft)
			surface.DrawTexturedRect( -20, 0, w - 20, h)
		end
		
		local TextLabel = vgui.Create( "DLabel", AdminInfoPanel  )
		TextLabel:SetSize( AdminInfoPanel:GetWide() - 80, 35 )
		TextLabel:SetPos( 100, 20 )
		TextLabel:SetFont( "BigTitle_PlaymusicPro_Font" )
		TextLabel:SetText( PlayMP:Str( "WelcomeAdmin", LocalPlayer():Nick()) )
		TextLabel:SetMouseInputEnabled( true )
		
		local TextLabel = vgui.Create( "DLabel", AdminInfoPanel  )
		TextLabel:SetSize( AdminInfoPanel:GetWide() - 80, 35 )
		TextLabel:SetPos( 100, 55 )
		TextLabel:SetFont( "Default_PlaymusicPro_Font" )
		TextLabel:SetText( PlayMP:Str( "UserAdminEx" ) )
		TextLabel:SetMouseInputEnabled( true )
	
		local UserImage = vgui.Create( "AvatarImage", AdminInfoPanel )
		UserImage:SetSize( 64, 64 )
		UserImage:SetPos( 18, 18 )
		UserImage:SetPlayer( LocalPlayer(), 64 )
		
			
		local function resetCtrlPanel( sid, nick )
		
			if sid == "" or sid == nil then return end
		
			PlayMP:GetUserInfoBySID(sid)
			
		end
		
		
		local PlayerPanel = vgui.Create( "DScrollPanel", DScrollPanel )
		PlayerPanel:SetSize( DScrollPanel:GetWide() / 2, DScrollPanel:GetTall() - 100 )
		PlayerPanel:SetPos( 0, 100 )
		PlayerPanel.Paint = function() 
			draw.RoundedBox( 5, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color( 70, 70, 70 ) )
		end
		
		local sbar = PlayerPanel:GetVBar()
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
			draw.RoundedBox( 5, 3, 0, w - 6, h, Color( 100, 100, 100 ) )
		end
		
		--[[local function CreatCheckBoxLabel( str, data, )
			local CategoryContentOne = vgui.Create( "DCheckBoxLabel" )	
			CategoryContentOne:SetText( str )
			CategoryContentOne:SetValue( data )
			CategoryContentOne:SizeToContents()
			
			PlayMP:AddCheckBox( panel, func, text, def, instant, vaild )
			
			return CategoryContentOne
		end]]
		
		DScrollPanel:SetSize(DScrollPanel:GetWide(), DScrollPanel:GetTall())
		local CtrlPanel
		
		CtrlPanel = vgui.Create( "DScrollPanel", DScrollPanel )
		CtrlPanel:SetSize( DScrollPanel:GetWide() / 2, DScrollPanel:GetTall() - 140 )
		CtrlPanel:SetPos( DScrollPanel:GetWide() / 2, 140 )
		CtrlPanel.Paint = function() end
		
		local sbar = CtrlPanel:GetVBar()
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
			draw.RoundedBox( 5, 3, 0, w - 6, h, Color( 100, 100, 100 ) )
		end
		
		net.Receive( "PlayMP:GetUserInfoBySID", function( len, ply )
				local data = net.ReadTable()
				
				if CtrlPanel != nil and CtrlPanel:IsValid() then
					CtrlPanel:Remove()
					CtrlPanel = vgui.Create( "DScrollPanel", DScrollPanel )
					CtrlPanel:SetSize( DScrollPanel:GetWide() / 2, DScrollPanel:GetTall() - 140 )
					CtrlPanel:SetPos( DScrollPanel:GetWide() / 2, 140 )
					CtrlPanel.Paint = function()
					
					local sbar = CtrlPanel:GetVBar()
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
						draw.RoundedBox( 5, 3, 0, w - 6, h, Color( 100, 100, 100 ) )
					end
					
					end
				end
				
				PlayMP:AddTextBox( CtrlPanel, 48, TOP, PlayMP:Str( "Music" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
				local check1 = PlayMP:AddCheckBox( CtrlPanel, nil, PlayMP:Str( "AdminSet_Qeeue" ), nil, true, data[1], "qeeue" )
				local check2 = PlayMP:AddCheckBox( CtrlPanel, nil, PlayMP:Str( "AdminSet_Skip" ), nil, true, data[1], "skip" )
				local check3 = PlayMP:AddCheckBox( CtrlPanel, nil, PlayMP:Str( "AdminSet_seekTo" ), nil, true, data[1], "seekto" )
				local check4 = PlayMP:AddCheckBox( CtrlPanel, nil, PlayMP:Str( "AdminSet_Ban" ), nil, true, data[1], "ban" )
				
				PlayMP:AddTextBox( CtrlPanel, 48, TOP, PlayMP:Str( "Admin" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
				local check5 = PlayMP:AddCheckBox( CtrlPanel, nil, PlayMP:Str( "AdminSet_AdminLicense" ), nil, true, data[1], "power" )
				
				local setOptions = vgui.Create( "DPanel", CtrlPanel )
				setOptions:SetSize( CtrlPanel:GetWide(), 180 )
				setOptions:Dock(TOP)
				setOptions:SetBackgroundColor(Color(0,0,0,0))
				PlayMP:AddActionButton( setOptions, PlayMP:Str( "AdminSet_SyncData" ), Color(42, 205, 114), setOptions:GetWide() - 300, 20, 280, 30, function() PlayMP:SetUserInfoBySID(targetedplayer, data) end)
			end)
		
		resetCtrlPanel( "", "" )
		
		
		
		local PlayerDataPanel = vgui.Create( "DPanel", DScrollPanel )
		PlayerDataPanel:SetSize( DScrollPanel:GetWide() / 2, 80 )
		PlayerDataPanel:SetPos( DScrollPanel:GetWide() / 2, 100 )
		PlayerDataPanel.Paint = function()
		end
		
		--local nick = PlayMP:AddTextEntryBox( PlayerDataPanel, TOP, PlayMP:Str( "NickName" ), PlayMP:Str( "AdminSet_SubmitNick" ), PlayerDataPanel:GetWide(), 40 )
		local sid = PlayMP:AddTextEntryBox( PlayerDataPanel, TOP, "SteamID", PlayMP:Str( "AdminSet_SubmitSID" ), PlayerDataPanel:GetWide(), 40 )
		--[[nick.OnEnter = function( self )
			local ent = ents.FindByName(self:GetValue())  -- 서버측으로 옮겨
			if ent !=nil and ent:IsPlayer() then
				resetCtrlPanel( ent:SteamID(), nil )
				targetedplayer = ent:SteamID()
			else
				PlayMP:Notice( PlayMP:Str( "AdminSet_NoUserData" ), Color(231, 76, 47), "warning" )
			end
		end]]
		sid.OnEnter = function( self )
			resetCtrlPanel( self:GetValue(), nil )
			targetedplayer = self:GetValue()
		end
		sid:RequestFocus() 
		
		PlayMP:AddTextBox( PlayerPanel, 48, TOP, PlayMP:Str( "AdminSet_OnlineUser" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )

		for k, v in pairs(player.GetAll()) do
		
			if not v:IsBot() then
		
				surface.SetFont( "Default_PlaymusicPro_Font" )
				local w, h = surface.GetTextSize( v:Nick() )
				
				local PlayUserButtonBack = vgui.Create( "DPanel", PlayerPanel )
				PlayUserButtonBack:SetSize( PlayerPanel:GetWide(), 42 )
				PlayUserButtonBack:Dock( TOP )
				PlayUserButtonBack:SetBackgroundColor( Color(255,255,255,10) )
				
				local PlayUserImage = vgui.Create( "AvatarImage", PlayUserButtonBack )
				PlayUserImage:SetSize( 32, 32 )
				PlayUserImage:SetPos( 20, 5 )
				PlayUserImage:SetPlayer( v, 32 )
							
				local PlayUser = vgui.Create( "DLabel", PlayUserButtonBack )
				PlayUser:SetFont( "Default_PlaymusicPro_Font" )
				PlayUser:SetSize( w, 42 )
				PlayUser:SetPos( 60, 0 )
				if v == LocalPlayer() then
					PlayUser:SetColor( Color( 42, 205, 114, 255) )
					PlayUser:SetText( v:Nick() )
				elseif v != LocalPlayer() and v:IsAdmin() then
					PlayUser:SetColor( Color( 255, 228, 0, 255) )
					PlayUser:SetText( v:Nick() )
				else
					PlayUser:SetColor( Color( 255, 255, 255, 255) )
					PlayUser:SetText( v:Nick() )
				end
				PlayUser:SetMouseInputEnabled( true )
				
				local PlayUserButton = vgui.Create( "DLabel", PlayUserButtonBack )
				PlayUserButton:SetFont( "Default_PlaymusicPro_Font" )
				PlayUserButton:SetPos( 0, 0 )
				PlayUserButton:SetSize( PlayUserButtonBack:GetWide(), PlayUserButtonBack:GetTall() )
				PlayUserButton:SetColor( Color( 255, 255, 255, 255 ) )
				PlayUserButton:SetText( "" )
				PlayUserButton:SetMouseInputEnabled( true )
				PlayUserButton.OnCursorEntered = function( self, w, h )
					PlayUserButtonBack:SetBackgroundColor( Color(255,255,255,50) )
				end
				PlayUserButton.OnCursorExited = function( self, w, h )
					PlayUserButtonBack:SetBackgroundColor( Color(255,255,255,10) )
				end
				PlayUserButton.DoClick = function()
					--nick:SetText( v:Nick() )
					sid:SetText( v:SteamID() )
					resetCtrlPanel( v:SteamID(), v:Nick() )
					targetedplayer = v:SteamID()
				end
				
			end
			
		end
		
		PlayMP:AddTextBox( PlayerPanel, 48, TOP, PlayMP:Str( "AdminSet_SavedUser" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
		
		PlayMP:GetUserInfoAll()
		net.Receive( "PlayMP:SendUserInfoAll", function( len, ply )
			local tab = net.ReadTable()
			for k, v in pairs(tab) do
			
				local id = util.SteamIDFrom64(string.Left(v,string.len(v)-4))
				
				surface.SetFont( "Default_PlaymusicPro_Font" )
				local w, h = surface.GetTextSize( id )
				
				local PlayUserButtonBack = vgui.Create( "DPanel", PlayerPanel )
				PlayUserButtonBack:SetSize( PlayerPanel:GetWide(), 42 )
				PlayUserButtonBack:Dock( TOP )
				PlayUserButtonBack:SetBackgroundColor( Color(255,255,255,10) )
				
				local PlayUserImage = vgui.Create( "AvatarImage", PlayUserButtonBack )
				PlayUserImage:SetSize( 32, 32 )
				PlayUserImage:SetPos( 20, 5 )
				PlayUserImage:SetSteamID( v, 32 ) 
							
				local PlayUser = vgui.Create( "DLabel", PlayUserButtonBack )
				PlayUser:SetFont( "Default_PlaymusicPro_Font" )
				PlayUser:SetSize( w, 42 )
				PlayUser:SetPos( 60, 0 )
				PlayUser:SetColor( Color( 200, 200, 200, 255 ) )
				PlayUser:SetText( id )
				PlayUser:SetMouseInputEnabled( true )
				
				local PlayUserButton = vgui.Create( "DLabel", PlayUserButtonBack )
				PlayUserButton:SetFont( "Default_PlaymusicPro_Font" )
				PlayUserButton:SetPos( 0, 0 )
				PlayUserButton:SetSize( PlayUserButtonBack:GetWide(), PlayUserButtonBack:GetTall() )
				PlayUserButton:SetColor( Color( 255, 255, 255, 255 ) )
				PlayUserButton:SetText( "" )
				PlayUserButton:SetMouseInputEnabled( true )
				PlayUserButton.OnCursorEntered = function( self, w, h )
					PlayUserButtonBack:SetBackgroundColor( Color(255,255,255,50) )
				end
				PlayUserButton.OnCursorExited = function( self, w, h )
					PlayUserButtonBack:SetBackgroundColor( Color(255,255,255,10) )
				end
				PlayUserButton.DoClick = function()
					--nick:SetText( v:Nick() )
					sid:SetText( id )
					resetCtrlPanel( id, id )
					targetedplayer = id
				end
				
				
			end
		end)
		
	end)
			
	PlayMP:AddOption( PlayMP:Str( "Options_ServerOptions" ), "ServerOptions", "", function( DScrollPanel )
	
		if not LocalPlayer():IsAdmin() and not PlayMP.LocalPlayerData[1]["power"] then
			PlayMP:AddTextBox( DScrollPanel, 60, TOP, PlayMP:Str( "Unknown_Error" ), DScrollPanel:GetWide() * 0.5, 5, "Default_PlaymusicPro_Font", Color(255,255,255), Color(0,0,0,0), TEXT_ALIGN_CENTER )
			return
		end
			
		--PlayMP:GetServerSettings()
		
			--net.Receive( "PlayMP:GetServerSettings", function()
	
				--local data = net.ReadTable()
				
				--for k, v in pairs(data) do
				--	PlayMP:ChangeSetting( v.UniName, v.Data )
				--end
					
				PlayMP:AddTextBox( DScrollPanel, 48, TOP, PlayMP:Str( "AdminSet_UserDefaultSet" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
				PlayMP:AddCheckBox( DScrollPanel, function() 
					PlayMP:ChangeServerSettings( "AOAPMP" )
				end, PlayMP:Str( "AdminSet_UserDefaultSet7" ), "AOAPMP" )
				PlayMP:AddCheckBox( DScrollPanel, function() 
					PlayMP:ChangeServerSettings( "AOAQueue" )
				end, PlayMP:Str( "AdminSet_UserDefaultSet1" ), "AOAQueue" )
				PlayMP:AddCheckBox( DScrollPanel, function() 
					PlayMP:ChangeServerSettings( "AOASkip" )
				end, PlayMP:Str( "AdminSet_UserDefaultSet2" ), "AOASkip" )
				PlayMP:AddCheckBox( DScrollPanel, function() 
					PlayMP:ChangeServerSettings( "AOACPL" )
				end, PlayMP:Str( "AdminSet_UserDefaultSet3" ), "AOACPL" )
				
				PlayMP:AddTextBox( DScrollPanel, 48, TOP, PlayMP:Str( "Player" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
				PlayMP:AddCheckBox( DScrollPanel, function() 
					PlayMP:ChangeServerSettings( "DONOTshowInfoPanel" )
				end, PlayMP:Str( "AdminSet_DONOTshowInfoPanel" ), "DONOTshowInfoPanel" )
				
				PlayMP:AddTextBox( DScrollPanel, 48, TOP, PlayMP:Str( "Options_queueList" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
				PlayMP:AddCheckBox( DScrollPanel, function() 
					PlayMP:ChangeServerSettings( "RepeatQueue" )
				end, PlayMP:Str( "AdminSet_UserDefaultSet4" ), "RepeatQueue" )
				PlayMP:AddTextBox( DScrollPanel, 55, TOP, PlayMP:Str( "Media_Limit" ), 40, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT)
				PlayMP:AddTextBox( DScrollPanel, 44, TOP, "", 40, 0, "Trebuchet24", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
					local numslider = PlayMP:CreatNumScroll( self, 100, 0, 0, 200, self:GetWide()-200, true)
					numslider:SetNum( GetConVar("playmp_queue"):GetFloat() )
					numslider.ValueChanged = function( d )
						PlayMP:ChangConVar( "playmp_queue", math.floor(d) )
					end
					self.Paint = function( self, w, h )
					surface.SetDrawColor( 70, 70, 70, 255 )
					surface.DrawLine( 30, h - 1, w - 30, h - 1 )
				end
				end)
				PlayMP:AddTextBox( DScrollPanel, 55, TOP, PlayMP:Str( "Media_Time_Limit" ), 40, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT)
				PlayMP:AddTextBox( DScrollPanel, 44, TOP, "", 40, 0, "Trebuchet24", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
					local numslider = PlayMP:CreatNumScroll( self, 100, 0, 0, 500, self:GetWide()-200, true)
					numslider:SetNum( GetConVar("playmp_media_time"):GetFloat() )
					numslider.ValueChanged = function( d )
						PlayMP:ChangConVar( "playmp_media_time", math.floor(d) )
					end
					self.Paint = function( self, w, h )
					surface.SetDrawColor( 70, 70, 70, 255 )
					surface.DrawLine( 30, h - 1, w - 30, h - 1 )
				end
				end)
				PlayMP:AddTextBox( DScrollPanel, 55, TOP, PlayMP:Str( "Media_Limit_User" ), 40, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT)
				PlayMP:AddTextBox( DScrollPanel, 44, TOP, "", 40, 0, "Trebuchet24", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
					local numslider = PlayMP:CreatNumScroll( self, 100, 0, 0, 200, self:GetWide()-200, true)
					numslider:SetNum( GetConVar("playmp_queue_user"):GetFloat() )
					numslider.ValueChanged = function( d )
						PlayMP:ChangConVar( "playmp_queue_user", math.floor(d) )
					end
					self.Paint = function( self, w, h )
					surface.SetDrawColor( 70, 70, 70, 255 )
					surface.DrawLine( 30, h - 1, w - 30, h - 1 )
				end
				end)
				PlayMP:AddTextBox( DScrollPanel, 48, TOP, PlayMP:Str( "AdminSet_Logs" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
				PlayMP:AddCheckBox( DScrollPanel, function() 
					PlayMP:ChangeServerSettings( "WriteLogs" )
				end, PlayMP:Str( "AdminSet_UserDefaultSet8" ), "WriteLogs" )
				PlayMP:AddTextBox( DScrollPanel, 48, TOP, PlayMP:Str( "Cache" ), 30, 0, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
				PlayMP:AddCheckBox( DScrollPanel, function() 
					PlayMP:ChangeServerSettings( "SaveCache" )
				end, PlayMP:Str( "AdminSet_UserDefaultSet5" ), "SaveCache" )
				PlayMP:AddTextBox( DScrollPanel, 55, TOP, PlayMP:Str( "AdminSet_UserDefaultSet6" ), 40, 0, "Default_PlaymusicPro_Font", Color( 255, 255, 255 ), Color(0,0,0,0), TEXT_ALIGN_LEFT, function( self, w, h )
					PlayMP:AddActionButton( self, PlayMP:Str( "RemoveCache" ), Color( 60, 60, 60, 255 ), w - 120, 12.5, 100, 30, function() PlayMP:RemoveCache() end)
					self.Paint = function( self, w, h )
						surface.SetDrawColor( 70, 70, 70, 255 )
						surface.DrawLine( 30, h - 1, w - 30, h - 1 )
					end
				end)
			
			
				PlayMP:GetCacheSize()
				
			--end)

			net.Receive( "PlayMP:GetCacheSize", function( len, ply )
				
				local data = net.ReadTable()
				PlayMP:AddTextBox( DScrollPanel, 80, TOP, PlayMP:Str( "Cache_Ex", data.f ), 30, 0, "Default_PlaymusicPro_Font", Color(255,255,255), Color(40, 40, 40, 0), TEXT_ALIGN_LEFT ) --  math.Round(data.s / 1024, 2)
				--label:SetText("Playmusic Pro는 재생했던 미디어 정보를 저장, 다음에 다시 재생할 때 이용하여 서버의 네트워크와 API 요청을 절약할 수 있습니다.\nPlaymusic Pro가 지금 " .. data.f .. "개의 미디어 정보를 저장했고, 서버의 저장 공간 중 약 " .. math.Round(data.s / 1024, 2) .. " KB 사용 중입니다.")
			end)
			
			--PlayMP:AddTextBox( DScrollPanel, 48, TOP, "Point Shop", 30, 12, "Trebuchet24", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
			--PlayMP:AddCheckBox( DScrollPanel, "", "Point Shop 과 연동", "포인트샵연동" )
		end)
				
			
end