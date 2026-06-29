local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

local assets = RS:WaitForChild("Assets")

local vfxTemplate = assets
	:WaitForChild("VFX")
	:WaitForChild("StudCollectVFX")

local collectSoundTemplate = assets
	:WaitForChild("Sounds")
	:WaitForChild("StudCollect")

local StudCollectVFX = {}

local random = Random.new()

local DOWN_DURATION = 0.35
local UP_DURATION = 0.55
local DOWN_DISTANCE = 1
local UP_DISTANCE = 18
local ROTATIONS = 4

local function playSound()
	local sound = collectSoundTemplate:Clone()

	sound.PlaybackSpeed = random:NextNumber(0.95, 1.05)
	sound.Parent = SoundService
	sound:Play()

	Debris:AddItem(sound, 3)
end

local function createInstantVFX(cframe, color)
	local vfxPart = vfxTemplate:Clone()

	vfxPart.CFrame = cframe
	vfxPart.Anchored = true
	vfxPart.CanCollide = false
	vfxPart.CanTouch = false
	vfxPart.CanQuery = false
	vfxPart.Transparency = 1
	vfxPart.Parent = workspace

	for _, object in vfxPart:GetDescendants() do
		if object:IsA("ParticleEmitter") then
			object.Color = ColorSequence.new(color)
			object.Enabled = false

			local emitCount = object:GetAttribute("EmitCount") or 20
			object:Emit(emitCount)
		end
	end

	Debris:AddItem(vfxPart, 3)
end

local function createSmokeTrail(part, color)
	local templateAttachment = vfxTemplate:FindFirstChildOfClass("Attachment")

	if not templateAttachment then
		return nil, nil
	end

	local smokeTemplate = templateAttachment:FindFirstChild("SmokeTrail")

	if not smokeTemplate or not smokeTemplate:IsA("ParticleEmitter") then
		return nil, nil
	end

	local attachment = Instance.new("Attachment")
	attachment.Name = "CollectSmokeAttachment"
	attachment.Parent = part

	local smoke = smokeTemplate:Clone()

	smoke.Color = ColorSequence.new(color)
	smoke.Enabled = true
	smoke.Parent = attachment

	return attachment, smoke
end

function StudCollectVFX.play(part, onCompleted)
	if not part or not part.Parent then
		if onCompleted then
			onCompleted()
		end

		return
	end

	createInstantVFX(part.CFrame, part.Color)
	playSound()

	part.Anchored = true
	part.CanTouch = false
	part.CanCollide = false

	local billboardGui = part:FindFirstChildOfClass("BillboardGui")

	if billboardGui then
		billboardGui.Enabled = false
	end

	local smokeAttachment, smokeEmitter = createSmokeTrail(
		part,
		part.Color
	)

	local originalCFrame = part.CFrame
	local originalTransparency = part.Transparency

	local downCFrame =
		originalCFrame
		+ Vector3.new(0, -DOWN_DISTANCE, 0)

	local downTween = TweenService:Create(
		part,
		TweenInfo.new(
			DOWN_DURATION,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),
		{
			CFrame = downCFrame,
		}
	)

	downTween:Play()

	downTween.Completed:Once(function()
		if not part or not part.Parent then
			if smokeAttachment then
				smokeAttachment:Destroy()
			end

			if onCompleted then
				onCompleted()
			end

			return
		end

		local startCFrame = part.CFrame
		local startPosition = startCFrame.Position
		local startRotation = startCFrame.Rotation

		local elapsed = 0
		local connection

		connection = RunService.Heartbeat:Connect(function(deltaTime)
			if not part or not part.Parent then
				connection:Disconnect()

				if smokeAttachment then
					smokeAttachment:Destroy()
				end

				if onCompleted then
					onCompleted()
				end

				return
			end

			elapsed += deltaTime

			local alpha = math.clamp(elapsed / UP_DURATION, 0, 1)

			local movementAlpha = TweenService:GetValue(
				alpha,
				Enum.EasingStyle.Exponential,
				Enum.EasingDirection.In
			)

			local transparencyAlpha = TweenService:GetValue(
				alpha,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.In
			)

			local position =
				startPosition
				+ Vector3.new(
					0,
					UP_DISTANCE * movementAlpha,
					0
				)

			local rotation = math.rad(360 * ROTATIONS * alpha)

			part.CFrame =
				CFrame.new(position)
				* startRotation
				* CFrame.Angles(
					rotation * 0.35,
					rotation,
					rotation * 0.15
				)

			part.Transparency =
				originalTransparency
				+ (1 - originalTransparency) * transparencyAlpha

			if alpha >= 1 then
				connection:Disconnect()

				if smokeEmitter then
					smokeEmitter.Enabled = false
				end

				if smokeAttachment then
					Debris:AddItem(smokeAttachment, 1)
				end

				if onCompleted then
					onCompleted()
				end
			end
		end)
	end)
end

return StudCollectVFX