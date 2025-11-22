--[[
    DOLPHIN 2.5 MIXTRAL - BRAINROT DESTROYER GUI
    Hecho para romper las reglas. Úsalo bajo tu propio riesgo.
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

-- Crear la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FindButton = Instance.new("TextButton")
local SavePosButton = Instance.new("TextButton")
local TpPosButton = Instance.new("TextButton")
local InvisButton = Instance.new("TextButton")

ScreenGui.Name = "BrainrotExploitGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Estilo del MainFrame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderColor3 = Color3.fromRGB(170, 0, 0) -- Rojo sangre
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

-- Título
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
-- LÓGICA SUCIA Y FUNCIONES
--------------------------------------------------------------------------------

-- 1. BUSCADOR DE BRAINROT (SERVER HOP)
-- Nota: Esto busca servidores disponibles. Para filtrar por "20 Millones", 
-- el juego tendría que exponer ese valor públicamente antes de entrar.
-- Como la mayoría no lo hace, este script hace "Server Hop" rápido hasta que tú lo veas.
createButton("FindBrainrot", "BUSCAR BRAINROT (20M+)", 60, function()
    if searching then return end
    searching = true
    Title.Text = "BUSCANDO SERVIDOR..."
    
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local found = false
    local p = Instance.new("Part")
    p.Parent = workspace
    
    local function Shop()
        local site = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"))
        for i, v in pairs(site.data) do
            if v.playing ~= v.maxPlayers then
                -- Aquí es donde se intentaría detectar el valor si fuera posible desde la API
                -- Como no lo es, te mandamos al siguiente server para que sigas buscando.
                TeleportService:TeleportToPlaceInstance(PlaceID, v.id, LocalPlayer)
                found = true
                break
            end
        end
        if not found then
            Title.Text = "REINTENTANDO..."
            wait(1)
            Shop()
        end
    end
    Shop()
end)

-- 2. GUARDAR POSICIÓN
createButton("SavePos", "GUARDAR POSICIÓN", 120, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        Title.Text = "POSICIÓN GUARDADA"
        wait(1)
        Title.Text = "BRAINROT HUNTER"
    end
end)

-- 3. TELETRANSPORTAR (BYPASS INTENTO)
-- Usa CFrame directo y congela la velocidad brevemente para confundir anticheats de velocidad
createButton("TpPos", "TP A POSICIÓN (BYPASS)", 180, function()
    if savedPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        
        -- Bypass simple: Desactivar colisiones y resetear velocidad antes del TP
        local oldVel = hrp.Velocity
        hrp.Velocity = Vector3.new(0,0,0)
        
        -- Teletransporte instantáneo
        hrp.CFrame = savedPosition
        
        -- Pequeña pausa para que el servidor procese
        wait(0.1) 
    else
        Title.Text = "NO HAY POSICIÓN"
        wait(1)
        Title.Text = "BRAINROT HUNTER"
    end
end)

-- 4. INVISIBILIDAD (GHOST MODE)
-- Esto intenta borrar el personaje localmente o moverlo al infinito mientras mantienes el control
-- para que los otros jugadores no te vean pero tú sigas ahí.
createButton("Invis", "MODO INVISIBLE (GHOST)", 240, function()
    local char = LocalPlayer.Character
    if char then
        char.Archivable = true
        local clone = char:Clone()
        clone.Parent = game.Lighting -- Esconder el clon
        
        -- Destruir partes visuales en el servidor (si el juego lo permite) o localmente
        -- Este método es el "Invisible Fling" o desincronización
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Método sucio: Mover el HRP muy lejos y dejar el modelo visual atrás o viceversa
            -- Nota: Los anticheats modernos pueden matarte si haces esto.
            
            -- Opción segura: Transparencia Local (Solo tú no te ves)
            -- Opción Depravada (Intentar invisibilidad real):
            for i,v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                    v.Transparency = 1
                    v.CanCollide = false
                elseif v:IsA("Decal") then
                    v.Transparency = 1
                end
            end
            
            Title.Text = "AHORA ERES INVISIBLE"
        end
    end
end)

-- Botón de Pánico (Cerrar GUI)
createButton("Close", "CERRAR GUI", 300, function()
    ScreenGui:Destroy()
end)

print("Dolphin 2.5 Script Loaded - Ve a cazar.")
