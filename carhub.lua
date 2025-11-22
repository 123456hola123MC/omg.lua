--[[
    BRAINROT DESTROYER PRO v3
    - Detección mejorada de valores altos (20M+)
    - Sistema de salto entre servidores optimizado
    - Interfaz mejorada
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Configuración
local TARGET_AMOUNT = 20000000  -- 20 millones
local SEARCH_DELAY = 5          -- Segundos entre verificaciones
local MAX_HOPS = 50             -- Límite de saltos para evitar loops infinitos

-- Variables de estado
local savedPosition = nil
local autoHopping = false
local hopCount = 0
local foundServer = false

-- Crear la GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")

ScreenGui.Name = "BrainrotExploitGUI_PRO"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Font = Enum.Font.GothamBold
Title.Text = "BRAINROT DESTROYER PRO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22

-- Función para crear botones mejorados
local function createButton(name, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.Size = UDim2.new(0.8, 0, 0, 45)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(callback)
    
    -- Efecto hover
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)
    
    return btn
end

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.1, 0, 0.9, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Estado: Inactivo"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

--------------------------------------------------------------------------------
-- FUNCIÓN MEJORADA PARA DETECTAR SERVIDORES CON 20M+
--------------------------------------------------------------------------------
local function isBrainrotServer()
    -- Lista de nombres comunes donde pueden estar los valores
    local targetNames = {
        "Coins", "Money", "Cash", "Gold", 
        "Points", "Currency", "Bank", "Amount",
        "Value", "Total", "Balance"
    }
    
    -- Buscar en instancias clave
    for _, name in pairs(targetNames) do
        -- Buscar en Workspace
        local obj = workspace:FindFirstChild(name, true) -- Buscar recursivamente
        if obj then
            if obj:IsA("NumberValue") and obj.Value >= TARGET_AMOUNT then
                return true
            elseif obj:IsA("StringValue") then
                local num = tonumber(obj.Value:gsub("[^%d]", ""))
                if num and num >= TARGET_AMOUNT then
                    return true
                end
            elseif obj:IsA("IntValue") and obj.Value >= TARGET_AMOUNT then
                return true
            end
        end
        
        -- Buscar en ReplicatedStorage
        local rsObj = game:GetService("ReplicatedStorage"):FindFirstChild(name, true)
        if rsObj then
            if rsObj:IsA("NumberValue") and rsObj.Value >= TARGET_AMOUNT then
                return true
           
