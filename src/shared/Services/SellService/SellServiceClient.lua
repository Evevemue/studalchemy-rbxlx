local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local sellRemote = RS:WaitForChild("Remotes"):WaitForChild("SellStud")
local sellAllRemote = RS:WaitForChild("Remotes"):WaitForChild("SellAllStuds")

local itemSellTemplate = RS:WaitForChild("Assets"):WaitForChild("ItemSellTemplate")

local DataService = require(RS:WaitForChild("Packages"):WaitForChild("DataService")).client

local studsModule = require(RS:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Studs"))

local SellServiceUtils = require(script.Parent:WaitForChild("SellServiceUtils"))

local SellServiceClient = {}

local itemFrames = {}

local sellGui = player.PlayerGui:WaitForChild("SellGui")
local mainFrame = sellGui:WaitForChild("MainFrame")
local itemsContainer = mainFrame:WaitForChild("ItemsContainer")
local worthLabel = mainFrame:WaitForChild("LowerFrame"):WaitForChild("WorthFrame"):WaitForChild("WorthLabel")
local sellAllbtn = mainFrame:WaitForChild("LowerFrame"):WaitForChild("SellAllFrame"):WaitForChild("SellAllBtn")

local function trySellAll()
	sellAllRemote:InvokeServer()
end

local function trySell(itemFrame, id, amount)
	sellRemote:InvokeServer(id, 1)
end

local function updateItemFrame(itemFrame, itemData, amount)
	itemFrame.NameLabel.Text = itemData.Name .. " (x" .. tostring(amount) .. ")"
	itemFrame.NameLabel.TextColor3 = itemData.Color
	itemFrame.NameLabel.UIStroke.Color = itemData.Color
	itemFrame.RarityLabel.Text = tostring(itemData.Rarity)
	itemFrame.ValueFrame.WorthLabel.Text = tostring(itemData.Value)
	itemFrame.ViewportFrame.WorldModel.StudTemplate.Color = itemData.Color
end

local function createItemFrame(id, itemData, amount)
	local itemFrame = itemSellTemplate:Clone()
	local sellFrame = itemFrame.SellFrame

	itemFrame.Name = id
	itemFrame.Parent = itemsContainer
	itemFrame.Visible = true
	sellFrame.Visible = false
	sellFrame.SellLabel.Text = "+"..tostring(itemData.Value * amount).." Gold"

	updateItemFrame(itemFrame, itemData, amount)

	itemFrame.MouseEnter:Connect(function()
		SellServiceUtils.hoverSell(sellFrame)
	end)

	itemFrame.MouseLeave:Connect(function()
		SellServiceUtils.hoverEndSell(sellFrame)
	end)
	
	itemFrame.SellFrame.SellBtn.MouseButton1Click:Connect(function()
		trySell(itemFrame, id, amount)
	end)

	itemFrames[id] = itemFrame
end

function SellServiceClient.CalculateWorth(inventory)
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

function SellServiceClient.RefreshInventory(inventory)
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

	worthLabel.Text = tostring(SellServiceClient.CalculateWorth(inventory))
end

function SellServiceClient.init()
	SellServiceClient.RefreshInventory(DataService:get("inventory"))
	
	sellAllbtn.MouseButton1Click:Connect(function()
		trySellAll()
	end)

	DataService:getChangedSignal("inventory"):Connect(function(newInventory)
		SellServiceClient.RefreshInventory(newInventory)
	end)
end

return SellServiceClient