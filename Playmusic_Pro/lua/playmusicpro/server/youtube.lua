PlayMP.Youtube = {}

function PlayMP.Youtube.request_to_ytdl( id )
    http.Fetch( "https://minbird.kr/utils/ytdl?v=" .. uri, function() end, function( message ) PlayMP:WriteLog( message ) end )
end

function PlayMP.Youtube.get_video_info( id )
    http.Fetch( PlayMP.urls.api .. "?part=snippet,contentDetails&id=" .. id .. "&key=" .. PlayMP.API_KEY, function(data,code,headers)

        local strJson = data
		local json = util.JSONToTable(strJson)
        local video = {}

        if json["items"][1] == nil then
			return
		end

        if json.error then
			local message = json["error"]["message"]
			if json["error"]["code"] == "403" then
				message = "Request refused by Google server. Please try again later."
			end
            print(message)
			return
		end


        local contentDetails = json["items"][1]["contentDetails"]
		local strVideoDuration = contentDetails["duration"]
        local snippet = json["items"][1]["snippet"]

        video.titleText = snippet["title"]
		video.ChannelTitle = snippet["channelTitle"]
		video.IsliveBroadcast = snippet["liveBroadcastContent"]

        if video.titleText == nil or video.titleText == "" then 
            return
        end
        if video.ChannelTitle == nil or video.ChannelTitle == "" then
            return
        end
        if video.IsliveBroadcast == "live" then
            return
        end

        return video
        

    end)
end



local conv_time = function()

    local video = {}
    
    video.Sec = string.match(strVideoDuration, "M([^<]+)S")
    if video.Sec == nil then
        video.Sec = string.match(strVideoDuration, "H([^<]+)S")
        if video.Sec == nil then
            video.Sec = string.match(strVideoDuration, "PT([^<]+)S")
            if video.Sec == nil then
                video.Sec = 0
            end
        end
    end
    
    video.Min = string.match(strVideoDuration, "H([^<]+)M")
    if video.Min == nil then
        video.Min = string.match(strVideoDuration, "PT([^<]+)M")
        if video.Min == nil then
            video.Min = 0
        end
    end
        
    video.Hour = string.match(strVideoDuration, "PT([^<]+)H")
    if video.Hour == nil then
        video.Hour = 0
    end

    video.VideoLength = video.Sec + video.Min * 60 + video.Hour * 3600 + 1

    return video.VideoLength

end