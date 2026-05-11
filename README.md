-- Anime Vanguards - Infinite Spin Script
-- Reseta rodada mantendo Trait Rerolls intactos

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

-- Configurações
local SPIN_HOTKEY = Enum.KeyCode.E -- Tecla para girar
local AUTO_RESET = true -- Reset automático após spin
local RESET_DELAY = 0.5 -- Delay antes de resetar (em segundos)

-- Função para obter os dados do jogador
local function getPlayerData()
    local playerData = player:FindFirstChild("PlayerData")
    return playerData
end

-- Função para salvar Trait Rerolls
local function saveTraitRerolls()
    local playerData = getPlayerData()
    if playerData then
        local stats = playerData:FindFirstChild("Stats")
        if stats then
            local traitRerolls = stats:FindFirstChild("TraitRerolls")
            if traitRerolls then
                return traitRerolls.Value
            end
        end
    end
    return 0
end

-- Função para restaurar Trait Rerolls
local function restoreTraitRerolls(amount)
    local playerData = getPlayerData()
    if playerData then
        local stats = playerData:FindFirstChild("Stats")
        if stats then
            local traitRerolls = stats:FindFirstChild("TraitRerolls")
            if traitRerolls then
                traitRerolls.Value = amount
            end
        end
    end
end

-- Função para resetar a rodada
local function resetWave()
    local remoteFolder = player:WaitForChild("PlayerData"):WaitForChild("Remotes")
    local resetRemote = remoteFolder:FindFirstChild("ResetWave")
    
    if resetRemote then
        resetRemote:FireServer()
    end
end

-- Função para fazer spin
local function performSpin()
    local traitRerolls = saveTraitRerolls()
    
    -- Executa o spin
    local remoteFolder = player:WaitForChild("PlayerData"):WaitForChild("Remotes")
    local spinRemote = remoteFolder:FindFirstChild("Spin")
    
    if spinRemote then
        spinRemote:FireServer()
        
        -- Aguarda e reseta
        if AUTO_RESET then
            wait(RESET_DELAY)
            resetWave()
            wait(0.2)
            restoreTraitRerolls(traitRerolls)
            print("✓ Wave resetada! Trait Rerolls mantidos: " .. traitRerolls)
        end
    end
end

-- Input para iniciar spin manual
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == SPIN_HOTKEY then
        performSpin()
    end
end)

print("✓ Script carregado!")
print("Pressione " .. tostring(SPIN_HOTKEY) .. " para girar com reset automático")
