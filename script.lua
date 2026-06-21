local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

function Optimize()
	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 100000

		for _,v in ipairs(workspace:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				v.Enabled = false
			elseif v:IsA("Trail") then
				v.Enabled = false
			elseif v:IsA("Beam") then
				v.Enabled = false
			end
		end
	end)
end

function CreateGui()
	local Gui = Instance.new("ScreenGui")
	Gui.Name = "LEGNAFPS"
	Gui.ResetOnSpawn = false
	Gui.Parent = PlayerGui

	return Gui
end

function CreateIntro(Gui)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(0,300,0,60)
	Frame.Position = UDim2.new(0.5,-150,0.15,0)
	Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
	Frame.BackgroundTransparency = 0.2
	Frame.Parent = Gui

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,16)
	Corner.Parent = Frame

	local Text = Instance.new("TextLabel")
	Text.Size = UDim2.new(1,0,1,0)
	Text.BackgroundTransparency = 1
	Text.Text = "LEGNA FPS"
	Text.TextScaled = true
	Text.Font = Enum.Font.GothamBold
	Text.TextColor3 = Color3.new(1,1,1)
	Text.Parent = Frame

	task.spawn(function()
		task.wait(5)

		TweenService:Create(
			Frame,
			TweenInfo.new(1),
			{BackgroundTransparency = 1}
		):Play()

		TweenService:Create(
			Text,
			TweenInfo.new(1),
			{TextTransparency = 1}
		):Play()

		task.wait(1)
		Frame:Destroy()
	end)
end

function CreateHUD(Gui)

	local HUD = Instance.new("Frame")
	HUD.Size = UDim2.new(0,280,0,50)
	HUD.Position = UDim2.new(0.4,0,0.08,0)
	HUD.BackgroundColor3 = Color3.fromRGB(0,0,0)
	HUD.BackgroundTransparency = 0.25
	HUD.Parent = Gui

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,18)
	Corner.Parent = HUD

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(40,40,40)
	Stroke.Thickness = 2
	Stroke.Parent = HUD

	local FPSWord = Instance.new("TextLabel")
	FPSWord.Size = UDim2.new(0,60,1,0)
	FPSWord.BackgroundTransparency = 1
	FPSWord.Text = "FPS"
	FPSWord.TextScaled = true
	FPSWord.Font = Enum.Font.GothamBold
	FPSWord.Parent = HUD

	local FPSValue = Instance.new("TextLabel")
	FPSValue.Size = UDim2.new(0,80,1,0)
	FPSValue.Position = UDim2.new(0,60,0,0)
	FPSValue.BackgroundTransparency = 1
	FPSValue.Text = "0"
	FPSValue.TextScaled = true
	FPSValue.TextColor3 = Color3.new(1,1,1)
	FPSValue.Font = Enum.Font.GothamBold
	FPSValue.Parent = HUD

	local Divider = Instance.new("TextLabel")
	Divider.Size = UDim2.new(0,20,1,0)
	Divider.Position = UDim2.new(0,140,0,0)
	Divider.BackgroundTransparency = 1
	Divider.Text = "|"
	Divider.TextScaled = true
	Divider.TextColor3 = Color3.new(1,1,1)
	Divider.Parent = HUD

	local PingLabel = Instance.new("TextLabel")
	PingLabel.Size = UDim2.new(0,120,1,0)
	PingLabel.Position = UDim2.new(0,160,0,0)
	PingLabel.BackgroundTransparency = 1
	PingLabel.Text = "0 MS"
	PingLabel.TextScaled = true
	PingLabel.Font = Enum.Font.GothamBold
	PingLabel.Parent = HUD

	return HUD,FPSWord,FPSValue,PingLabel
end

function Rainbow(Label)
	RunService.RenderStepped:Connect(function()
		local Hue = (tick()*0.15)%1
		Label.TextColor3 = Color3.fromHSV(Hue,1,1)
	end)
end

function FPSCounter(Label)

	local Frames = 0
	local Last = tick()

	RunService.RenderStepped:Connect(function()

		Frames += 1

		if tick()-Last >= 1 then
			Label.Text = tostring(Frames)
			Frames = 0
			Last = tick()
		end

	end)

end

function PingCounter(Label)

	RunService.Heartbeat:Connect(function()

		local Success, Ping = pcall(function()
			return math.floor(
				Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
			)
		end)

		if Success then

			Label.Text = Ping.." MS"

			if Ping < 100 then
				Label.TextColor3 = Color3.fromRGB(0,255,0)

			elseif Ping < 200 then
				Label.TextColor3 = Color3.fromRGB(255,140,0)

			else
				Label.TextColor3 = Color3.fromRGB(255,0,0)
			end
		end

	end)

end

function Drag(Frame)

	local Dragging = false
	local DragInput
	local DragStart
	local StartPos

	local function Update(Input)

		local Delta = Input.Position - DragStart

		Frame.Position = UDim2.new(
			StartPos.X.Scale,
			StartPos.X.Offset + Delta.X,
			StartPos.Y.Scale,
			StartPos.Y.Offset + Delta.Y
		)

	end

	Frame.InputBegan:Connect(function(Input)

		if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

			Dragging = true
			DragStart = Input.Position
			StartPos = Frame.Position

			Input.Changed:Connect(function()

				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end

			end)

		end

	end)

	Frame.InputChanged:Connect(function(Input)

		if Input.UserInputType == Enum.UserInputType.MouseMovement
		or Input.UserInputType == Enum.UserInputType.Touch then

			DragInput = Input

		end

	end)

	UserInputService.InputChanged:Connect(function(Input)

		if Input == DragInput and Dragging then
			Update(Input)
		end

	end)

end

Optimize()

local Gui = CreateGui()

CreateIntro(Gui)

local HUD,FPSWord,FPSValue,PingLabel = CreateHUD(Gui)

Rainbow(FPSWord)

FPSCounter(FPSValue)

PingCounter(PingLabel)

Drag(HUD)
