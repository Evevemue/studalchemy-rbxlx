local MergeServiceUtils = {}

function MergeServiceUtils.getAvailableAmount(currentInventory, currentlyUsed, id)
	return math.max((currentInventory[id] or 0) - (currentlyUsed[id] or 0), 0)
end

function MergeServiceUtils.getEmptyPlace(mergeInfo)
	if mergeInfo.first == nil then return "first" end
	if mergeInfo.second == nil then return "second" end

	return nil
end

function MergeServiceUtils.getMergeFrame(place: "first" | "second", mergeFirst, mergeSecond)
	return place == "first" and mergeFirst or mergeSecond
end

function MergeServiceUtils.addUsedItem(currentlyUsed, id)
	currentlyUsed[id] = (currentlyUsed[id] or 0) + 1
end

function MergeServiceUtils.removeUsedItem(currentlyUsed, id)
	local newAmount = (currentlyUsed[id] or 0) - 1

	if newAmount <= 0 then
		currentlyUsed[id] = nil
	else
		currentlyUsed[id] = newAmount
	end
end

function MergeServiceUtils.updateMergeFrame(itemData, frame)
	frame.NameLabel.Visible = true
	frame.RarityLabel.Visible = true
	frame.ViewportFrame.Visible = true

	frame.NameLabel.Text = itemData.Name
	frame.NameLabel.TextColor3 = itemData.Color
	frame.NameLabel.UIStroke.Color = itemData.Color
	frame.RarityLabel.Text = tostring(itemData.Rarity)
	frame.ViewportFrame.WorldModel.StudTemplate.Color = itemData.Color

	local valueFrame = frame:FindFirstChild("ValueFrame")
	local removeBtn = frame:FindFirstChild("RemoveMergeBtn")

	if valueFrame then
		valueFrame.Visible = true
		valueFrame.WorthLabel.Text = tostring(itemData.Value)
	end

	if removeBtn then removeBtn.Visible = true end
end

function MergeServiceUtils.clearMergeFrame(frame)
	frame.NameLabel.Visible = false
	frame.RarityLabel.Visible = false
	frame.ViewportFrame.Visible = false

	local valueFrame = frame:FindFirstChild("ValueFrame")
	local removeBtn = frame:FindFirstChild("RemoveMergeBtn")

	if valueFrame then valueFrame.Visible = false end
	if removeBtn then removeBtn.Visible = false end
end

function MergeServiceUtils.updateItemFrame(itemFrame, itemData, amount)
	itemFrame.Visible = amount > 0

	itemFrame.NameLabel.Text = itemData.Name .. " (x" .. tostring(amount) .. ")"
	itemFrame.NameLabel.TextColor3 = itemData.Color
	itemFrame.NameLabel.UIStroke.Color = itemData.Color
	itemFrame.RarityLabel.Text = tostring(itemData.Rarity)
	itemFrame.ValueFrame.WorthLabel.Text = tostring(itemData.Value)
	itemFrame.ViewportFrame.WorldModel.StudTemplate.Color = itemData.Color

	itemFrame.AddToMergeBtn.Active = amount > 0
	itemFrame.AddToMergeBtn.AutoButtonColor = amount > 0
end

return MergeServiceUtils