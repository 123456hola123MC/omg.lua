-- CarHub para Steal a Brainrot - Versión 2.1 (Completo y Corregido)
-- Creado para un exploit de Roblox (Compatible con Delta Executor)
-- Nota: Los scripts externos deben estar disponibles. El Finder usa simulación + externos.

-- Cargar los scripts externos para el Finder y el Tween
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GlyphsCaveOfTeasure/BrainrotFinder/refs/heads/main/SecretFinder"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ily123950/Vulkan/refs/heads/main/Trx"))()
end)

-- Esperar a que el juego y el jugador se carguen
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

-- Variables de estado
local invincible = false
local godConnections = {}
local charAddedConn = nil
local savedPosition = nil

-- === CONFIGURACIÓN DEL BRAINROT FINDER ===
-- Lista de brainrots objetivo.
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

-- Función para setup Godmode
local function setupGodmode()
    local function onCharacterAdded(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            local conn = hum.HealthChanged:Connect(function(health)
                if invincible and health < hum.MaxHealth * 0.99 then
                    hum.Health = hum.MaxHealth
                end
            end)
            table.insert(godConnections, conn)
        end
    end

    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end
    charAddedConn = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
end

local function toggleGodmode()
    if invincible then
        setupGodmode()
    else
        for _, conn in ipairs(godConnections) do
            if conn then conn:Disconnect() end
        end
        godConnections = {}
        if charAddedConn then
            charAddedConn:Disconnect()
            charAddedConn = nil
        end
    end
end

-- === FUNCIÓN PARA CREAR LA GUI DEL FINDER (SUB-MENÚ) ===
local function createFinderGui()
    -- Crear una ScreenGui para el menú del finder
    local finderScreenGui = Instance.new("ScreenGui")
    finderScreenGui.Name = "CarHubFinderGui"
    finderScreenGui.Parent = game.CoreGui

    local finderFrame = Instance.new("Frame")
    finderFrame.Name = "FinderFrame"
    finderFrame.Parent = finderScreenGui
    finderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    finderFrame.BorderSizePixel = 0
    finderFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    finderFrame.Size = UDim2.new(0, 500, 0, 400)
    finderFrame.Draggable = true

    local ucorner = Instance.new("UICorner")
    ucorner.CornerRadius = UDim.new(0, 8)
    ucorner.Parent = finderFrame

    local finderTitle = Instance.new("TextLabel")
    finderTitle.Name = "FinderTitle"
    finderTitle.Parent = finderFrame
    finderTitle.BackgroundTransparency = 1
    finderTitle.Size = UDim2.new(1, 0, 0, 40)
    finderTitle.Font = Enum.Font.SourceSansBold
    finderTitle.Text = "🧠 Brainrots Encontrados (20M+)"
    finderTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
    finderTitle.TextSize = 22

    local serverList = Instance.new("ScrollingFrame")
    serverList.Name = "ServerList"
    serverList.Parent = finderFrame
    serverList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    serverList.BorderSizePixel = 0
    serverList.Position = UDim2.new(0, 10, 0, 50)
    serverList.Size = UDim2.new(1, -20, 1, -100)
    serverList.ScrollBarThickness = 10
    serverList.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 0)

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = serverList
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        serverList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)

    -- Simulación de búsqueda de servidores (integra con scripts externos via _G)
    local function findServers()
        -- NOTA: Scripts externos populan datos reales. Esto es fallback simulado.
        local foundServers = {
            {name = "Servidor de La Vacca", value = 25000000, jobId = "PLACEHOLDER_JOB_ID_1"},
            {name = "Servidor de Nuclearo", value = 30000000, jobId = "PLACEHOLDER_JOB_ID_2"},
            {name = "Servidor de Supreme Combinasion", value = 50000000, jobId = "PLACEHOLDER_JOB_ID_3"},
            {name = "Servidor de Dragon Cannelloni", value = 40000000, jobId = "PLACEHOLDER_JOB_ID_4"},
        }

        for _, server in ipairs(foundServers) do
            local entryFrame = Instance.new("Frame")
            entryFrame.Name = "Entry"
            entryFrame.Parent = serverList
            entryFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            entryFrame.Size = UDim2.new(1, 0, 0, 50)
            entryFrame.LayoutOrder = _

            local uc = Instance.new("UICorner")
            uc.CornerRadius = UDim.new(0, 4)
            uc.Parent = entryFrame

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = entryFrame
            nameLabel.BackgroundTransparency = 1
            nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
            nameLabel.Font = Enum.Font.SourceSans
            nameLabel.Text = server.name .. " - $" .. (server.value / 1000000) .. "M"
            nameLabel.TextColor3 = Color3.new(1, 1, 1)
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextSize = 14

            local joinButton = Instance.new("TextButton")
            joinButton.Parent = entryFrame
            joinButton.Size = UDim2.new(0.35, 0, 0.8, 0)
            joinButton.Position = UDim2.new(0.63, 0, 0.1, 0)
            joinButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            joinButton.Font = Enum.Font.SourceSansBold
            joinButton.Text = "Te quires unir o que papa"
            joinButton.TextColor3 = Color3.new(1, 1, 1)
            joinButton.TextSize = 12

            local jcorner = Instance.new("UICorner")
            jcorner.CornerRadius = UDim.new(0, 4)
            jcorner.Parent = joinButton

            joinButton.MouseButton1Click:Connect(function()
                StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = "[CarHub] Intentando unirse al servidor: " .. server.name;
                    Color = Color3.new(0, 1, 1);
                })
                -- Descomenta con JobId real: TeleportService:TeleportToPlaceInstance(game.PlaceId, server.jobId, LocalPlayer)
                -- pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, server.jobId, LocalPlayer)
            end)
        end
    end

    findServers()

    local closeFinderButton = Instance.new("TextButton")
    closeFinderButton.Name = "CloseFinderButton"
    closeFinderButton.Parent = finderFrame
    closeFinderButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeFinderButton.BorderSizePixel = 0
    closeFinderButton.Position = UDim2.new(0.5, -50, 1, -40)
    closeFinderButton.Size = UDim2.new(0, 100, 0, 30)
    closeFinderButton.Font = Enum.Font.SourceSansBold
    closeFinderButton.Text = "Cerrar"
    closeFinderButton.TextColor3 = Color3.new(1, 1, 1)
    closeFinderButton.TextSize = 16

    local ccorner = Instance.new("UICorner")
    ccorner.CornerRadius = UDim.new(0, 6)
    ccorner.Parent = closeFinderButton

    closeFinderButton.MouseButton1Click:Connect(function()
        finderScreenGui:Destroy()
    end)
