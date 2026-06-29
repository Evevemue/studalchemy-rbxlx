local SellServiceUtils = {}

function SellServiceUtils.hoverSell(sellFrame: TextLabel)
	sellFrame.Visible = true
end

function SellServiceUtils.hoverEndSell(sellFrame: TextLabel)
	sellFrame.Visible = false
end

return SellServiceUtils