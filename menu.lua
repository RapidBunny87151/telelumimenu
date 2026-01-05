loadstring(game:loadstring(game:HttpGet("https://raw.githubusercontent.com/RapidBunny87151/telelumimenu/blob/main/menu.lua)"))()"))()
ocal RunService = game:GetService("RunService")
local enabled = false  -- Wird mit dem Toggle verbunden.

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggle.Text = enabled and "Ultra Instinct: ON" or "Ultra Instinct: OFF"
end)

local function canDodge()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    if char:FindFirstChildOfClass("Humanoid").Health <= 0 then return false end
    return true
end

local function randomDodge()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Anticheat-safe random offset (nur CFrame lokal ändern)
    local angle = math.random() * 2 * math.pi
    local distance = math.random(6,10)  -- Passe an dein Game an
    local offset = Vector3.new(math.cos(angle)*distance, 0, math.sin(angle)*distance)
    local newPos = hrp.Position + offset

    -- Versuche RemoteEvent zu verwenden (wenn bekannt)
    local remote = nil -- Setze hier deinen Remote-Namen, falls bekannt!
    if remote and typeof(remote)=="Instance" then
        remote:FireServer(newPos)
    else
        -- Standardmäßiges CFrame-Setzen (wird manchmal zurückgesetzt!)
        hrp.CFrame = CFrame.new(newPos)
    end
end

local conn;
conn = RunService.Heartbeat:Connect(function()
    if enabled and canDodge() then
        -- Hier kannst du eigene Detection einbauen (zB checke auf Gegner in Range)
        if math.random() < 0.01 then -- Zufällig dodgen
            randomDodge()
        end
    end
end)

-- Zum Entfernen des Scripts:
gui.AncestryChanged:Connect(function()
    if not gui:IsDescendantOf(game) then
        if conn then pcall(function() conn:Disconnect() end) end
    end
end)

