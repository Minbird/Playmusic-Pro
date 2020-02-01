
hook.Add( "HUDPaint", "PlayMP_CurFrameTime", function()
	PlayMP.CurFrameTime = 1 / RealFrameTime()
end)

local blur = Material( "pp/blurscreen" )
	function PlayMP:blurEffMainmenu( panel, lay, density, alpha )
		
		if not panel then return end -- error!
		local x, y = panel:LocalToScreen(0, 0)

		surface.SetDrawColor( 255, 255, 255, alpha )
		surface.SetMaterial( blur )

		for i = 1, 3 do
			blur:SetFloat( "$blur", ( i / lay ) * density )
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect( -x -15, -y -52, ScrW() +30, ScrH() +60 )
		end
			
	end
	
	function PlayMP:blurEff( panel, lay, density, alpha )
		
		if not panel then return end -- error!
		local x, y = panel:LocalToScreen(0, 0)

		surface.SetDrawColor( 255, 255, 255, alpha )
		surface.SetMaterial( blur )

		for i = 1, 3 do
			blur:SetFloat( "$blur", ( i / lay ) * density )
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
		end
			
	end

function PlayMP:OpenSubFrame( title, uniqueName, w, t, func )
		
		local SubFrame = vgui.Create( "DFrame" )
		SubFrame:SetSize( ScrW(), ScrH() + 25 )
		SubFrame:SetPos(0, -25)
		SubFrame:SetTitle( "" )
		SubFrame:SetDraggable( false )
		SubFrame:SetSkin( "Default" )
		SubFrame:ShowCloseButton( true )
		SubFrame:MakePopup()
		
		if PlayMP:GetSetting( "Use_Blur", false, true) then
			SubFrame.Paint = function(self, w, h)
				if PlayMP.blurEff != nil then
					PlayMP:blurEff( self, 1, 1, 255 )
				end
				draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 240 ) )
			end
		else
			SubFrame.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 240 ) )
			end
		end
	
		local basePanel = vgui.Create( "DPanel", SubFrame )
		basePanel:SetMouseInputEnabled( true )
		basePanel:SetSize( w, t )
		basePanel:SetPos( (SubFrame:GetWide() * 0.5) - w * 0.5 , (SubFrame:GetTall() * 0.5) - t * 0.5 )
		basePanel.Paint = function( self, w, h ) 
			draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 255 ) )
		end
		
		local Title = vgui.Create( "DPanel", basePanel )
		Title:SetSize( basePanel:GetWide(), 30 )
		Title:Dock( TOP )
		Title.Paint = function( self, w, h ) 
			draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40, 255 ) )
			draw.DrawText( title, "Default_PlaymusicPro_Font", w * 0.5, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		end
	
		local ScrollPanel = vgui.Create( "DScrollPanel", basePanel )
		ScrollPanel:SetSize( basePanel:GetWide(), basePanel:GetTall() - 80 )
		ScrollPanel:Dock( TOP )
		ScrollPanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) end
		
		local sbar = ScrollPanel:GetVBar()
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
		
		local ButtonPanel = vgui.Create( "DPanel", basePanel )
		ButtonPanel:SetSize( basePanel:GetWide(), 50 )
		ButtonPanel:Dock( TOP )
		ButtonPanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 60, 60, 60 ) ) end
		
		hook.Add( uniqueName, uniqueName, func )
		hook.Run( uniqueName, SubFrame, ScrollPanel, ButtonPanel )
		
		SubFrame:ShowCloseButton( false )
		
end

function PlayMP:CreatFrame( frameTitle, uniqueName )


	PlayMP.MainMenuPanel = vgui.Create( "DFrame" )
	--PlayMP.MainMenuPanel:SetSize( ScrW(), ScrH() )
	PlayMP.MainMenuPanel:SetSize( ScrW() * 0.8, ScrH() * 0.8 + 25 )
	--PlayMP.MainMenuPanel:SetPos( 0, 0 )
	PlayMP.MainMenuPanel:Center()
	PlayMP.MainMenuPanel:SetTitle( "" )
	PlayMP.MainMenuPanel:SetDraggable( false )
	PlayMP.MainMenuPanel:SetSkin( "Default" )
	PlayMP.MainMenuPanel:ShowCloseButton( false )
	PlayMP.MainMenuPanel:MakePopup()

	PlayMP.basePanel = vgui.Create( "DPanel", PlayMP.MainMenuPanel )
	PlayMP.basePanel:SetMouseInputEnabled( true )
	PlayMP.basePanel:SetPos(0,0)
	PlayMP.basePanel:SetSize( PlayMP.MainMenuPanel:GetWide(), PlayMP.MainMenuPanel:GetTall())
	PlayMP.basePanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) end
	

	local quitbutton = vgui.Create( "DButton", PlayMP.MainMenuPanel ) 
	quitbutton:SetText( "X" )		
	quitbutton:SetFont( "Trebuchet24" )	
	quitbutton:SetPos( PlayMP.MainMenuPanel:GetWide() - 55, 30 )
	quitbutton:SetSize( 50, 20 )	
	quitbutton:SetColor( Color( 255, 255, 255, 255 ) )	
	quitbutton.DoClick = function()			
		hook.Remove("HUDPaint", uniqueName)
		hook.Remove("Tick", "DoNoticeToPlayerOnMenu")
		PlayMP.MenuWindowPanel:Clear()
		PlayMP.MainMenuPanel:Remove()
		PlayMP.MainMenuPanel:Close()
		PlayMP.MainMenuPanel = nil
	end
	quitbutton.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 120, 120 ) ) end
	
	local windowAlpha = PlayMP:GetSetting( "메인메뉴의불투명도", false, true)
	
	if isnumber(windowAlpha) != true then
		windowAlpha = tonumber(windowAlpha)
	end
	
	if windowAlpha == nil or windowAlpha == {} then
		windowAlpha = 255
		PlayMP:AddSetting( "메인메뉴의불투명도", 255 )
	end
	
	--hook.Add( "HUDPaint", uniqueName, function()
	
		PlayMP.MainMenuPanel.Paint = function(self, w, h)
			
			self:SetAlpha( windowAlpha )
			
			draw.RoundedBox( 0, 0, 25, w, h - 25, Color( 50, 50, 50, 255))
			draw.RoundedBox( 0, 0, 25, w, 30, Color( 35, 35, 35, 255))
			--surface.SetDrawColor( 30, 30,30, 255 )
			--surface.DrawLine( 0, 55, w, 55 )
			draw.DrawText( frameTitle, "DermaDefault", 10 , 33, Color(255,255,255,255))
			
		end
		
	--end)
	
	PlayMP.sideMenuPanel = vgui.Create( "DScrollPanel", PlayMP.basePanel )
	PlayMP.sideMenuPanel:SetMouseInputEnabled( true )
	PlayMP.sideMenuPanel:SetPos( 0, 56 )
	PlayMP.sideMenuPanel:SetSize( 300, PlayMP.basePanel:GetTall() - 202 )
	PlayMP.sideMenuPanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 255 ) ) end
	
	local sbar = PlayMP.sideMenuPanel:GetVBar()
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
	
	PlayMP.volPanel = vgui.Create( "DPanel", PlayMP.basePanel )
	PlayMP.volPanel:SetMouseInputEnabled( true )
	PlayMP.volPanel:SetPos( 0, PlayMP.basePanel:GetTall() - 145 )
	PlayMP.volPanel:SetSize( 300, 54 )
	PlayMP.volPanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20, 255 ) ) end
	
