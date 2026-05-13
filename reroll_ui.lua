--[[
    ROME HUB v7.0 - BRUTAL HONEST VERSION
    Apenas o que FUNCIONA de verdade
    Sem firula, sem "IA falsa", sem DeepScan maluco
--]]

local Services = {
    Players = game:GetService("Players"),
    UIS = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    VIM = game:GetService("VirtualInputManager"),
    Workspace = game:GetService("Workspace"),
    CoreGui = game:GetService("CoreGui")
}

local plr = Services.Players.LocalPlayer
local cam = Services.Workspace.CurrentCamera

-- ============================================
-- SISTEMA DE CONFIGURAÇÃO MANUAL
-- Aqui VOCÊ configura baseado no update atual
-- ============================================
local CONFIG = {
    -- Atualize isso quando o jogo mudar
    UI_PATHS = {
        HP_BAR = nil,        -- Ex: "ScreenGui/HUD/HP/Bar"
        GOLD_TEXT = nil,     -- Ex: "ScreenGui/HUD/Gold/Amount"
        FLOOR_TEXT = nil,    -- Ex: "ScreenGui/StageCounter/Text"
        CARD_CONTAINER = nil,-- Ex: "ScreenGui/CardSelection"
        SHOP_CONTAINER = nil,-- Ex: "ScreenGui/ShopUI"
        BATTLE_HUD = nil,    -- Ex: "ScreenGui/BattleHUD"
        PLACEMENT_GRID = nil -- Ex: "ScreenGui/PlacementGrid"
    },
    
    -- Cores exatas para detecção
    COLORS = {
        HP_BAR = Color3.fromRGB(255, 50, 50),
        NODE_BATTLE = Color3.fromRGB(200, 200, 200),
        NODE_ELITE = Color3.fromRGB(255, 60, 60),
        NODE_SHOP = Color3.fromRGB(255, 200, 50),
        NODE_REST = Color3.fromRGB(50, 255, 50),
        SLOT_EMPTY = Color3.fromRGB(80, 80, 80),
        SLOT_OCCUPIED = Color3.fromRGB(40, 40, 40)
    },
    
    -- Delays baseados no seu ping
    DELAYS = {
        CLICK = 0.1,
        AFTER_CLICK = 0.3,
        AFTER_PLACE = 0.5,
        TICK_RATE = 0.5
    }
}

-- ============================================
-- FUNÇÕES SIMPLES QUE FUNCIONAM
-- ============================================

-- 1. Encontrar elemento por caminho (sem GetDescendants)
local function FindByPath(path)
    if not path then return nil end
    local current = plr.PlayerGui
    for _, step in ipairs(path:split("/")) do
        current = current:FindFirstChild(step)
        if not current then return nil end
    end
    return current
end

-- 2. Clicar em posição absoluta
local function ClickAt(x, y)
    Services.VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
    task.wait(CONFIG.DELAYS.CLICK)
    Services.VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

-- 3. Clicar em objeto GUI
local function ClickObject(obj)
    if not obj or not obj.Parent then return false end
    local pos = obj.AbsolutePosition
    local size = obj.AbsoluteSize
    ClickAt(pos.X + size.X/2, pos.Y + size.Y/2)
    return true
end

-- 4. Verificar se elemento está visível
local function IsVisible(obj)
    if not obj then return false end
    return obj.Visible and obj.AbsoluteSize.X > 10 and obj.AbsoluteSize.Y > 10
end

-- 5. Encontrar elementos por cor (mais seguro que texto)
local function FindByColor(targetColor, tolerance)
    tolerance = tolerance or 15
    local results = {}
    
    -- Procura APENAS em containers conhecidos
    local containers = {
        plr.PlayerGui:FindFirstChild("ScreenGui"),
        plr.PlayerGui:FindFirstChild("BattleHUD"),
        plr.PlayerGui:FindFirstChild("OdysseyHUD")
    }
    
    for _, container in ipairs(containers) do
        if container then
            for _, obj in ipairs(container:GetDescendants()) do
                if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("ImageButton") then
                    if obj.Visible then
                        local color = obj.BackgroundColor3 or obj.ImageColor3
                        if color and 
                           math.abs(color.R*255 - targetColor.R*255) < tolerance and
                           math.abs(color.G*255 - targetColor.G*255) < tolerance and
                           math.abs(color.B*255 - targetColor.B*255) < tolerance then
                            table.insert(results, obj)
                        end
                    end
                end
            end
        end
    end
    
    return results
