AddCSLuaFile()



ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Billboard"
ENT.Author = "Minbird"
ENT.Category = "PlayMusic Pro"
ENT.Information = "Video Viewer for Playmusic Pro!"
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

	self:SetModel( "models/props/cs_assault/billboard.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	if ( SERVER ) then
	
		if PlayMP.worldScrIsCreate == true then
			overlap = true
			self:Remove()
			PrintMessage( HUD_PRINTTALK, "이미 플레이어가 생성되어있습니다." )
			return
		end
		
		PlayMP.worldScrIsCreate = true

		self:PhysicsInit( SOLID_VPHYSICS )
		
		self.Entity:SetUseType(SIMPLE_USE)

		self:Freeze()

	else

		
		self.Entity:DrawShadow(false)
		self.Mat = nil
		self.PlayerHTML = nil
		self:OpenPage()

	end
	
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:Wake() end

end

function ENT:Freeze()
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:EnableMotion( false ) end
	local nowpos = self:GetPos()
	self:SetPos( Vector(nowpos.x, nowpos.y, nowpos.z+100),false )
end

-- Load the DHTML reference panel
function ENT:OpenPage()
	
	if ( self.Panel ) then

		self.Panel:Remove()
		self.Panel = nil

	end


	self.Panel = vgui.Create( "DHTML" )
	self.Panel:SetSize( ScrW(), ScrH())

	self.Panel:OpenURL("https://minbird.github.io/html/app/player.html")


	self.Panel:SetAlpha( 0 )
	self.Panel:SetMouseInputEnabled( false )

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
				render.DrawQuadEasy( Vector(1.0, 0, 0), Vector(-6.2,0,0), 221, 131, Color(255,255,255), 180)
			
			cam.End3D2D()
			
		elseif ( self.Panel and self.Panel:GetHTMLMaterial() ) then

			local html_mat = self.Panel:GetHTMLMaterial()
			local scrScaleH = 1024
			
			if ScrH() >= 1080 then -- fit to model scale based off the players scr resolution
				scrScaleH = 2048
			elseif ScrH() >= 1440 then
				scrScaleH = 1024
			end
			
			local scale_x, scale_y = ScrW()/2048, ScrH()/scrScaleH
			
			local matdata =
			{
				["$basetexture"]=html_mat:GetName(),
				["$basetexturetransform"]="center 0 0 scale " .. scale_x .. " " .. scale_y .. " rotate 0 translate 0 0",
				["$model"]=1
			}

			local uid = string.Replace( html_mat:GetName(), "__vgui_texture_", "" )
			
			self.Mat = CreateMaterial( "WebMaterial_"..uid, "VertexLitGeneric", matdata )

		end

		render.SuppressEngineLighting(false)

		render.ModelMaterialOverride( nil )
	
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

cleanup.Register("billboard_pm")
if ( CLIENT ) then
	language.Add("billboard_pm", "PlayMusic Pro Viewer")
end