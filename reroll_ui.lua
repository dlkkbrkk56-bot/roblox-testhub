-- SCRIPT REROLL INFINITO - VERSÃO DEFINITIVA
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ativo = false
local rerolls = 0

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RerollGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 130)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.4
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 100, 100)
frame.Parent = screenGui

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 35)
status.Position = UDim2.new(0, 0, 0, 5)
status.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
status.Text = "❌ INATIVO"
status.TextColor3 = Color3.fromRGB(255, 50, 50)
status.TextSize = 14
status.Font = Enum.Font.GothamBold
status.Parent = frame

local contador = Instance.new("TextLabel")
contador.Size = UDim2.new(1, 0, 0, 35)
contador.Position = UDim2.new(0, 0, 0, 45)
contador.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
contador.Text = "🎲 Rerolls: 0"
contador.TextColor3 = Color3.fromRGB(100, 255, 100)
contador.TextSize = 14
contador.Font = Enum.Font.Gotham
contador.Parent = frame

local dica = Instance.new("TextLabel")
dica.Size = UDim2.new(1, 0, 0, 25)
dica.Position = UDim2.new(0, 0, 0, 85)
dica.BackgroundTransparency = 1
dica.Text = "⚠️ Selecione uma unidade antes"
dica.TextColor3 = Color3.fromRGB(255, 200, 100)
dica.TextSize = 11
dica.Parent = frame

local botao = Instance.new("TextButton")
botao.Size = UDim2.new(0, 120, 0, 35)
botao.Position = UDim2.new(0.5, -60, 0, 108)
botao.Text = "🔴 ATIVAR"
botao.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
botao.TextColor3 = Color3.fromRGB(255, 255, 255)
botao.TextSize = 14
botao.Font = Enum.Font.GothamBold
botao.BorderSizePixel = 0
botao.Parent = frame

-- FUNÇÃO CORRIGIDA - Acha o botão Reroll
local function clicarReroll()
    -- Procura a janela Traits
    local windows = playerGui:FindFirstChild("Windows")
    if not windows then 
        dica.Text = "❌ Janela Windows não encontrada"
        return false 
    end
    
    local traits = windows:FindFirstChild("Traits")
    if not traits then 
        dica.Text = "❌ Abra a janela TRAITS!"
        return false 
    end
    
    -- Procura o botão Reroll (baseado no seu print)
    local rerollBtn = nil
    
    -- Busca em todos os lugares da janela Traits
    local function buscarBotao(objeto)
        for _, filho in ipairs(objeto:GetChildren()) do
            -- Verifica se é um botão (ImageButton ou TextButton)
            if filho:IsA("ImageButton") or filho:IsA("TextButton") then
                -- Pelo nome
                if filho.Name and filho.Name:lower() == "reroll" then
                    rerollBtn = filho
                    return true
                end
                -- Pelo texto (se tiver)
                if filho.Text and filho.Text:lower() == "reroll" then
                    rerollBtn = filho
                    return true
                end
            end
            -- Verifica filhos
            if buscarBotao(filho) then
                return true
            end
        end
        return false
    end
    
    buscarBotao(traits)
    
    if not rerollBtn then
        dica.Text = "🔴 Selecione uma UNIDADE primeiro!"
        return false
    end
    
    if not rerollBtn.Visible then
        dica.Text = "🔴 Botão não está visível!"
        return false
    end
    
    -- Clica!
    dica.Text = "🎯 Rerollando..."
    print("✅ Clicou no botão Reroll!")
    rerollBtn.MouseButton1Click:Fire()
    task.wait(2)
    return true
end

-- Loop principal
local function loopReroll()
    while ativo do
        status.Text = "🟡 PROCURANDO..."
        status.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        if clicarReroll() then
            rerolls = rerolls + 1
            contador.Text = "🎲 Rerolls: " .. rerolls
            
            status.Text = "🟢 REJOIN EM 3s"
            status.TextColor3 = Color3.fromRGB(0, 255, 0)
            dica.Text = "✅ Reroll " .. rerolls .. " concluído!"
            task.wait(3)
            
            -- Teleporta de volta
            TeleportService:Teleport(game.PlaceId, player)
            break
        else
            status.Text = "🔴 SELECIONE UNIDADE!"
            status.TextColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(2)
        end
    end
end

-- Liga/Desliga
local function alternar()
    ativo = not ativo
    
    if ativo then
        status.Text = "🟢 ATIVO"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
        botao.Text = "🔴 DESATIVAR"
        botao.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        dica.Text = "✅ Rodando... mantenha a tela"
        loopReroll()
    else
        status.Text = "🔴 INATIVO"
        status.TextColor3 = Color3.fromRGB(255, 50, 50)
        botao.Text = "🟢 ATIVAR"
        botao.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        dica.Text = "⚠️ Selecione uma unidade antes"
    end
end

botao.MouseButton1Click:Connect(alternar)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        alternar()
    end
end)

print("✅ SCRIPT CARREGADO!")
print("=" .. string.rep("=", 50))
print("📌 COMO USAR:")
print("1. Abra a janela TRAITS")
print("2. CLIQUE em uma UNIDADE")
print("3. Pressione E ou clique em ATIVAR")
print("=" .. string.rep("=", 50))
