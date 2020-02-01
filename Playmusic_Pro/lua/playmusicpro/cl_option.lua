
function PlayMP:LoadOptions()

	for k, v in ipairs( PlayMP.OptionsData ) do
		v.Func()
	end
	
end


function PlayMP:DoAnimaOption( aim, posX, posY, endPoxX, endPoxY, remove, panel, panelNew, mother, time )
	
	if not PlayMP:GetSetting( "Use_Animation", false, true ) then
		panel:Clear()
		panelNew:SetPos( posX, posY )
		panelNew:SetAlpha(255)
		PlayMP.MenuWindowPanel = panelNew
		return
	end
	
	local motherTall = mother:GetTall()
	local motherWide = mother:GetWide()
	local endPoxX = endPoxX
	local endPoxY = endPoxY
	
	local time = time
	
	if time == nil then
		time = 0
	end
	
	if aim then
		
		if aim == "UP" then
			endPoxX = PlayMP.sideMenuPanel:GetWide()
			endPoxY = -motherTall
			panelNew:SetPos( PlayMP.sideMenuPanel:GetWide(), motherTall )
			
		elseif aim == "DOWN" then
			endPoxX = PlayMP.sideMenuPanel:GetWide()
			endPoxY = motherTall
			panelNew:SetPos( PlayMP.sideMenuPanel:GetWide(), -motherTall )
		end
		
	end
	
	panel:AlphaTo(0, time/3, 0, function() if remove then panel:Clear() end end)
	panelNew:AlphaTo(255, time/3)
			
	panel:MoveTo( endPoxX, endPoxY, time, 0, -1 ) 
	panelNew:MoveTo( posX, posY, time/3, 0, -1 )
	
	PlayMP.MenuWindowPanel = panelNew
	
end

function PlayMP:ChangeMenuWindow( panelName, funcd )

			hook.Run( "MenuChanged_PMP", panelName )
			
			local MenuWindowPanelNew = vgui.Create( "DPanel", PlayMP.basePanel )
			MenuWindowPanelNew:SetPos( PlayMP.sideMenuPanel:GetWide(), 56 )
			MenuWindowPanelNew:SetSize( PlayMP.basePanel:GetWide() - PlayMP.sideMenuPanel:GetWide(), PlayMP.basePanel:GetTall() )
			MenuWindowPanelNew.Paint = function( self, w, h ) 
				--draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) 
			end
			MenuWindowPanelNew:SetAlpha( 0 )
			
		
			local DScrollPanel = vgui.Create( "DScrollPanel", MenuWindowPanelNew )
			DScrollPanel:SetSize( MenuWindowPanelNew:GetWide(), MenuWindowPanelNew:GetTall() - 145 )
			DScrollPanel:SetPos( 0, 0)
	
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
		
			local oldPanel
			local aniAim
			
			for k, v in pairs(PlayMP.MenuWindows) do
				if v["UniqueName"] == panelName then
					local func = v["Func"]
					
					if oldPanel then
						aniAim = "UP"
					else
						aniAim = "DOWN"
					end

					PlayMP:DoAnimaOption( aniAim, PlayMP.sideMenuPanel:GetWide(), 56, 56, nil, true, PlayMP.MenuWindowPanel, MenuWindowPanelNew, PlayMP.basePanel, 0.4 )
					
					hook.Add( panelName, panelName, func )
					hook.Run( panelName, DScrollPanel )
					hook.Remove( panelName, panelName )
					
					--v.MenuFuncion:ColorTo(Color(255,150,100,255),0.1)
					
				else
					--v.MenuFuncion:ColorTo(Color(255,255,255,255),0.1)
				end
				if v["UniqueName"] == PlayMP.CurMenuPage then
					oldPanel = k
				end
			end
			
			PlayMP.CurMenuPage = panelName
			
			return MenuChan
			
		end