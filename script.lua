--// LEGNA HUB V4 FULL (ALL IN ONE)

if not game:IsLoaded() then game.Loaded:Wait() end

--// VARIABLES
local KEY = "LEGNA OP"
local savedKey = false

--// SERVICIOS
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

--// GUARDADO KEY
pcall(function()
	if isfile and readfile then
		if isfile("legna_key.txt") then
			if readfile("legna_key.txt") == KEY then
				savedKey = true
			end
		end
	end
end)

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "LEGNA_HUB"

--// LOADER GALAXIA
local loader = Instance.new("Frame", gui)
loader.Size = UDim2.new(1,0,1,0)
loader.BackgroundColor3 = Color3.fromRGB(5,5,20)

local title = Instance.new("TextLabel", loader)
title.Size = UDim2.new(1,0,0.1,0)
title.Position = UDim2.new(0,0,0.3,0)
title.Text = "LEGNA HUB"
title.TextScaled = true
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack

local barBG = Instance.new("Frame", loader)
barBG.Size = UDim2.new(0.4,0,0.03,0)
barBG.Position = UDim2.new(0.3,0,0.5,0)
barBG.BackgroundColor3 = Color3.fromRGB(30,30,60)

local bar = Instance.new("Frame", barBG)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)

local percent = Instance.new("TextLabel", loader)
percent.Size = UDim2.new(1,0,0.05,0)
percent.Position = UDim2.new(0,0,0.55,0)
percent.Text = "0%"
percent.TextScaled = true
percent.BackgroundTransparency = 1

-- RGB título
task.spawn(function()
	while loader.Parent do
		title.TextColor3 = Color3.fromHSV(tick()%5/5,1,1)
		task.wait()
	end
end)

-- carga
for i = 1,100 do
	bar.Size = UDim2.new(i/100,0,1,0)
	percent.Text = i.."%"
	task.wait(0.08)
end

loader:Destroy()

--// KEY SYSTEM
if not savedKey then
	local keyFrame = Instance.new("Frame", gui)
	keyFrame.Size = UDim2.new(0.3,0,0.2,0)
	keyFrame.Position = UDim2.new(0.35,0,0.4,0)
	keyFrame.BackgroundColor3 = Color3.fromRGB(15,15,30)

	local box = Instance.new("TextBox", keyFrame)
	box.Size = UDim2.new(0.8,0,0.3,0)
	box.Position = UDim2.new(0.1,0,0.2,0)
	box.PlaceholderText = "ENTER KEY"

	local btn = Instance.new("TextButton", keyFrame)
	btn.Size = UDim2.new(0.6,0,0.3,0)
	btn.Position = UDim2.new(0.2,0,0.6,0)
	btn.Text = "CHECK"

	btn.MouseButton1Click:Connect(function()
		if box.Text == KEY then
			if writefile then
				writefile("legna_key.txt", KEY)
			end
			keyFrame:Destroy()
		end
	end)

	repeat task.wait() until not keyFrame.Parent
end

--// OPTIMIZACIÓN FPS
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e10
Lighting.Brightness = 1
Lighting.ClockTime = 14

for _,v in pairs(workspace:GetDescendants()) do
	if v:IsA("BasePart") then
		v.Material = Enum.Material.Plastic
		v.Reflectance = 0
	elseif v:IsA("Decal") then
		v.Transparency = 0.5
	end
end

--// FPS + PING
local fps = Instance.new("TextLabel", gui)
fps.Position = UDim2.new(0,10,0,10)
fps.Size = UDim2.new(0,120,0,40)
fps.BackgroundTransparency = 1
fps.TextScaled = true

local ping = Instance.new("TextLabel", gui)
ping.Position = UDim2.new(0,10,0,50)
ping.Size = UDim2.new(0,120,0,40)
ping.BackgroundTransparency = 1
ping.TextScaled = true

local last = tick()
local frames = 0

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		fps.Text = "FPS: "..frames
		frames = 0
		last = tick()

		local p = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
		ping.Text = "PING: "..p

		if p > 200 then
			ping.TextColor3 = Color3.fromRGB(255,0,0)
		elseif p > 100 then
			ping.TextColor3 = Color3.fromRGB(255,150,0)
		else
			ping.TextColor3 = Color3.fromRGB(0,255,0)
		end
	end
end)

--// BOTÓN AIM (MÓVIL)
local aimBtn = Instance.new("TextButton", gui)
aimBtn.Size = UDim2.new(0,120,0,50)
aimBtn.Position = UDim2.new(0.8,0,0.7,0)
aimBtn.Text = "AIM: OFF"
aimBtn.BackgroundColor3 = Color3.fromRGB(20,20,40)
aimBtn.TextColor3 = Color3.new(1,1,1)
aimBtn.TextScaled = true

local aiming = false
aimBtn.MouseButton1Click:Connect(function()
	aiming = not aiming
	aimBtn.Text = aiming and "AIM: ON" or "AIM: OFF"
end)

--// AIMBOT PECHO
local FOV = 120
local circle = Drawing.new("Circle")
circle.Radius = FOV
circle.Thickness = 2
circle.Color = Color3.fromRGB(0,170,255)
circle.Filled = false
circle.Visible = true

function getTarget()
	local closest = nil
	local distMax = FOV

	for _,v in pairs(Players:GetPlayers()) do
		if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			
			local pos, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
			
			if vis then
				local dist = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
				
				if dist < distMax then
					distMax = dist
					closest = v
				end
			end
		end
	end

	return closest
end

RunService.RenderStepped:Connect(function()
	circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

	if aiming then
		local t = getTarget()
		if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
			local part = t.Character.HumanoidRootPart
			local current = Camera.CFrame
			local new = CFrame.new(current.Position, part.Position)
			Camera.CFrame = current:Lerp(new, 0.15)
		end
	end
end)

--// LOGO PRO
local logo = Instance.new("ImageLabel", gui)
logo.Size = UDim2.new(0,100,0,100)
logo.Position = UDim2.new(0.78,0,0.55,0)
logo.BackgroundTransparency = 1
logo.Image = "https://i.imgur.com/8kKQZ5Q.png"

local stroke = Instance.new("UIStroke", logo)
stroke.Thickness = 2

task.spawn(function()
	while logo.Parent do
		stroke.Color = Color3.fromHSV(tick()%5/5,1,1)
		task.wait()
	end
end)

task.spawn(function()
	while logo.Parent do
		logo:TweenSize(UDim2.new(0,105,0,105), "Out", "Sine", 0.8, true)
		task.wait(0.8)
		logo:TweenSize(UDim2.new(0,100,0,100), "Out", "Sine", 0.8, true)
		task.wait(0.8)
	end
end)
