local RS = game:GetService("ReplicatedStorage")

local Rarities = require(RS:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Rarities"))
local studsModule = require(RS:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Studs"))

local SpawnServiceUtils = {}

function SpawnServiceUtils.getRandomStud()
	local totalWeight = 0

	for _, stud in pairs(studsModule) do
		if stud.Rarity == Rarities.Primary then
			totalWeight += stud.Production
		end
	end

	local roll = math.random() * totalWeight
	local current = 0

	for _, stud in pairs(studsModule) do
		if stud.Rarity == Rarities.Primary then
			current += stud.Production

			if roll <= current then
				return stud
			end
		end
	end
end

return SpawnServiceUtils