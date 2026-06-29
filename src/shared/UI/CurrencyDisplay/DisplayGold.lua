local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local DataService = require(RS:WaitForChild("Packages"):WaitForChild("DataService")).client

local plr = game.Players.LocalPlayer

local goldLabel = plr
	:WaitForChild("PlayerGui")
	:WaitForChild("CurrencyDisplay")
	:WaitForChild("MainFrame")
	:WaitForChild("GoldDisplay")
	:WaitForChild("GoldLabel")

local DisplayGold = {}

local currentGold = 0
local popTween
local returnTween

local goldScale = goldLabel:FindFirstChild("GoldScale")

if not goldScale then
	goldScale = Instance.new("UIScale")
	goldScale.Name = "GoldScale"
	goldScale.Scale = 1
	goldScale.Parent = goldLabel
end

local function playPop()
	if popTween then
		popTween:Cancel()
	end

	if returnTween then
		returnTween:Cancel()
	end

	goldScale.Scale = 1

	popTween = TweenService:Create(
		goldScale,
		TweenInfo.new(
			0.12,
			Enum.EasingStyle.Back,
			Enum.EasingDirection.Out
		),
		{
			Scale = 1.25
		}
	)

	returnTween = TweenService:Create(
		goldScale,
		TweenInfo.new(
			0.14,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),
		{
			Scale = 1
		}
	)

	popTween:Play()

	popTween.Completed:Once(function()
		returnTween:Play()
	end)
end

function DisplayGold.update(newGold)
	newGold = newGold or DataService:get("gold") or 0

	goldLabel.Text = tostring(newGold)

	if newGold > currentGold then
		playPop()
	end

	currentGold = newGold
end

function DisplayGold.init()
	currentGold = DataService:get("gold") or 0
	goldLabel.Text = tostring(currentGold)

	DataService:getChangedSignal("gold"):Connect(function(newGold)
		DisplayGold.update(newGold)
	end)
end

return DisplayGold