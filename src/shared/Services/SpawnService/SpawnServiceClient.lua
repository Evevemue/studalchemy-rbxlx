local RS = game:GetService("ReplicatedStorage")

local Stud = require(RS:WaitForChild("Shared"):WaitForChild("Classes"):WaitForChild("Stud"))

local StudSpawnVFX = require(script.Parent:WaitForChild("StudSpawnVFX"))
local StudCollectVFX = require(script.Parent:WaitForChild("StudCollectVFX"))
local StudsSpawnedDisplayService = require(script.Parent.Parent:WaitForChild("StudsSpawnedDisplayService"))

local studRemote = RS:WaitForChild("Remotes"):WaitForChild("StudRemote")
local studTemplate = RS:WaitForChild("Assets"):WaitForChild("StudTemplate")

local studsContainer = workspace:WaitForChild("StudsContainer")

local SpawnServiceClient = {}

local initialized = false
local activeStuds = {}

local function requestCollection(studObject)
	studRemote:FireServer("Collect", studObject.id)
end

local function spawnStud(data)
	if type(data) ~= "table" then
		return
	end

	if type(data.Id) ~= "string" then
		return
	end

	if activeStuds[data.Id] then
		return
	end

	local instance = studTemplate:Clone()

	instance.Name = data.Name
	instance.Color = data.Color
	instance.Position = data.Position
	instance.Anchored = true
	instance.CanCollide = false
	instance.CanTouch = true
	instance:SetAttribute("studId", data.Id)
	instance.Parent = studsContainer

	local studObject = Stud.new(
		instance,
		data,
		requestCollection
	)

	activeStuds[data.Id] = studObject
	
	StudsSpawnedDisplayService.updateDisplay()
	studObject:init()
	StudSpawnVFX.play(instance)
end

local function removeStud(studId)
	local studObject = activeStuds[studId]

	if not studObject then
		return
	end

	activeStuds[studId] = nil
	StudsSpawnedDisplayService.updateDisplay()

	local instance = studObject.instance

	if instance then
		StudSpawnVFX.stop(instance)
	end

	StudCollectVFX.play(instance, function()
		studObject:confirmCollection()
	end)
end

local function rejectCollection(studId)
	local studObject = activeStuds[studId]

	if not studObject then
		return
	end

	studObject:rejectCollection()
end

function SpawnServiceClient.init()
	if initialized then
		return
	end

	initialized = true

	studRemote.OnClientEvent:Connect(function(action, data)
		if action == "Spawn" then
			spawnStud(data)
		elseif action == "Remove" then
			removeStud(data)
		elseif action == "Reject" then
			rejectCollection(data)
		end
	end)

	studRemote:FireServer("Ready")
end

return SpawnServiceClient