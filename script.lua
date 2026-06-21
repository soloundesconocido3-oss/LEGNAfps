local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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

function CreateHUD()
	local gui = Instance.new("ScreenGui")
	gui.Name = "LEGNA_FPS"
	gui.ResetOnSpawn = false
	gui.Parent = playerGui

	return gui
end

function CreateIntro(gui)
	-- RGB LEGNA FPS
	-- Mostrar 5 segundos
	-- Fade y destruir
end

function CreateCounter(gui)
	-- Crear Frame
	-- Crear RGB
	-- Crear FPS
	-- Crear Ping
end

function UpdateFPS()
	-- FPS Counter
end

function UpdatePing()
	-- Ping Counter
end

function RainbowText(label)
	-- RGB Rainbow
end

function EnableDrag(frame)
	-- PC + Mobile Drag
end

Optimize()

local gui = CreateHUD()

CreateIntro(gui)

local frame = CreateCounter(gui)

EnableDrag(frame)

UpdateFPS()

UpdatePing()
