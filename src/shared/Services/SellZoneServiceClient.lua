local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local FrameAnimator = require(RS:WaitForChild("UI"):WaitForChild("Animations"):WaitForChild("FrameAnimator"))

local sellZone = workspace:WaitForChild("Map"):WaitForChild("SellZone"):WaitForChild("SellZonePart")

local sellGui = player:WaitForChild("PlayerGui"):WaitForChild("SellGui")
local mainFrame = sellGui:WaitForChild("MainFrame")

local SellZoneServiceClient = {}

local insideZone = false
local elapsed = 0

local CHECK_INTERVAL = 0.1

local function isInsideZone(position)
	local localPosition = sellZone.CFrame:PointToObjectSpace(position)
	local halfSize = sellZone.Size / 2

	return math.abs(localPosition.X) <= halfSize.X
		and math.abs(localPosition.Y) <= halfSize.Y
		and math.abs(localPosition.Z) <= halfSize.Z
end

local function updateZone()
	local character = player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")

	if not rootPart then
		if insideZone then
			insideZone = false
			FrameAnimator.close(mainFrame)
		end

		return
	end

	local isInside = isInsideZone(rootPart.Position)

	if isInside == insideZone then
		return
	end

	insideZone = isInside

	if insideZone then
		FrameAnimator.open(mainFrame)
	else
		FrameAnimator.close(mainFrame)
	end
end

function SellZoneServiceClient.init()
	FrameAnimator.setup(mainFrame)

	RunService.Heartbeat:Connect(function(deltaTime)
		elapsed += deltaTime

		if elapsed < CHECK_INTERVAL then
			return
		end

		elapsed = 0
		updateZone()
	end)
end

return SellZoneServiceClient