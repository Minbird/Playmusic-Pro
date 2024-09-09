PlayMP.ui = {}

function PlayMP.ui.make_frame( x, y, w, h )
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

function PlayMP:ShowNotchInfoPanel( boo, text )

	if boo then
		
		local ivbasGener = PlayMP:GetSetting( "DONOTshowInfoPanel", false, true )
	
		if PlayMP.NotchInfoPanel != nil and PlayMP.NotchInfoPanel:Valid() then
			hook.Remove("Think", "PlayerVideoTitle_TextSliderThink")
			hook.Remove("Tick", "MainNotchInfoPanelTimebarTick")
			hook.Remove("Think", "PlayerVideoTitle_aniImage_Think")
			PlayMP.NotchInfoPanel:Clear()
			PlayMP.NotchInfoPanel:Close()
		end
	
		PlayMP.NotchInfoPanel = vgui.Create( "DFrame" )
		PlayMP.NotchInfoPanel:SetSize( ScrW() * 0.3, 50 )
		if ivbasGener then
			PlayMP.NotchInfoPanel:SetPos(ScrW() * 0.55 - ScrW() * 0.2, 0)
			PlayMP.NotchInfoPanel:SetAlpha(0)
		else
			PlayMP.NotchInfoPanel:SetPos(ScrW() * 0.55 - ScrW() * 0.2, 20)
		end
		PlayMP.NotchInfoPanel:SetTitle( "" )
		PlayMP.NotchInfoPanel:SetDraggable( false )
		PlayMP.NotchInfoPanel:SetSkin( "Default" )
		PlayMP.NotchInfoPanel:ShowCloseButton( false )
		PlayMP.NotchInfoPanel.Paint = function(self, w, h)
			draw.RoundedBox( 0, 2, 2, w - 4, h - 4, Color( 0, 0, 0, 255 ) )
		end
		
		PlayMP.MainNotchInfoPanel = vgui.Create( "DPanel", PlayMP.NotchInfoPanel )
		PlayMP.MainNotchInfoPanel:SetPos( 5, 5 )
		PlayMP.MainNotchInfoPanel:SetSize( PlayMP.NotchInfoPanel:GetWide() - 10, PlayMP.NotchInfoPanel:GetTall() - 10 )
		PlayMP.MainNotchInfoPanel.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20, 255 ) ) end
		
		PlayMP.NotchInfoPanel_PlayerVideoImage = vgui.Create( "HTML", PlayMP.MainNotchInfoPanel )
		PlayMP.NotchInfoPanel_PlayerVideoImage:SetPos( -10, PlayMP.MainNotchInfoPanel:GetTall() * -0.6)
		PlayMP.NotchInfoPanel_PlayerVideoImage:SetSize( PlayMP.MainNotchInfoPanel:GetWide() + 30, PlayMP.MainNotchInfoPanel:GetTall() * 2)
		PlayMP.NotchInfoPanel_PlayerVideoImage:SetMouseInputEnabled(false)
		
		local matGradientLeft = CreateMaterial("gradient-l", "UnlitGeneric", {["$basetexture"] = "vgui/gradient-l", ["$vertexalpha"] = "1", ["$vertexcolor"] = "1", ["$ignorez"] = "1", ["$nomip"] = "1"})
		local PlayerVideoImagePanel = vgui.Create( "DPanel", PlayMP.MainNotchInfoPanel )
		PlayerVideoImagePanel:SetPos( 0, 0 )
		PlayerVideoImagePanel:SetSize( PlayMP.MainNotchInfoPanel:GetWide(), PlayMP.MainNotchInfoPanel:GetTall() )
		
		if PlayMP:GetSetting( "Use_Blur", false, true) then
			PlayerVideoImagePanel.Paint = function( self, w, h ) 
				blurEff(self, 1, 1, 255)
				surface.SetDrawColor(0, 0, 0, 255)
				surface.SetMaterial(matGradientLeft)
				surface.DrawTexturedRect( -20, 0, w - 20, h)
				
				surface.DrawTexturedRectRotated( w/2 + 20, h/2, w - 20, h , 180)
			end
		else
			PlayerVideoImagePanel.Paint = function( self, w, h ) 
				surface.SetDrawColor(0, 0, 0, 255)
				surface.SetMaterial(matGradientLeft)
				surface.DrawTexturedRect( -20, 0, w - 20, h)
				
				surface.DrawTexturedRectRotated( w/2 + 20, h/2, w - 20, h , 180)
			end
		end
		
		local nowplaying = PlayMP:Str( "Now_Playing" )
		local prepareplay = PlayMP:Str( "Prepare_Play" )
		
		local nowplayingText = nowplaying
		
		if PlayMP.isPlaying != true then
			nowplayingText = prepareplay
		end
		
		surface.SetFont( "DebugFixed" )
		local w, h = surface.GetTextSize( nowplayingText )
		
		PlayMP.nowplayingTextLabel = vgui.Create( "DLabel", PlayMP.MainNotchInfoPanel )
		PlayMP.nowplayingTextLabel:SetPos( 20, PlayMP.MainNotchInfoPanel:GetTall() / 2 - h / 2 )
		PlayMP.nowplayingTextLabel:SetFont( "DebugFixed" )
		PlayMP.nowplayingTextLabel:SetSize( w, h )
		PlayMP.nowplayingTextLabel:SetColor( Color( 255, 255, 255, 255 ) )
		PlayMP.nowplayingTextLabel:SetText( nowplayingText )
		
		local aniIamge = vgui.Create( "DPanel", PlayMP.MainNotchInfoPanel )
		aniIamge:SetPos( 2, PlayMP.MainNotchInfoPanel:GetTall() * 0.5 - 10 )
		aniIamge:SetSize( 16, 16 )
		local pos1 = 1
		local pos2 = 2
		local pos3 = 3
		aniIamge.Paint = function()
		
			draw.RoundedBox( 0, 4, 18 - (18 / pos1)+1, 2, 18 / pos1 - 1, Color(255,150,100,255/pos1) )
			draw.RoundedBox( 0, 8, 18 - (18 / pos2)+1, 2, 18 / pos2 - 1, Color(255,150,100,255/pos2) )
			draw.RoundedBox( 0, 12, 18 - (18 / pos3)+1, 2, 18 / pos3 - 1, Color(255,150,100,255/pos3) )
		
		end
		
		local text = text
		
		if text == nil then
			text = PlayMP:Str( "Unknown_Error" )
		end
		
		PlayMP.PlayerVideoTitlePanel = vgui.Create( "DPanel", PlayMP.MainNotchInfoPanel )
		PlayMP.PlayerVideoTitlePanel:SetPos( 24 + w, 0 )
		PlayMP.PlayerVideoTitlePanel:SetSize( PlayMP.MainNotchInfoPanel:GetWide() - (24 + w), PlayMP.MainNotchInfoPanel:GetTall() )
		PlayMP.PlayerVideoTitlePanel.Paint = function()end
		
		local aniImage_Think = {}
		
		aniImage_Think.aniImage = CurTime()

		
		local asdfasdf = (PlayMP.PlayerVideoTitlePanel:GetTall() / 2 - h / 2)
		
		hook.Add( "Think", "PlayerVideoTitle_aniImage_Think", function()
				
				if aniImage_Think.aniImage + 0.1 < CurTime() then
			
				if PlayMP.Player.isPlaying == nil or PlayMP.Player.isPlaying == false then
					nowplayingText = prepareplay
					return
				else
					nowplayingText = nowplaying
				end
				
				aniImage_Think.aniImage = CurTime()
				
				pos1 = pos1 + 0.2
				pos2 = pos2 + 0.2
				pos3 = pos3 + 0.2

				if pos1 > 2.8 then
					pos1 = 1
				end
				if pos2 > 2.8 then
					pos2 = 1
				end
				if pos3 > 2.8 then
					pos3 = 1
				end

			end
		end)
		
		PlayMP.timebarBack = vgui.Create( "DPanel", PlayMP.PlayerVideoTitlePanel )
		PlayMP.timebarBack:SetPos( 10, PlayMP.PlayerVideoTitlePanel:GetTall() - 5 )
		PlayMP.timebarBack:SetSize( PlayMP.PlayerVideoTitlePanel:GetWide() - 20, 3 )
		PlayMP.timebarBack:SetBackgroundColor( Color( 200, 200, 200, 50 ) )
		
		
		PlayMP.timebar = vgui.Create( "DPanel", PlayMP.PlayerVideoTitlePanel )
		PlayMP.timebar:SetPos( 10, PlayMP.PlayerVideoTitlePanel:GetTall() - 5 )
		PlayMP.timebar:SetSize( 0, 3 )
		PlayMP.timebar:SetBackgroundColor( Color(255, 255, 255, 150) )
		
		local timeTick = CurTime()
		PlayMP.timebar.Think = function()
			if timeTick + 0.5 > CurTime() then return end
			if PlayMP.Player.Cur_play_time != nil and PlayMP.Player.Cur_Media_Length != nil then
				local curtime = PlayMP.Player.Cur_play_time / PlayMP.Player.Cur_Media_Length
				PlayMP.timebar:SetPos( 10, PlayMP.PlayerVideoTitlePanel:GetTall() - 5 )
				PlayMP.timebar:SetSize( (PlayMP.PlayerVideoTitlePanel:GetWide() - 20) * curtime, 3 )
			end
			timeTick = CurTime()
		end
		
		local ivbas = PlayMP:GetSetting( "Show_InfPan_Always", false, true )
		if ivbas != true or ivbasGener == true then
			PlayMP.NotchInfoPanel_PlayerVideoImage:SetAlpha(0)
			PlayMP.NotchInfoPanel:AlphaTo( 0, 1 )
			PlayMP.NotchInfoPanel:MoveTo( ScrW() * 0.55 - ScrW() * 0.2, 0, 1)
		end
		
	else
	
		if PlayMP.NotchInfoPanel != nil and PlayMP.NotchInfoPanel:Valid() then
			hook.Remove("Tick", "MainNotchInfoPanelTimebarTick")
			hook.Remove("Think", "PlayerVideoTitle_TextSliderThink")
			hook.Remove("Think", "PlayerVideoTitle_aniImage_Think")
			PlayMP.NotchInfoPanel:Clear()
			PlayMP.NotchInfoPanel:Close()
		end
		
	end
