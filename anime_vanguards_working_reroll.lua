-- Anime Vanguards - Infinite Reroll (VERSÃO CORRIGIDA)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========== CONFIGURAÇÕES ==========
local HOTKEY = Enum.KeyCode.E
local IS_ACTIVE = false
local REROLL_COUNT = 0

-- ========== FUNÇÃO PARA CLICAR NO REROLL ==========
local function clickRerollButton()
    -- Procura em Windows > Crafting > Holder
    local windows = playerGui:FindFirstChild("Windows")
    if not windows then
        warn("❌ Windows não encontrada!")
        return false
    end
    
    local crafting = windows:FindFirstChild("Crafting")
    if not crafting then
        warn("❌ Crafting não encontrada!")
        return false
    end
    
    local holder = crafting:FindFirstChild("Holder")
    if not holder then
        warn("❌ Holder não encontrada!")
        return false
    end
    
    -- Procura o botão Reroll
    local rerollButton = holder:FindFirstChild("Reroll")
    if not rerollButton then
        warn("❌ Botão Reroll não encontrado em Holder!")
        -- Tenta procurar em outro lugar
        for _, child in ipairs(holder:GetDescendants()) do
            if child:IsA("TextButton") and child.Text == "Reroll" then
                rerollButton = child
                break
            end
        end
    end
    
    if not rerollButton then
        warn("❌ Reroll não encontrado!")
        return false
    end
    
    -- Verifica se está visível
    if not rerollButton.Visible then
        warn("⚠️ Botão Reroll não está visível!")
        return false
    end
    
    -- Clica no botão
    rerollButton.MouseButton1Click:Fire()
    print("✅ Reroll clicado!")
    return true
end

-- ========== FUNÇÃO PARA REJOIN ==========
local function rejoinGame()
    print("🔄 Preparando rejoin...")
    wait(1) -- Aguarda o reroll ser processado
    
    local placeId = game.PlaceId
    print("📍 PlaceId: " .. placeId)
    
    print("🚪 Saindo do jogo...")
    Players:LeaveGame()
    
    wait(3)
    
    print("🚀 Entrando novamente...")
    TeleportService:Teleport(placeId, player)
end

-- ========== LOOP INFINITO ==========
local function infiniteRerollWithRejoin()
    while IS_ACTIVE do
        print("\n--- INICIANDO CICLO " .. (REROLL_COUNT + 1) .. " ---")
        
        if clickRerollButton() then
            REROLL_COUNT = REROLL_COUNT + 1
            print("📊 Rerolls feitos: " .. REROLL_COUNT)
            
            rejoinGame()
            
            -- Aguarda reconexão
            print("⏳ Aguardando reconexão (15s)...")
            wait(15)
        else
            print("❌ Erro ao clicar no reroll!")
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
            print("\n" .. string.rep("=", 70))
            print("🎮 INFINITE REROLL COM REJOIN - ATIVADO!")
            print("=" .. string.rep("=", 70))
            print("✓ Janela de Traits deve estar ABERTA")
            print("✓ Script vai fazer loops de Reroll -> Rejoin")
            print("=" .. string.rep("=", 70) .. "\n")
            infiniteRerollWithRejoin()
        else
            print("\n⛔ SCRIPT PARADO!")
            print("Total de rerolls: " .. REROLL_COUNT .. "\n")
        end
    end
end)

print("\n" .. string.rep("=", 70))
print("✅ SCRIPT CARREGADO!")
print("=" .. string.rep("=", 70))
print("\n📋 COMO USAR:")
print("1. Abra a janela de Traits (clique em Crafting)")
print("2. Pressione E para iniciar")
print("3. Script vai clicar em Reroll -> Sair -> Entrar novamente")
print("4. Pressione E para parar")
print("\n⌨️ Hotkey: E")
print("=" .. string.rep("=", 70) .. "\n")
