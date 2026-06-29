local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")

local AnimateButton = require(script.Parent.Parent:WaitForChild("Buttons"):WaitForChild("AnimateButton"))
local FrameAnimator = require(script.Parent.Parent:WaitForChild("Animations"):WaitForChild("FrameAnimator"))

local prompt = workspace:WaitForChild("Map"):WaitForChild("Lab"):WaitForChild("Lab"):WaitForChild("ProximityPart"):WaitForChild("ProximityPrompt")

local mergeFrame = plrGui:WaitForChild("MergeGui"):WaitForChild("MainFrame")
local closeBtn = mergeFrame:WaitForChild("UpperFrame"):WaitForChild("CloseFrame"):WaitForChild("CloseBtn")

local MergeVisibility = {}

local initialized = false

function MergeVisibility.open()
	FrameAnimator.open(mergeFrame)
end

function MergeVisibility.close()
	FrameAnimator.close(mergeFrame)
end

function MergeVisibility.toggleVisibility()
	FrameAnimator.toggle(mergeFrame)
end

function MergeVisibility.init()
	if initialized then return end
	initialized = true

	FrameAnimator.setup(mergeFrame)
	AnimateButton.addAnimations(closeBtn, closeBtn.Parent)

	prompt.Triggered:Connect(MergeVisibility.open)
	closeBtn.MouseButton1Click:Connect(MergeVisibility.close)
end

return MergeVisibility