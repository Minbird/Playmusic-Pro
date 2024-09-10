PlayMP:AddSeparator( PlayMP:Str( "System" ), "icon16/application.png" )
PlayMP:AddOption( PlayMP:Str( "UpdateLog" ), "updateLog", "", function( DScrollPanel ) 
	local HTML = vgui.Create("DHTML", DScrollPanel )
	HTML:SetPos( 0, 0 )
	HTML:SetSize( DScrollPanel:GetWide(), DScrollPanel:GetTall() )
	HTML:SetEnabled(true)
	HTML:SetHTML(PlayMP.GetLoadingAni())
	HTML:OpenURL("https://sites.google.com/view/minbirdworkshop/playmusic/update-logs")
end)

surface.CreateFont( "VeryBigTitle_PlaymusicPro_Font", {
	font = "Arial",
	extended = false,
	size = 60,
	weight = 300,
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

PlayMP:AddOption( PlayMP:Str( "SysInfo" ), "systemInfo", "", function( DScrollPanel )

local matGradientLeft = CreateMaterial("gradient-l", "UnlitGeneric", {["$basetexture"] = "vgui/gradient-l", ["$vertexalpha"] = "1", ["$vertexcolor"] = "1", ["$ignorez"] = "1", ["$nomip"] = "1"})
		
		DScrollPanel:SetPos( 0, 230 )
		DScrollPanel:SetSize( DScrollPanel:GetWide(), DScrollPanel:GetTall() - 230 )
		
		local Main = vgui.Create( "DPanel", PlayMP.MenuWindowPanel )
		Main:SetSize( DScrollPanel:GetWide(), 230 )
		Main:Dock( TOP )
		Main:SetBackgroundColor( Color(0,0,0,0) )
		
		local Main2 = vgui.Create( "DPanel", Main)
		Main2:SetSize( DScrollPanel:GetWide(), 200 )
		Main2:Dock( TOP )
		Main2:SetBackgroundColor( Color(0,0,0,0) )
		
		local Main3 = vgui.Create( "DImage", Main2 )	
		--breen_img:SetPos( 10, 35 )
		--breen_img:SetSize( 150, 150 )
		Main3:SetSize( DScrollPanel:GetWide()/12*16, DScrollPanel:GetWide()/12*9)
		Main3:SetPos( -50, Main3:GetTall()/2*-1 )
		Main3:SetImage( "backgrounds/thegooddoctorf_the_one_free_rockstar.jpg" )
		Main3:SetAlpha(0)

		local function MoveAni()
			Main3:SetPos( -50, Main3:GetTall()/2*-1 )
			local files = file.Find( "backgrounds/*.jpg", "GAME" )
			files = "backgrounds/" .. files[ math.random( #files ) ]
			Main3:SetImage( files )
			Main3:AlphaTo( 255, 3, 0 )
			Main3:AlphaTo( 0, 3, 17 )
			Main3:MoveTo( 0, Main3:GetTall()/2*-1, 20, 0, 1, function() MoveAni() end)
		end
		MoveAni()
		
		local systemInfoPane = vgui.Create( "DPanel", Main2 )
		systemInfoPane:SetSize( DScrollPanel:GetWide(), 200 )
		systemInfoPane.Paint = function( self, w, h )
			surface.SetDrawColor(30, 30, 30, 255)
			surface.SetMaterial(matGradientLeft)
			surface.DrawTexturedRect( -20, 0, w - 20, h)
		end
		
		local TextLabel = vgui.Create( "DLabel", systemInfoPane  )
		TextLabel:SetSize( systemInfoPane:GetWide() - 80, 50 )
		TextLabel:SetPos( 50, 20 )
		TextLabel:SetFont( "VeryBigTitle_PlaymusicPro_Font" )
		TextLabel:SetText( "Playmusic Pro" )
		TextLabel:SetMouseInputEnabled( true )
		
		local givelove = 0
		local function dorainbow(self)
			if givelove != 5 then 
				self:ColorTo(Color(255,255,255),0.2)
				return 
			end
			self:ColorTo(Color(255,0,0),0.2)
			self:ColorTo(Color(255,255,0),0.2,0.2)
			self:ColorTo(Color(0,255,0),0.2,0.4)
			self:ColorTo(Color(0,255,255),0.2,0.6)
			self:ColorTo(Color(0,0,255),0.2,0.8)
			self:ColorTo(Color(255,0,255),0.2,1, function() dorainbow(self) end)
		end
		function TextLabel:DoClick()
			givelove = givelove + 1
			if givelove < 5 then
				self:SetColor(Color(255,0,0))
				self:ColorTo(Color(255,255,255),0.2)
			elseif givelove == 5 then
				dorainbow(self)
			else
				givelove = 0
			end
		end
		
		local TextLabel = vgui.Create( "DLabel", systemInfoPane  )
		TextLabel:SetSize( systemInfoPane:GetWide() - 80, 30 )
		TextLabel:SetPos( 50, 70 )
		TextLabel:SetFont( "Default_PlaymusicPro_Font" )
		TextLabel:SetText( PlayMP:Str( "InstalledVer", PlayMP.info.version_str) )
		TextLabel:SetMouseInputEnabled( true )
		
		local TextLabel = vgui.Create( "DLabel", systemInfoPane  )
		TextLabel:SetSize( systemInfoPane:GetWide() - 80, 30 )
		TextLabel:SetPos( 50, systemInfoPane:GetTall() - 50 )
		TextLabel:SetFont( "Default_PlaymusicPro_Font" )
		TextLabel:SetText( "Copyright © by Minbird(민버드)\nDO NOT RE-UPLOAD to steam workshop or any other site. 재배포 금지." )
		TextLabel:SetMouseInputEnabled( true )
		
		if tonumber(PlayMP.info.newer_version) > tonumber(PlayMP.info.version) then
			PlayMP:AddTextBox( Main, 30, TOP, PlayMP:Str( "ThereIsNewPlayMusicUsable" ), DScrollPanel:GetWide() * 0.5, 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(42, 205, 114), TEXT_ALIGN_CENTER )
		elseif tonumber(PlayMP.info.newer_version) == tonumber(PlayMP.info.version) then
			PlayMP:AddTextBox( Main, 30, TOP, PlayMP:Str( "NewerVerNow" ), DScrollPanel:GetWide() * 0.5, 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(50, 50, 50), TEXT_ALIGN_CENTER )
		end
		
		if PlayMP.info.is_beta then
			PlayMP:AddTextBox( DScrollPanel, 30, TOP, PlayMP:Str( "SysNowInBeta" ), DScrollPanel:GetWide() * 0.5, 12, "Default_PlaymusicPro_Font", Color(255,255,255), Color(150, 0, 0), TEXT_ALIGN_CENTER )
		end

		PlayMP:AddTextBox( DScrollPanel, 100, TOP, PlayMP:Str( "SysInfo_Ex_01" ), 15, 10, "VeryBigTitle_PlaymusicPro_Font", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
		PlayMP:AddTextBox( DScrollPanel, 120, TOP, PlayMP:Str( "SysInfo_Ex_02" ), 15, -70, "Default_PlaymusicPro_Font", Color(255,255,255), Color(50, 50, 50), TEXT_ALIGN_LEFT, function(self, w, h) 
			PlayMP:AddActionButton( self, PlayMP:Str( "Support" ), Color( 70, 70, 70 ), w/2-50, 70, 100, 30, function()
			end)
		end)
		
		PlayMP:AddTextBox( DScrollPanel, 100, TOP, PlayMP:Str( "SysInfo_Ex_03" ), 15, 10, "VeryBigTitle_PlaymusicPro_Font", Color(255,255,255), Color(40, 40, 40), TEXT_ALIGN_LEFT )
		PlayMP:AddTextBox( DScrollPanel, 120, TOP, PlayMP:Str( "SysInfo_Ex_04" ), 15, -70, "Default_PlaymusicPro_Font", Color(255,255,255), Color(50, 50, 50), TEXT_ALIGN_LEFT, function(self, w, h) 
			PlayMP:AddActionButton( self, PlayMP:Str( "Report" ), Color( 70, 70, 70 ), w/2-50, 70, 100, 30, function()
			end)
		end)
		
		
end)


PlayMP:AddOption( PlayMP:Str( "PMPNotice" ), "notice", "", function( DScrollPanel ) 
	local HTML = vgui.Create("DHTML", DScrollPanel )
	HTML:SetPos( 0, 0 )
	HTML:SetSize( DScrollPanel:GetWide(), DScrollPanel:GetTall() )
	HTML:SetEnabled(true)
	HTML:OpenURL("https://sites.google.com/view/minbirdworkshop/playmusic/notice")
	PlayMP:ChangeSetting("NoticeReadCount", PlayMP.noticecountOnInternet)
end)

PlayMP:AddOption( PlayMP:Str( "QnA" ), "qna", "", function( DScrollPanel ) 
	local HTML = vgui.Create("DHTML", DScrollPanel )
	HTML:SetPos( 0, 0 )
	HTML:SetSize( DScrollPanel:GetWide(), DScrollPanel:GetTall() )
	HTML:SetEnabled(true)
	HTML:OpenURL("https://sites.google.com/view/minbirdworkshop/playmusic/qna")
end)