end

-- ============================================
-- FUNÇÕES ESPECÍFICAS DO ODYSSEY
-- ============================================

-- Ler HP (se configurado)
local function GetHP()
    local bar = FindByPath(CONFIG.UI_PATHS.HP_BAR)
    if bar and bar:IsA("Frame") then
        return math.floor(bar.Size.X.Scale * 100)
    end
    
    -- Fallback: procurar barra vermelha
    local redBars = FindByColor(CONFIG.COLORS.HP_BAR, 20)
    for _, bar in ipairs(redBars) do
        if bar:IsA("Frame") and bar.Size.X.Scale < 1.1 then
            return math.floor(bar.Size.X.Scale * 100)
        end
    end
    
    return 100
end

-- Detectar nós do mapa
local function GetMapNodes()
    local nodes = {}
    
    -- Procurar por botões com cores específicas
    local battleNodes = FindByColor(CONFIG.COLORS.NODE_BATTLE, 25)
    local eliteNodes = FindByColor(CONFIG.COLORS.NODE_ELITE, 25)
    local shopNodes = FindByColor(CONFIG.COLORS.NODE_SHOP, 25)
    local restNodes = FindByColor(CONFIG.COLORS.NODE_REST, 25)
    
    for _, obj in ipairs(battleNodes) do
        if obj:IsA("ImageButton") or obj:IsA("TextButton") then
            table.insert(nodes, {Type = "BATTLE", Obj = obj})
        end
    end
    
    for _, obj in ipairs(eliteNodes) do
        if obj:IsA("ImageButton") or obj:IsA("TextButton") then
            table.insert(nodes, {Type = "ELITE", Obj = obj})
        end
    end
    
    for _, obj in ipairs(shopNodes) do
        if obj:IsA("ImageButton") or obj:IsA("TextButton") then
            table.insert(nodes, {Type = "SHOP", Obj = obj})
        end
    end
    
    for _, obj in ipairs(restNodes) do
        if obj:IsA("ImageButton") or obj:IsA("TextButton") then
            table.insert(nodes, {Type = "REST", Obj = obj})
        end
    end
    
    return nodes
end

-- Detectar slots de posicionamento
local function GetPlacementSlots()
    local slots = {}
    local grid = FindByPath(CONFIG.UI_PATHS.PLACEMENT_GRID)
    
    if not grid then
        -- Fallback: procurar slots por cor
        local possibleSlots = FindByColor(CONFIG.COLORS.SLOT_EMPTY, 30)
        for _, obj in ipairs(possibleSlots) do
            if obj:IsA("ImageButton") or obj.Active then
                table.insert(slots, {Obj = obj, Occupied = false})
            end
        end
        return slots
    end
    
    for _, slot in ipairs(grid:GetChildren()) do
        if slot:IsA("ImageButton") then
            local occupied = slot.BackgroundColor3 and 
                           math.abs(slot.BackgroundColor3.R*255 - CONFIG.COLORS.SLOT_OCCUPIED.R*255) < 30
            
            table.insert(slots, {
                Obj = slot,
                Occupied = occupied
            })
        end
    end
    
    return slots
end

-- Detectar cartas para escolher
local function GetCardChoices()
    local container = FindByPath(CONFIG.UI_PATHS.CARD_CONTAINER)
    if not container or not IsVisible(container) then return {} end
    
    local cards = {}
    for _, obj in ipairs(container:GetDescendants()) do
        if obj:IsA("TextLabel") then
            table.insert(cards, {
                Text = obj.Text,
                Obj = obj
            })
        end
    end
    
    return cards
