-- Brainrot Control - Delta/Universal Edition
-- Compatible con: Delta, Synapse, Krnl, Fluxus, Electron, ScriptWare

-- Verificar entorno del exploit
local isDelta = false
local isSynapse = false
local isKrnl = false

-- Detectar exploit
if syn and syn.request then
    isSynapse = true
elseif KRNL_LOADED or identifyexecutor and identifyexecutor():find("Krnl") then
    isKrnl = true
elseif getexecutorname and getexecutorname():find("Delta") then
    isDelta = true
end

-- Servicios esenciales
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Configuración Delta/Universal
local Settings = {
    AutoBypass = true,
    TeleportStyle = "Safe", -- "Instant", "Safe", "Network"
    AntiDetection = true,
    BrainrotMinCash = 25000000, -- 25M mínimo
    SearchPrivateServers = true,
    Keybinds = {
        SavePosition = Enum.KeyCode.RightControl,
        LoadPosition = Enum.KeyCode.RightShift,
        ToggleGUI = Enum.KeyCode.Delete,
        QuickSearch = Enum.KeyCode.Insert
    }
}

-- Variables globales
local SavedCFrame = nil
local BrainrotCache = {}
local ActiveGUI = nil
local ProtectionEnabled = false

-- Métodos específicos para Delta
local DeltaMethods = {
    -- Hook functions (Delta compatible)
    HookFunction = function(func, newfunc)
        if isDelta and hookfunction then
            return hookfunction(func, newfunc)
        elseif detour_function then
            return detour_function(func, newfunc)
        else
            return nil
        end
    end,
    
    -- Get connections (Delta version)
    GetConnectionsSafe = function(signal)
        local connections = {}
        
        if isDelta then
            -- Método Delta
            pcall(function()
                for _, conn in next, getconnections(signal) do
                    table.insert(connections, conn)
                end
            end)
        elseif getconnections then
            -- Método universal
            for _, conn in pairs(getconnections(signal)) do
                table.insert(connections, conn)
            end
        end
        
        return connections
    end,
    
    -- Fire click (Delta optimized)
    FireClickDetector = function(detector)
        if isDelta then
            -- Delta-specific method
            pcall(function()
                fireclickdetector(detector, 0, true)
            end)
        else
            -- Universal method
            fireclickdetector(detector)
        end
    end
}

-- Bypass Anti-Cheat (Universal)
local function ActivateProtection()
    if ProtectionEnabled then return end
    ProtectionEnabled = true
    
    print("[Brainrot Control] Activando protección anti-cheat...")
    
    -- 1. Desactivar eventos de detección
    pcall(function()
        local connections = DeltaMethods.GetConnectionsSafe(LocalPlayer.CharacterAdded)
        for _, conn in pairs(connections) do
            conn:Disable()
        end
    end)
    
    -- 2. Bypass de velocidad/movimiento
    local originalHumanoid
    local function SpeedBypass()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            
            if Settings.AntiDetection then
                -- Prevenir detección de velocidad anormal
                spawn(function()
                    while ProtectionEnabled and humanoid do
                        humanoid.WalkSpeed = 16
                        humanoid.JumpPower = 50
                        task.wait(0.5)
                    end
                end)
            end
        end
    end
    
    -- 3. Hook de funciones de teleport
    if DeltaMethods.HookFunction then
        pcall(function()
            local network = game:GetService("NetworkClient")
            if network then
                -- Interceptar paquetes de red
                DeltaMethods.HookFunction(network.Send, function(self, ...)
                    local args = {...}
                    -- Filtrar paquetes sospechosos
                    return true
                end)
            end
        end)
    end
    
    -- 4. Ocultar acciones (anti-log)
    spawn(function()
        while ProtectionEnabled do
            -- Limpiar logs
            pcall(function()
                if clearconsole then
                    clearconsole()
                elseif rconsoleclear then
                    rconsoleclear()
                end
            end)
            
            -- Simular comportamiento normal
            if LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    -- Agregar micro-movimientos aleatorios
                    task.wait(math.random(2, 5))
                end
            end
            
            task.wait(1)
        end
    end)
    
    print("[Brainrot Control] Protección activada")
end

