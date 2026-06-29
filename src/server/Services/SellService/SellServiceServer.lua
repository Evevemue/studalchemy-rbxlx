local RS = game:GetService("ReplicatedStorage")
local sellRemote = RS:WaitForChild("Remotes"):WaitForChild("SellStud")
local sellAllRemote = RS:WaitForChild("Remotes"):WaitForChild("SellAllStuds")
local DataService = require(RS:WaitForChild("Packages"):WaitForChild("DataService")).server
local studsModule = require(RS:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Studs"))

local SellServiceServer = {}

local function trySellAll(player)
	local inventory = DataService:get(player, "inventory")
	if inventory == {} then return end
	
	local worth = 0
	
	for id, amount in pairs(inventory) do
		worth += studsModule[id].Value * amount
	end
	
	DataService:update(player, "gold", function(current)
		return current + worth
	end)
	DataService:update(player, { "inventory" }, function(inventory)
		return {}
	end)

	return true
end

local function trySell(player, id, amount)
	local inventory = DataService:get(player, "inventory")
	local itemData = studsModule[id]
	if not itemData then
		return false
	end
	
	if not inventory[id] or inventory[id] < amount then
		return false
	end
	
	local worth = itemData.Value * amount
	DataService:update(player, "gold", function(current)
		return current + worth
	end)
	DataService:update(player, { "inventory" }, function(inventory)
		local newInventory = table.clone(inventory)

		newInventory[id] -= 1
		if newInventory[id] <= 0 then
			newInventory[id] = nil
		end

		return newInventory
	end)
	
	return true
end

function SellServiceServer.init()
	sellRemote.OnServerInvoke = trySell
	sellAllRemote.OnServerInvoke = trySellAll
end

return SellServiceServer
