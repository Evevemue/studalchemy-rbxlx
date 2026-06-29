local RS = game:GetService("ReplicatedStorage")

local DataService = require(RS:WaitForChild("Packages"):WaitForChild("DataService")).client

local studsContainer = workspace:WaitForChild("StudsContainer")
local studsNumberLabel = workspace:WaitForChild("BillboardGuis"):WaitForChild("StudyardBillboardHolder"):WaitForChild("BillboardGui"):WaitForChild("MainFrame"):WaitForChild("StudsNumberLabel")

local StudsSpawnedDisplayService = {}

function StudsSpawnedDisplayService.updateDisplay()
	local spawnedAmount = #studsContainer:GetChildren()
	studsNumberLabel.Text = spawnedAmount.."/"..DataService:get("maxStuds").." studs spawned"
end

function StudsSpawnedDisplayService.init()
	StudsSpawnedDisplayService.updateDisplay()
	
	DataService:getChangedSignal("maxStuds"):Connect(function(newValue)
		print(newValue)
	end)
end

return StudsSpawnedDisplayService
