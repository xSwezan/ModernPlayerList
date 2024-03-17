local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fitumi = require(ReplicatedStorage.DevPackages.Fitumi)

local FakePlayersFolder = workspace:WaitForChild("FakePlayers")

local function NewPlayer(FakePlayerFolder: Folder)
	local FakePlayer = Fitumi.a.fake()
	FakePlayer.Name = FakePlayerFolder.Name
	FakePlayer.DisplayName = FakePlayerFolder.Name
	FakePlayer.UserId = math.random(100000000,1000000000)

	Fitumi.a.callTo(FakePlayer.FindFirstChild, FakePlayer, "leaderstats"):returns(FakePlayerFolder:WaitForChild("leaderstats"))

	return FakePlayer
end

return function(target)
	local FakePlayers = {}

	for _, FakePlayer in FakePlayersFolder:GetChildren() do
		table.insert(FakePlayers, NewPlayer(FakePlayer))
	end

	local App = require(script.Parent.App){
		FakePlayers = FakePlayers;
	}
	App.Parent = target

	return function()
		App:Destroy()
	end
end