--[[
    BRAINROT FINDER IMPROVED v3
    - Detección mejorada de valores altos (20M+)
    - Sistema de salto optimizado
    - Soporte para servidores privados
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
 game:GetService("HttpService")

-- Configuración
local TARGET_AMOUNT = 20000000  -- 20 millones
local SEARCH_DELAY = 5          -- Segundos entre saltos
local MAX_HOPS = 50             -- Límite de saltos para prevenir loops infinitos

-- Variables de estado
local autoHopping = false
local hopCount = 0
local foundServer = false

-- Función mejorada para detectar valores altos
local function isBrainrotServer()
    -- 1. Buscar en instancias clave primero
    local keyInstances = {
        "Coins", "CoinsValue", "Money", "Cash", 
        "Currency", "Gold", "Points", "Bank"
    }
    
    for _, name in pairs(keyInstances) do
        local obj = workspace:FindFirstChild(name) or game.ReplicatedStorage:FindFirstChild(name)
        if obj then
            if obj:IsA("NumberValue") and obj.Value >= TARGET_AMOUNT then
                return true
            elseif obj:IsA("StringValue") then
                local num = tonumber(obj.Value:gsub("[^%d]", ""))
                if num and num >= TARGET_AMOUNT then
                    return true
                end
            elseif obj:IsA("Folder") then
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("NumberValue") and child.Value >= TARGET_AMOUNT then
                        return true
                    end
                end
            end
        end
    end
    
    -- 2. Buscar en textos visibles (más lento pero más exhaustivo)
    for _, descendant in pairs(game:GetDescendants()) do
        if descendant:IsA("TextLabel") or descendant:IsA("TextBox") or descendant:IsA("TextButton") then
            local text = descendant.Text
            if type(text) == "string" then
                -- Busca patrones como "20M", "20,000,000", "20m", etc.
                local cleanText = text:gsub(",", ""):lower()
                if cleanText:find("20m") or cleanText:find("20000000") then
                    return true
                end
                
                -- Extraer números del texto
                local num = tonumber(cleanText:match("%d+"))
                if num and num >= TARGET_AMOUNT then
                    return true
                end
            end
        end
    end
    
    return false
end

-- Función mejorada para saltar de servidor
local function hopToNextServer()
    if not autoHopping or hopCount >= MAX_HOPS then return end
    
    hopCount = hopCount + 1
    
    -- Primero intentar obtener lista de servidores (para saltar específicamente)
    local success, servers = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet(
            string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=2&limit=100", game.PlaceId)
        ))
    end)
    
    if success and servers and servers.data and #servers.data > 0 then
        -- Filtrar servidores con jugadores (evitar vacíos)
        local validServers = {}
        for _, server in pairs(servers.data) do
            if server.playing and server.playing > 1 and server.id ~= game.JobId then
                table.insert(validServers, server.id)
            end
        end
        
        if #validServers > 0 then
            -- Saltar a un servidor aleatorio de la lista
            TeleportService:TeleportToPlaceInstance(game.PlaceId, validServers[math.random(1, #validServers)])
            return
        end
    end
    
    -- Si falla la API, usar método de salto genérico
    TeleportService:Teleport(game.PlaceId)
end

-- Función principal de búsqueda
local function startSearch()
    autoHopping = true
    hopCount = 0
    foundServer = false
    
    while autoHopping and hopCount < MAX_HOPS do
        wait(SEARCH_DELAY)  -- Esperar a que el juego cargue
        
        if isBrainrotServer() then
            foundServer = true
            autoHopping = false
            print("¡SERVIDOR CON BRAINROT ENCONTRADO!")
            break
        else
            hopToNextServer()
            wait(5)  -- Esperar antes de verificar de nuevo
        end
    end
    
    if not foundServer then
        print("BÚSQUEDA FINALIZADA: No se encontró ningún servidor con Brainrot")
    end
end

-- Crear interfaz simple
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local StartButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "BrainrotFinderGUI"
ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Active = true
Frame.Draggable = true

Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "BRAINROT FINDER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

StartButton.Parent = Frame
StartButton.Position = UDim2.new(0.1, 0, 0.3, 0)
StartButton.Size = UDim2.new(0.8, 0, 0, 40)
StartButton.Font = Enum.Font.Gotham
StartButton.Text = "INICIAR BÚSQUEDA"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextSize = 14
StartButton.MouseButton1Click:Connect(startSearch)

StatusLabel.Parent = Frame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.7, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 40)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Listo para buscar"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14

-- Actualizar estado
local function updateStatus(text)
    StatusLabel.Text = text
end

-- Conectar eventos para actualizar estado
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if autoHopping then
        updateStatus("Verificando servidor...")
        wait(3)  -- Tiempo para que cargue el juego
        if isBrainrotServer() then
            updateStatus("¡BRAINROT ENCONTRADO!")
            autoHopping = false
        else
            updateStatus("Saltando a nuevo servidor...")
        end
    end
end)

print("Brainrot Finder Improved v3 cargado correctamente")
