-- LEGNA FPS + PING (FPS BLANCO, PING DINÁMICO)

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LegnaFPS"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 130, 0, 30)
frame.Position = UDim2.new(0, 70, 0, 8)
frame.BackgroundColor3 = Color3.fromRGB(8,8,8)
frame.BorderSizePixel = 0
frame.Parent = gui

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(45,45,45)
stroke.Thickness = 1.5
stroke.Parent = frame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = frame

-- TEXTO
local text = Instance.new("TextLabel")
text.Size = UDim2.new(1,0,1,0)
text.BackgroundTransparency = 1
text.Font = Enum.Font.GothamBold
text.TextScaled = true
text.RichText = true
text.TextColor3 = Color3.fromRGB(255,255,255)
text.Parent = frame

-- ALERTA
local alert = Instance.new("Frame")
alert.Size = UDim2.new(0, 140, 0, 30)
alert.Position = UDim2.new(0, 70, 0, 40)
alert.BackgroundColor3 = Color3.fromRGB(8,8,8)
alert.BorderSizePixel = 0
alert.Parent = gui

local aStroke = Instance.new("UIStroke")
aStroke.Color = Color3.fromRGB(45,45,45)
aStroke.Thickness = 1.5
aStroke.Parent = alert

local aCorner = Instance.new("UICorner")
aCorner.CornerRadius = UDim.new(0, 6)
aCorner.Parent = alert

local aText = Instance.new("TextLabel")
aText.Size = UDim2.new(1,0,1,0)
aText.BackgroundTransparency = 1
aText.Font = Enum.Font.GothamBold
aText.TextScaled = true
aText.RichText = true
aText.Parent = alert

-- ALERTA 5s
task.spawn(function()
	local hue = 0
	for i = 1, 300 do
		hue = (hue + 0.01) % 1
		local rgb = Color3.fromHSV(hue,1,1)

		aText.Text = '<font color="rgb('..
			math.floor(rgb.R*255)..','..
			math.floor(rgb.G*255)..','..
			math.floor(rgb.B*255)..')">L</font>EGNA FPS'

		task.wait(0.016)
	end
	alert:Destroy()
end)

-- COLOR DEL PING
local function getPingColor(ping)
	if ping < 200 then
		return Color3.fromRGB(0,255,0) -- verde
	elseif ping <= 600 then
		return Color3.fromRGB(255,165,0) -- naranja
	else
		local intensity = math.clamp((ping - 600) / 400, 0, 1)
		local r = 255
		local g = math.floor(50 * (1 - intensity))
		local b = math.floor(50 * (1 - intensity))
		return Color3.fromRGB(r,g,b)
	end
end

-- PING
local function getPing()
	local ping = 0
	pcall(function()
		ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	return math.floor(ping)
end

-- FPS
local fps = 0
local last = tick()
local hue = 0

RunService.RenderStepped:Connect(function()
	fps += 1

	if tick() - last >= 1 then
		local currentFPS = fps
		fps = 0
		last = tick()

		local ping = getPing()
		local pingColor = getPingColor(ping)

		-- RGB solo para la L
		hue = (hue + 0.02) % 1
		local rgb = Color3.fromHSV(hue,1,1)

		text.Text =
		'<font color="rgb('..
		math.floor(rgb.R*255)..','..
		math.floor(rgb.G*255)..','..
		math.floor(rgb.B*255)..')">L</font> '..
		'<font color="rgb(255,255,255)">'..currentFPS..' FPS</font>'..
		' | '..
		'<font color="rgb('..
		math.floor(pingColor.R*255)..','..
		math.floor(pingColor.G*255)..','..
		math.floor(pingColor.B*255)..')">'..
		ping..' MS</font>'
	end
end)
