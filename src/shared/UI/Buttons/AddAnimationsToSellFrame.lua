local plr = game.Players.LocalPlayer
local sellFrame = plr:WaitForChild("PlayerGui"):WaitForChild("SellGui"):WaitForChild("MainFrame")

local AnimateButton = require(script.Parent.AnimateButton)

local AddAnimationsToSellFrame = {}

function AddAnimationsToSellFrame.init()
	AnimateButton.addAnimations(sellFrame.LowerFrame.SellAllFrame.SellAllBtn, sellFrame.LowerFrame.SellAllFrame)
end

return AddAnimationsToSellFrame
