local UI = {}

function UI.init()
	for _, module in script:GetDescendants() do
		if module:IsA("ModuleScript") then
			local mod = require(module)

			if type(mod.init) == "function" then
				mod.init()
			end
		end
	end
end

return UI