end

	PlayMP.MenuWindows = {}
		
	function PlayMP:AddOption( name, uniqueName, image, func )
		local f = PlayMP:AddOptionToPanel( name, uniqueName, image, func )

		if uniqueName == "systemInfo" or uniqueName == "updateLog" then
			if PlayMP.NewerVerE != nil and tonumber(PlayMP.NewerVerE) > tonumber(PlayMP.CurSystemVersion.VerE) then
				f.Notion(true)
			end
		end
	end

	function PlayMP:AddOptionToPanel( name, uniqueName, image, func )
	
		local AddOption_funcd = {}
	
		local button = {}
		button.Color = Color(255,255,255,0)
	
		local optionButtonMain = PlayMP.sideMenuPanel:Add( "DPanel" )
		optionButtonMain:SetMouseInputEnabled( true )
		optionButtonMain:SetSize( PlayMP.sideMenuPanel:GetWide(), 40 )
		optionButtonMain:Dock( TOP )
		optionButtonMain:SetBackgroundColor(Color(0,0,0,0))
		
		local optionButton = vgui.Create( "DPanel", optionButtonMain )
		optionButton:SetMouseInputEnabled( true )
		optionButton:SetSize( PlayMP.sideMenuPanel:GetWide()-20, 35 )
		optionButton:SetPos( 10, 5 )
		
		local sel = vgui.Create( "DPanel", optionButton )
		sel:SetMouseInputEnabled( true )
		sel:SetSize( 5, 35 )
		sel:SetPos( 10, 0 )
		sel:SetBackgroundColor( Color(255,150,100,255) )
		sel:SetAlpha(0)
		
		local notion = vgui.Create( "DPanel", optionButton )
		notion:SetMouseInputEnabled( true )
		notion:SetSize( 4, 4 )
		notion:SetPos( 18, 4 )
		notion:SetBackgroundColor( Color(255,150,100,255) )
		notion:SetAlpha(0)
		
		local notion2 = vgui.Create( "DPanel", optionButton )
		notion2:SetMouseInputEnabled( true )
		notion2:SetSize( 8, 8 )
		notion2:SetPos( 16, 2 )
		notion2.Paint = function(self, w, h) draw.RoundedBox( w/2, 0, 0, w, h, Color(255,150,100,255) ) end
		notion2:SetAlpha(0)
		
		local TextPos = 0
		
		--[[local breen_img = vgui.Create( "DImage", optionButton )
		breen_img:SetPos( 5, 0 )
		breen_img:SetSize( 35, 35 )
		breen_img:SetImage( "image/playlist.png" )]]
		
		local label = vgui.Create( "DLabel", optionButton )
		label:SetSize( optionButton:GetWide() - 45, 35 )
		label:SetPos( 25,0 )
		label:SetFont( "OptionsButtonDefault_PlaymusicPro_Font" )
		label:SetColor( Color( 255, 255, 255, 255 ) )
		label:SetText( name )
		label:SetMouseInputEnabled( true )
		
		optionButton.Paint = function( self, w, h )
		end
	
		label.OnCursorEntered = function( self, w, h )
			button.OnCursorEntered = true
			optionButton:AlphaTo(50,0.05)
		end
		label.OnCursorExited = function( self, w, h )
			button.OnCursorEntered = false
			optionButton:AlphaTo(255,0.1)
		end
		
		AddOption_funcd.Changed = function(d) end
		
		AddOption_funcd.ColorTo = function( d, col, ti )
			label:ColorTo(col, ti)
		end
		
		AddOption_funcd.DoNotion = false
		AddOption_funcd.Notion = function( bool )
			
			for k, v in pairs(PlayMP.MenuWindows) do
				if v.UniqueName == uniqueName then
					if v.DoNotion == nil then
						AddOption_funcd.DoNotion = bool
						v.DoNotion = bool
						chat.AddText(tostring(v.DoNotion))
					else
						AddOption_funcd.DoNotion = v.DoNotion
					end
				end
			end
				
				local function doRepeat()
					notion:SetAlpha(255)
					notion2:SetAlpha(255)
					notion2:SetSize( 4, 4 )
					notion2:SetPos( 18, 4 )
					notion2:MoveTo( 15, 1, 0.1)
					notion2:SizeTo( 10, 10, 0.1 )
					notion2:AlphaTo( 0, 1, 0, 
					function() 
						if AddOption_funcd.DoNotion then 
							notion2:AlphaTo( 0, 1, 0, function() doRepeat() end)
						else 
							notion:AlphaTo(0, 1)
							notion2:AlphaTo(0, 1)
						end 
					end)
				end
				
				doRepeat()
			--end
		end

		function label:DoClick()
		
			PlayMP:ChangeMenuWindow( uniqueName )
			button.isVaild = true
			AddOption_funcd.Changed(uniqueName)
			
			AddOption_funcd.DoNotion = false
			
			for k, v in pairs(PlayMP.MenuWindows) do
				if v.UniqueName == uniqueName then
					v.DoNotion = false
				end
			end

		end
		
		local function MenuChanged(d)
			if d == uniqueName then 
				label:ColorTo(Color(255,150,100), 0.1) 
				sel:AlphaTo(255, 0.1)
				label:MoveTo( 35,0,0.1 )
			else 
				label:ColorTo(Color(255,255,255), 0.1) 
				sel:AlphaTo(0, 0.1)
				label:MoveTo( 25,0,0.1 )
			end
		end
		
		hook.Add("MenuChanged_PMP", "MenuChanged_" .. uniqueName, function(d) MenuChanged(d) end)
		
		for k, v in pairs(PlayMP.MenuWindows) do
			if v.UniqueName == uniqueName then
				AddOption_funcd.DoNotion = v.DoNotion
				return AddOption_funcd
			end
		end
		
		table.insert( PlayMP.MenuWindows, {
			Func = func,
			UniqueName = uniqueName,
			DoNotion = nil
		}
		)
		
		return AddOption_funcd
		
	end
	
	function PlayMP:AddSeparator( name, icon )
	
		local Separator = PlayMP.sideMenuPanel:Add( "DPanel" )
		Separator:SetSize( PlayMP.sideMenuPanel:GetWide(), 50 )
		Separator:Dock( TOP )
		
		Separator.Paint = function( self, w, h )
		end
		
		--[[local iconImg = vgui.Create( "DImage", Separator )
		iconImg:SetPos( 10, 33 )
		iconImg:SetSize( 16, 16 )
		iconImg:SetImage( icon )]]
		
		local label = vgui.Create( "DLabel", Separator )
		label:SetSize( Separator:GetWide(), 40 )
		label:SetPos( 20, 20)
		label:SetFont( "Default_PlaymusicPro_Font" )
		label:SetColor( Color( 255, 255, 255, 255 ) )
		label:SetText( name )
		label:SetMouseInputEnabled( true )
		
	end
	
	local gamemode = GetConVar("gamemode"):GetString()
	local cornerRadius = 15
	
	if gamemode == "zombiesurvival" then
		cornerRadius = 14
	end
	
	function PlayMP:AddActionButton( panel, name, colorP, posX, posY, sizeW, sizeT, func, icon )	
		
			local button = {}
			button.Color = Color( 255,255,255,0 )
			
			local name = name
			
			local buttonPanel = vgui.Create( "DButton", panel )
			if icon then
				buttonPanel:SetIcon( icon )
			end
			buttonPanel:SetText( "" )			
			buttonPanel:SetPos( posX, posY )				
			buttonPanel:SetSize( sizeW, sizeT )	
			buttonPanel:SetFont("ButtonDefault_PlaymusicPro_Font")
			buttonPanel:SetColor(Color( 255, 255, 255, 255 ))
			
			local font = "ButtonDefault_PlaymusicPro_Font"
			surface.SetFont( font )
			local w, h = surface.GetTextSize( name )
			
			local DoScroll = false
			
			if w > sizeW then
				DoScroll = true
			end
			
			local buttonPanelW = buttonPanel:GetWide() * 0.5
					
			buttonPanel.Paint = function( self, w, h )
				
				draw.RoundedBox( cornerRadius, 0, 0, w, h, colorP )
				draw.RoundedBox( cornerRadius, 0, 0, w, h, button.Color )

				if DoScroll then
					if buttonPanelW < -w * 0.5 then
						buttonPanelW = w*1.5
					end
					buttonPanelW = buttonPanelW - 50 / PlayMP.CurFrameTime
				end
				
				draw.DrawText( name, "ButtonDefault_PlaymusicPro_Font", buttonPanelW, 6, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
				
			end
			
			buttonPanel.DoClick = func
			
			buttonPanel.SetText = function(t, str) name = str end
			
			
			
			return buttonPanel
				
		end

	function PlayMP:AddCheckBox( panel, func, text, def, instant, vaild, unique )
	
		local table = {}
		if instant != nil and instant == true then
			table.Vaild = vaild[unique]
		else
			table.Vaild = tobool(PlayMP:GetSetting( def, false, true ))
		end


		local CheckBoxPanel = panel:Add( "DPanel" )
		CheckBoxPanel:SetSize( panel:GetWide(), 55 )
		CheckBoxPanel:Dock( TOP )
		CheckBoxPanel.Paint = function( self, w, h )
			surface.SetDrawColor( 70, 70, 70, 255 )
			surface.DrawLine( 30, h - 1, w - 30, h - 1 )
		end
		
		local toggleAni = {}
		toggleAni.a = 3
		toggleAni.b = true
		toggleAni.backCol = Color(150,150,150)
	
		local toggleButPanel = vgui.Create( "DPanel", CheckBoxPanel )
		toggleButPanel:SetSize( 55, 30 )
		toggleButPanel:SetPos( CheckBoxPanel:GetWide() - 90, 10 )
		toggleButPanel:SetBackgroundColor( Color(0,0,0,0) )
		
		local toggle = vgui.Create( "DPanel", toggleButPanel )
		toggle:SetSize( 55, 30 )
		toggle:SetPos( 0, 0 )
		toggle.Paint = function( self, w, h )
			draw.RoundedBox( cornerRadius, 0, 0, w, h, toggleAni.backCol )
		end
		
		local toggle2 = vgui.Create( "DPanel", toggleButPanel )
		toggle2:SetSize( 24, 24 )
		if table.Vaild then
			toggle2:SetPos( 28, 3 )
			toggleAni.backCol = Color(42, 205, 114)
		else
			toggle2:SetPos( 3, 3 )
			toggleAni.backCol = Color(150,150,150)
		end
		local curTime = CurTime()
		
		toggle2.Paint = function( self, w, h )
			draw.RoundedBox( 12, 0, 0, w, h, Color( 255, 255, 255, 255 ) )
			--[[toggle2:SetPos( toggleAni.a, 3 )
				
				if toggleAni.a >= 28 then
					toggleAni.b = true
				elseif toggleAni.a <= 3 then
					toggleAni.b = false
				end
				
				if toggleAni.b and table.Vaild == false then
					toggleAni.a = toggleAni.a - 400 / PlayMP.CurFrameTime
					toggleAni.backCol = Color(150,150,150)
				elseif toggleAni.b == false and table.Vaild == true then
					toggleAni.a = toggleAni.a + 400 / PlayMP.CurFrameTime
					toggleAni.backCol = Color(42, 205, 114)
				elseif toggleAni.a > 28 and table.Vaild == true then
					toggleAni.a = 28
				elseif toggleAni.a < 3 and table.Vaild == false then
					toggleAni.a = 3
				end]]
			
		end
		
		local TogDoClick = vgui.Create( "DLabel", toggleButPanel  )
		TogDoClick:SetSize( toggleButPanel:GetWide(), toggleButPanel:GetTall() )
		TogDoClick:SetPos( 0, 0 )
		TogDoClick:SetFont( "DebugFixed" )
		TogDoClick:SetText( "" )
		TogDoClick:SetMouseInputEnabled( true )
	
		function TogDoClick:DoClick()
			if table.Vaild then
				toggle2:MoveTo(3,3,0.2)
				table.Vaild = false
				toggleAni.backCol = Color(150,150,150)
				if instant != nil and instant == true then
					vaild[unique] = table.Vaild
				end
			else
				toggle2:MoveTo(28,3,0.2)
				table.Vaild = true
				toggleAni.backCol = Color(42, 205, 114)
				if instant != nil and instant == true then
					vaild[unique] = table.Vaild
				end
			end
			
			if instant != nil and instant == true then
				return table.Vaild
			else
				hook.Add(def, def, function() PlayMP:ChangeSetting( def, table.Vaild ) end)
				hook.Run( def )
				hook.Run( text, table.Vaild, label )
			end
		end
		
		--[[local Tiggle = vgui.Create( "DImageButton", CheckBoxPanel )
		Tiggle:SetPos( CheckBoxPanel:GetWide() - 90, 10 )
		Tiggle:SetSize( 50, 30 )
		Tiggle:SetImage( "image/Toggle_true.png" )		
		Tiggle.DoClick = function()
			if table.Vaild then
				Tiggle:SetImage( "image/Toggle_false.png" )
				table.Vaild = false
			else
				Tiggle:SetImage( "image/Toggle_true.png" )	
				table.Vaild = true
			end
		end]]
		
		local label = vgui.Create( "DLabel", CheckBoxPanel )
		label:SetSize( CheckBoxPanel:GetWide() - 100, CheckBoxPanel:GetTall() )
		label:SetPos( 40, 0 )
		label:SetFont( "Default_PlaymusicPro_Font" )
		label:SetColor( Color( 255, 255, 255, 255 ) )
		label:SetText( text )
		
		hook.Add( text, text, func )
			
	end

	
	
	function PlayMP:AddTextBox( panel, tall, dock, text, x, y, font, color, boxColor, align, func )
		
		local align = align
		
		local TextBox = panel:Add( "DPanel" )
		TextBox:SetSize( panel:GetWide(), tall )
		TextBox:Dock( dock )
		TextBox.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, boxColor )
			--draw.DrawText( text, font, x, y, color, align )
		end

		local label = vgui.Create( "DLabel", TextBox )
		label:SetPos( x,y )
		label:SetSize( TextBox:GetWide()-x, TextBox:GetTall()-y )
		
		surface.SetFont( font )
		local w, h = surface.GetTextSize( text )
	
		if align == TEXT_ALIGN_LEFT then
			label:SetPos( x,y )
		elseif align == TEXT_ALIGN_CENTER then
			if w <= TextBox:GetWide() then
				local center = TextBox:GetWide()/2
				label:SetPos( center-w/2,0 )
				label:SetSize( w, TextBox:GetTall() )
			else
				local line = h * math.Round(w/(TextBox:GetWide()-50)) + h
				label:SetPos( 25,TextBox:GetTall()/2 - line/2 )
				label:SetSize( TextBox:GetWide() - 50, line)
			end
		end

		label:SetFont( font )
		label:SetColor( color )
		label:SetText( text )
		label:SetWrap( true )
		
		hook.Add( text, text, func )
		hook.Run( text, TextBox, TextBox:GetWide(), TextBox:GetTall(), label )
		
		return label
		
	end
	
	
	function PlayMP:AddTextEntryBox( scrpanel, dock, text, subtext, w, h )
	
		local entryX = 0
		if text != nil then
			entryX = 1
		end
	
		local EndPanel = scrpanel:Add( "DPanel" )
		EndPanel:SetSize( scrpanel:GetWide(), h )
		EndPanel:Dock( dock )
		EndPanel.Paint = function( self, w, h ) 
			draw.RoundedBox( cornerRadius, (entryX * 85) + 5, 5, w - (entryX * 85) - 10, h - 10, Color(100,100,100,255) )
		end
		
		if entryX == 1 then
			local EndLength = vgui.Create( "DLabel", EndPanel )
			EndLength:SetFont( "Default_PlaymusicPro_Font" )
			EndLength:SetSize( 70, 30 )
			EndLength:SetPos( 15 , 5 )
			EndLength:SetColor( Color( 255, 255, 255, 255 ) )
			EndLength:SetText( text )
		end
				
		local EndLengthTextEntry = vgui.Create( "DTextEntry", EndPanel )
		EndLengthTextEntry:SetPos( (entryX * 85) + 5, 5 )
		EndLengthTextEntry:SetSize( w - (entryX * 85) - 10, h - 10 )
		EndLengthTextEntry:SetDrawBackground(false)
		EndLengthTextEntry:SetCursorColor(Color( 255, 255, 255, 255 ))
		EndLengthTextEntry:SetFont( "Default_PlaymusicPro_Font" )
		EndLengthTextEntry:SetTextColor( Color( 255, 255, 255, 255 ) )
		EndLengthTextEntry:SetPlaceholderText( subtext )
		
		return EndLengthTextEntry
	end
	
	
	function PlayMP:CreatNumScroll( panel, x, y, mn, mx, wide, numEntry, name, doFloor)
	
		local trackMouse = false
		local myData = 0
		local wide = wide
		
		local doFloor = doFloor
		
		if doFloor == nil then
			doFloor = true
		end
		
		local numscrollPanel = vgui.Create( "DPanel", panel )
		numscrollPanel:SetPos(x,y)
		numscrollPanel:SetSize(wide,24)
		numscrollPanel:SetBackgroundColor( Color(0,0,0,0) )
		
		local numscrollMain = vgui.Create( "DPanel", numscrollPanel )
		numscrollMain:SetPos(0,4)
		numscrollMain:SetSize(wide,16)
		numscrollMain:SetBackgroundColor( Color(0,0,0,0) )
		
		local numscrollSec = vgui.Create( "DPanel", numscrollMain )
		numscrollSec:SetPos(2,6)
		numscrollSec:SetSize(wide-4,4)
		numscrollSec.Paint = function( self, w, h ) draw.RoundedBox( 2, 0, 0, w, h, Color( 150, 150, 150, 255 ) ) end
		numscrollSec:AlphaTo( 50, 0.2 ) 
		
		local numscrollFir = vgui.Create( "DPanel", numscrollMain )
		numscrollFir:SetPos(2,6)
		numscrollFir:SetSize(wide-4,4)
		numscrollFir.Paint = function( self, w, h ) draw.RoundedBox( 2, 0, 0, w, h, Color( 255, 255, 255, 255 ) ) end
		
		local numscrollBut = vgui.Create( "DPanel", numscrollMain )
		numscrollBut:SetPos(2,7)
		numscrollBut:SetSize(8,8)
		numscrollBut:SetAlpha(0)
		numscrollBut.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 255, 255, 255 ) ) end
		
		numscrollMain.OnCursorEntered = function( self, w, h )
			numscrollBut:AlphaTo( 255, 0.2 ) 
			numscrollSec:AlphaTo( 200, 0.2 ) 
			trackMouse = true
		end
		numscrollMain.OnCursorExited = function( self, w, h )
			numscrollBut:AlphaTo( 0, 0.2 ) 
			numscrollSec:AlphaTo( 50, 0.2 ) 
			--trackMouse = false
		end
		
		numscrollSec.OnCursorEntered = function( self, w, h )
			numscrollBut:AlphaTo( 255, 0.2 )
			numscrollSec:AlphaTo( 200, 0.2 ) 
			trackMouse = true
		end
		numscrollSec.OnCursorExited = function( self, w, h )
			numscrollBut:AlphaTo( 0, 0.2 ) 
			numscrollSec:AlphaTo( 50, 0.2 ) 
			--trackMouse = false
		end
		
		numscrollFir.OnCursorEntered = function( self, w, h )
			numscrollBut:AlphaTo( 255, 0.2 ) 
			numscrollSec:AlphaTo( 200, 0.2 ) 
			trackMouse = true
		end
		numscrollFir.OnCursorExited = function( self, w, h )
			numscrollBut:AlphaTo( 0, 0.2 ) 
			numscrollSec:AlphaTo( 50, 0.2 ) 
			--trackMouse = false
		end
		
		numscrollBut.OnCursorEntered = function( self, w, h )
			numscrollBut:AlphaTo( 255, 0.2 ) 
			numscrollSec:AlphaTo( 200, 0.2 ) 
			trackMouse = true
		end
		numscrollBut.OnCursorExited = function( self, w, h )
			numscrollBut:AlphaTo( 0, 0.2 ) 
			numscrollSec:AlphaTo( 50, 0.2 ) 
			
			--trackMouse = false
		end
		
		local nscroll = {}
		
		local numscrollEntry = {}
		
		numscrollEntry.SetText = function() end
		
		if numEntry then
		
			wide = wide - 40
			numscrollMain:SetSize(wide,16)
			numscrollSec:SetSize(wide-4,4)
			numscrollFir:SetSize(wide-4,4)
			
			numscrollEntry = vgui.Create( "DTextEntry", numscrollPanel )
			numscrollEntry:SetPos(wide+5,0)
			numscrollEntry:SetSize(30,24)
			numscrollEntry:SetFont("DermaDefault")
			numscrollEntry:SetText(mx)
			numscrollEntry:SetDrawBackground(false)
			numscrollEntry:SetTextColor( Color( 255, 255, 255, 255 ) )
			
			numscrollEntry.OnEnter = function( self )
				numscrollFir:SetSize((wide-2)*(self:GetValue()/mx),4)
				numscrollBut:SetPos((wide-4)*(self:GetValue()/mx)-4,4)
				numscrollEntry:SetText(self:GetValue())
				
				nscroll.ValueChanging(self:GetValue())
				nscroll.ValueChanged(self:GetValue())
			end
			
		end
		
		local datachange = false
		local curx, cury = 0,0
		local alphato = false
		local curData
		
		numscrollMain.Think = function()
			if trackMouse then
				curx, cury = numscrollMain:LocalCursorPos()
				
				if cury < -20 or cury > 36 then trackMouse = false end
				
				if input.IsMouseDown(MOUSE_LEFT) then
					if curx >= 2 and curx <= wide - 2 then
						numscrollFir:SetSize(curx-2,4)
						numscrollBut:SetPos(curx-4,4)
						if doFloor then
							nscroll.ValueChanging(math.Round((curx/wide)*mx))
							curData = math.Round((curx/wide)*mx)
							numscrollEntry:SetText(math.Round((curx/wide)*mx))
						else
							nscroll.ValueChanging((curx/wide)*mx)
							curData = (curx/wide)*mx
							numscrollEntry:SetText((curx/wide)*mx)
						end
					elseif curx < 2 then
						numscrollFir:SetSize(0,4)
						numscrollBut:SetPos(0,4)
						nscroll.ValueChanging(mn)
						curData = mn
						numscrollEntry:SetText(mn)
					elseif curx > wide - 2 then
						numscrollFir:SetSize(wide-4,4)
						numscrollBut:SetPos(wide-8,4)
						nscroll.ValueChanging(mx)
						curData = mx
						numscrollEntry:SetText(mx)
					end
					datachange = true
				else
					if datachange then
						trackMouse = false
					end
				end
			else
				if datachange then
					datachange = false
					nscroll.ValueChanged(curData)
				end
			end
		
			if alphato == true then
				numscrollBut:AlphaTo( 255, 0.3 )
				alphato = false
			end
		end
		
		nscroll.SetNum = function( a, num ) 
			numscrollFir:SetSize((wide-4)*(num/mx),4)
			numscrollBut:SetPos((wide-4)*(num/mx)-4,4)
			if num == 0 then
				numscrollFir:SetSize(0,4)
				numscrollBut:SetPos(0,4)
			end
			numscrollEntry:SetText(num)
		end
		
		nscroll.ValueChanged = function() end
		
		nscroll.ValueChanging = function() end
		
		nscroll.GetValue = function(  ) 
			if doFloor then
				return math.Round((numscrollFir:GetWide()/(wide-4))*mx)
			else
				return (numscrollFir:GetWide()/(wide-4))*mx
			end
		end
		
		return nscroll
	end
	
	
	function PlayMP:MainMenu()

		PlayMP.MainMenuCtrlPanel = vgui.Create( "DPanel", PlayMP.MainMenuPanel )
		PlayMP.MainMenuCtrlPanel:SetPos( 0, PlayMP.MainMenuPanel:GetTall() - 90 )
		PlayMP.MainMenuCtrlPanel:SetSize( PlayMP.MainMenuPanel:GetWide(), 90 )
		PlayMP.MainMenuCtrlPanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20, 255 ) ) end
		
		PlayMP.PlayerVideoImage = vgui.Create( "HTML", PlayMP.MainMenuCtrlPanel )
		PlayMP.PlayerVideoImage:SetPos( -8, PlayMP.MainMenuPanel:GetTall() * -0.5 -15 )
		PlayMP.PlayerVideoImage:SetSize( PlayMP.MainMenuPanel:GetWide() + 30, PlayMP.MainMenuPanel:GetTall() + 30)
		PlayMP.PlayerVideoImage:SetMouseInputEnabled(false)
		local curtime = CurTime()
		local mmpgt = PlayMP.MainMenuPanel:GetTall()
		PlayMP.PlayerVideoImage.Think = function( self )
			if curtime + 0.04 < CurTime() then
				x, y = input.GetCursorPos()
				self:SetPos( -8 + (x-ScrW()/2)*0.02, mmpgt * -0.5 -15 + (y-ScrH()/2)*0.02 )
				
				curtime = CurTime()
			end
		end
		
		local matGradientLeft = CreateMaterial("gradient-l", "UnlitGeneric", {["$basetexture"] = "vgui/gradient-l", ["$vertexalpha"] = "1", ["$vertexcolor"] = "1", ["$ignorez"] = "1", ["$nomip"] = "1"})
		local PlayerVideoImagePanel = vgui.Create( "DPanel", PlayMP.MainMenuCtrlPanel )
		PlayerVideoImagePanel:SetPos( 0, 0 )
		PlayerVideoImagePanel:SetSize( PlayMP.MainMenuCtrlPanel:GetWide(), PlayMP.MainMenuCtrlPanel:GetTall() )
		
		if PlayMP:GetSetting( "Use_Blur", false, true) then
			PlayerVideoImagePanel.Paint = function( self, w, h ) 
				PlayMP:blurEffMainmenu(self, 5, 10, 255)
				surface.SetDrawColor(50, 50, 50, 207)
				surface.SetMaterial(matGradientLeft)
				surface.DrawTexturedRect( w/4, 0, w/4, h)
				draw.RoundedBox( 0, 0, 0, w/4, h, Color( 50, 50, 50, 200 ) )
				surface.SetDrawColor(50, 50, 50, 220)
				surface.DrawTexturedRect( 0, 0, w/3, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 220 ) )
			end
		else
			PlayerVideoImagePanel.Paint = function( self, w, h ) 
				surface.SetDrawColor(50, 50, 50, 207)
				surface.SetMaterial(matGradientLeft)
				surface.DrawTexturedRect( w/4, 0, w/4, h)
				draw.RoundedBox( 0, 0, 0, w/4, h, Color( 50, 50, 50, 200 ) )
				surface.SetDrawColor(50, 50, 50, 220)
				surface.DrawTexturedRect( 0, 0, w/3, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 220 ) )
			end
		end
		
		PlayMP.MainMenuCtrlPanel_Button = vgui.Create( "DPanel", PlayMP.MainMenuCtrlPanel )
		PlayMP.MainMenuCtrlPanel_Button:SetPos( 0, 0 )
		PlayMP.MainMenuCtrlPanel_Button:SetSize( 150,PlayMP.MainMenuCtrlPanel:GetTall() )
		PlayMP.MainMenuCtrlPanel_Button.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, 5, h, Color( 205, 114, 42 ) ) end
	
		PlayMP.PlayerVideoTitle = vgui.Create( "DLabel", PlayMP.MainMenuCtrlPanel )
		PlayMP.PlayerVideoTitle:SetPos( 160, 0 )
		PlayMP.PlayerVideoTitle:SetFont( "Default_PlaymusicPro_Font" )
		PlayMP.PlayerVideoTitle:SetSize( PlayMP.MainMenuCtrlPanel:GetWide() - 500, 50 )
		PlayMP.PlayerVideoTitle:SetColor( Color( 255, 255, 255, 255 ) )
		PlayMP.PlayerVideoTitle:SetText( "PlayMusic Pro" )
		PlayMP.PlayerVideoTitle:SetMouseInputEnabled( true )
		
		PlayMP.PlayerVideoChannel = vgui.Create( "DLabel", PlayMP.MainMenuCtrlPanel )
		PlayMP.PlayerVideoChannel:SetPos( 160, 24 )
		PlayMP.PlayerVideoChannel:SetFont( "Default_PlaymusicPro_Font" )
		PlayMP.PlayerVideoChannel:SetSize( PlayMP.MainMenuCtrlPanel:GetWide() - 500, 50 )
		PlayMP.PlayerVideoChannel:SetColor( Color( 150, 150, 150, 255 ) )
		PlayMP.PlayerVideoChannel:SetText( "" )
		PlayMP.PlayerVideoChannel:SetMouseInputEnabled( true )
	
			local Button_Skip = vgui.Create( "DLabel", PlayMP.MainMenuCtrlPanel_Button )
			Button_Skip:SetPos( PlayMP.MainMenuCtrlPanel_Button:GetWide() / 2 - 15, PlayMP.MainMenuCtrlPanel_Button:GetTall() * 0.5 - 15 )
			Button_Skip:SetSize( 30, 30 )	
			Button_Skip:SetText("")
			local playpoly = PlayMP.GetPoly("TriangleToRight30")
			local playpoly2 = PlayMP.GetPoly("TriangleToRight30_2")
			local alpha = 50
			local alpha2 = 5
			Button_Skip.Paint = function( self, w, h )
				surface.SetDrawColor( 255, 255, 255, alpha )
				draw.NoTexture()
				surface.DrawPoly( playpoly )
				surface.SetDrawColor( 255, 255, 255, alpha2 )
				surface.DrawPoly( playpoly2 )
				--draw.RoundedBox( 1, 0, 4, 4, 26, Color( 255, 255, 255, alpha + alpha2 ) )
				draw.RoundedBoxEx( 1, 2, 5, 4, 20, Color( 255, 255, 255, alpha + alpha2 ), true, false, true, false ) 
				draw.RoundedBox( 8, 24, 4, 4, 22, Color( 255, 255, 255, alpha + alpha2 ) )
			end
			Button_Skip:SetMouseInputEnabled( true )
			Button_Skip.DoClick = function()
				PlayMP:SkipMusic()
			end
			Button_Skip.OnCursorEntered = function( self, w, h )
				alpha = 255
				alpha2 = 150
			end
			Button_Skip.OnCursorExited = function( self, w, h )
				alpha = 50
				alpha2 = 25
			end
		
		
		if LocalPlayer():IsAdmin() or PlayMP.LocalPlayerData[1]["power"] then
			
			net.Receive( "PlayMP:GetServerSettings", function()
		
				local data = net.ReadTable()
					
				for k, v in pairs(data) do
					PlayMP:ChangeSetting( v.UniName, v.Data )
				end
				
			end)
			
			local Button_repeat = vgui.Create( "DImageButton", PlayMP.MainMenuCtrlPanel_Button )
			local Button_repeat_Vail = PlayMP:GetSetting( "RepeatQueue", false, true )
			
			if Button_repeat_Vail then
				Button_repeat:SetImage( "icon16/control_repeat_blue.png" )
			else
				Button_repeat:SetImage( "icon16/control_repeat.png" )
			end
			
			Button_repeat:SetColor( Color( 255, 255, 255, 100 ) )
			Button_repeat:SizeToContents() 
			local asdX, asdY = Button_Skip:GetPos() 
			Button_repeat:SetPos( asdX + 50, (asdY + 15) - (Button_repeat:GetTall()/2) )
			Button_repeat.DoClick = function()

				if Button_repeat_Vail then
					Button_repeat:SetImage( "icon16/control_repeat.png" )
					PlayMP:ChangeSetting( "RepeatQueue", false )
					PlayMP:ChangeServerSettings( "RepeatQueue" )
					Button_repeat_Vail = false
				else
					Button_repeat:SetImage( "icon16/control_repeat_blue.png" )
					PlayMP:ChangeSetting( "RepeatQueue", true )
					PlayMP:ChangeServerSettings( "RepeatQueue" )
					Button_repeat_Vail = true
				end
			end
			Button_repeat.OnCursorEntered = function( self, w, h )
				Button_repeat:SetColor( Color( 255, 255, 255, 255 ) )
			end
			Button_repeat.OnCursorExited = function( self, w, h )
				Button_repeat:SetColor( Color( 255, 255, 255, 100 ) )
			end
			
		end
		
		--[[local VolumeSlider = vgui.Create( "DNumSlider", PlayMP.volPanel )
		VolumeSlider:SetPos( -50,12 )			
		VolumeSlider:SetSize( 340, 30 )		
		VolumeSlider:SetText( " " )	
		VolumeSlider:SetMin( 0 )
		VolumeSlider:SetMax( 100 )				
		VolumeSlider:SetValue( PlayMP.GetPlayerVolume() )]]
		
		local VolumeSlider = PlayMP:CreatNumScroll( PlayMP.volPanel, 50, 16, 0, 100, 240, true)
		VolumeSlider:SetNum(PlayMP.GetPlayerVolume())
	
		local Button_Vol = vgui.Create( "DImageButton", PlayMP.volPanel )
		Button_Vol:SetPos( 10, 12 )
		Button_Vol:SetSize( 30, 30 )
		Button_Vol:SetImage( "vgui/playmusic_pro/vol1" )
		Button_Vol.DoClick = function()
			if PlayMP.PlayerHTML then
				if not PlayMP:isMuted() then
					
					if PlayMP.PlayerHTML != nil and PlayMP.PlayerHTML:Valid() then
						PlayMP.PlayerHTML:QueueJavascript([[player.unMute();]])
					end
					if VolumeSlider:GetValue() > 85 then
						Button_Vol:SetImage( "vgui/playmusic_pro/vol1" )
					elseif VolumeSlider:GetValue() > 50 then
						Button_Vol:SetImage( "vgui/playmusic_pro/vol2" )
					elseif VolumeSlider:GetValue() > 10 then
						Button_Vol:SetImage( "vgui/playmusic_pro/vol3" )
					elseif VolumeSlider:GetValue() == 0 or VolumeSlider:GetValue() < 10 then
						Button_Vol:SetImage( "vgui/playmusic_pro/vol4" )
					end
					
				else
					if PlayMP.PlayerHTML != nil and PlayMP.PlayerHTML:Valid() then
						PlayMP.PlayerHTML:QueueJavascript([[player.mute();]])
					end
					Button_Vol:SetImage( "vgui/playmusic_pro/mute.png" )
					
				end
			end
		end
		Button_Vol.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, Color( 0, 0, 0, 230 ) ) 
		end
		
		if VolumeSlider:GetValue() > 85 then
			Button_Vol:SetImage( "vgui/playmusic_pro/vol1" )
		elseif VolumeSlider:GetValue() > 50 then
			Button_Vol:SetImage( "vgui/playmusic_pro/vol2" )
		elseif VolumeSlider:GetValue() > 10 then
			Button_Vol:SetImage( "vgui/playmusic_pro/vol3" )
		elseif VolumeSlider:GetValue() == 0 or VolumeSlider:GetValue() <= 10 then
			Button_Vol:SetImage( "vgui/playmusic_pro/vol4" )
		end
		
		VolumeSlider.ValueChanging = function(  )
			PlayMP.SetPlayerVolume( VolumeSlider:GetValue() )
			
			if PlayMP.PlayerIsMuted then return end
			
			if VolumeSlider:GetValue() > 85 then
				Button_Vol:SetImage( "vgui/playmusic_pro/vol1" )
			elseif VolumeSlider:GetValue() > 50 then
				Button_Vol:SetImage( "vgui/playmusic_pro/vol2" )
			elseif VolumeSlider:GetValue() > 10 then
				Button_Vol:SetImage( "vgui/playmusic_pro/vol3" )
			elseif VolumeSlider:GetValue() == 0 or VolumeSlider:GetValue() <= 10 then
				Button_Vol:SetImage( "vgui/playmusic_pro/vol4" )
			end
			
		end
		
	
		if PlayMP.CurVideoInfo then
			for k, v in pairs( PlayMP.CurVideoInfo ) do
				if tonumber(v["QueueNum"]) == PlayMP.CurPlayNum then
					local image
					if PlayMP:GetSetting( "FMem", false, true) then
						image = v["ImageLow"]
					else
						image = v["Image"]
					end
					PlayMP.PlayerVideoImage:SetHTML( "<img src=\"" .. image .. "\" width=\" " .. ScrW() * 0.8 .. " \" height=\" " .. ScrH() * 0.8 .. "\">" )
					
					PlayMP.PlayerVideoTitle:SetText( v["Title"] )
					PlayMP.PlayerVideoChannel:SetText( v["Channel"] )
				end
			end
		end
		
		local seektoMain = vgui.Create( "DPanel", PlayMP.MainMenuCtrlPanel )
		seektoMain:SetPos( 210, 53 )
		seektoMain:SetSize( PlayMP.MainMenuCtrlPanel:GetWide() - 400, 40 )
		seektoMain.Paint = function( self, w, h ) 
			--draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 15 ) )
		end
		
		surface.SetFont( "Default_PlaymusicPro_Font" )
		local w, h = surface.GetTextSize( "--:--" )
		
		local seektoTimeView = vgui.Create( "DPanel", PlayMP.MainMenuCtrlPanel )
		seektoTimeView:SetPos( 210, 53 - h + 4 )
		seektoTimeView:SetSize( w + 10, h + 4 )
		seektoTimeView:SetAlpha(0)
		seektoTimeView.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) ) end
		
		local seektoTimeViewText = vgui.Create( "DLabel", seektoTimeView )
		seektoTimeViewText:SetPos(seektoTimeView:GetWide()/2 - w/2)
		seektoTimeViewText:SetText("--:--")
		
		
		local seektoMainX, seektoMainY = seektoMain:GetPos()
		local seektoMainW, seektoMainH = seektoMain:GetSize()
		
		local playtime = vgui.Create( "DLabel", PlayMP.MainMenuCtrlPanel )
		playtime:SetSize( w, h )
		playtime:SetPos( seektoMainX - w - 10, seektoMainY + (seektoMainH/2) - (h/2))
		playtime:SetFont( "Default_PlaymusicPro_Font" )
		playtime:SetColor( Color( 255, 255, 255, 255 ) )
		playtime:SetText( "--:--" )
		playtime:SetMouseInputEnabled( true )
		local playtimetime = math.Round( PlayMP.CurPlayTime )
		playtime.Think = function()
			if math.Round( PlayMP.CurPlayTime ) != playtimetime then
				playtimetime = math.Round( PlayMP.CurPlayTime )
				local Strtime = string.ToMinutesSeconds(playtimetime)
				playtime:SetText( Strtime )
				surface.SetFont( "Default_PlaymusicPro_Font" )
				local w, h = surface.GetTextSize( Strtime )
				playtime:SetSize( w, h )
				playtime:SetPos( seektoMainX - w - 10, seektoMainY + (seektoMainH/2) - (h/2))
			end
		end
		
		local remaintime = vgui.Create( "DLabel", PlayMP.MainMenuCtrlPanel )
		remaintime:SetSize( w, h )
		remaintime:SetPos( seektoMainX + seektoMainW + 10, seektoMainY + (seektoMainH/2) - (h/2))
		remaintime:SetFont( "Default_PlaymusicPro_Font" )
		remaintime:SetColor( Color( 255, 255, 255, 255 ) )
		remaintime:SetText( "--:--" )
		remaintime:SetMouseInputEnabled( true )
		local remaintimetime = math.Round( PlayMP.CurVideoLength - PlayMP.CurPlayTime )
		remaintime.Think = function()
			if math.Round(PlayMP.CurVideoLength - PlayMP.CurPlayTime) != remaintimetime then
				remaintimetime = math.Round( PlayMP.CurVideoLength - PlayMP.CurPlayTime )
				local Strtime = string.ToMinutesSeconds(remaintimetime)
				remaintime:SetText( Strtime )
				surface.SetFont( "Default_PlaymusicPro_Font" )
				local w, h = surface.GetTextSize( Strtime )
				remaintime:SetSize( w, h )
				remaintime:SetPos( seektoMainX + seektoMainW + 10, seektoMainY + (seektoMainH/2) - (h/2))
			end
		end
		
		local seekto = PlayMP:CreatNumScroll( seektoMain, 0, 8, 0, 1, seektoMain:GetWide(), false, nil, false)
		seekto:SetNum( PlayMP.CurPlayTime / PlayMP.CurVideoLength )
		seekto.ValueChanged = function( d ) 
			PlayMP:DoSeekToVideo( d * PlayMP.CurVideoLength )
			seektoTimeView:AlphaTo(0,1,1)
		end
		seekto.ValueChanging = function( d )
			seektoTimeView:SetAlpha(255)
			surface.SetFont( "Default_PlaymusicPro_Font" )
			local w, h = surface.GetTextSize(string.ToMinutesSeconds(d * PlayMP.CurVideoLength))
			seektoTimeViewText:SetText(string.ToMinutesSeconds(d * PlayMP.CurVideoLength))
			seektoTimeView:SetPos( (210 + (seektoMain:GetWide() * d)) - (w/2) - 5, 53 - h + 4 )
			seektoTimeView:SetSize( w + 10, h + 4 )
			seektoTimeViewText:SetPos(seektoTimeView:GetWide()/2 - w/3)
		end
		
		hook.Add("Think", "Menu Time Seekto bar Think", function()
			
			if PlayMP.MainMenuPanel == nil then hook.Remove("Think", "Menu Time Seekto bar Think") return end
			--if not PlayMP.MainMenuPanel:IsValid() then hook.Remove("Think", "Menu Time Seekto bar Think") end
			
			if PlayMP.CurPlayTime == nil then return end
			if PlayMP.CurVideoLength == nil then return end
			
			seekto:SetNum( PlayMP.CurPlayTime / PlayMP.CurVideoLength )
			
		end)

		--[[local seekto_f = vgui.Create( "DPanel", seektoMain  )
		seekto_f:SetPos( 0, 18 )
		seekto_f:SetSize( seektoMain:GetWide(), 4 )
		seekto_f.Paint = function( self, w, h ) 
			draw.RoundedBox( 3, 0, 0, w, h, Color( 255, 255, 255, 70 ) )
		end
		
		local seekto_b = vgui.Create( "DPanel", seektoMain  )
		seekto_b:SetPos( 0, 18 )
		seekto_b:SetSize( seektoMain:GetWide(), 4 )
		seekto_b.Paint = function( self, w, h )
			draw.RoundedBox( 3, 0, 0, w, h, Color( 255, 255, 255, 16 ) )
		end
		
		local seekto_c_ClickColor = Color( 255, 255, 255, 0 )
		local seekto_c_TrackMouse = false
		local doseekto = false
		
		local seekto_c = vgui.Create( "DPanel", seektoMain  )
		seekto_c:SetPos( 0, 10 )
		seekto_c:SetSize( 20, 20 )
		seekto_c.Paint = function( self, w, h )
			draw.RoundedBox( 8, 1, 1, w -2, h-2, Color( 240, 240, 240, 255 ) )
			draw.RoundedBox( 7, 3, 3, w -6, h -6, Color( 70, 70, 70, 255 ) )
			draw.RoundedBox( 10, 0, 0, w, h, seekto_c_ClickColor )
		end
		
		local seekto_c_act = vgui.Create( "DLabel", seekto_c )
		seekto_c_act:Dock( FILL )
		seekto_c_act:SetColor( Color( 0, 0, 0, 0 ) )
		seekto_c_act:SetText( "" )
		seekto_c_act:SetMouseInputEnabled( true )
		
		seekto_c_act.OnCursorEntered = function( self, w, h )
			seekto_c_TrackMouse = true
			seekto_c_ClickColor = Color( 255, 255, 255, 255 )
		end
		seekto_c_act.OnCursorExited = function( self, w, h )
			seekto_c_ClickColor = Color( 255, 255, 255, 0 )
		end
		
		seektoMain.OnCursorEntered = function( self, w, h )
			seekto_c_TrackMouse = true
			seekto_c_ClickColor = Color( 50, 50, 50, 170 )
		end
		seektoMain.OnCursorExited = function( self, w, h )
			seekto_c_TrackMouse = false
			seekto_c_ClickColor = Color( 0, 0, 0, 0 )
		end
		seekto_f.OnCursorEntered = function( self, w, h )
			seekto_c_TrackMouse = true
			seekto_c_ClickColor = Color( 50, 50, 50, 170 )
		end
		seekto_b.OnCursorEntered = function( self, w, h )
			seekto_c_TrackMouse = true
			seekto_c_ClickColor = Color( 50, 50, 50, 170 )
		end]]
		
		PlayMP.MenuWindowPanel = vgui.Create( "DPanel", PlayMP.basePanel )
		PlayMP.MenuWindowPanel:SetPos( PlayMP.sideMenuPanel:GetWide(), 56 )
		PlayMP.MenuWindowPanel:SetSize( PlayMP.basePanel:GetWide() - PlayMP.sideMenuPanel:GetWide(), PlayMP.basePanel:GetTall() )
		PlayMP.MenuWindowPanel.Paint = function( self, w, h ) 
			--draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) 
		end
		
		function PlayMP:OpenWriteQueueInfoPanelPlayList( id, force )
		
			if PlayMP:GetSetting( "Quick_Request", false, true ) and force != true then 
				PlayMP:AddQueue( id, 0, 0, true )
				return
			end
			
			PlayMP:OpenSubFrame( PlayMP:Str( "QeeueMedia_Plyst" ), "큐에등록하기", 600, 550, function( mainPanel, scrpanel, ButtonPanel )
			
				if id then
					
					local URL = scrpanel:Add( "DPanel" )
					URL:SetSize( scrpanel:GetWide(), 270 )
					URL:Dock( TOP )
					URL.Paint = function( self, w, h ) 
					end
					URL:SetMouseInputEnabled( true )
					
					local Video = vgui.Create( "HTML", URL )
					Video:SetSize( 480, 270 )
					Video:SetPos( (URL:GetWide() * 0.5) - 240, 0 )
					Video:SetMouseInputEnabled( true )
					Video:OpenURL( "https://www.youtube.com/embed/watch?list=" .. id .. "&t=0s&index=2" )
				
				end
				
				local rhrmqOption = scrpanel:Add( "DPanel" )
				rhrmqOption:SetSize( scrpanel:GetWide(), 50 )
				rhrmqOption:Dock( TOP )
				rhrmqOption.Paint = function( self, w, h ) 
					draw.DrawText( PlayMP:Str( "DoYouWantQeeueThisPlyst" ), "Default_PlaymusicPro_Font", w * 0.5, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
				end
				
				PlayMP:AddActionButton( ButtonPanel, PlayMP:Str("QueueRequest"), Color( 42, 205, 114 ), ButtonPanel:GetWide() - 200, 10, 100, 30, function() 
						hook.Remove("HUDPaint", "OpenRequestQueueWindow")
						mainPanel:Close()
						
						PlayMP:AddQueue( id, 0, 0, true )
						
					end)
						
					PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Cancel" ), Color(231, 76, 47), ButtonPanel:GetWide() - 90, 10, 80, 30, function() 
						hook.Remove("HUDPaint", "OpenRequestQueueWindow")
						mainPanel:Close() 
					end)
			
			end)
		
		end
		
		
		PlayMP:LoadOptions()
	
		
		PlayMP:ChangeMenuWindow( "queueList" )
		
	
	end
	
