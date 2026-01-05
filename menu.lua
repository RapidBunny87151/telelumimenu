--[[
GojoMaster.lua
Loadstring-kompatibel: Einfach per
loadstring(game:loadstring(game:HttpGet("https://raw.githubusercontent.com/RapidBunny87151/telelumimenu.git)"))()"))()
ausführen
]]

-- Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local plr = Players.LocalPlayer

-- Remotes erstellen falls nicht vorhanden
local folder = RS:FindFirstChild("GojoRemotes") or Instance.new("Folder", RS)
folder.Name = "GojoRemotes"

local function createRemote(name)
	local r = folder:FindFirstChild(name)
	if not r then
		r = Instance.new("RemoteEvent", folder)
		r.Name = name
	end
	return r
end

local ToggleFly = createRemote("ToggleFly")
local Boost = createRemote("Boost")
local Teleport = createRemote("Teleport")

-- ====== GOJO UI ======
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "GojoUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.25,0.45)
frame.Position = UDim2.fromScale(0.02,0.25)
frame.BackgroundColor3 = Color3.fromRGB(20,20,40)
frame.BorderSizePixel = 0
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0,16)

-- Titel
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.15)
title.Text = "GOJO ∞ CONTROL"
title.TextColor3 = Color3.fromRGB(100,200,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Gojo Bild als Hintergrund (du musst AssetID ersetzen)
local image = Instance.new("ImageLabel", frame)
image.Size = UDim2.fromScale(1,1)
image.Position = UDim2.fromScale(0,0)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://1234567890" -- <- HIER DEINE GOJO ASSETID
image.ZIndex = 0

-- Spielerliste
local listFrame = Instance.new("Frame", frame)
listFrame.Size = UDim2.fromScale(1,0.8)
listFrame.Position = UDim2.fromScale(0,0.18)
listFrame.BackgroundTransparency = 1

local listLayout = Instance.new("UIListLayout", listFrame)
listLayout.Padding = UDim.new(0,6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function refreshPlayerList()
	listFrame:ClearAllChildren()
	for _,p in Players:GetPlayers() do
		if p ~= plr then
			local b = Instance.new("TextButton", listFrame)
			b.Text = "Teleport → "..p.Name
			b.Size = UDim2.fromScale(0.9,0.08)
			b.BackgroundColor3 = Color3.fromRGB(40,40,80)
			b.TextColor3 = Color3.fromRGB(255,255,255)
			b.Font = Enum.Font.Gotham
			b.TextScaled = true
			b.AutoButtonColor = true
			b.MouseButton1Click:Connect(function()
				Teleport:FireServer(p.Name)
			end)
		end
	end
end

refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- ===== HOTKEYS =====
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.F then
		ToggleFly:FireServer()
	end
	if input.KeyCode == Enum.KeyCode.Q then
		Boost:FireServer()
	end
end)

-- ===== DEMO FLY SIMULATION (nur Client) =====
local flying = false
local boostLevel = 1

ToggleFly.OnClientEvent:Connect(function()
	flying = not flying
end)

Boost.OnClientEvent:Connect(function()
	boostLevel = (boostLevel % 3) + 1
end)

RunService.RenderStepped:Connect(function(delta)
	if flying and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = plr.Character.HumanoidRootPart
		local speed = ({50,100,200})[boostLevel]
		hrp.Velocity = hrp.CFrame.LookVector * speed
	end
end)

print("⚡ GOJO MASTER LOADSTRING READY")
