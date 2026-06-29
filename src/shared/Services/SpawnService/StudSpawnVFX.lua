local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local StudSpawnVFX = {}

local levitationConnections = {}

function StudSpawnVFX.play(part)
	if not part then return end

	local originalSize = part.Size

	local tweenInfo = TweenInfo.new(
		0.25,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(part, tweenInfo, {
		Size = originalSize,
		Transparency = 0
	})

	tween:Play()

	task.defer(function()
		StudSpawnVFX.startLevitation(part)
	end)
end

function StudSpawnVFX.startLevitation(part)
	if not part or not part.Parent then return end

	if levitationConnections[part] then
		levitationConnections[part]:Disconnect()
	end

	local startPos = part.Position
	local speed = 2
	local height = 0.5

	local phaseOffset = math.random() * 1000

	levitationConnections[part] = RunService.Heartbeat:Connect(function()
		if not part or not part.Parent then
			if levitationConnections[part] then
				levitationConnections[part]:Disconnect()
				levitationConnections[part] = nil
			end
			return
		end

		local t = os.clock() + phaseOffset
		local offsetY = math.sin(t * speed) * height

		part.Position = Vector3.new(
			startPos.X,
			startPos.Y + offsetY,
			startPos.Z
		)
	end)
end

function StudSpawnVFX.stop(part)
	if levitationConnections[part] then
		levitationConnections[part]:Disconnect()
		levitationConnections[part] = nil
	end
end

return StudSpawnVFX