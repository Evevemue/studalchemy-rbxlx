local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Recipes = require(RS:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Recipes"))
local studsModule = require(RS:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Studs"))
local DataService = require(RS:WaitForChild("Packages"):WaitForChild("DataService")).client
local MergeServiceUtils = require(script.Parent:WaitForChild("MergeServiceUtils"))

local mergeRemote = RS:WaitForChild("Remotes"):WaitForChild("MergeStuds")
local itemTemplate = RS:WaitForChild("Assets"):WaitForChild("ItemForMergeTemplate")

local plr = Players.LocalPlayer
local mergeMainFrame = plr:WaitForChild("PlayerGui"):WaitForChild("MergeGui"):WaitForChild("MainFrame")
local itemsContainer = mergeMainFrame:WaitForChild("ItemsContainer")
local mergeFrame = mergeMainFrame:WaitForChild("MergeFrame")
local mergeFirst = mergeFrame:WaitForChild("MergeFirst")
local mergeSecond = mergeFrame:WaitForChild("MergeSecond")
local mergeProduct = mergeFrame:WaitForChild("MergeProduct")
local mergeBtn = mergeProduct:WaitForChild("MergeBtn")

local removeFirstBtn = mergeFirst:WaitForChild("RemoveMergeBtn")
local removeSecondBtn = mergeSecond:WaitForChild("RemoveMergeBtn")

local itemFrames = {}
local currentInventory = {}

local mergeInfo = {
	first = nil,
	second = nil,
}

local currentlyUsed = {}
local currentProduct = nil
local merging = false

local MergeServiceClient = {}

local function getAvailableAmount(id)
	return MergeServiceUtils.getAvailableAmount(currentInventory, currentlyUsed, id)
end

local function getMergeFrame(place)
	return MergeServiceUtils.getMergeFrame(place, mergeFirst, mergeSecond)
end

local function setMergeButtonEnabled(enabled)
	mergeBtn.Active = enabled
	mergeBtn.AutoButtonColor = enabled
end

local function refreshSingleItem(id)
	local itemFrame = itemFrames[id]
	local itemData = studsModule[id]

	if not itemFrame or not itemData then return end

	MergeServiceUtils.updateItemFrame(itemFrame, itemData, getAvailableAmount(id))
end

local function refreshMergeProduct()
	currentProduct = nil
	MergeServiceUtils.clearMergeFrame(mergeProduct)
	setMergeButtonEnabled(false)

	if not mergeInfo.first or not mergeInfo.second then return end

	local product = Recipes.Find(mergeInfo.first, mergeInfo.second)
	if not product then return end

	currentProduct = product
	MergeServiceUtils.updateMergeFrame(product, mergeProduct)
	setMergeButtonEnabled(not merging)
end

local function resetMerge()
	mergeInfo.first = nil
	mergeInfo.second = nil
	currentProduct = nil

	table.clear(currentlyUsed)

	MergeServiceUtils.clearMergeFrame(mergeFirst)
	MergeServiceUtils.clearMergeFrame(mergeSecond)
	MergeServiceUtils.clearMergeFrame(mergeProduct)

	setMergeButtonEnabled(false)
end

function MergeServiceClient.addToMerge(itemData, place: "first" | "second")
	local id = itemData.Id

	if mergeInfo[place] ~= nil then return end
	if getAvailableAmount(id) <= 0 then return end

	mergeInfo[place] = id

	MergeServiceUtils.addUsedItem(currentlyUsed, id)
	MergeServiceUtils.updateMergeFrame(itemData, getMergeFrame(place))

	refreshSingleItem(id)
	refreshMergeProduct()
end

function MergeServiceClient.removeFromMerge(place: "first" | "second")
	local id = mergeInfo[place]
	if not id then return end

	mergeInfo[place] = nil

	MergeServiceUtils.removeUsedItem(currentlyUsed, id)
	MergeServiceUtils.clearMergeFrame(getMergeFrame(place))

	refreshSingleItem(id)
	refreshMergeProduct()
end

function MergeServiceClient.tryAddToMerge(itemData)
	if getAvailableAmount(itemData.Id) <= 0 then return end

	local emptyPlace = MergeServiceUtils.getEmptyPlace(mergeInfo)

	if not emptyPlace then
		warn("Both merge slots are occupied")
		return
	end

	MergeServiceClient.addToMerge(itemData, emptyPlace)
end

function MergeServiceClient.merge()
	if merging then return end
	if not currentProduct then return end
	if not mergeInfo.first or not mergeInfo.second then return end

	local firstId = mergeInfo.first
	local secondId = mergeInfo.second

	merging = true
	setMergeButtonEnabled(false)

	local callSuccess, success, result, updatedInventory = pcall(function()
		return mergeRemote:InvokeServer(firstId, secondId)
	end)

	merging = false

	if not callSuccess then
		warn("Merge remote error:", success)
		refreshMergeProduct()
		return
	end

	if not success then
		warn("Merge failed:", result)

		if result == "NOT_ENOUGH_ITEMS" and updatedInventory then
			resetMerge()
			MergeServiceClient.RefreshInventory(updatedInventory)
		else
			refreshMergeProduct()
		end

		return
	end

	resetMerge()
	MergeServiceClient.RefreshInventory(updatedInventory or DataService:get("inventory"))

	print("Merged:", firstId, "+", secondId, "=", result)
end

local function createItemFrame(id, itemData, amount)
	local itemFrame = itemTemplate:Clone()
	local addToMergeBtn = itemFrame:WaitForChild("AddToMergeBtn")

	itemFrame.Name = id
	itemFrame.Parent = itemsContainer

	addToMergeBtn.MouseButton1Click:Connect(function()
		MergeServiceClient.tryAddToMerge(itemData)
	end)

	itemFrames[id] = itemFrame

	MergeServiceUtils.updateItemFrame(itemFrame, itemData, amount)
end

local function validateSelectedItems()
	for _, place in ipairs({ "first", "second" }) do
		local id = mergeInfo[place]

		if id and (currentlyUsed[id] or 0) > (currentInventory[id] or 0) then
			MergeServiceClient.removeFromMerge(place)
		end
	end
end

function MergeServiceClient.RefreshInventory(inventory)
	currentInventory = inventory or {}

	validateSelectedItems()

	for id, amount in pairs(currentInventory) do
		if amount <= 0 then continue end

		local itemData = studsModule[id]

		if not itemData then
			warn("Unknown inventory item:", id)
			continue
		end

		local availableAmount = getAvailableAmount(id)
		local itemFrame = itemFrames[id]

		if itemFrame then
			MergeServiceUtils.updateItemFrame(itemFrame, itemData, availableAmount)
		else
			createItemFrame(id, itemData, availableAmount)
		end
	end

	for id, itemFrame in pairs(itemFrames) do
		if currentInventory[id] == nil or currentInventory[id] <= 0 then
			itemFrame:Destroy()
			itemFrames[id] = nil
		end
	end
end

function MergeServiceClient.init()
	resetMerge()
	MergeServiceClient.RefreshInventory(DataService:get("inventory"))

	removeFirstBtn.MouseButton1Click:Connect(function()
		MergeServiceClient.removeFromMerge("first")
	end)

	removeSecondBtn.MouseButton1Click:Connect(function()
		MergeServiceClient.removeFromMerge("second")
	end)

	mergeBtn.MouseButton1Click:Connect(MergeServiceClient.merge)

	DataService:getChangedSignal("inventory"):Connect(function(newInventory)
		MergeServiceClient.RefreshInventory(newInventory)
	end)
end

return MergeServiceClient