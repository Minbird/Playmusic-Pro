PlayMP.Setting = {}
PlayMP.Setting.DATA = {}
PlayMP.Setting.FILE_NAME = "PlayMusicPro3_Setting.txt"

if SERVER then
    PlayMP.Setting.FILE_NAME = "PlayMusicPro3_Setting_Server.txt"
end

-----------------------------------------------
-- read and write to your gmod data folder...--
-----------------------------------------------

local create_default_setting_file = function()

    --file.Write( PlayMP.Setting.FILE_NAME, util.TableToJSON(PlayMP.Setting.DATA.DEFAULT["DEFAULT"]) )
end

function PlayMP.Setting.road()

    if file.Find( PlayMP.Setting.FILE_NAME, "DATA" ) == nil then
		--create_default_setting_file()
        PlayMP.Logger.log( "New User! Creating setting file in data folder...", "INFO" )
    end

	local data = file.Read( PlayMP.Setting.FILE_NAME, "DATA" )
	local table = util.JSONToTable(data or "{}")

    PlayMP.Setting.DATA = table
end


function PlayMP.Setting.write()
    file.Write( PlayMP.Setting.FILE_NAME, util.TableToJSON(PlayMP.Setting.DATA) )
end





function PlayMP.Setting:toggle( key, value ) -- only for true/false value
    local curSet = PlayMP.Setting:get( key )
	if curSet then
		PlayMP.Setting:change( key, false )
	else
		PlayMP.Setting:change( key, true )
	end
    PlayMP.Setting.write()
end

function PlayMP.Setting:change( key, value ) -- change setting data, can insert any value
	PlayMP.Setting.DATA[key] = value
    PlayMP.Setting.write()
end

function PlayMP.Setting:get( key )
	local data = PlayMP.Setting.DATA[key]
    if data == nil or data == {} then
		return PlayMP.Setting:get_default(key)
	end
	return data
end

function PlayMP:GetSetting( str, getAll, returnOnlyData )
		
	if getAll then
		return PlayMP.Setting.DATA
	end

	return PlayMP.Setting:get( str )
	
end

function PlayMP:ChangeSetting( str, any )
	
	PlayMP.Setting:change( str, any )
	
end


function PlayMP:AddSetting( name, data )

	PlayMP.Setting.DATA[name] = data
	PlayMP.Setting.write()
	
end


function PlayMP:GetServerSettings()
	net.Start("PlayMP:GetServerSettings")
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

net.Receive( "PlayMP:GetServerSettings", function()
	
	local data = net.ReadTable()
	
	for k, v in pairs(data) do
		PlayMP:AddSetting( k, v )
	end

end)

PlayMP:GetServerSettings()







--------------------
-- Default Setting--
--------------------
PlayMP.Setting.DATA_DEFAULT = {}

function PlayMP.Setting.Set_Default( key, data )
    PlayMP.Setting.DATA_DEFAULT[key] = data
end

function PlayMP.Setting:get_default( key )
	if key == nil or key == "" then return {} end
	PlayMP:AddSetting( key, PlayMP.Setting.DATA_DEFAULT[key] ) -- 세팅이 누락되었기 때문에 설정을 오버라이드한다.
    return PlayMP.Setting.DATA_DEFAULT[key]
end

PlayMP.Setting.Set_Default( "SyncPlay_WCAH", true )
PlayMP.Setting.Set_Default( "No_Play_Always", false )
PlayMP.Setting.Set_Default( "Show_MediaPlayer", false )
PlayMP.Setting.Set_Default( "Show_InfPan_Always", false )
PlayMP.Setting.Set_Default( "No_Show_InfoPanel", true )
PlayMP.Setting.Set_Default( "Quick_Request", false )
PlayMP.Setting.Set_Default( "PlayX01", false )
PlayMP.Setting.Set_Default( "Use_Blur", true )
PlayMP.Setting.Set_Default( "Use_Animation", true )
PlayMP.Setting.Set_Default( "업뎃알림안함", false )
PlayMP.Setting.Set_Default( "FMem", false )
PlayMP.Setting.Set_Default( "SyncMediaAndPlayer", true )
PlayMP.Setting.Set_Default( "removeOldQueue", true )
PlayMP.Setting.Set_Default( "MainPlayerData",{
		X=10,
		Y=10,
		W=160,
		H=80
	}
)
PlayMP.Setting.Set_Default( "MainMenu_Alpha", 255 )
PlayMP.Setting.Set_Default( "시스템언어", "SystemLang" )
PlayMP.Setting.Set_Default( "mainMenuBind", 100 )
PlayMP.Setting.Set_Default( "PlayerType", 0 )
PlayMP.Setting.Set_Default( "PlayerEngine", 0 )
PlayMP.Setting.Set_Default( "DONOTshowInfoPanel", false )
PlayMP.Setting.Set_Default( "NoticeReadCount", 0 )
PlayMP.Setting.Set_Default( "RepeatQueue", false )
PlayMP.Setting.Set_Default( "메인메뉴의불투명도", 255 )
PlayMP.Setting.Set_Default( "NoUpdateNotice", false )
PlayMP.Setting.Set_Default( "VolConWhenPlyStVo", 0.30 )


-- init...
PlayMP.Setting.road()