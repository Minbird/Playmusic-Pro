
PlayMP.Client_History = {}
PlayMP.Client_History.MediaHistory = {}

local history_limit = 10

local d = file.Read( "PlayMusicPro_MyMediaHistory.txt", "DATA" )
if d != nil and d != "" then
	PlayMP.Client_History.MediaHistory = util.JSONToTable(d)
end

function PlayMP:AddMediaHistory( data ) -- 저장/불러오기 모듈화 시급~~~ 근데 귀찮아 나중에 할래

	for k, v in pairs(PlayMP.Client_History.MediaHistory) do
		if v.thumbnails == data.thumbnails then
			table.remove(PlayMP.Client_History.MediaHistory, k )
		end
	end
	
	local TimeString = os.date( "%H:%M:%S" , Timestamp )
	local DateString = os.date( "%m/%d/%y" , Timestamp )
	local Time = os.time()

	data.TimeString = TimeString
	data.DateString = DateString
	data.Time = Time
	
	PrintTable(data)

	if data != nil and istable(data) then
		table.insert(PlayMP.Client_History.MediaHistory, 1, data)
		if #PlayMP.Client_History.MediaHistory > history_limit then
			table.remove(PlayMP.Client_History.MediaHistory, history_limit+1 )
		end
	else
		error("Data must have table value, but that is nil or not table value.")
	end
	
	if file.Find( "PlayMusicPro_MyMediaHistory.txt", "DATA" ) == nil then
		file.Append("PlayMusicPro_MyMediaHistory.txt")
	end
	
	local data = util.TableToJSON(PlayMP.Client_History.MediaHistory)
	file.Write( "PlayMusicPro_MyMediaHistory.txt", data )

end

