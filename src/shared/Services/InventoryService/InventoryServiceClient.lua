local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local itemTemplate = RS:WaitForChild("Assets"):WaitForChild("ItemTemplate")

local DataService = require(RS:WaitForChild("Packages"):WaitForChild("DataService")).client

local studsModule = require(RS:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Studs"))

local InventoryServiceUtils = require(script.Parent:WaitForChild("InventoryServiceUtils"))

local InventoryServiceClient = {}

local initialized = false
local itemFrames = {}

local inventoryGui = player.PlayerGui:WaitForChild("Inventory")
local mainFrame = inventoryGui:WaitForChild("MainFrame")
local itemsContainer = mainFrame:WaitForChild("ItemsContainer")
local worthLabel = mainFrame:WaitForChild("LowerFrame"):WaitForChild("WorthFrame"):WaitForChild("WorthLabel")

local function updateItemFrame(itemFrame, itemData, amount)
	itemFrame.NameLabel.Text = itemData.Name .. " (x" .. tostring(amount) .. ")"
	itemFrame.NameLabel.TextColor3 = itemData.Color
	itemFrame.NameLabel.UIStroke.Color = itemData.Color
	itemFrame.RarityLabel.Text = tostring(itemData.Rarity)
	itemFrame.ValueFrame.WorthLabel.Text = tostring(itemData.Value)
	itemFrame.ViewportFrame.WorldModel.StudTemplate.Color = itemData.Color
end

local function createItemFrame(id, itemData, amount)
	local itemFrame = itemTemplate:Clone()

	itemFrame.Name = id
	itemFrame.Parent = itemsContainer
	itemFrame.Visible = true

	updateItemFrame(itemFrame, itemData, amount)

	itemFrame.MouseEnter:Connect(function()
		InventoryServiceUtils.hoverRarity(itemFrame.RarityLabel)
	end)

	itemFrame.MouseLeave:Connect(function()
		InventoryServiceUtils.hoverEndRarity(itemFrame.RarityLabel)
	end)

	itemFrames[id] = itemFrame
end

function InventoryServiceClient.CalculateWorth(inventory)
	local worth = 0

	for id, amount in pairs(inventory or {}) do
		local itemData = studsModule[id]

		if not itemData then
			continue
		end

		worth += itemData.Value * amount
	end

	return worth
end

function InventoryServiceClient.RefreshInventory(inventory)
	inventory = inventory or {}

	for id, amount in pairs(inventory) do
		local itemData = studsModule[id]

		if not itemData then
			warn("Unknown inventory item:", id)
			continue
		end

		local itemFrame = itemFrames[id]

		if itemFrame then
			updateItemFrame(itemFrame, itemData, amount)
		else
			createItemFrame(id, itemData, amount)
		end
	end

	for id, itemFrame in pairs(itemFrames) do
		if inventory[id] == nil or inventory[id] <= 0 then
			itemFrame:Destroy()
			itemFrames[id] = nil
		end
	end

	worthLabel.Text = tostring(InventoryServiceClient.CalculateWorth(inventory))
end

function InventoryServiceClient.init()
	if initialized then
		return
	end

	initialized = true

	InventoryServiceClient.RefreshInventory(DataService:get("inventory"))

	DataService:getChangedSignal("inventory"):Connect(function(newInventory)
		InventoryServiceClient.RefreshInventory(newInventory)
	end)
end

return InventoryServiceClient