function PlayMP:OpenWriteQueueInfoPanel( url, force, sT, eT )
		
			if PlayMP:GetSetting( "Quick_Request", false, true ) and force != true then 
				local sT = sT
				local eT = eT
				
				if sT == nil then
					sT = 0
				end
				if eT == nil then
					eT = 0
				end
				PlayMP:AddQueue( url, sT, eT )
				return
			end
		
			PlayMP:OpenSubFrame( PlayMP:Str( "QeeueMedia" ), "큐에등록하기", 600, 550, function( mainPanel, scrpanel, ButtonPanel )
					
					if url then
					
						local PriviewUri = url
					
						local URL = scrpanel:Add( "DPanel" )
						URL:SetSize( scrpanel:GetWide(), 270 )
						URL:Dock( TOP )
						URL.Paint = function( self, w, h ) 
						end
						URL:SetMouseInputEnabled( true )
						
						if string.find(url,"youtube")!=nil then
							if string.find(url,"list=")!=nil then
								
								hook.Remove("HUDPaint", "OpenRequestQueueWindow")
								mainPanel:Close()
								
								PlayMP:OpenWriteQueueInfoPanelPlayList( string.match(url,"[?&]list=([^&]*)") )
								
								return
							end
							PriviewUri = string.match(url,"[?&]v=([^&]*)")
						elseif string.find(url,"youtu.be")!=nil then
							PriviewUri = string.match(url,"https://youtu.be/([^&]*)")
						end
					
						local Video = vgui.Create( "HTML", URL )
						Video:SetSize( 480, 270 )
						Video:SetPos( (URL:GetWide() * 0.5) - 240, 0 )
						Video:SetMouseInputEnabled( true )
						Video:OpenURL( "https://www.youtube.com/embed/" .. PriviewUri .. "?autoplay=0&showinfo=0&rel=0&disablekb=0" )
						
					end
					
					local URLEntry = PlayMP:AddTextEntryBox( scrpanel, TOP, nil, PlayMP:Str("EnterYoutubeUrl"), scrpanel:GetWide(), 40 )
					URLEntry:SetText( url )
					
					local rhrmqOption = scrpanel:Add( "DPanel" )
					rhrmqOption:SetSize( scrpanel:GetWide(), 50 )
					rhrmqOption:Dock( TOP )
					rhrmqOption.Paint = function( self, w, h ) 
						draw.DrawText( PlayMP:Str("AdvancedOptions"), "Default_PlaymusicPro_Font", w * 0.5, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
					end
					
					local StartEntry = PlayMP:AddTextEntryBox( scrpanel, TOP, PlayMP:Str("StartTime"), PlayMP:Str("StartTime"), scrpanel:GetWide(), 40 )
					StartEntry:SetText( string.ToMinutesSeconds(sT) )
					local EndLengthTextEntry = PlayMP:AddTextEntryBox( scrpanel, TOP, PlayMP:Str("EndTime"), PlayMP:Str("EndTime"), scrpanel:GetWide(), 40 )
					EndLengthTextEntry:SetText( string.ToMinutesSeconds(eT) )
				
					PlayMP:AddActionButton( ButtonPanel, PlayMP:Str("QueueRequest"), Color( 42, 205, 114 ), ButtonPanel:GetWide() - 200, 10, 100, 30, function() 
						hook.Remove("HUDPaint", "OpenRequestQueueWindow")
						mainPanel:Close()
						
						if string.find( URLEntry:GetValue(),"list=")!=nil then
								
							hook.Remove("HUDPaint", "OpenRequestQueueWindow")
							mainPanel:Close()
								
							PlayMP:OpenWriteQueueInfoPanelPlayList( string.match(URLEntry:GetValue(),"[?&]list=([^&]*)") )
								
							return
						end
						
						local startTimeStr = StartEntry:GetValue()
						local endTimeStr = EndLengthTextEntry:GetValue()
						
						local SS = 0
						local SM = 0

						local ES = 0
						local EM = 0

						local c = 0
						for s in string.gmatch( StartEntry:GetValue(), "[^%s:]+" ) do
							c = c + 1
							if c == 2 then
								SS = tonumber(s)
							else
								SM = tonumber(s)
							end
						end
						
						local c = 0
						for s in string.gmatch( EndLengthTextEntry:GetValue(), "[^%s:]+" ) do
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
						
							local queueRequest = {}
							
							queueRequest.startTime = SS + SM
							queueRequest.endTime = ES + EM
							
							if queueRequest.startTime > queueRequest.endTime then
							
								if queueRequest.endTime == 0 or queueRequest.endTime == "" then
								
								else
									
									if queueRequest.startTime < queueRequest.endTime then
										PlayMP:Notice( PlayMP:Str( "QeeueMedia_Error01" ), Color(231, 76, 47), "warning" )
										return
									end
									
								end
								
							end
				
							PlayMP:AddQueue( URLEntry:GetValue(), queueRequest.startTime, queueRequest.endTime )
							
							timer.Simple( 1, function()
								if PlayMP.CurMenuPage == "queueList" then
									PlayMP:ChangeMenuWindow( "queueList" )
								end
							end)
						else
							PlayMP:Notice( PlayMP:Str( "QeeueMedia_Error02" ), Color(231, 76, 47), "warning" )
						end
						
					end)
						
					PlayMP:AddActionButton( ButtonPanel, PlayMP:Str( "Cancel" ), Color(231, 76, 47), ButtonPanel:GetWide() - 90, 10, 80, 30, function() 
						hook.Remove("HUDPaint", "OpenRequestQueueWindow")
						mainPanel:Close() 
					end)
			
			end)
		
		end


function PlayMP:DoNoticeToPlayer( text, color, type )

	
	if PlayMP.NotchInfoPanel != nil and PlayMP.NotchInfoPanel:Valid() then -- 정보패널에 알림을 표시하기 전 정보패널 존재 확인
		
		local ivbas = PlayMP:GetSetting( "Show_InfPan_Always", false, true )
		local ivbasGener = PlayMP:GetSetting( "DONOTshowInfoPanel", false, true )
		if ivbas != true then
			PlayMP.NotchInfoPanel_PlayerVideoImage:SetAlpha(255)
			PlayMP.NotchInfoPanel:AlphaTo( 255, 1 )
			--PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2, 20, 1, 0)
			if type == "warning" then
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2 -10, 20, 0.05, 0, -1, function()
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2 +10, 20, 0.05, 0, -1, function()
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2 -10, 20, 0.05, 0, -1, function()
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2 +10, 20, 0.05, 0, -1, function()
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2, 20, 0.05, 0, -1, function()
				end)
				end)
				end)
				end)
				end)
			else
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2, 20, 1, 0, -1)
			end
		elseif ivbasGener == true then
			chat.AddText("[Playmusic Pro] " .. text)
		else
			if type == "warning" then
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2 -10, 20, 0.05, 0, -1, function()
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2 +10, 20, 0.05, 0, -1, function()
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2 -10, 20, 0.05, 0, -1, function()
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2 +10, 20, 0.05, 0, -1, function()
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2, 20, 0.05, 0, -1, function()
				end)
				end)
				end)
				end)
				end)
			else
				PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2, 20, 1, 0, -1)
			end
		end
		
		local NoticePanel = vgui.Create( "DPanel", PlayMP.NotchInfoPanel )
		NoticePanel:SetPos( 0, 0 )
		NoticePanel:SetSize( PlayMP.NotchInfoPanel:GetWide(), PlayMP.NotchInfoPanel:GetTall() )
		NoticePanel.Paint = function( self, w, h )
			PlayMP:blurEff( self, 1, 1, 255 )
			draw.RoundedBox( 0, 0, 0, w, h, color ) 
		end
		NoticePanel:SetAlpha( 0 ) 
		
		surface.SetFont( "Default_PlaymusicPro_Font" )
		local w, h = surface.GetTextSize( text )
		
		local NotichLable = vgui.Create( "DLabel", NoticePanel )
		NotichLable:SetFont( "Default_PlaymusicPro_Font" )
		NotichLable:SetSize( w, h )
		NotichLable:SetColor( Color( 255, 255, 255, 255 ) )
		NotichLable:SetText( text )
		
		if (w + 10) > NoticePanel:GetWide() then
			NotichLable:SetPos( 10, NoticePanel:GetTall() / 2 - h / 2 )
			NotichLable:MoveTo( NoticePanel:GetWide() -20 -w , NoticePanel:GetTall() / 2 - h / 2, 8, 2, 1)
		else
			NotichLable:SetPos( NoticePanel:GetWide() / 2 - w / 2, NoticePanel:GetTall() / 2 - h / 2 )
		end
		
		NoticePanel:AlphaTo( 255, 0.5, 0, function()
			NoticePanel:AlphaTo( 0, 5, 9.5, function()
				
				local ivbas = PlayMP:GetSetting( "Show_InfPan_Always", false, true )
				if ivbas != true then
					PlayMP.NotchInfoPanel_PlayerVideoImage:SetAlpha(0)
					PlayMP.NotchInfoPanel:AlphaTo( 0, 1 )
					PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.5 - ScrW() * 0.2, 0, 1, 0, -1, function() 
						NotichLable:Clear()
						NoticePanel:Clear()
					end)
				end
				
			end) 
		end)
		
	end
	
	