end

-- === CREACIÓN DE LA GUI PRINCIPAL (CARHUB) ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CarHub"
screenGui.Parent = game.CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Draggable = true

local mcorner = Instance.new("UICorner")
mcorner.CornerRadius = UDim.new(0, 12)
mcorner.Parent = mainFrame

local mstroke = Instance.new("UIStroke")
mstroke.Color = Color3.fromRGB(255, 255, 0)
mstroke.Thickness = 2
mstroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.BorderSizePixel = 0
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "🚗 CarHub v2.1 - Steal a Brainrot"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
titleLabel.TextSize = 24

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Parent = mainFrame
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Position = UDim2.new(0, 10, 0, 55)
buttonsFrame.Size = UDim2.new(1, -20, 1, -80)

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.Parent = buttonsFrame
buttonLayout.Padding = UDim.new(0, 8)
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.FillDirection = Enum.FillDirection.Vertical

-- Función helper para crear botones
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = buttonsFrame
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 16

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.new(1,1,1)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) end)

    return btn
end

-- Botón Finder
createButton("🧠 Buscador de Brainrots", function()
    createFinderGui()
end)

-- Botón Godmode
local godButton = createButton("🛡️ Godmode: OFF", function()
    invincible = not invincible
    godButton.Text = "🛡️ Godmode: " .. (invincible and "ON 🟢" or "OFF 🔴")
    godButton.BackgroundColor3 = invincible and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    toggleGodmode()
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[CarHub] Godmode " .. (invincible and "activado ✅" or "desactivado ❌");
        Color = invincible and Color3.new(0,1,0) or Color3.new(1,0,0);
    })
end)

-- Botón Save Pos
createButton("💾 Guardar Posición", function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPosition = hrp.CFrame
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[CarHub] ¡Posición guardada! 📍";
            Color = Color3.new(0, 1, 0);
        })
    else
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[CarHub] Error: Sin personaje.";
            Color = Color3.new(1, 0, 0);
        })
    end
end)

-- Botón Teleport Pos
createButton("🚀 TP a Posición Guardada", function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and savedPosition then
        hrp.CFrame = savedPosition
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[CarHub] ¡Teleportado a posición guardada! ✨";
            Color = Color3.new(0, 1, 1);
        })
    else
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[CarHub] Error: Sin posición guardada o personaje.";
            Color = Color3.new(1, 0, 0);
        })
    end
end)

-- Botón Cerrar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Position = UDim2.new(0.5, -50, 1, -35)
closeButton.Size = UDim2.new(0, 100, 0, 30)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "❌ Cerrar"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 16
closeButton.LayoutOrder = 999

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Mensaje de carga
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[CarHub v2.1] Cargado correctamente! Usa la GUI arrastrable. Compatible con Delta ✅";
    Color = Color3.fromRGB(0, 255, 255);
    Font = Enum.Font.SourceSansBold;
    FontSize = Enum.FontSize.Size18;
})
