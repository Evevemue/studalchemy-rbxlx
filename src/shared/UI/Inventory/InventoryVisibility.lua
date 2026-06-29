local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")

local AnimateButton = require(script.Parent.Parent:WaitForChild("Buttons"):WaitForChild("AnimateButton"))
local FrameAnimator = require(script.Parent.Parent:WaitForChild("Animations"):WaitForChild("FrameAnimator"))

local inventoryFrame = plrGui:WaitForChild("Inventory"):WaitForChild("MainFrame")
local closeBtn = inventoryFrame:WaitForChild("UpperFrame"):WaitForChild("CloseFrame"):WaitForChild("CloseBtn")

local InventoryVisibility = {}

function InventoryVisibility.open()
	FrameAnimator.open(inventoryFrame)
end

function InventoryVisibility.close()
	FrameAnimator.close(inventoryFrame)
end

function InventoryVisibility.toggleVisibility()
	FrameAnimator.toggle(inventoryFrame)
end

function InventoryVisibility.init()
	FrameAnimator.setup(inventoryFrame)
	AnimateButton.addAnimations(closeBtn, closeBtn.Parent)

	closeBtn.MouseButton1Click:Connect(InventoryVisibility.close)
end

return InventoryVisibility