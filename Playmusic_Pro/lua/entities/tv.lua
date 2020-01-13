AddCSLuaFile()



ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "TV"
ENT.Author = "Minbird"
ENT.Category = "PlayMusic Pro"
ENT.Spawnable = true

local ENT = ENT
local self = ENT
--ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if ( CLIENT ) then
	ENT.Mat = nil
	ENT.Panel = nil
end

local overlap = false
function ENT:Initialize()

	if ( SERVER ) then
	
		if PlayMP.worldScrIsCreate == true then
			overlap = true
			self:Remove()
			PrintMessage( HUD_PRINTTALK, "이미 플레이어가 생성되어있습니다." )
			return
		end

		self:SetModel( "models/props_phx/rt_screen.mdl" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

		self:PhysicsInit( SOLID_VPHYSICS )
		
		self.Entity:SetUseType(SIMPLE_USE)

		self:Freeze()

	else

		-- Reset material and panel and load DHTML panel
		self.Entity:DrawShadow(false)
		self.Mat = nil
		self.PlayerHTML = nil
		self:OpenPage()

	end
	
	PlayMP.worldScrIsCreate = true

end

function ENT:Freeze()
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:EnableMotion( false ) end
end

-- Load the DHTML reference panel
function ENT:OpenPage()
	
	if ( self.Panel ) then

		self.Panel:Remove()
		self.Panel = nil

	end

	-- Create a web page panel and fill the entire screen
	self.Panel = vgui.Create( "DHTML" )
	self.Panel:SetSize( ScrW(), ScrH())

	-- Wiki page URL

	-- Load the wiki page
	--self.Panel:SetHTML("Press 'E' to enable\n활성화하려면 'E'를 누르십시오")
	self.Panel:OpenURL("https://minbird.github.io/html/app/player.html")

	-- Hide the panel
	self.Panel:SetAlpha( 0 )
	self.Panel:SetMouseInputEnabled( false )

	-- Disable HTML messages
	function self.Panel:ConsoleMessage( msg ) end
	
	PlayMP.WorldPlayerHTML = self.Panel
	
	PlayMP.ChangeStrOnWorldVideoViewer(PlayMP:Str( "PressEToEnable" ))

end

PlayMP.LoadWorldPlayer = ENT.OpenPage

function ENT:Draw()
	self:DrawModel()
	
		render.SuppressEngineLighting(true)
		if ( self.Mat ) then
			cam.Start3D2D(self:GetPos(), self:GetAngles(), 1)
				
				render.SetMaterial(self.Mat)
				render.DrawQuadEasy( Vector(6.2, 0, 19), Vector(-6.2,0,0), 56, 33.5, Color(255,255,255), 180)
			
			cam.End3D2D()
			
		elseif ( self.Panel and self.Panel:GetHTMLMaterial() ) then

			-- Get the html material
			local html_mat = self.Panel:GetHTMLMaterial()
			
			local scale_x, scale_y = ScrW()/2048, ScrH()/2048
			
			if ScrH() < 1080 then -- scale problem??
				scale_x, scale_y = ScrW()/2048, ScrH()/1024
			end

			local matdata =
			{
				["$basetexture"]=html_mat:GetName(),
				["$basetexturetransform"]="center 0 0 scale "..scale_x.." "..scale_y.." rotate 0 translate 0 0",
				["$model"]=1
			}

			-- Unique ID used for material name
			local uid = string.Replace( html_mat:GetName(), "__vgui_texture_", "" )

			-- Create the model material
			self.Mat = CreateMaterial( "WebMaterial_"..uid, "VertexLitGeneric", matdata )

		end

		render.SuppressEngineLighting(false)

		render.ModelMaterialOverride( nil )
	
		--[[if PlayMP.PlayerMode == nil then
			local ang = self:GetAngles()
			local pos = self:GetPos()
			cam.Start3D2D( Vector(pos.x + 6.2, pos.y, pos.z + 33.5), Angle(ang.p - 180, ang.y - 90, ang.r +270), 0.3)
				draw.SimpleText( "Press 'E' to enable", "DermaDefault", 0, 0, color_white, TEXT_ALIGN_CENTER )
			cam.End3D2D()
		end]]
	
end

function ENT:OnRemove()

	if overlap then overlap = false return end
	PlayMP.worldScrIsCreate = false
	PlayMP.PlayerMode = nil

		if SERVER then
			--PlayMP:ChangePlayerMode(nil,"nomal")
		end
		
		if CLIENT then
			--PlayMP:LoadPlayer()
			PlayMP:ChangePlayerMode( "nomal" )
			self.Panel:OpenURL("https://minbird.github.io/html/app/player.html")
			chat.AddText(PlayMP:Str( "RemovedWorldViewer" ))
		end
		
end


function ENT:Use( activator, caller, use_type, value )
	
	if SERVER then
		PlayMP:ChangePlayerMode(activator)
	end

	
end