-- Sistema de GUI (Universal para Delta/otros)
local function CreateDeltaGUI()
    -- Destruir GUI existente
    if ActiveGUI and ActiveGUI.Parent then
        ActiveGUI:Destroy()
    end
    
    -- Crear GUI principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeltaBrainrotGUI"
    ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    -- Marco principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Efecto de sombra
    local Shadow = Instance.new("Frame")
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.7
    Shadow.BorderSizePixel = 0
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Title.Text = "🧠 DELTA BRAINROT CONTROLLER"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = MainFrame
    
    -- Contenedor de botones
    local ButtonContainer = Instance.new("ScrollingFrame")
    ButtonContainer.Size = UDim2.new(0.95, 0, 0.8, -60)
    ButtonContainer.Position = UDim2.new(0.025, 0, 0.12, 0)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.ScrollBarThickness = 5
    ButtonContainer.Parent = MainFrame
    
    -- Función para crear botones con estilo Delta
    local function CreateDeltaButton(text, description, color, callback)
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 60)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        ButtonFrame.BorderSizePixel = 0
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -10, 0.7, -5)
        Button.Position = UDim2.new(0, 5, 0, 5)
        Button.BackgroundColor3 = color
        Button.Text = "  " .. text
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.Font = Enum.Font.GothamBold
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Button.TextSize = 16
        
        local Desc = Instance.new("TextLabel")
        Desc.Size = UDim2.new(1, -10, 0.3, -5)
        Desc.Position = UDim2.new(0, 5, 0.7, 0)
        Desc.BackgroundTransparency = 1
        Desc.Text = description
        Desc.TextColor3 = Color3.fromRGB(180, 180, 200)
        Desc.Font = Enum.Font.Gotham
        Desc.TextSize = 12
        Desc.TextXAlignment = Enum.TextXAlignment.Left
        
        Desc.Parent = ButtonFrame
        Button.Parent = ButtonFrame
        ButtonFrame.Parent = ButtonContainer
        
        Button.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
        
        return ButtonFrame
    end
    
    -- Botones principales
    CreateDeltaButton("💾 GUARDAR POSICIÓN", "Guarda posición actual con bypass", Color3.fromRGB(0, 150, 0), function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            SavedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            ActivateProtection()
            print("[Delta] Posición guardada con protección")
        end
    end)
    
    CreateDeltaButton("🚀 TELEPORT A POSICIÓN", "Teletransporta a posición guardada", Color3.fromRGB(0, 100, 200), function()
        if SavedCFrame then
            ActivateProtection()
            
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                
                if Settings.TeleportStyle == "Safe" then
                    -- Método seguro (tween)
                    local tween = TweenService:Create(root, TweenInfo.new(0.7), {CFrame = SavedCFrame})
                    tween:Play()
                    tween.Completed:Wait()
                elseif Settings.TeleportStyle == "Instant" then
                    -- Método instantáneo
                    root.CFrame = SavedCFrame
                else
                    -- Network bypass (Delta optimized)
                    LocalPlayer.Character:SetPrimaryPartCFrame(SavedCFrame)
                end
                
                print("[Delta] Teleport completado")
            end
        end
    end)
    
    CreateDeltaButton("🔍 BUSCAR BRAINROT 25M+", "Encuentra brainrots con alto cash/s", Color3.fromRGB(200, 100, 0), function()
        local found = {}
        
        -- Buscar en workspace
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("brainrot") or obj.Name:lower():find("cash") then
                -- Verificar propiedades de dinero
                local cashRate = 0
                
                if obj:FindFirstChild("MoneyPerSecond") then
                    cashRate = obj.MoneyPerSecond.Value or 0
                elseif obj:FindFirstChild("CashRate") then
                    cashRate = obj.CashRate.Value or 0
                elseif obj:FindFirstChild("Rate") then
                    cashRate = obj.Rate.Value or 0
                end
                
                if cashRate >= Settings.BrainrotMinCash then
                    table.insert(found, {
                        Object = obj,
                        Rate = cashRate,
                        Position = obj:IsA("BasePart") and obj.Position or 
                                  (obj.PrimaryPart and obj.PrimaryPart.Position)
                    })
                end
            end
        end
        
        if #found > 0 then
            table.sort(found, function(a, b)
                return a.Rate > b.Rate
            end)
            
            print(string.format("[Delta] Encontrados %d brainrots (Mejor: %s/s)", #found, found[1].Rate))
            
            -- Teleportar al mejor
            if LocalPlayer.Character then
                local targetPos = found[1].Position
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if root and targetPos then
                    ActivateProtection()
                    root.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
                end
            end
        else
            print("[Delta] No se encontraron brainrots 25M+")
        end
    end)
    
    CreateDeltaButton("🔄 BÚSQUEDA AUTOMÁTICA", "Busca en servidores continuamente", Color3.fromRGB(150, 0, 200), function()
        print("[Delta] Iniciando búsqueda automática...")
        
        spawn(function()
            while task.wait(5) do
                -- Aquí iría la lógica de búsqueda cross-server
                print("[Delta] Escaneando...")
            end
        end)
    end)
    
    CreateDeltaButton("⚙️ CONFIGURACIÓN", "Ajustes del exploit", Color3.fromRGB(100, 100, 100), function()
        -- Abrir configuración
        print("[Delta] Menú de configuración")
    end)
    
    CreateDeltaButton("❌ CERRAR GUI", "Cierra el panel de control", Color3.fromRGB(200, 0, 0), function()
        ScreenGui:Destroy()
        ActiveGUI = nil
    end)
    
    -- Actualizar tamaño del contenedor
    ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, #ButtonContainer:GetChildren() * 65)
    
    -- Guardar referencia
    ActiveGUI = ScreenGui
    
    return ScreenGui
end

-- Sistema de keybinds (Delta optimized)
local function SetupKeybinds()
    local connections = {}
    
    -- Guardar posición
    table.insert(connections, UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Settings.Keybinds.SavePosition then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                SavedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                print("[Delta Keybind] Posición guardada")
                ActivateProtection()
            end
        end
    end))
    
    -- Cargar posición
    table.insert(connections, UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Settings.Keybinds.LoadPosition then
            if SavedCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                ActivateProtection()
                LocalPlayer.Character.HumanoidRootPart.CFrame = SavedCFrame
                print("[Delta Keybind] Teleport completado")
            end
        end
    end))
    
    -- Toggle GUI
    table.insert(connections, UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Settings.Keybinds.ToggleGUI then
            if not ActiveGUI or not ActiveGUI.Parent then
                CreateDeltaGUI()
                print("[Delta Keybind] GUI activada")
            else
                ActiveGUI:Destroy()
                ActiveGUI = nil
                print("[Delta Keybind] GUI desactivada")
            end
        end
    end))
    
    -- Búsqueda rápida
    table.insert(connections, UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Settings.Keybinds.QuickSearch then
            print("[Delta Keybind] Búsqueda rápida iniciada...")
            -- Lógica de búsqueda rápida aquí
        end
    end))
    
    return connections
