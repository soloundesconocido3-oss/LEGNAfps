-- ================= 🌌 LEGNA HUB LOADER + KEY =================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- GUI BASE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- FONDO GALAXIA
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(5,5,25)
bg.Parent = ScreenGui

-- ESTRELLAS (animación simple)
for i = 1,50 do
	local star = Instance.new("Frame")
	star.Size = UDim2.new(0,2,0,2)
	star.Position = UDim2.new(math.random(),0,math.random(),0)
	star.BackgroundColor3 = Color3.new(1,1,1)
	star.BorderSizePixel = 0
	star.Parent = bg

	task.spawn(function()
		while star.Parent do
			star.Position = star.Position + UDim2.new(0, math.random(-1,1), 0, math.random(1,3))
			task.wait(0.05)
		end
	end)
end

-- TEXTO
local title = Instance.new("TextLabel")
title.Text = "LEGNA HUB"
title.Size = UDim2.new(1,0,0,50)
title.Position = UDim2.new(0,0,0.3,0)
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0,170,255)
title.Parent = bg

local sub = Instance.new("TextLabel")
sub.Text = "rjb"
sub.Size = UDim2.new(1,0,0,20)
sub.Position = UDim2.new(0,0,0.37,0)
sub.BackgroundTransparency = 1
sub.TextScaled = true
sub.TextColor3 = Color3.fromRGB(255,50,50)
sub.Parent = bg

-- BARRA
local barBG = Instance.new("Frame")
barBG.Size = UDim2.new(0.6,0,0,20)
barBG.Position = UDim2.new(0.2,0,0.5,0)
barBG.BackgroundColor3 = Color3.fromRGB(30,30,30)
barBG.Parent = bg

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
bar.Parent = barBG

-- PORCENTAJE
local percent = Instance.new("TextLabel")
percent.Size = UDim2.new(1,0,0,20)
percent.Position = UDim2.new(0,0,0.55,0)
percent.BackgroundTransparency = 1
percent.TextColor3 = Color3.new(1,1,1)
percent.TextScaled = true
percent.Text = "0%"
percent.Parent = bg

-- LOADING 8 SEGUNDOS
for i = 1,100 do
	bar.Size = UDim2.new(i/100,0,1,0)
	percent.Text = i.."%"
	task.wait(0.08)
end

-- KEY UI
bg:ClearAllChildren()

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3,0,0.3,0)
frame.Position = UDim2.new(0.35,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,40)
frame.Parent = bg

local box = Instance.new("TextBox")
box.PlaceholderText = "Enter Key..."
box.Size = UDim2.new(0.8,0,0.3,0)
box.Position = UDim2.new(0.1,0,0.2,0)
box.Parent = frame

local btn = Instance.new("TextButton")
btn.Text = "VERIFY"
btn.Size = UDim2.new(0.6,0,0.3,0)
btn.Position = UDim2.new(0.2,0,0.6,0)
btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
btn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,0,0.2,0)
status.Position = UDim2.new(0,0,0.85,0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1,1,1)
status.Text = ""
status.Parent = frame

-- VALIDACIÓN
local KEY = "LEGNA OP"

btn.MouseButton1Click:Connect(function()
	if box.Text == KEY then
		status.Text = "✅ Correct Key"
		task.wait(1)
		ScreenGui:Destroy()

		-- 🔥 AQUÍ SIGUE TU SCRIPT NORMAL 🔥

	else
		status.Text = "❌ Wrong Key"
	end
end)
