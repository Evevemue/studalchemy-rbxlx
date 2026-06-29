local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Recipes = require(RS:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Recipes"))
local Studs = require(RS:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Studs"))
local DataService = require(RS:WaitForChild("Packages"):WaitForChild("DataService")).server

local mergeRemote = RS:WaitForChild("Remotes"):WaitForChild("MergeStuds")

local MergeServiceServer = {}

local mergingPlayers = {}
local lastMergeTimes = {}

local MERGE_COOLDOWN = 0.15

local function isValidItemId(id)
	if type(id) ~= "string" then return false end
	if #id > 50 then return false end
	if not Studs[id] then return false end

	return true
end

local function hasRequiredItems(inventory, firstId, secondId)
	if firstId == secondId then return (inventory[firstId] or 0) >= 2 end

	return (inventory[firstId] or 0) >= 1 and (inventory[secondId] or 0) >= 1
end

local function removeItem(inventory, id)
	local newAmount = (inventory[id] or 0) - 1

	if newAmount <= 0 then
		inventory[id] = nil
	else
		inventory[id] = newAmount
	end
end

local function mergeStuds(player, firstId, secondId)
	if mergingPlayers[player] then return false, "BUSY" end
	if not isValidItemId(firstId) or not isValidItemId(secondId) then return false, "INVALID_ITEMS" end

	local product = Recipes.Find(firstId, secondId)
	if not product then return false, "INVALID_RECIPE" end
	if not product.Id or Studs[product.Id] ~= product then return false, "INVALID_PRODUCT" end

	local currentTime = os.clock()
	local lastMergeTime = lastMergeTimes[player] or 0

	if currentTime - lastMergeTime < MERGE_COOLDOWN then return false, "TOO_FAST" end

	lastMergeTimes[player] = currentTime
	mergingPlayers[player] = true

	local mergeSuccessful = false
	local updatedInventory = nil

	local updateSuccess, updateError = pcall(function()
		DataService:update(player, { "inventory" }, function(inventory)
			inventory = inventory or {}

			if not hasRequiredItems(inventory, firstId, secondId) then
				updatedInventory = table.clone(inventory)
				return table.clone(inventory)
			end

			local newInventory = table.clone(inventory)

			removeItem(newInventory, firstId)
			removeItem(newInventory, secondId)

			newInventory[product.Id] = (newInventory[product.Id] or 0) + 1

			mergeSuccessful = true
			updatedInventory = newInventory

			return newInventory
		end)
	end)

	mergingPlayers[player] = nil

	if not updateSuccess then
		warn("Merge error for", player.Name, updateError)
		return false, "SERVER_ERROR"
	end

	if not mergeSuccessful then return false, "NOT_ENOUGH_ITEMS", updatedInventory end

	return true, product.Id, updatedInventory
end

function MergeServiceServer.init()
	mergeRemote.OnServerInvoke = mergeStuds

	Players.PlayerRemoving:Connect(function(player)
		mergingPlayers[player] = nil
		lastMergeTimes[player] = nil
	end)
end

return MergeServiceServer