local TweenService = game:GetService("TweenService")

local FrameAnimator = {}

local states = setmetatable({}, { __mode = "k" })

local defaultOpenTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local defaultCloseTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local function cancelTween(state)
	if state.currentTween then
		state.currentTween:Cancel()
		state.currentTween = nil
	end
end

local function createState(frame, options)
	options = options or {}

	local visiblePosition = options.visiblePosition or frame.Position
	local hiddenOffset = options.hiddenOffset or 1

	local state = {
		visiblePosition = visiblePosition,
		hiddenPosition = options.hiddenPosition or UDim2.new(visiblePosition.X.Scale, visiblePosition.X.Offset, visiblePosition.Y.Scale + hiddenOffset, visiblePosition.Y.Offset),
		openTweenInfo = options.openTweenInfo or defaultOpenTweenInfo,
		closeTweenInfo = options.closeTweenInfo or defaultCloseTweenInfo,
		currentTween = nil,
	}

	states[frame] = state

	return state
end

local function getState(frame)
	return states[frame] or createState(frame)
end

function FrameAnimator.setup(frame, options)
	local state = createState(frame, options)

	frame.Position = state.hiddenPosition
	frame.Visible = false
end

function FrameAnimator.open(frame)
	local state = getState(frame)

	cancelTween(state)

	if not frame.Visible then
		frame.Position = state.hiddenPosition
		frame.Visible = true
	end

	local tween = TweenService:Create(frame, state.openTweenInfo, { Position = state.visiblePosition })
	state.currentTween = tween

	tween.Completed:Once(function()
		if state.currentTween == tween then
			state.currentTween = nil
		end
	end)

	tween:Play()
end

function FrameAnimator.close(frame)
	local state = getState(frame)

	if not frame.Visible then
		return
	end

	cancelTween(state)

	local tween = TweenService:Create(frame, state.closeTweenInfo, { Position = state.hiddenPosition })
	state.currentTween = tween

	tween.Completed:Once(function(playbackState)
		if state.currentTween ~= tween then
			return
		end

		state.currentTween = nil

		if playbackState == Enum.PlaybackState.Completed then
			frame.Visible = false
		end
	end)

	tween:Play()
end

function FrameAnimator.toggle(frame)
	if frame.Visible then
		FrameAnimator.close(frame)
	else
		FrameAnimator.open(frame)
	end
end

function FrameAnimator.destroy(frame)
	local state = states[frame]

	if not state then
		return
	end

	cancelTween(state)
	states[frame] = nil
end

return FrameAnimator