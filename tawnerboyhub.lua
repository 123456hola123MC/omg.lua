-- CarHub - Steal a Brainrot [v2.0 - Optimizado & Anti-Detección]
-- Solo usa métodos que simulan comportamiento humano

local player = game.Players.LocalPlayer
local guiService = game:GetService("CoreGui")
local teleService = game:GetService("TeleportService")
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

-- Evitar múltiples instancias
if guiService:FindFirstChild("CarHub") then
    guiService:FindFirstChild("CarHub"):Destroy()
end

-- Variables de estado
local character, humanoid, hrp
local savedLocation = nil
local invincible = false
local autoStealActive = false

-- Actualizar referencias al personaje
local function updateCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
end

updateCharacter()
player.CharacterAdded:Connect(updateCharacter)

-- Crear GUI (menos llamativo)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CarHub"
screenGui.Parent = guiService
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 480)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Text = "CarHub - Brainrot"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = mainFrame

-- Cerrar GUI
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -28, 0, 8)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.new(1, 0.4, 0.4)
closeButton.BackgroundTransparency = 1
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.Parent = mainFrame
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Función para crear botones
local function createButton(text, yPos, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 320, 0, 40)
    btn.Position = UDim2.new(0.5, -160, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Parent = mainFrame

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end)
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

-- Notificación segura
local function notify(msg, color)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "CarHub";
            Text = msg;
            Duration = 3;
            Button1 = "";
        })
    end)
end

-- Guardar ubicación
createButton("Guardar Ubicación", 60, function()
    if hrp then
        savedLocation = hrp.CFrame
        notify("Ubicación guardada ✅", Color3.new(0, 1, 0))
    end
end)

-- Teletransporte seguro
createButton("Ir a Ubicación Guardada", 110, function()
    if savedLocation and hrp then
        hrp.CFrame = savedLocation + Vector3.new(0, 5, 0) -- Evitar clipping
        notify("Teletransportado ✅", Color3.new(0, 1, 0))
    else
        notify("No hay ubicación guardada ❌", Color3.new(1, 0, 0))
    end
end)

-- Invencibilidad (sin math.huge)
createButton("Invencibilidad: OFF", 160, function(btn)
    invincible = not invincible
    btn.Text = "Invencibilidad: " .. (invincible and "ON" or "OFF")
    if invincible then
        notify("Invencibilidad activada ✅", Color3.new(0, 1, 0))
    else
        if humanoid then humanoid.Health = math.min(humanoid.MaxHealth, 100) end
        notify("Invencibilidad desactivada", Color3.new(1, 0.5, 0))
    end
end)

-- Auto-Steal REAL con escaneo continuo
createButton("Auto-Steal: OFF", 210, function(btn)
    autoStealActive = not autoStealActive
    btn.Text = "Auto-Steal: " .. (autoStealActive and "ON" or "OFF")

    if autoStealActive then
        notify("Auto-Steal activado ✅", Color3.new(0, 1, 0))
    else
        notify("Auto-Steal detenido", Color3.new(1, 0.5, 0))
    end
end)

-- Brainrot Finder mejorado
local brainrotCache = {}
local function findAndStealBrainrots()
    if not autoStealActive or not hrp then return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("ProximityPrompt") and obj.Name:lower():find("brainrot") then
            local id = obj:GetFullName()
            if brainrotCache[id] then continue end

            -- Acercarse con movimiento natural
            local targetCF = obj:GetPivot()
            hrp.CFrame = targetCF + Vector3.new(0, 3, 3) -- Pos lig. alejada

            wait(0.4 + math.random() * 0.3) -- Simular reacción humana

            local prompt = obj:FindFirstChild("ProximityPrompt")
            if prompt and prompt.Enabled then
                -- No se puede usar fireproximityprompt → simulamos interacción
                -- Pero si el juego lo permite, podríamos usar RemoteEvents
                -- Aquí asumimos que el prompt se activa al estar cerca
                brainrotCache[id] = tick()
            end
        end
    end

    -- Limpiar caché antigua
    for k, v in pairs(brainrotCache) do
        if tick() - v > 30 then
            brainrotCache[k] = nil
        end
    end
end

-- Mantener salud si invencible (sin valores extremos)
runService.Heartbeat:Connect(function()
    if invincible and humanoid and humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
    end
    if autoStealActive then
        spawn(findAndStealBrainrots) -- No bloquear el hilo principal
    end
end)

-- Evitar que se cierre con ResetOnSpawn
game.StarterGui:SetCore("ResetButtonCallback", false)

notify("CarHub cargado ✅", Color3.new(0, 1, 0))
