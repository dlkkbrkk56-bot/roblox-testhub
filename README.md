-- Anime Vanguards - Infinite Reroll com Rejoin
-- Faz reroll -> Sai do jogo -> Entra de novo -> Rerolls restaurados
-- Pity continua contando

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local playerData = player:WaitForChild("PlayerData")

-- ========== CONFIGURAÇÕES ==========
local HOTKEY = Enum.KeyCode.E
local IS_ACTIVE = false
local REROLL_DELAY = 0.5
local REJOIN_DELAY = 5 -- Tempo para esperar antes de entrar de novo

-- ========== FUNÇÃO PARA CLICAR NO BOTÃO REROLL ==========
local function clickRerollButton()
    local traitsGui = playerGui:FindFirstChild("TraitsGui")
    if not traitsGui then
        print("❌ TraitsGui não encontrada!")
        return false
    end
    
    local rerollButton = nil
    for _, child in ipairs(traitsGui:GetDescendants()) do
        if (child:IsA("TextButton") and child.Text == "Reroll") or child.Name == "Reroll" then
            rerollButton = child
            break
        end
    end
    
    if not rerollButton or not rerollButton.Visible then
        print("❌ Botão Reroll não encontrado!")
        return false
    end
    
    -- Clica no botão
    rerollButton.MouseButton1Click:Fire()
    print("✓ Reroll executado!")
    return true
end

-- ========== FUNÇÃO PARA SAIR E ENTRAR NOVAMENTE ==========
local function rejoinGame()
    print("🔄 Saindo do jogo...")
    
    -- Aguarda um pouco para o reroll ser processado
    wait(REROLL_DELAY)
    
    -- Obtém informações do jogo atual
    local placeId = game.PlaceId
    local jobId = game.JobId
    
    print("⏳ Aguardando " .. REJOIN_DELAY .. " segundos antes de entrar...")
    wait(REJOIN_DELAY)
    
    -- Sai do jogo
    Players:LeaveGame()
    
    -- Aguarda um pouco e entra de novo no mesmo jogo
    wait(2)
    TeleportService:Teleport(placeId, player)
end

-- ========== FUNÇÃO PRINCIPAL ==========
local function infiniteRerollWithRejoin()
    local rerollCount = 0
    
    while IS_ACTIVE do
        -- Clica no reroll
        if clickRerollButton() then
            rerollCount = rerollCount + 1
            print("📊 Rerolls executados: " .. rerollCount)
            
            -- Rejoin
            rejoinGame()
            
            -- Aguarda reconexão (o script continuará quando reiniciar)
            wait(10)
        else
            print("⚠️ Erro ao executar reroll!")
            IS_ACTIVE = false
            break
        end
    end
end

-- ========== HOTKEY ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == HOTKEY then
        IS_ACTIVE = not IS_ACTIVE
        
        if IS_ACTIVE then
            print("🚀 SCRIPT ATIVADO!")
            print("✓ Iniciando reroll + rejoin infinito...")
            infiniteRerollWithRejoin()
        else
            print("⛔ SCRIPT DESATIVADO!")
        end
    end
end)

print("=" .. string.rep("=", 60))
print("🎮 INFINITE TRAIT REROLL COM REJOIN - SCRIPT CARREGADO")
print("=" .. string.rep("=", 60))
print()
print("📋 O que o script faz:")
print("1. Clica no botão 'Reroll'")
print("2. Aguarda processamento do reroll")
print("3. Sai do jogo (rejoin)")
print("4. Entra de novo automático")
print("5. Os rerolls voltam, MAS o Pity continua contando")
print("6. Repete infinitamente")
print()
print("⚙️ CONFIGURAÇÕES:")
print("Hotkey: " .. tostring(HOTKEY) .. " (ligar/desligar)")
print("Delay rejoin: " .. REJOIN_DELAY .. " segundos")
print()
print("=" .. string.rep("=", 60))
