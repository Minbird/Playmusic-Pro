PlayMP.User = {}
PlayMP.LocalPlayerData = {}

PlayMP.User.Get_my_data = function()

    net.Start("PlayMP:GetUserInfoBySID")
    net.SendToServer()

    net.Receive( "PlayMP:GetUserInfoBySID", function( len, ply )
        PlayMP.LocalPlayerData = net.ReadTable()
    end)

end