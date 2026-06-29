local Players = game:GetService("Players")

local Stud = {}
Stud.__index = Stud

function Stud.new(instance, data, onCollectionRequested)
	local self = setmetatable({}, Stud)

	self.instance = instance
	self.data = data
	self.id = data.Id
	self.pendingCollection = false
	self.collected = false
	self.touchConnection = nil
	self.onCollectionRequested = onCollectionRequested
	
	local frame = self.instance.BillboardGui.MainFrame
	frame.StudName.Text = self.data.Name
	frame.StudName.TextColor3 = self.data.Color
	frame.StudRarity.Text = data.Rarity
	frame.StudValue.Text = self.data.Value.." Gold"
	
	return self
end

function Stud:init()
	if self.touchConnection then
		return
	end

	self.instance.CanTouch = true

	self.touchConnection = self.instance.Touched:Connect(function(hit)
		self:onTouched(hit)
	end)
end

function Stud:onTouched(hit)
	if self.pendingCollection or self.collected then
		return
	end

	local character = hit:FindFirstAncestorOfClass("Model")

	if character ~= Players.LocalPlayer.Character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoid or humanoid.Health <= 0 then
		return
	end

	self:requestCollection()
end

function Stud:requestCollection()
	if self.pendingCollection or self.collected then
		return
	end

	self.pendingCollection = true

	if self.instance then
		self.instance.CanTouch = false
	end

	if self.onCollectionRequested then
		local success, result = pcall(self.onCollectionRequested, self)

		if not success then
			self:rejectCollection()
		end
	end
end

function Stud:confirmCollection()
	if self.collected then
		return
	end

	self.pendingCollection = false
	self.collected = true

	self:destroy()
end

function Stud:rejectCollection()
	if self.collected then
		return
	end

	self.pendingCollection = false

	if self.instance and self.instance.Parent then
		self.instance.CanTouch = true
	end
end

function Stud:destroy()
	if self.touchConnection then
		self.touchConnection:Disconnect()
		self.touchConnection = nil
	end

	if self.instance then
		self.instance:Destroy()
		self.instance = nil
	end

	self.data = nil
	self.onCollectionRequested = nil
end

return Stud