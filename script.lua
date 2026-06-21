--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer

---------------------------------------------------
-- 🌑 GUI BASE
local gui = Instance.new("ScreenGui")
gui.Name = "LEGNA_GOD_PANEL"
gui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame", gui)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
bg.BackgroundTransparency = 0.6

---------------------------------------------------
-- 🧱 MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 600, 0, 360)
main.Position = UDim2.new(0.5, -300, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BorderSizePixel = 0

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255,60,60)
stroke.Thickness = 1
stroke.Transparency = 0.5

---------------------------------------------------
-- 📌 SIDEBAR
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 140, 1, -40)
sidebar.Position = UDim2.new(0,0,0,40)
sidebar.BackgroundColor3 = Color3.fromRGB(10,10,10)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,16)

---------------------------------------------------
-- 📄 TOP BAR
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -140, 0, 40)
title.Position = UDim2.new(0,140,0,0)
title.BackgroundTransparency = 1
title.Text = "LEGNA GOD PANEL"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

---------------------------------------------------
-- 📦 CONTENT
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-150,1,-50)
content.Position = UDim2.new(0,150,0,50)
content.BackgroundTransparency = 1

local function clear()
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("GuiObject") then v:Destroy() end
	end
end

---------------------------------------------------
-- 🔘 BUTTON SYSTEM
local function button(text, y, callback)
	local b = Instance.new("TextButton", content)
	b.Size = UDim2.new(1,-10,0,40)
	b.Position = UDim2.new(0,5,0,y)
	b.BackgroundColor3 = Color3.fromRGB(20,20,20)
	b.Text = text
	b.TextColor3 = Color3.fromRGB(220,220,220)
	b.Font = Enum.Font.Gotham
	b.TextSize = 13

	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)

	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(255,60,60)
	s.Transparency = 0.7

	b.MouseEnter:Connect(function()
		TweenService:Create(s, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
	end)

	b.MouseLeave:Connect(function()
		TweenService:Create(s, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
	end)

	b.MouseButton1Click:Connect(callback)
end

---------------------------------------------------
-- 📊 SERVER TAB
local function openServer()
	clear()

	local ping = "N/A"
	pcall(function()
		ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()).." ms"
	end)

	button("Players: "..#Players:GetPlayers(), 0)
	button("Ping: "..ping, 50)
	button("PlaceId: "..game.PlaceId, 100)

	local job = Instance.new("TextBox", content)
	job.Size = UDim2.new(1,-10,0,40)
	job.Position = UDim2.new(0,5,0,160)
	job.Text = game.JobId
	job.BackgroundColor3 = Color3.fromRGB(20,20,20)
	job.TextColor3 = Color3.fromRGB(255,255,255)
	job.ClearTextOnFocus = false

	Instance.new("UICorner", job).CornerRadius = UDim.new(0,10)

	button("Copy JobId", 210, function()
		setclipboard(game.JobId)
	end)
end

---------------------------------------------------
-- 🚀 BOOST SYSTEM (INTELLIGENT)
local boostEnabled = false

local function applyBoost(state)
	if state then
		-- Low graphics
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.SmoothPlastic
				v.Reflectance = 0
				v.CastShadow = false
			end
		end

		Lighting.GlobalShadows = false
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	else
		Lighting.GlobalShadows = true
	end
end

local function openBoost()
	clear()

	button("FPS BOOST (Toggle)", 0, function()
		boostEnabled = not boostEnabled
		applyBoost(boostEnabled)
	end)

	button("REMOVE SHADOWS", 50, function()
		Lighting.GlobalShadows = false
	end)

	button("LOW GRAPHICS MODE", 100, function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end)

	button("RESET VISUALS", 150, function()
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.Plastic
			end
		end

		Lighting.GlobalShadows = true
		settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
	end)
end

---------------------------------------------------
-- 📌 TABS
local function tab(name, y, callback)
	local t = Instance.new("TextButton", sidebar)
	t.Size = UDim2.new(1,0,0,40)
	t.Position = UDim2.new(0,0,0,y)
	t.Text = name
	t.BackgroundTransparency = 1
	t.TextColor3 = Color3.fromRGB(180,180,180)
	t.Font = Enum.Font.Gotham
	t.TextSize = 13

	t.MouseButton1Click:Connect(function()
		clear()
		callback()
	end)
end

tab("Server", 20, openServer)
tab("Boost", 70, openBoost)
tab("General", 120, function()
	clear()
	button("UI Loaded", 0)
end)

---------------------------------------------------
-- 🚀 DEFAULT
openServer()
