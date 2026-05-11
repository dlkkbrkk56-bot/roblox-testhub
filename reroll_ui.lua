-- Anime Vanguards - Infinite Reroll com Interface Visual
-- Script completo com GUI bonita

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========== VARIÁVEIS GLOBAIS ==========
local HOTKEY = Enum.KeyCode.E
local IS_ACTIVE = false
local REROLL_COUNT = 0
local REROLL_SPEED = 0.5
local scriptGui = nil
local statusLabel = nil
local counterLabel = nil

-- ========== FUNÇÃO PARA CRIAR INTERFACE ==========
local function createInterface()
    -- Cria ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RerollScriptUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    mainFrame.BorderColor3 = Color3.fromRGB(100, 150, 255)
    mainFrame.BorderSizePixel = 2
    mainFrame.Parent = screenGui
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
    titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    titleLabel.TextSize = 14
    titleLabel.Text = "🎮 REROLL INFINITO"
    titleLabel.BorderSizePixel = 0
    titleLabel.Parent = mainFrame
    
    -- Status Label
    statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(1, -10, 0, 25)
    statusLabel.Position = UDim2.new(0, 5, 0, 35)
    statusLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    statusLabel.TextSize = 12
    statusLabel.Text = "⛔ INATIVO"
    statusLabel.BorderSizePixel = 0
    statusLabel.Parent = mainFrame
    
    -- Counter Label
    counterLabel = Instance.new("TextLabel")
    counterLabel.Name = "Counter"
    counterLabel.Size = UDim2.new(1, -10, 0, 25)
    counterLabel.Position = UDim2.new(0, 5, 0, 65)
    counterLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    counterLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    counterLabel.TextSize = 12
    counterLabel.Text = "📊 Rerolls: 0"
    counterLabel.BorderSizePixel = 0
    counterLabel.Parent = mainFrame
    
    -- Botão ON/OFF
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, -10, 0, 35)
    toggleButton.Position = UDim2.new(0, 5, 0, 95)
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 12
    toggleButton.Text = "LIGAR SCRIPT"
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = mainFrame
    
    -- Efeito hover no botão
    toggleButton.MouseEnter:Connect(function()
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    end)
    
    toggleButton.MouseLeave:Connect(function()
        if IS_ACTIVE then
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
    
    toggleButton.MouseButton1Click:Connect(function()
        IS_ACTIVE = not IS_ACTIVE
        updateUI()
    end)
    
    scriptGui = screenGui
    return screenGui
end

-- ========== FUNÇÃO PARA ATUALIZAR INTERFACE ==========
function updateUI()
    if statusLabel then
        if IS_ACTIVE then
            statusLabel.TextColor3 = Color3.fromRGB(50, 200, 50)
            statusLabel.Text = "✅ ATIVO"
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            toggleButton.Text = "DESLIGAR SCRIPT"
        else
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            statusLabel.Text = "⛔ INATIVO"
            toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            toggleButton.Text = "LIGAR SCRIPT"
        end
    end
    
    if counterLabel then
        counterLabel.Text = "📊 Rerolls: " .. REROLL_COUNT
    end
end

-- ========== FUNÇÃO PARA CLICAR NO REROLL ==========
local function clickRerollButton()
    local windows = playerGui:FindFirstChild("Windows")
    if not windows then return false end
    
    local crafting = windows:FindFirstChild("Crafting")
    if not crafting then return false end
    
    local holder = crafting:FindFirstChild("Holder")
    if not holder then return false end
    
    local rerollButton = holder:FindFirstChild("Reroll")
    if not rerollButton then
        for _, child in ipairs(holder:GetDescendants()) do
            if child:IsA("TextButton") and child.Text == "Reroll" then
                rerollButton = child
                break
            end
        end
    end
    
    if not rerollButton or not rerollButton.Visible then
        return false
    end
    
    rerollButton.MouseButton1Click:Fire()
    return true
end

-- ========== FUNÇÃO PARA REJOIN ==========
local function rejoinGame()
    wait(1)
    local placeId = game.PlaceId
    Players:LeaveGame()
    wait(3)
    TeleportService:Teleport(placeId, player)
end

-- ========== LOOP INFINITO ==========
local function infiniteRerollWithRejoin()
    while IS_ACTIVE do
        if clickRerollButton() then
            REROLL_COUNT = REROLL_COUNT + 1
            updateUI()
            rejoinGame()
            wait(15)
        else
            IS_ACTIVE = false
            updateUI()
            break
        end
    end
end

-- ========== HOTKEY ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == HOTKEY then
        IS_ACTIVE = not IS_ACTIVE
        updateUI()
        
        if IS_ACTIVE then
            infiniteRerollWithRejoin()
        end
    end
end)

-- ========== INICIALIZAÇÃO ==========
createInterface()
updateUI()

print("\n" .. string.rep("=", 70))
print("✅ SCRIPT CARREGADO COM SUCESSO!")
print("=" .. string.rep("=", 70))
print("\n📋 INSTRUÇÕES:")
print("1. Uma interface aparecerá no canto superior esquerdo")
print("2. Clique no botão ou pressione E para ligar/desligar")
print("3. Mantenha a janela de Traits aberta")
print("4. O script fará reroll -> rejoin -> reroll...")
print("\n⌨️ Hotkey: E")
print("=" .. string.rep("=", 70) .. "\n")
