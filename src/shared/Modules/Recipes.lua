local Studs = require(script.Parent:WaitForChild("Studs"))

local Recipes = {}

Recipes.Mixes = {
	["rubyStud+sapphireStud"] = Studs.violetStud,

	["rubyStud+goldenStud"] = Studs.orangeStud,

	["sapphireStud+goldenStud"] = Studs.greenStud,

	["rubyStud+crystalStud"] = Studs.pinkStud,

	["sapphireStud+obsidianStud"] = Studs.navyStud,

	["goldenStud+obsidianStud"] = Studs.brownStud,


	["violetStud+orangeStud"] = Studs.lavaliteStud,

	["greenStud+pinkStud"] = Studs.natureiteStud,

	["navyStud+brownStud"] = Studs.necriteStud,

	["lavaliteStud+crystalStud"] = Studs.clouditeStud,

	["natureiteStud+violetStud"] = Studs.elixiriteStud,

	["necriteStud+rubyStud"] = Studs.bloodstoneStud,


	["lavaliteStud+necriteStud"] = Studs.eyeOfChaosStud,

	["clouditeStud+natureiteStud"] = Studs.rainbowiteStud,

	["bloodstoneStud+elixiriteStud"] = Studs.arcanumStud,

	["eyeOfChaosStud+rainbowiteStud"] = Studs.stardustStud,


	["stardustStud+arcanumStud"] = Studs.nexiteStud,

	["nexiteStud+eyeOfChaosStud"] = Studs.voltaniumStud,

	["voltaniumStud+stardustStud"] = Studs.philosopherStud,
}

function Recipes.Find(item1, item2)
	local key1 = item1 .. "+" .. item2
	local key2 = item2 .. "+" .. item1

	return Recipes.Mixes[key1] or Recipes.Mixes[key2]
end

return Recipes