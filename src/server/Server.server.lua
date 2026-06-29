local RS = game:GetService("ReplicatedStorage")

local DataService = require(RS:WaitForChild("Packages"):WaitForChild("DataService")).server

local services = script.Parent:WaitForChild("Services")
local SpawnServiceServer = require(services:WaitForChild("SpawnService"):WaitForChild("SpawnServiceServer"))
local SellServiceServer = require(services:WaitForChild("SellService"):WaitForChild("SellServiceServer"))
local MergeServiceServer = require(services:WaitForChild("MergeService"):WaitForChild("MergeServiceServer"))

DataService:init({
	template = {
		gold = 0,
		maxStuds = 10,
		inventory = {},
	}
})

SpawnServiceServer.init()
SellServiceServer.init()
MergeServiceServer.init()

