local RS = game:GetService("ReplicatedStorage")

local services = RS:WaitForChild("Shared"):WaitForChild("Services")

local DataService = require(RS:WaitForChild("Packages"):WaitForChild("DataService")).client
local SpawnServiceClient = require(services:WaitForChild("SpawnService"):WaitForChild("SpawnServiceClient"))
local InventoryServiceClient = require(services:WaitForChild("InventoryService"):WaitForChild("InventoryServiceClient"))
local SellServiceClient = require(services:WaitForChild("SellService"):WaitForChild("SellServiceClient"))
local SellZoneServiceClient = require(services:WaitForChild("SellZoneServiceClient"))
local StudsSpawnedDisplayService = require(services:WaitForChild("StudsSpawnedDisplayService"))
local MergeServiceClient = require(services:WaitForChild("MergeService"):WaitForChild("MergeServiceClient"))
local UI = require(RS:WaitForChild("UI"))

DataService:init()
SpawnServiceClient.init()
StudsSpawnedDisplayService.init()
InventoryServiceClient.init()
SellServiceClient.init()
SellZoneServiceClient.init()
MergeServiceClient.init()
UI.init()