end

timer.Simple( 1, function() PlayMP:ShowNotchInfoPanel( true, "PlayMusic Pro" ) end)



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
	
	local curtime = PlayMP.Player.Cur_play_time / PlayMP.Player.Cur_Media_Length
	PlayMP.timebar:SetPos( 10, PlayMP.PlayerVideoTitlePanel:GetTall() - 5 )
	PlayMP.timebar:SetSize( (PlayMP.PlayerVideoTitlePanel:GetWide() - 20) * curtime, 3 )
end



function PlayMP.UpdateNotchInfoPanel( text, img )

    local text = text
    if text == nil then text = "" end

	if PlayMP.InfoPanelPlayerVideoTitle != nil then 
		--PlayMP.InfoPanelPlayerVideoTitle:Clear()
		PlayMP.InfoPanelPlayerVideoTitle:Remove()
		PlayMP.InfoPanelPlayerVideoTitle = nil
	end
	
	if PlayMP.InfoPanelPlayerVideoTitle2 != nil then 
		--PlayMP.InfoPanelPlayerVideoTitle2:Clear()
		PlayMP.InfoPanelPlayerVideoTitle2:Remove() 
		PlayMP.InfoPanelPlayerVideoTitle2 = nil
		hook.Remove("Think", "PlayerVideoTitle_TextSliderThink")
	end
	
	surface.SetFont( "NotchInfoPanel_PlaymusicPro_Font" )
	local w, h = surface.GetTextSize( text )
		
	PlayMP.InfoPanelPlayerVideoTitle = vgui.Create( "DLabel", PlayMP.PlayerVideoTitlePanel )
	PlayMP.InfoPanelPlayerVideoTitle:SetPos( PlayMP.PlayerVideoTitlePanel:GetWide() / 2 - w / 2, PlayMP.PlayerVideoTitlePanel:GetTall() / 2 - h / 2 )
	PlayMP.InfoPanelPlayerVideoTitle:SetFont( "NotchInfoPanel_PlaymusicPro_Font" )
	PlayMP.InfoPanelPlayerVideoTitle:SetSize( w, h )
	PlayMP.InfoPanelPlayerVideoTitle:SetColor( Color( 255, 255, 255, 255 ) )
	PlayMP.InfoPanelPlayerVideoTitle:SetText( text )
	
	local asdfasdf = (PlayMP.PlayerVideoTitlePanel:GetTall() / 2 - h / 2)
	
	if w > PlayMP.PlayerVideoTitlePanel:GetWide() - 150 then
			
		PlayMP.InfoPanelPlayerVideoTitle2 = vgui.Create( "DLabel", PlayMP.PlayerVideoTitlePanel )
		PlayMP.InfoPanelPlayerVideoTitle2:SetPos( 5, PlayMP.PlayerVideoTitlePanel:GetWide() / 2 - h / 2 )
		PlayMP.InfoPanelPlayerVideoTitle2:SetFont( "NotchInfoPanel_PlaymusicPro_Font" )
		PlayMP.InfoPanelPlayerVideoTitle2:SetSize( w, h )
		PlayMP.InfoPanelPlayerVideoTitle2:SetColor( Color( 255, 255, 255, 255 ) )
		PlayMP.InfoPanelPlayerVideoTitle2:SetText( text )
			
		local PlayerVideoTitle_TextSliderThink = {}
			
		PlayerVideoTitle_TextSliderThink.Pos = 5
		PlayerVideoTitle_TextSliderThink.Pos2 = w + 100
		PlayerVideoTitle_TextSliderThink.Think_TimeThink = CurTime()
		PlayerVideoTitle_TextSliderThink.StopTime = 0
			
		hook.Add( "Think", "PlayerVideoTitle_TextSliderThink", function()
			
			if 0.05 + PlayerVideoTitle_TextSliderThink.StopTime > CurTime() - PlayerVideoTitle_TextSliderThink.Think_TimeThink then return end
			PlayerVideoTitle_TextSliderThink.Think_TimeThink = CurTime()
			
			PlayerVideoTitle_TextSliderThink.Pos = PlayerVideoTitle_TextSliderThink.Pos - 1
			PlayerVideoTitle_TextSliderThink.Pos2 = PlayerVideoTitle_TextSliderThink.Pos2 - 1
			PlayerVideoTitle_TextSliderThink.StopTime = 0
				
			if PlayerVideoTitle_TextSliderThink.Pos == 5 then
				PlayerVideoTitle_TextSliderThink.StopTime = 5
				PlayerVideoTitle_TextSliderThink.Pos2 = w + 100
			elseif PlayerVideoTitle_TextSliderThink.Pos2 == 5 then
				PlayerVideoTitle_TextSliderThink.StopTime = 5
				PlayerVideoTitle_TextSliderThink.Pos = w + 100
			end
				
			PlayMP.InfoPanelPlayerVideoTitle:SetPos( PlayerVideoTitle_TextSliderThink.Pos, asdfasdf )
			PlayMP.InfoPanelPlayerVideoTitle2:SetPos( PlayerVideoTitle_TextSliderThink.Pos2, asdfasdf )
				
		end)
			
	end
	
	PlayMP.NotchInfoPanel_PlayerVideoImage:SetHTML( "<img src=\"" .. img .. "\" width=\" " .. PlayMP.NotchInfoPanel:GetWide() + 10 .. " \" height=\" " .. PlayMP.NotchInfoPanel:GetWide() / 16 * 9 + 10 .. "\">" )

