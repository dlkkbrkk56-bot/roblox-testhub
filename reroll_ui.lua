-- Anime Vanguards - Infinite Reroll COM INTERFACE VISUAL
-- Script profissional com GUI completa

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========== VARIÁVEIS GLOBAIS ==========
local IS_ACTIVE = false
local REROLL_COUNT = 0
local HOTKEY = Enum.KeyCode.E
local REROLL_SPEED = 1 -- Velocidade em segundos
local REJOIN_DELAY = 5 -- Delay antes de rejoin

-- ========== CRIAR INTERFACE ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RerollScriptUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== PAINEL PRINCIPAL ==========
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 350, 0, 400)
mainPanel.Position = UDim2.new(0, 20, 0, 100)
mainPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainPanel.BorderColor3 = Color3.fromRGB(100, 150, 255)
mainPanel.BorderSizePixel = 3
mainPanel.Parent = screenGui

-- ========== TITULO ==========
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 50, 100)
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Text = "🎮 REROLL SCRIPT"
title.Parent = mainPanel

-- ========== STATUS ==========
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(0.8, 0, 0, 30)
statusLabel.Position = UDim2.new(0.1, 0, 0.12, 0)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 18
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = "⛔ INATIVO"
statusLabel.Parent = mainPanel

-- ========== CONTADOR ==========
local counterLabel = Instance.new("TextLabel")
counterLabel.Name = "Counter"
counterLabel.Size = UDim2.new(0.8, 0, 0, 35)
counterLabel.Position = UDim2.new(0.1, 0, 0.23, 0)
counterLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
counterLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
counterLabel.TextSize = 20
counterLabel.Font = Enum.Font.GothamBold
counterLabel.Text = "📊 Rerolls: 0"
counterLabel.Parent = mainPanel

