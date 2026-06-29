local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local DataService = require(RS:WaitForChild("Packages"):WaitForChild("DataService")).server
local StringFormatter = require(RS:WaitForChild("Packages"):WaitForChild("StringFormatter"))

local HttpService = game:GetService("HttpService")

local Rarities = require(
	RS:WaitForChild("Shared")
		:WaitForChild("Modules")
		:WaitForChild("Rarities")
)

local studsModule = require(
	RS:WaitForChild("Shared")
		:WaitForChild("Modules")
		:WaitForChild("Studs")
)

local studRemote = RS:WaitForChild("Remotes"):WaitForChild("StudRemote")

local spawnZone = workspace:WaitForChild("SpawnZone")
local spawn1 = spawnZone:WaitForChild("1")
local spawn2 = spawnZone:WaitForChild("2")

local random = Random.new()

local SPAWN_INTERVAL = 0.3
local COLLECTION_DISTANCE = 8

local SpawnServiceServer = {}

local initialized = false
local activeStuds = {}
local activeSpawners = {}

local function countStuds(studs)
	local count = 0

	for _ in pairs(studs) do
		count += 1
	end

	return count
end

local function randomBetween(a, b)
	return random:NextNumber(
		math.min(a, b),
		math.max(a, b)
	)
end

local function getRandomStud()
	local totalWeight = 0

	for _, studData in pairs(studsModule) do
		if studData.Rarity == Rarities.Primary then
			totalWeight += studData.Production
		end
	end

	if totalWeight <= 0 then
		return nil
	end

	local roll = random:NextNumber(0, totalWeight)
	local currentWeight = 0

	for _, studData in pairs(studsModule) do
		if studData.Rarity == Rarities.Primary then
			currentWeight += studData.Production

			if roll <= currentWeight then
				return studData
			end
		end
	end

	return nil
end

local function getRandomPosition()
	return Vector3.new(
		randomBetween(spawn1.Position.X, spawn2.Position.X),
		((spawn1.Position.Y + spawn2.Position.Y) / 2) + 0.5,
		randomBetween(spawn1.Position.Z, spawn2.Position.Z)
	)
end

local function awardStud(player, studData)
	local studId = studData.Id or StringFormatter.toCamelCase(studData.Name)

	local newAmount = DataService:update(
		player,
		{ "inventory", studId },
		function(currentAmount)
			return (currentAmount or 0) + 1
		end
	)

	return true
end

local function spawnStudForPlayer(player)
	local playerStuds = activeStuds[player]

	if not playerStuds then
		return
	end
	
	local maxStuds = DataService:get(player, "maxStuds")
	
	if countStuds(playerStuds) >= maxStuds then
		return
	end

	local studData = getRandomStud()

	if not studData then
		return
	end

	local studId = HttpService:GenerateGUID(false)
	local position = getRandomPosition()

	local payload = {
		Id = studId,
		Name = studData.Name,
		Color = studData.Color,
		Position = position,
		Rarity = studData.Rarity,
		Value = studData.Value,
	}

	playerStuds[studId] = {
		Id = studId,
		Position = position,
		StudData = studData,
		Payload = payload,
	}

	studRemote:FireClient(player, "Spawn", payload)
end

local function rejectCollection(player, studId)
	studRemote:FireClient(player, "Reject", studId)
end

local function collectStud(player, studId)
	if type(studId) ~= "string" then
		return
	end

	local playerStuds = activeStuds[player]

	if not playerStuds then
		return
	end

	local studRecord = playerStuds[studId]

	if not studRecord then
		rejectCollection(player, studId)
		return
	end

	local character = player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if not rootPart or not humanoid or humanoid.Health <= 0 then
		rejectCollection(player, studId)
		return
	end

	local distance = (rootPart.Position - studRecord.Position).Magnitude

	if distance > COLLECTION_DISTANCE then
		rejectCollection(player, studId)
		return
	end

	local success, errorMessage = pcall(function()
		awardStud(player, studRecord.StudData)
	end)

	if not success then
		warn("Error while awarding stud:", errorMessage)
		rejectCollection(player, studId)
		return
	end

	playerStuds[studId] = nil

	studRemote:FireClient(player, "Remove", studId)
end

local function sendExistingStuds(player)
	local playerStuds = activeStuds[player]

	if not playerStuds then
		return
	end

	for _, studRecord in pairs(playerStuds) do
		studRemote:FireClient(player, "Spawn", studRecord.Payload)
	end
end

local function startSpawner(player)
	activeStuds[player] = activeStuds[player] or {}

	if activeSpawners[player] then
		sendExistingStuds(player)
		return
	end

	activeSpawners[player] = true

	sendExistingStuds(player)

	task.spawn(function()
		while activeSpawners[player] and player.Parent do
			spawnStudForPlayer(player)
			task.wait(SPAWN_INTERVAL)
		end
	end)
end

local function removePlayer(player)
	activeSpawners[player] = nil
	activeStuds[player] = nil
end

function SpawnServiceServer.init()
	if initialized then
		return
	end

	initialized = true

	studRemote.OnServerEvent:Connect(function(player, action, data)
		if action == "Ready" then
			startSpawner(player)
		elseif action == "Collect" then
			collectStud(player, data)
		end
	end)

	Players.PlayerRemoving:Connect(removePlayer)
end

return SpawnServiceServer