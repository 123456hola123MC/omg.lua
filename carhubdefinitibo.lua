-- CarHub para Steal a Brainrot - Versión 2.0
-- Creado para un exploit de Roblox

-- Esperar a que el juego se cargue completamente
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- Variable para la invencibilidad
local invincible = false
local godConnection = nil

-- Variable para la ubicación guardada
local savedPosition = nil

-- === CONFIGURACIÓN DEL BRAINROT FINDER ===
-- Lista de brainrots objetivo. El script buscará los que valgan más de 20 millones.
_G.TargetBrainrots = {
    "La Vacca Saturno Saturnita", "Torrtuginni Dragonfrutini",
    "Los Tralaleritos", "Las Tralaleritas", "Las Vaquitas Saturnitas",
    "Graipuss Medussi", "Pot Hotspot", "La Grande Combinasion",
    "Nuclearo Dinossauro", "Garama and Madundung",
    "Chicleteira Bicicleteira", "Sammyni Spyderini", "Secret Lucky Block",
    "Agarrini Ia Palini", "Los Combinasionas",
    "Dragon Cannelloni", "Dul Dul Dul", "Karkerkar Kurkur", "Los Hotspotsitos",
    "Esok Sekolah",
    "Blackhole Goat", "Ketupat Kepat", "Bisonte Giuppitere", "Los Spyderinis", "La Supreme Combinasion", "Los Matteos", "Job Job Job Sahur"
}
-- === FIN DE LA CONFIGURACIÓN ===


-- Función para crear la GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CarHub"
screenGui.Parent = game.CoreGui -- Se inyecta en CoreGui para que no se elimine

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Draggable = true

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.BorderSizePixel = 0
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "CarHub - Steal a Brainrot v2"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
titleLabel.TextSize = 20

-- Botón de Brainrot Finder
local brainrotFinderButton = Instance.new("TextButton")
brainrotFinderButton.Name = "BrainrotFinderButton"
brainrotFinderButton.Parent = mainFrame
brainrotFinderButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
brainrotFinderButton.BorderSizePixel = 0
brainrotFinderButton.Position = UDim2.new(0, 20, 0, 60)
brainrotFinderButton.Size = UDim2.new(0, 160, 0, 40)
brainrotFinderButton.Font = Enum.Font.SourceSans
brainrotFinderButton.Text = "Brainrot Finder"
brainrotFinderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
brainrotFinderButton.TextSize = 18

-- Botón de Invencibilidad
local invincibilityButton = Instance.new("TextButton")
invincibilityButton.Name = "InvincibilityButton"
invincibilityButton.Parent = mainFrame
invincibilityButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
invincibilityButton.BorderSizePixel = 0
invincibilityButton.Position = UDim2.new(0, 220, 0, 60)
invincibilityButton.Size = UDim2.new(0, 160, 0, 40)
invincibilityButton.Font = Enum.Font.SourceSans
invincibilityButton.Text = "Invencibilidad: OFF"
invincibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invincibilityButton.TextSize = 18

-- Botón de Guardar Ubicación
local savePosButton = Instance.new("TextButton")
savePosButton.Name = "SavePosButton"
savePosButton.Parent = mainFrame
savePosButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
savePosButton.BorderSizePixel = 0
savePosButton.Position = UDim2.new(0, 20, 0, 120)
savePosButton.Size = UDim2.new(0, 160, 0, 40)
savePosButton.Font = Enum.Font.SourceSans
savePosButton.Text = "Guardar Ubicación"
savePosButton.TextColor3 = Color3.fromRGB(255, 255, 255)
savePosButton.TextSize = 18

-- Botón de Teletransportarse
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Parent = mainFrame
teleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportButton.BorderSizePixel = 0
teleportButton.Position = UDim2.new(0, 220, 0, 120)
teleportButton.Size = UDim2.new(0, 160, 0, 40)
teleportButton.Font = Enum.Font.SourceSans
teleportButton.Text = "Teletransportarse"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextSize = 18

-- Botón de Cerrar GUI
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18


-- --- LÓGICA DE LAS FUNCIONES ---

-- Función para activar/desactivar la invencibilidad
local function toggleInvincibility()
    invincible = not invincible
    if invincible then
        invincibilityButton.Text = "Invencibilidad: ON"
        invincibilityButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            godConnection = LocalPlayer.Character.Humanoid.Died:Connect(function()
                LocalPlayer.Character:BreakJoints()
                wait()
                LocalPlayer:LoadCharacter()
                if invincible then
                    toggleInvincibility()
                    toggleInvincibility()
                end
            end)
        end
    else
        invincibilityButton.Text = "Invencibilidad: OFF"
        invincibilityButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        if godConnection then
            godConnection:Disconnect()
            godConnection = nil
        end
    end
end

-- Función para guardar la posición actual
local function savePosition()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = LocalPlayer.Character.HumanoidRootPart.Position
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[CarHub] Ubicación guardada.";
            Color = Color3.new(0, 1, 0);
            Font = Enum.Font.SourceSansBold;
        })
    end
end

-- Función para teletransportarse a la posición guardada
local function teleportToSavedPosition()
    if savedPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[CarHub] Teletransportado a la ubicación guardada.";
            Color = Color3.new(0, 1, 0);
            Font = Enum.Font.SourceSansBold;
        })
    else
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[CarHub] No hay ninguna ubicación guardada.";
            Color = Color3.new(1,
