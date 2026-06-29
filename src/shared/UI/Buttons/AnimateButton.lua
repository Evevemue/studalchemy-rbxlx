local TweenService = game:GetService("TweenService")

local AnimateButton = {}

local hoverInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local clickInfo = TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function getBaseSize(btn)
	local base = btn:GetAttribute("BaseSize")

	if not base then
		btn:SetAttribute("BaseSize", btn.Size)
		base = btn.Size
	end

	return base
end

function AnimateButton.MouseHover(btn)
	local base = getBaseSize(btn)

	TweenService:Create(btn, hoverInfo, {
		Size = UDim2.new(
			base.X.Scale * 1.08,
			base.X.Offset,
			base.Y.Scale * 1.08,
			base.Y.Offset
		)
	}):Play()
end

function AnimateButton.MouseHoverEnd(btn)
	local base = getBaseSize(btn)

	TweenService:Create(btn, hoverInfo, {
		Size = base
	}):Play()
end

function AnimateButton.MouseDown(btn)
	local base = getBaseSize(btn)

	TweenService:Create(btn, clickInfo, {
		Size = UDim2.new(
			base.X.Scale * 0.92,
			base.X.Offset,
			base.Y.Scale * 0.92,
			base.Y.Offset
		)
	}):Play()
end

function AnimateButton.MouseUp(btn)
	AnimateButton.MouseHover(btn)
end

function AnimateButton.addAnimations(btn, obj)
	if obj == nil then obj = btn end
	
	btn.MouseEnter:Connect(function()
		AnimateButton.MouseHover(obj)
	end)
	btn.MouseLeave:Connect(function()
		AnimateButton.MouseHoverEnd(obj)
	end)
	btn.MouseButton1Down:Connect(function()
		AnimateButton.MouseDown(obj)
	end)
	btn.MouseButton1Up:Connect(function()
		AnimateButton.MouseUp(obj)
	end)
end

return AnimateButton