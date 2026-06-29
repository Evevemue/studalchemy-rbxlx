local InventoryServiceUtils = {}

function InventoryServiceUtils.hoverRarity(rarityLabel: TextLabel)
	rarityLabel.TextTransparency = 0
	rarityLabel.UIStroke.Transparency = 0
	rarityLabel.UIGradient.Transparency = NumberSequence.new(0)
	rarityLabel.ZIndex = 6
end

function InventoryServiceUtils.hoverEndRarity(rarityLabel: TextLabel)
	rarityLabel.TextTransparency = 0.5
	rarityLabel.UIStroke.Transparency = 0.5
	rarityLabel.UIGradient.Transparency = NumberSequence.new(0.5)
	rarityLabel.ZIndex = 4
end

return InventoryServiceUtils