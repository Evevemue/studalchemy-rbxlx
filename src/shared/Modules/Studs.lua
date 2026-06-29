local Rarities = require(script.Parent:WaitForChild("Rarities"))

local Studs = {

	-- BASIC (8)

	rubyStud = {
		Name = "Ruby Stud",
		Rarity = Rarities.Primary,
		Color = Color3.fromRGB(235, 16, 16),
		Value = 1,
		Production = 5,
	},

	sapphireStud = {
		Name = "Sapphire Stud",
		Rarity = Rarities.Primary,
		Color = Color3.fromRGB(0, 90, 255),
		Value = 1,
		Production = 5,
	},

	goldenStud = {
		Name = "Golden Stud",
		Rarity = Rarities.Primary,
		Color = Color3.fromRGB(255, 220, 0),
		Value = 1,
		Production = 5,
	},

	crystalStud = {
		Name = "Crystal Stud",
		Rarity = Rarities.Primary,
		Color = Color3.fromRGB(240, 240, 255),
		Value = 2,
		Production = 3,
	},

	emeraldStud = {
		Name = "Emerald Stud",
		Rarity = Rarities.Primary,
		Color = Color3.fromRGB(0, 200, 80),
		Value = 2,
		Production = 3,
	},

	obsidianStud = {
		Name = "Obsidian Stud",
		Rarity = Rarities.Primary,
		Color = Color3.fromRGB(59, 59, 59),
		Value = 3,
		Production = 2,
	},

	amberStud = {
		Name = "Amber Stud",
		Rarity = Rarities.Primary,
		Color = Color3.fromRGB(255, 150, 0),
		Value = 3,
		Production = 2,
	},

	amethystStud = {
		Name = "Amethyst Stud",
		Rarity = Rarities.Primary,
		Color = Color3.fromRGB(150, 0, 255),
		Value = 3,
		Production = 1,
	},


	-- COMBINED (6)

	violetStud = {
		Name = "Violet Stud",
		Rarity = Rarities.Basic,
		Color = Color3.fromRGB(180, 0, 255),
		Value = 9,
	},

	orangeStud = {
		Name = "Orange Stud",
		Rarity = Rarities.Basic,
		Color = Color3.fromRGB(255, 120, 0),
		Value = 9,
	},

	greenStud = {
		Name = "Green Stud",
		Rarity = Rarities.Basic,
		Color = Color3.fromRGB(0, 255, 100),
		Value = 9,
	},

	pinkStud = {
		Name = "Pink Stud",
		Rarity = Rarities.Basic,
		Color = Color3.fromRGB(255, 120, 200),
		Value = 16,
	},

	navyStud = {
		Name = "Navy Stud",
		Rarity = Rarities.Basic,
		Color = Color3.fromRGB(0, 0, 120),
		Value = 25,
	},

	brownStud = {
		Name = "Brown Stud",
		Rarity = Rarities.Basic,
		Color = Color3.fromRGB(120, 70, 30),
		Value = 16,
	},


	-- MAGIC (6)

	lavaliteStud = {
		Name = "Lavalite Stud",
		Rarity = Rarities.Advanced,
		Color = Color3.fromRGB(255, 60, 0),
		Value = 100,
	},

	natureiteStud = {
		Name = "Natureite Stud",
		Rarity = Rarities.Advanced,
		Color = Color3.fromRGB(50, 255, 50),
		Value = 120,
	},

	necriteStud = {
		Name = "Necrite Stud",
		Rarity = Rarities.Advanced,
		Color = Color3.fromRGB(60, 0, 80),
		Value = 150,
	},

	clouditeStud = {
		Name = "Cloudite Stud",
		Rarity = Rarities.Advanced,
		Color = Color3.fromRGB(220, 240, 255),
		Value = 180,
	},

	elixiriteStud = {
		Name = "Elixirite Stud",
		Rarity = Rarities.Advanced,
		Color = Color3.fromRGB(0, 255, 255),
		Value = 200,
	},

	bloodstoneStud = {
		Name = "Bloodstone Stud",
		Rarity = Rarities.Advanced,
		Color = Color3.fromRGB(120, 0, 0),
		Value = 250,
	},


	-- LEGENDARY (4)

	eyeOfChaosStud = {
		Name = "Eye of Chaos Stud",
		Rarity = Rarities.Mythic,
		Color = Color3.fromRGB(255, 0, 255),
		Value = 800,
	},

	rainbowiteStud = {
		Name = "Rainbowite Stud",
		Rarity = Rarities.Mythic,
		Color = Color3.fromRGB(255, 255, 255),
		Value = 1000,
	},

	arcanumStud = {
		Name = "Arcanum Stud",
		Rarity = Rarities.Mythic,
		Color = Color3.fromRGB(180, 0, 255),
		Value = 1500,
	},

	stardustStud = {
		Name = "Stardust Stud",
		Rarity = Rarities.Mythic,
		Color = Color3.fromRGB(255, 255, 180),
		Value = 3000,
	},


	-- ENDGAME (3)

	nexiteStud = {
		Name = "Nexite Stud",
		Rarity = Rarities.Legendary,
		Color = Color3.fromRGB(255, 255, 255),
		Value = 10000,
	},

	voltaniumStud = {
		Name = "Voltanium Stud",
		Rarity = Rarities.Legendary,
		Color = Color3.fromRGB(0, 220, 255),
		Value = 25000,
	},

	philosopherStud = {
		Name = "Philosopher's Stud",
		Rarity = Rarities.Legendary,
		Color = Color3.fromRGB(255, 215, 0),
		Value = 100000,
	},
}

for id, studData in pairs(Studs) do
	studData.Id = id
end

return Studs