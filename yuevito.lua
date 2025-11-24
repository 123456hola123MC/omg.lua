-- CarHub for Steal a Brainrot
-- Creado para un exploit. Usar bajo tu propio riesgo.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Función para notificar al usuario
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5;
    })
end

-- Crear la GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CarHub"
screenGui.Parent = game.CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Draggable = true

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.BorderSizePixel = 0
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "CarHub - Steal a Brainrot"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20.000

-- Sección de Búsqueda de Servidor
local serverFrame = Instance.new("Frame")
serverFrame.Name = "ServerFrame"
serverFrame.Parent = mainFrame
serverFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
serverFrame.BorderSizePixel = 0
serverFrame.Position = UDim2.new(0, 10, 0, 50)
serverFrame.Size = UDim2.new(1, -20, 0, 80)

local serverLabel = Instance.new("TextLabel")
serverLabel.Name = "ServerLabel"
serverLabel.Parent = serverFrame
serverLabel.BackgroundTransparency = 1
serverLabel.Position = UDim2.new(0, 5, 0, 5)
serverLabel.Size = UDim2.new(0.5, -10, 0, 20)
serverLabel.Font = Enum.Font.SourceSans
serverLabel.Text = "Servidores con >25M Brainrot:"
serverLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
serverLabel.TextSize = 14.000
serverLabel.TextXAlignment = Enum.TextXAlignment.Left

local searchButton = Instance.new("TextButton")
searchButton.Name = "SearchButton"
searchButton.Parent = serverFrame
searchButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
searchButton.BorderSizePixel = 0
searchButton.Position = UDim2.new(0, 5, 0, 30)
searchButton.Size = UDim2.new(0.5, -10, 0, 40)
searchButton.Font = Enum.Font.SourceSansBold
searchButton.Text = "Buscar Servidor"
searchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
searchButton.TextSize = 16.000

-- Sección de Invencibilidad
local invincibleToggle = Instance.new("TextButton")
invincibleToggle.Name = "InvincibleToggle"
invincibleToggle.Parent = mainFrame
invincibleToggle.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
invincibleToggle.BorderSizePixel = 0
invincibleToggle.Position = UDim2.new(0, 10, 0, 140)
invincibleToggle.Size = UDim2.new(0, 185, 0, 40)
invincibleToggle.Font = Enum.Font.SourceSansBold
invincibleToggle.Text = "Invencibilidad: OFF"
invincibleToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
invincibleToggle.TextSize = 16.000

-- Sección de Teletransporte
local teleportFrame = Instance.new("Frame")
teleportFrame.Name = "TeleportFrame"
teleportFrame.Parent = mainFrame
teleportFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportFrame.BorderSizePixel = 0
teleportFrame.Position = UDim2.new(0, 10, 0, 190)
teleFrame.Size = UDim2.new(1, -20, 0, 70)

local savePosButton = Instance.new("TextButton")
savePosButton.Name = "SavePosButton"
savePosButton.Parent = teleportFrame
savePosButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
savePosButton.BorderSizePixel = 0
savePosButton.Position = UDim2.new(0, 0, 0, 5)
savePosButton.Size = UDim2.new(0.5, -5, 0, 30)
savePosButton.Font = Enum.Font.SourceSansBold
savePosButton.Text = "Guardar Ubicación"
savePosButton.TextColor3 = Color3.fromRGB(255, 255, 255)
savePosButton.TextSize = 14.000

local loadPosButton = Instance.new("TextButton")
loadPosButton.Name = "LoadPosButton"
loadPosButton.Parent = teleportFrame
loadPosButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
loadPosButton.BorderSizePixel = 0
loadPosButton.Position = UDim2.new(0.5, 5, 0, 5)
loadPosButton.Size = UDim2.new(0.5, -5, 0, 30)
loadPosButton.Font = Enum.Font.SourceSansBold
loadPosButton.Text = "Teletransportar"
loadPosButton.TextColor3 = Color3.fromRGB(255, 255, 255)
loadPosButton.TextSize = 14.000

-- Botón para cerrar la GUI
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
closeButton.BorderSizePixel = 0
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeFrame.TextSize = 18.000

-- Variables para las funciones
local isInvincible = false
local savedPosition = nil
local invincibleConnection = nil

-- Lógica de la GUI

-- Cerrar GUI
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Función de Invencibilidad
local function toggleInvincibility()
    isInvincible = not isInvincible
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if isInvincible then
                invincibleToggle.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
                invincibleToggle.Text = "Invencibilidad: ON"
                -- Método 1: Bloquear el cambio de salud
                humanoid.Changed:Connect(function(property)
                    if property == "Health" and isInvincible then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end)
                -- Método 2: Establecer una salud muy alta para evitar la muerte por una sola vez
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                notify("Invencibilidad", "Activada", 3)
            else
                invincibleToggle.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
                invincibleToggle.Text = "Invencibilidad: OFF"
                humanoid.MaxHealth = 100
                humanoid.Health = 100
                notify("Invencibilidad", "Desactivada", 3)
            end
        end
    end
end

invincibleToggle.MouseButton1Click:Connect(toggleInvincibility)

-- Función de Teletransporte
savePosButton.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character.PrimaryPart then
        savedPosition = character.PrimaryPart.CFrame
        notify("Ubicación Guard
