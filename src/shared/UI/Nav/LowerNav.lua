local plr = game.Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")
local navFrame = plrGui:WaitForChild("NavGui"):WaitForChild("NavFrame")
local backpackBtn = navFrame:WaitForChild("BackpackBtn")

local AnimateButton = require(script.Parent.Parent:WaitForChild("Buttons"):WaitForChild("AnimateButton"))
local InventoryVisibility = require(script.Parent.Parent.Inventory:WaitForChild("InventoryVisibility"))

local LowerNav = {}

function LowerNav.init()
	for _, btn in pairs(navFrame:GetChildren()) do
		if not btn:IsA("ImageButton") then continue end
		AnimateButton.addAnimations(btn)
	end
end

backpackBtn.MouseButton1Click:Connect(function()
	InventoryVisibility.toggleVisibility()
end)

return LowerNav