end

function PlayMP.GetLoadingAni()
local loadAnima = [[
	<html>
		<head>
		<title>Preloader</title>
		<style>
			.lds-spinner {
			  color: official;
			  display: inline-block;
			  position: relative;
			  width: 64px;
			  height: 64px;
			}
			.lds-spinner div {
			  transform-origin: 32px 32px;
			  animation: lds-spinner 1.2s linear infinite;
			}
			.lds-spinner div:after {
			  content: " ";
			  display: block;
			  position: absolute;
			  top: 3px;
			  left: 29px;
			  width: 5px;
			  height: 14px;
			  border-radius: 20%;
			  background: #fff;
			}
			.lds-spinner div:nth-child(1) {
			  transform: rotate(0deg);
			  animation-delay: -1.1s;
			}
			.lds-spinner div:nth-child(2) {
			  transform: rotate(30deg);
			  animation-delay: -1s;
			}
			.lds-spinner div:nth-child(3) {
			  transform: rotate(60deg);
			  animation-delay: -0.9s;
			}
			.lds-spinner div:nth-child(4) {
			  transform: rotate(90deg);
			  animation-delay: -0.8s;
			}
			.lds-spinner div:nth-child(5) {
			  transform: rotate(120deg);
			  animation-delay: -0.7s;
			}
			.lds-spinner div:nth-child(6) {
			  transform: rotate(150deg);
			  animation-delay: -0.6s;
			}
			.lds-spinner div:nth-child(7) {
			  transform: rotate(180deg);
			  animation-delay: -0.5s;
			}
			.lds-spinner div:nth-child(8) {
			  transform: rotate(210deg);
			  animation-delay: -0.4s;
			}
			.lds-spinner div:nth-child(9) {
			  transform: rotate(240deg);
			  animation-delay: -0.3s;
			}
			.lds-spinner div:nth-child(10) {
			  transform: rotate(270deg);
			  animation-delay: -0.2s;
			}
			.lds-spinner div:nth-child(11) {
			  transform: rotate(300deg);
			  animation-delay: -0.1s;
			}
			.lds-spinner div:nth-child(12) {
			  transform: rotate(330deg);
			  animation-delay: 0s;
			}
			@keyframes lds-spinner {
			  0% {
				opacity: 1;
			  }
			  100% {
				opacity: 0;
			  }
			}


		</style>
	</head>
<body>

	<div class="lds-spinner"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div>
	
</body>
</html>
]]

return loadAnima
end


include("playmusicpro/cl_option.lua")

