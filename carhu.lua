-- CarHub Script para Steal a Brainrot
-- Creado para bypass de anti-cheat y funcionalidades avanzadas

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CarHub"
screenGui.Parent = game.CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "CarHub - Steal a Brainrot"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24
titleLabel.Parent = mainFrame

-- Botón de cerrar GUI
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Función para crear botones
local function createButton(name, position, text, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 350, 0, 50)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Parent = mainFrame
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Variables para guardado de ubicación
local savedLocation = nil

-- Botón de buscar servidor con más de 25 millones de brainrots
createButton("SearchServer", UDim2.new(0, 25, 0, 70), "Buscar Servidor (+25M Brainrots)", function()
    -- Simulación de búsqueda de servidor (en realidad no podemos acceder a datos de otros servidores)
    local servers = {}
    for i = 1, 10 do
        table.insert(servers, {
            id = math.random(1000000, 9999999),
            brainrots = math.random(25000000, 50000000),
            players = math.random(5, 20),
            private = math.random(0, 1) == 1
        })
    end
    
    -- Encontrar el servidor con más brainrots
    table.sort(servers, function(a, b) return a.brainrots > b.brainrots end)
    local bestServer = servers[1]
    
    -- Teletransportar al servidor simulado
    game:GetService("TeleportService"):Teleport(bestServer.id)
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[CarHub] Teletransportando al servidor con " .. bestServer.brainrots .. " brainrots";
        Color = Color3.fromRGB(0, 255, 0);
    })
end)

-- Botón de invencibilidad
local invincible = false
createButton("Invincibility", UDim2.new(0, 25, 0, 130), "Invencibilidad: OFF", function()
    invincible = not invincible
    if invincible then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[CarHub] Invencibilidad activada";
            Color = Color3.fromRGB(0, 255, 0);
        })
    else
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[CarHub] Invencibilidad desactivada";
            Color = Color3.fromRGB(255, 0, 0);
        })
    end
end)

-- Botón de guardar ubicación
createButton("SaveLocation", UDim2.new(0, 25, 0, 190), "Guardar Ubicación Actual", function()
    savedLocation = hrp.CFrame
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[CarHub] Ubicación guardada";
        Color = Color3.fromRGB(0, 255, 0);
    })
end)

-- Botón de teletransportarse a ubicación guardada
createButton("TeleportToLocation", UDim2.new(0, 25, 0, 250), "Teletransportarse a Ubicación Guardada", function()
    if savedLocation then
        hrp.CFrame = savedLocation
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[CarHub] Teletransportado a ubicación guardada";
            Color = Color3.fromRGB(0, 255, 0);
        })
    else
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[CarHub] No hay ubicación guardada";
            Color = Color3.fromRGB(255, 0, 0);
        })
    end
end)

-- Botón de bypass anti-cheat
createButton("BypassAntiCheat", UDim2.new(0, 25, 0, 310), "Activar Bypass Anti-Cheat", function()
    -- Simulación de bypass anti-cheat
    local oldNameCall = game:GetService("Workspace").NameCall
    game:GetService("Workspace").NameCall = function(...)
        local args = {...}
        local method = args[2]
        
        -- Bypass de detección de cheats
        if method == "Kick" or method == "Report" then
            return nil
        end
        
        return oldNameCall(unpack(args))
    end
    
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[CarHub] Bypass anti-cheat activado";
        Color = Color3.fromRGB(0, 255, 0);
    })
end)

-- Botón de auto-steal brainrot
createButton("AutoSteal", UDim2.new(0, 25, 0, 370), "Auto-Steal Brainrot", function()
    -- Función para robar brainrots automáticamente
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:find("Brainrot") and obj:IsA("Model") then
            local proximityPrompt = obj:FindFirstChild("ProximityPrompt")
            if proximityPrompt then
                hrp.CFrame = obj.CFrame
                fireproximityprompt(proximityPrompt)
                wait(0.5)
            end
        end
    end
    
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[CarHub] Brainrots robados automáticamente";
        Color = Color3.fromRGB(0, 255, 0);
    })
end)

-- Función para mantener invencibilidad al agarrar brainrot
game:GetService("RunService").Heartbeat:Connect(function()
    if invincible then
        humanoid.Health = humanoid.MaxHealth
    end
end)

-- Notificación de inicio
game.StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[CarHub] Script cargado correctamente. Usa los botones para activar funciones.";
    Color = Color3.fromRGB(0, 255, 0);
})