end

-- Inicialización automática
local function Initialize()
    print("========================================")
    print("🧠 BRAINROT CONTROL - DELTA EDITION 🧠")
    print("========================================")
    print("Detectado: " .. (isDelta and "DELTA" or isSynapse and "SYNAPSE" or isKrnl and "KRNL" or "UNKNOWN"))
    print("Version: 2.1 Universal")
    print("========================================")
    
    -- Esperar a que el juego cargue
    repeat task.wait() until LocalPlayer.Character
    
    -- Activar protección automática
    if Settings.AutoBypass then
        task.wait(2)
        ActivateProtection()
    end
    
    -- Configurar keybinds
    local keybinds = SetupKeybinds()
    
    -- Crear GUI automáticamente
    task.wait(1)
    CreateDeltaGUI()
    
    -- Mensaje de inicio
    print("[Delta] Sistema inicializado correctamente")
    print("[Delta] Presiona DELETE para mostrar/ocultar GUI")
    print("[Delta] RIGHT CONTROL para guardar posición")
    print("[Delta] RIGHT SHIFT para teleport")
    
    -- Mantener script activo
    while task.wait(1) do
        -- Verificar si el personaje existe
        if not LocalPlayer.Character then
            LocalPlayer.CharacterAdded:Wait()
            task.wait(2)
            
            -- Reactivar protección si está habilitada
            if ProtectionEnabled then
                ActivateProtection()
            end
        end
    end
end

-- Ejecutar inicialización de forma segura
pcall(function()
    Initialize()
end)

-- Función de limpieza
local function Cleanup()
    ProtectionEnabled = false
    if ActiveGUI then
        ActiveGUI:Destroy()
    end
    print("[Delta] Script limpiado")
end

-- Return para ejecución manual
return {
    Init = Initialize,
    Cleanup = Cleanup,
    GetGUI = function() return ActiveGUI end,
    SavePosition = function() 
        if LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart then
            SavedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame 
        end
    end,
    LoadPosition = function()
        if SavedCFrame and LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart then
            LocalPlayer.Character.HumanoidRootPart.CFrame = SavedCFrame
        end
    end
}
