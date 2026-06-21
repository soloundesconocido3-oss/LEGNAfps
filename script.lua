local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FPSCounter"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 55)
Frame.Position = UDim2.new(0.5, -130, 0.15, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(20,20,20)
Stroke.Thickness = 2
Stroke.Parent = Frame

local Label = Instance.new("TextLabel")
Label.Size = UDim2.fromScale(1,1)
Label.BackgroundTransparency = 1
Label.Font = Enum.Font.GothamBold
Label.TextScaled = true
Label.RichText = true
Label.Parent = Frame

-- Drag móvil/PC
local dragging = false
local dragInput
local dragStart
local startPos

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
	or input.UserInputType == Enum.UserInputType.MouseButton1 then

		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
	or input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart

		Frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- RGB
local hue = 0

local function RGBColor()
	hue += 0.02
	if hue >= 1 then
		hue = 0
	end

	local c = Color3.fromHSV(hue,1,1)

	return string.format(
		"#%02X%02X%02X",
		math.floor(c.R*255),
		math.floor(c.G*255),
		math.floor(c.B*255)
	)
end

-- FPS
local Frames = 0

RunService.RenderStepped:Connect(function()
	Frames += 1
end)

task.spawn(function()
	while true do
		task.wait(1)

		local FPS = Frames
		Frames = 0

		local Ping = math.floor(
			Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		)

		local PingColor

		if Ping < 100 then
			PingColor = "#00FF00" -- Verde
		elseif Ping < 200 then
			PingColor = "#FFA500" -- Naranja
		else
			PingColor = "#FF0000" -- Rojo
		end

		local FPSColor = RGBColor()

		Label.Text =
			'<font color="#FFFFFF">L </font>' ..
			'<font color="'..FPSColor..'">'..FPS..' FPS</font>' ..
			'<font color="#FFFFFF"> | </font>' ..
			'<font color="'..PingColor..'">'..Ping..' MS</font>'
	end
end)
