local count
local countMax

PlayMP.voteCount = 0
PlayMP.voteCountMax = 0

PlayMP.voteActivated = false

net.Receive( "PlayMP:voteCountUpdate", function()
	count = net.ReadFloat()
	countMax = net.ReadFloat()
	
	PlayMP.voteCount = count
	PlayMP.voteCountMax = countMax
end)

net.Receive( "PlayMP:voteActivate", function()
	PlayMP.voteActivated = net.ReadBool()
end)