end



function PlayMP:EditMainPlayer()

	hook.Remove("HUDPaint", "PlaymusicP_MainMenu")
	hook.Remove("Tick", "DoNoticeToPlayerOnMenu")
	PlayMP.MainMenuPanel:AlphaTo(0,0.1,0, function()
		PlayMP.MenuWindowPanel:Clear()
		PlayMP.MainMenuPanel:Remove()
		PlayMP.MainMenuPanel:Close()
		PlayMP.MainMenuPanel = nil
	end)
	
	if PlayMP.PlayerMainPanel != nil and PlayMP.PlayerMainPanel:Valid() then
		PlayMP.PlayerMainPanel:SetAlpha(0)
		PlayMP.PlayerMainPanel:SetMouseInputEnabled(false)
	end 
	
	local vv = PlayMP:GetSetting( "MainPlayerData" )
	print("why")
	PrintTable(vv)
	
	local editPanel = vgui.Create( "DFrame" )
	editPanel:SetMouseInputEnabled(true)
	editPanel:SetPaintedManually(false)
	editPanel:SetSizable( true )
	editPanel:SetPos( vv.X, vv.Y )
	editPanel:SetSize( vv.W, vv.H )
	if vv.H < 144 then
		editPanel:SetSize( 256, 144 )
	end
	editPanel.Paint = function( self, w, h ) draw.RoundedBox( 5, 0, 0, w, h, Color( 0, 0, 0, 230 ) ) end
	editPanel:ShowCloseButton( false )
	editPanel:MakePopup()
	editPanel:SetAlpha(0)
	editPanel:AlphaTo(255,0.3,0)
	
	local editPanelPanel = vgui.Create( "DPanel", editPanel )
	editPanelPanel:SetBackgroundColor(Color(0,0,0,0))
	editPanelPanel:SetSize(vv.W, 30)
	editPanelPanel:SetPos(20, vv.H/2-50)
	
	local tself
	local wW, hH
	local xX, yY
	local x, y = editPanel:GetPos()
	
	local label = vgui.Create( "DLabel", editPanelPanel )
		label:SetPos( editPanel:GetWide() * 0.5, 15 )
		label:SetSize( editPanel:GetWide()-x, editPanel:GetTall()-y )
		
		surface.SetFont( "Default_PlaymusicPro_Font" )
		local w, h = surface.GetTextSize( PlayMP:Str( "Edit_PlyMainPanel_Explain" ) )
	
		local center = editPanel:GetWide()/2
		label:SetPos( center-w/2,0 )
		label:SetSize( w, editPanel:GetTall() )
	
		
		label:SetFont( "Default_PlaymusicPro_Font" )
		label:SetColor( Color( 255, 255, 255 ) )
		label:SetText( PlayMP:Str( "Edit_PlyMainPanel_Explain" ) )
		label:SetWrap( true )
		
	local actionbutton = PlayMP:AddActionButton( editPanelPanel, PlayMP:Str( "Apply" ), Color(231, 76, 47), editPanelPanel:GetWide() * 0.5 -50, 80, 100, 30, function()
		
			local x, y = editPanel:GetPos()
			local w, h = editPanel:GetSize()
			
			if w > h then
				h = (w / 16) * 9
			else
				w = (h / 9) * 16
			end
			
			PlayMP:ChangeSetting( "MainPlayerData", {
					X=x,
					Y=y,
					W=w,
					H=h
				} 
			)
			
			if PlayMP:GetSetting( "디버그모드", false, true) then
				chat.AddText("w:" .. w .. " h:" .. h .. " x:" .. x .. " y:" .. y)
			end
		
		hook.Remove("Think", "editPanel.Think.PMPRO")
		
		editPanel:Close()
		
		if PlayMP.PlayerMainPanel != nil then
			PlayMP.PlayerHTML:Remove()
			PlayMP.PlayerMainPanel:Remove()
		end -- 이걸 수정하고 나서 하게 할까?
		
		PlayMP:CreatFrame( "Playmusic Pro", "PlaymusicP_MainMenu" )
		PlayMP:MainMenu()
		PlayMP:ChangeMenuWindow( "ClientOptions" )
		
		if PlayMP.Player.isPlaying then
			PlayMP.Player:Reload_Player()
		end
		
	end)
	
	local w
	local h
	local x
	local y
	
	editPanel.Print = function( self, ww, hh )
	
		draw.RoundedBox( 5, 0, 0, ww, hh, Color( 0, 0, 0, 230 ) )
	
	end
	
	hook.Add("Think", "editPanel.Think.PMPRO", function()
		
		w, h = editPanel:GetSize()
		x, y = editPanel:GetPos()
		
		if w > h then
			h = (w / 16) * 9
		else
			w = (h / 9) * 16
		end
		
		if x < 0 then
			x = 0
		elseif x + editPanel:GetWide() > ScrW() then
			x = ScrW() - editPanel:GetWide()
		elseif y < 0 then
			y = 0
		elseif y + editPanel:GetTall() > ScrH() then
			y = ScrH() - editPanel:GetTall()
		end
		
		
		
		if h < 144 then
			w = 256
			h = 144
		end
		
		editPanel:SetSize( w, h )
		editPanel:SetPos( x, y )
		
		editPanelPanel:SetSize(w, 80)
		editPanelPanel:SetPos(0, h/2-40)
		
		surface.SetFont( "Default_PlaymusicPro_Font" )
		local sw, sh = surface.GetTextSize( PlayMP:Str( "Edit_PlyMainPanel_Explain" ) )
		
		label:SetPos( w/2-sw/2,30 )
		label:SetSize( sw, editPanelPanel:GetTall() )
		actionbutton:SetPos( w/2-50, editPanelPanel:GetTall()/2 - 15 )

		
	end)

end