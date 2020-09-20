

PlayMP.MinPerForSkip = GetConVar( "playmp_MinPerForSkip" ):GetFloat() 
local voteCount = 0
PlayMP.voteCount = 0
local votedPlayer = {}

local test_vote = 1
local dotest = false

util.AddNetworkString("PlayMP:voteCountUpdate")

function PlayMP:clearVoteCount()
	voteCount = 0
	PlayMP.voteCount = 0
	net.Start("PlayMP:voteCountUpdate")
		net.WriteFloat( 0 )
		net.WriteFloat( math.max(math.Round(PlayMP.MinPerForSkip/100 * (#player.GetHumans())), 1) )
	net.Broadcast()
	table.remove(votedPlayer)
end

util.AddNetworkString("PlayMP:voteActivate")

function PlayMP:voteActivate(bo)
	net.Start("PlayMP:voteActivate")
		net.WriteBool(bo)
	net.Broadcast()
end

local function endVote()
	PlayMP.MinPerForSkip = GetConVar( "playmp_MinPerForSkip" ):GetFloat() 
	PlayMP:clearVoteCount()
	
	if PlayMP:GetSetting( "RemoveOldMedia", false, true ) or tobool(PlayMP.CurrentQueueInfo[PlayMP.CurPlayNum].removeOldMedia) then
		PlayMP:RemoveQueue( PlayMP.CurPlayNum )
	else
		PlayMP:EndMusic()
	end
	
	PlayMP:voteActivate(PlayMP:GetSetting( "UseSkipToVote", false, true ))
end

function PlayMP:updateVoteCount( num, ply )

	PlayMP.MinPerForSkip = GetConVar( "playmp_MinPerForSkip" ):GetFloat() 
	voteCount = voteCount + 1
	PlayMP.voteCount = voteCount
	
	if ply != nil then
		PlayMP:NoticeForPlayer( "Someone_want_skip_music", "gray", "notice", nil, {ply:Nick(), voteCount, math.max(math.Round(PlayMP.MinPerForSkip/100 * (#player.GetHumans())),1)} )
	end
	
	net.Start("PlayMP:voteCountUpdate")
		net.WriteFloat( voteCount )
		net.WriteFloat( math.max(math.Round(PlayMP.MinPerForSkip/100 * (#player.GetHumans())), 1) )
	net.Broadcast()
	
	if voteCount >= math.max(math.Round(PlayMP.MinPerForSkip/100 * (#player.GetHumans())), 1) then
		endVote()
	end
	
end

function PlayMP:RecieveVoteRequest( ply )

	PlayMP:voteActivate(PlayMP:GetSetting( "UseSkipToVote", false, true ))
	
	if dotest then
		print(ply:SteamID() .. " 인원:" .. math.max(math.Round(PlayMP.MinPerForSkip/100 * (#player.GetHumans()))) .. " 비율:" .. PlayMP.MinPerForSkip/100 .. " 인원:" .. #player.GetHumans())
	end

	local plydata = PlayMP:GetUserInfoBySID(ply:SteamID())[1]
	for k, v in pairs(votedPlayer) do

		if v == ply:SteamID() then
			if ply:IsAdmin() == true or plydata.power == true then
				endVote()
			end

			return
		end
	end
	
	table.insert(votedPlayer, ply:SteamID())
	
	--if ply:IsAdmin() == true or plydata.power == true then

	--else
		if not PlayMP.isPlaying then
			PlayMP:NoticeForPlayer( "cant_vote_when_notplaying", "red", "warning", ply )
			return
		end
		PlayMP:updateVoteCount( voteCount + 1, ply ) 
	--end
end