-- ========== BOTÃO ON/OFF ==========
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.8, 0, 0, 50)
toggleButton.Position = UDim2.new(0.1, 0, 0.37, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "LIGAR SCRIPT (E)"
toggleButton.Parent = mainPanel

-- ========== DIVISOR ==========
local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.new(0.8, 0, 0, 2)
divider.Position = UDim2.new(0.1, 0, 0.54, 0)
divider.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
divider.BorderSizePixel = 0
divider.Parent = mainPanel

-- ========== LABEL VELOCIDADE ==========
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(0.8, 0, 0, 25)
speedLabel.Position = UDim2.new(0.1, 0, 0.59, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "⚡ Velocidade: " .. REROLL_SPEED .. "s"
speedLabel.Parent = mainPanel

-- ========== BOTÕES VELOCIDADE ==========
local speedDownButton = Instance.new("TextButton")
speedDownButton.Name = "SpeedDown"
speedDownButton.Size = UDim2.new(0.35, 0, 0, 30)
speedDownButton.Position = UDim2.new(0.1, 0, 0.66, 0)
speedDownButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
speedDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDownButton.TextSize = 14
speedDownButton.Font = Enum.Font.Gotham
speedDownButton.Text = "➖ Mais Lento"
speedDownButton.Parent = mainPanel

local speedUpButton = Instance.new("TextButton")
speedUpButton.Name = "SpeedUp"
speedUpButton.Size = UDim2.new(0.35, 0, 0, 30)
speedUpButton.Position = UDim2.new(0.55, 0, 0.66, 0)
speedUpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
speedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUpButton.TextSize = 14
speedUpButton.Font = Enum.Font.Gotham
speedUpButton.Text = "➕ Mais Rápido"
speedUpButton.Parent = mainPanel

-- ========== INFO ==========
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "Info"
infoLabel.Size = UDim2.new(0.9, 0, 0, 60)
infoLabel.Position = UDim2.new(0.05, 0, 0.80, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.Text = "💡 Dica: Abra a janela de Traits antes de ativar o script!\n\n✓ Hotkey: E\n✓ Clique nos botões para customizar"
infoLabel.Parent = mainPanel

-- ========== FUNÇÕES DA UI ==========
local function updateStatus()
    if IS_ACTIVE then
        statusLabel.Text = "✅ ATIVO"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        toggleButton.Text = "DESLIGAR SCRIPT (E)"
    else
        statusLabel.Text = "⛔ INATIVO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        toggleButton.Text = "LIGAR SCRIPT (E)"
    end
end

local function updateCounter()
    counterLabel.Text = "📊 Rerolls: " .. REROLL_COUNT
end

local function updateSpeed()
    speedLabel.Text = "⚡ Velocidade: " .. REROLL_SPEED .. "s"
end

-- ========== NOTIFICAÇÕES ==========
local function showNotification(message, color)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0.8, 0, 0, 40)
    notif.Position = UDim2.new(0.1, 0, 0, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(100, 200, 100)
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextSize = 14
    notif.Font = Enum.Font.Gotham
    notif.Text = message
    notif.Parent = mainPanel
    
    game:GetService("Debris"):AddItem(notif, 3)
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
    showNotification("✅ Reroll executado!", Color3.fromRGB(100, 255, 100))
    return true
end

-- ========== FUNÇÃO PARA REJOIN ==========
local function rejoinGame()
    showNotification("🔄 Rejoinando...", Color3.fromRGB(200, 200, 100))
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
            updateCounter()
            
            rejoinGame()
            
            wait(REJOIN_DELAY)
        else
            showNotification("❌ Erro ao clicar no reroll!", Color3.fromRGB(255, 100, 100))
            IS_ACTIVE = false
            updateStatus()
            break
        end
    end
end

-- ========== EVENTOS DOS BOTÕES ==========
toggleButton.MouseButton1Click:Connect(function()
    IS_ACTIVE = not IS_ACTIVE
    updateStatus()
    
    if IS_ACTIVE then
        showNotification("🚀 Script ativado!", Color3.fromRGB(100, 255, 100))
        infiniteRerollWithRejoin()
    else
        showNotification("⛔ Script desativado!", Color3.fromRGB(255, 100, 100))
    end
end)

speedDownButton.MouseButton1Click:Connect(function()
    if REROLL_SPEED > 0.5 then
        REROLL_SPEED = REROLL_SPEED - 0.5
        updateSpeed()
        showNotification("📉 Velocidade reduzida", Color3.fromRGB(100, 200, 255))
    end
end)

speedUpButton.MouseButton1Click:Connect(function()
    if REROLL_SPEED < 5 then
        REROLL_SPEED = REROLL_SPEED + 0.5
        updateSpeed()
        showNotification("📈 Velocidade aumentada", Color3.fromRGB(100, 200, 255))
    end
end)

-- ========== HOTKEY ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == HOTKEY then
        toggleButton:TriggerEvent("MouseButton1Click")
    end
end)

-- ========== ANIMAÇÃO HOVER ==========
toggleButton.MouseEnter:Connect(function()
    if IS_ACTIVE then
        toggleButton.BackgroundColor3 = Color3.fromRGB(70, 170, 70)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 70, 70)
    end
end)

toggleButton.MouseLeave:Connect(function()
    if IS_ACTIVE then
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    end
end)

speedDownButton.MouseEnter:Connect(function()
    speedDownButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
end)

speedDownButton.MouseLeave:Connect(function()
    speedDownButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

speedUpButton.MouseEnter:Connect(function()
    speedUpButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
end)

speedUpButton.MouseLeave:Connect(function()
    speedUpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

-- ========== INICIALIZAÇÃO ==========
updateStatus()
updateCounter()
updateSpeed()

showNotification("✅ Interface carregada!", Color3.fromRGB(100, 255, 100))

print("\n" .. string.rep("=", 70))
print("✅ ANIME VANGUARDS - REROLL SCRIPT COM INTERFACE")
print("=" .. string.rep("=", 70))
print("\n🎮 INTERFACE CRIADA COM SUCESSO!")
print("\n📋 FUNCIONALIDADES:")
print("✓ Botão ON/OFF visual")
print("✓ Contador de rerolls em tempo real")
print("✓ Status do script (Ativo/Inativo)")
print("✓ Controle de velocidade")
print("✓ Notificações visuais")
print("✓ Hotkey customizável (E)")
print("\n" .. string.rep("=", 70) .. "\n")
