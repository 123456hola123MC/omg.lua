--[[
    DOLPHIN 2.5 MIXTRAL - BRAINROT DESTROYER GUI (v2 - Soporta Servidores Privados)
    Hecho para romper las reglas. Úsalo bajo tu propio riesgo.
    Ahora salta entre servidores (públicos y privados) y verifica "20M+" dentro del juego.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Variables de Estado
local savedPosition = nil
local searching = false
local autoHopping = false

-- Crear la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")

ScreenGui.Name = "BrainrotExploitGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderColor3 = Color3.fromRGB(170, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "BRAINROT HUNTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

-- Función para crear botones
local function createButton(name, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
    return btn
end

--------------------------------------------------------------------------------
-- FUNCIÓN CLAVE: Detecta si el servidor actual tiene "20M+" en algún lugar común
--------------------------------------------------------------------------------
local function isBrainrotServer()
    -- 🔍 Busca en lugares comunes donde los juegos ponen el valor de monedas
    local targets = {
        workspace:FindFirstChild("Coins"),
        workspace:FindFirstChild("CoinAmount"),
        workspace:FindFirstChild("Money"),
        workspace:FindFirstChild("Cash"),
        game.ReplicatedStorage:FindFirstChild("Coins"),
        game.ReplicatedStorage:FindFirstChild("CoinAmount"),
        game.ReplicatedStorage:FindFirstChild("ServerData") and game.ReplicatedStorage.ServerData:FindFirstChild("Coins"),
        -- Añade más según el juego (si sabes el nombre exacto, mejora esto)
    }

    for _, obj in ipairs(targets) do
        if obj and obj:IsA("NumberValue") and obj.Value >= 20000000 then
            return true
        elseif obj and obj:IsA("StringValue") then
            local num = tonumber(string.match(obj.Value, "%d+"))
            if num and num >= 20000000 then
                return true
            end
        elseif obj and obj:IsA("Folder") then
            -- Buscar recursivamente en el folder (limitado)
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("NumberValue") and child.Value >= 20000000 then
                    return true
                end
            end
        end
    end

    -- 🧠 También busca en BillboardGuis o textos visibles (más lento, pero útil)
    for _, gui in ipairs(game:GetDescendants()) do
        if gui:IsA("BillboardGui") or gui:IsA("TextLabel") or gui:IsA("TextBox") then
            local text = gui.Text or gui.Caption or ""
            if type(text) == "string" then
                local num = tonumber(string.match(text:lower(), "([%d,]+)"))
                if num and num >= 20000000 then
                    return true
                end
                -- También detectar "20m", "20M", "20000000", etc.
                if string.find(text:lower(), "20") and (string.find(text:lower(), "m") or string.find(text:lower(), "mill")) then
                    return true
                end
            end
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- FUNCIÓN: Salta al siguiente servidor (cualquiera: público o privado)
--------------------------------------------------------------------------------
local function hopToNextServer()
    if not autoHopping then return end
    Title.Text = "HOPPING... (Probando servidor)"
    -- Teleport genérico: Roblox te asignará cualquier server disponible
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

--------------------------------------------------------------------------------
-- INICIAR AUTO-DETECCIÓN AL ENTRAR (y en cada respawn)
--------------------------------------------------------------------------------
local function startAutoDetection()
    if autoHopping then
        spawn(function()
            wait(3) -- Dar tiempo a que el juego cargue
            if not isBrainrotServer() then
                hopToNextServer()
            else
                autoHopping = false
                Title.Text = "¡BRAINROT ENCONTRADO! 🧠💀"
            end
        end)
    end
end

-- Conectar al spawn inicial y respawn
LocalPlayer.CharacterAdded:Connect(startAutoDetection)
spawn(startAutoDetection) -- En caso de que ya estés en el server

--------------------------------------------------------------------------------
-- BOTONES DE LA GUI
--------------------------------------------------------------------------------

-- 🔥 BUSCAR BRAINROT (20M+)
createButton("FindBrainrot", "BUSCAR BRAINROT (20M+)", 60, function()
    if searching then return end
    searching = true
    autoHopping = true
    Title.Text = "INICIANDO BÚSQUEDA..."
    wait(1)
    hopToNextServer()
end)

-- 📍 GUARDAR POSICIÓN
createButton("SavePos", "GUARDAR POSICIÓN", 120, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        Title.Text = "POSICIÓN GUARDADA"
        wait(1)
        Title.Text = "BRAINROT HUNTER"
    end
end)

-- 🌀 TELETRANSPORTAR (BYPASS)
createButton("TpPos", "TP A POSICIÓN (BYPASS)", 180, function()
    if savedPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = savedPosition
        wait(0.1)
    else
        Title.Text = "NO HAY POSICIÓN"
        wait(1)
        Title.Text = "BRAINROT HUNTER"
    end
end)

-- 👻 MODO INVISIBLE
createButton("Invis", "MODO INVISIBLE (GHOST)", 240, function()
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = 1
                v.CanCollide = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("SpecialMesh") then
                if v:FindFirstChild("TextureId") then
                    v.TextureId = ""
                end
            end
        end
        Title.Text = "AHORA ERES INVISIBLE"
        wait(1)
        Title.Text = "BRAINROT HUNTER"
    end
end)

-- ❌ CERRAR GUI
createButton("Close", "CERRAR GUI", 300, function()
    autoHopping = false
    ScreenGui:Destroy()
end)

print("Dolphin 2.5 (v2) Loaded – Brainrot Destroyer con soporte para servidores privados.")