end

-- ============================================
-- ESTRATÉGIA SIMPLES (SEM "IA FALSA")
-- ============================================
local function ChooseBestCard(cards)
    local priorities = {
        ["limit break"] = 100,
        ["monarch"] = 95,
        ["all range"] = 90,
        ["elite"] = 85,
        ["rageful"] = 80,
        ["treasure"] = 75,
        ["critical"] = 70,
        ["double damage"] = 65,
        ["shield pen"] = 60,
        ["health"] = 50,
        ["speed"] = 45,
        ["range"] = 40,
        ["gold"] = 20,
        ["shield"] = 10
    }
    
    local bestCard = nil
    local bestPriority = -1
    
    for _, card in ipairs(cards) do
        for keyword, priority in pairs(priorities) do
            if card.Text:lower():find(keyword) then
                if priority > bestPriority then
                    bestPriority = priority
                    bestCard = card
                end
            end
        end
    end
    
    return bestCard
end

-- ============================================
-- LOOP PRINCIPAL (SIMPLES E FUNCIONAL)
-- ============================================
local active = false
local mainCoroutine = nil

local function MainLoop()
    while active do
        -- 1. Verificar cartas
        local cards = GetCardChoices()
        if #cards > 0 then
            local bestCard = ChooseBestCard(cards)
            if bestCard then
                ClickObject(bestCard.Obj)
                task.wait(CONFIG.DELAYS.AFTER_CLICK)
            end
        end
        
        -- 2. Verificar mapa
        local nodes = GetMapNodes()
        if #nodes > 0 then
            -- Prioridade: ELITE > BATTLE > SHOP > REST
            local priority = {"ELITE", "BATTLE", "SHOP", "REST"}
            for _, nodeType in ipairs(priority) do
                for _, node in ipairs(nodes) do
                    if node.Type == nodeType then
                        ClickObject(node.Obj)
                        task.wait(CONFIG.DELAYS.AFTER_CLICK)
                        break
                    end
                end
            end
        end
        
        -- 3. Verificar batalha
        local slots = GetPlacementSlots()
        local emptySlots = {}
        for _, slot in ipairs(slots) do
            if not slot.Occupied then
                table.insert(emptySlots, slot)
            end
        end
        
        if #emptySlots > 0 then
            -- Clicar nos slots vazios
            for _, slot in ipairs(emptySlots) do
                ClickObject(slot.Obj)
                task.wait(CONFIG.DELAYS.AFTER_PLACE)
            end
        end
        
        task.wait(CONFIG.DELAYS.TICK_RATE)
    end
end

-- ============================================
-- INTERFACE SIMPLES
-- ============================================
local function CreateGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "RomeHub"
    gui.Parent = Services.CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(1, -310, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
    frame.Parent = gui
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = "🔥 ATIVAR"
    btn.BackgroundColor3 = Color3.fromRGB(180, 30, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        
        if active then
            btn.Text = "⏹️ PARAR"
            btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            mainCoroutine = task.spawn(MainLoop)
        else
            btn.Text = "🔥 ATIVAR"
            btn.BackgroundColor3 = Color3.fromRGB(180, 30, 50)
            if mainCoroutine then
                task.cancel(mainCoroutine)
                mainCoroutine = nil
            end
        end
    end)
    
    -- Tecla X para toggle
    Services.UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.X then
            active = not active
            if active then
                mainCoroutine = task.spawn(MainLoop)
            elseif mainCoroutine then
                task.cancel(mainCoroutine)
                mainCoroutine = nil
            end
            btn.Text = active and "⏹️ PARAR" or "🔥 ATIVAR"
            btn.BackgroundColor3 = active and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(180, 30, 50)
        end
    end)
end

CreateGUI()
print("🔥 ROME HUB v7.0 - VERSÃO BRUTAL HONESTA")
print("✅ Simples, direto, sem firula")
print("⚠️ Configure os paths em CONFIG.UI_PATHS")
print("🎮 Pressione X para ativar/desativar")
