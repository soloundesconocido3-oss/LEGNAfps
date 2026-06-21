--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

---------------------------------------------------
-- 📡 DEBUG SYSTEM
local function log(msg)
	print("[LEGNA DEBUG]: "..msg)
	if console then
		console.Text = console.Text .. "\n" .. msg
	end
end

---------------------------------------------------
-- 🧱 GUI SAFE START
local gui = Instance.new("ScreenGui")
gui.Name = "LEGNA_STABLE_UI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

log("GUI created")

---------------------------------------------------
-- 🌑 MAIN PANEL
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 520, 0, 320)
main.Position = UDim2.new(0.5, -260, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

log("Main panel loaded")

---------------------------------------------------
-- 📌 SIDEBAR
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 140, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(12,12,12)

Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,14)

---------------------------------------------------
-- 📄 TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,-140,0,35)
title.Position = UDim2.new(0,140,0,0)
title.BackgroundTransparency = 1
title.Text = "LEGNA DEBUG PANEL"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

---------------------------------------------------
-- 📦 CONTENT
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-150,1,-40)
content.Position = UDim2.new(0,150,0,40)
content.BackgroundTransparency = 1

---------------------------------------------------
-- 🧪 DEBUG CONSOLE UI
local console = Instance.new("TextLabel", main)
console.Size = UDim2.new(1,-150,0,80)
console.Position = UDim2.new(0,150,1,-80)
console.BackgroundColor3 = Color3.fromRGB(10,10,10)
console.TextColor3 = Color3.fromRGB(0,255,120)
console.Font = Enum.Font.Code
console.TextSize = 12
console.TextXAlignment = Enum.TextXAlignment.Left
console.TextYAlignment = Enum.TextYAlignment.Top
console.Text = "DEBUG CONSOLE:\n"
console.ClipsDescendants = true

Instance.new("UICorner", console).CornerRadius = UDim.new(0,10)

log("Debug console ready")

---------------------------------------------------
-- 🧹 CLEAR UI
local function clear()
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("GuiObject") then v:Destroy() end
	end
end

---------------------------------------------------
-- 🔘 SAFE BUTTON
local function button(text, y, callback)
	local b = Instance.new("TextButton", content)
	b.Size = UDim2.new(1,-10,0,40)
	b.Position = UDim2.new(0,5,0,y)
	b.BackgroundColor3 = Color3.fromRGB(25,25,25)
	b.Text = text
	b.TextColor3 = Color3.fromRGB(220,220,220)
	b.Font = Enum.Font.Gotham
	b.TextSize = 13

	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)

	b.MouseButton1Click:Connect(function()
		log("Button pressed: "..text)

		local ok, err = pcall(callback)
		if not ok then
			log("ERROR: "..tostring(err))
		end
	end)
end

---------------------------------------------------
-- 📊 SERVER TAB (SAFE)
local function openServer()
	clear()
	log("Opening server tab")

	local ping = "N/A"

	pcall(function()
		local item = Stats.Network.ServerStatsItem["Data Ping"]
		if item then
			ping = math.floor(item:GetValue()).." ms"
		end
	end)

	button("Players: "..#Players:GetPlayers(), 0, function() end)
	button("Ping: "..ping, 50, function() end)
	button("PlaceId: "..game.PlaceId, 100, function() end)

	log("Server info loaded")
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
		log("Tab selected: "..name)
		clear()
		callback()
	end)
end

tab("Server", 20, openServer)
tab("Debug", 70, function()
	clear()
	log("Debug tab opened")

	button("Test Error", 0, function()
		error("Test error triggered")
	end)

	button("Print Ping", 50, function()
		log("Ping checked manually")
	end)
end)

---------------------------------------------------
-- 🚀 START SAFE
pcall(function()
	openServer()
	log("UI fully loaded")
end)
