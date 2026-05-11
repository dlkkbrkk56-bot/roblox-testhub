-- SCRIPT DE FARM DE TRAITS - PROCURA MONARCH
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ativo = false
local tentativas = 0
local TRAIT_DESEJADA = "Monarch"  -- << TRAIT QUE VOCÊ QUER

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TraitFarmGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.4
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
frame.Parent = screenGui

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 35)
status.Position = UDim2.new(0, 0, 0, 5)
status.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
status.Text = "❌ PARADO"
status.TextColor3 = Color3.fromRGB(255, 50, 50)
status.TextSize = 14
status.Font = Enum.Font.GothamBold
status.Parent = frame

local tentativasLabel = Instance.new("TextLabel")
tentativasLabel.Size = UDim2.new(1, 0, 0, 35)
tentativasLabel.Position = UDim2.new(0, 0, 0, 45)
tentativasLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
tentativasLabel.Text = "🎲 Tentativas: 0"
tentativasLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
tentativasLabel.TextSize = 14
tentativasLabel.Font = Enum.Font.Gotham
tentativasLabel.Parent = frame

local alvoLabel = Instance.new("TextLabel")
alvoLabel.Size = UDim2.new(1, 0, 0, 25)
alvoLabel.Position = UDim2.new(0, 0, 0, 85)
alvoLabel.BackgroundTransparency = 1
alvoLabel.Text = "🎯 Procurando: MONARCH"
alvoLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
alvoLabel.TextSize = 12
alvoLabel.Parent = frame

local botao = Instance.new("TextButton")
botao.Size = UDim2.new(0, 120, 0, 35)
botao.Position = UDim2.new(0.5, -60, 0, 115)
botao.Text = "🔴 INICIAR"
botao.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
botao.TextColor3 = Color3.fromRGB(255, 255, 255)
botao.TextSize = 14
botao.Font = Enum.Font.GothamBold
botao.BorderSizePixel = 0
botao.Parent = frame

-- FUNÇÃO PARA VERIFICAR SE APARECEU MONARCH
local function verificarTrait()
    local windows = playerGui:FindFirstChild("Windows")
    if not windows then return false end
    
    local traits = windows:FindFirstChild("Traits")
    if not traits then return false end
    
    -- Procura o texto da trait atual
    local textoEncontrado = nil
    
    local function buscarTexto(objeto)
        for _, filho in ipairs(objeto:GetChildren()) do
            if filho:IsA("TextLabel") or filho:IsA("TextButton") then
                if filho.Text and (string.find(filho.Text, "Monarch") or string.find(filho.Text, "MONARCH")) then
                    textoEncontrado = filho.Text
                    return true
                end
            end
            if buscarTexto(filho) then
                return true
            end
        end
        return false
    end
    
    buscarTexto(traits)
    
    if textoEncontrado then
        print("🎉 TRAIT ENCONTRADA: " .. textoEncontrado)
        return true
    end
    return false
end

-- FUNÇÃO PARA CLICAR NO REROLL
local function clicarReroll()
    local windows = playerGui:FindFirstChild("Windows")
    if not windows then return false end
    
    local traits = windows:FindFirstChild("Traits")
    if not traits then return false end
    
    local rerollBtn = nil
    
    local function buscarBotao(objeto)
        for _, filho in ipairs(objeto:GetChildren()) do
            if (filho:IsA("ImageButton") or filho:IsA("TextButton")) and filho.Name and filho.Name:lower() == "reroll" then
                rerollBtn = filho
                return true
            end
            if buscarBotao(filho) then
                return true
            end
        end
        return false
    end
    
    buscarBotao(traits)
    
    if not rerollBtn or not rerollBtn.Visible then
        return false
    end
    
    rerollBtn.MouseButton1Click:Fire()
    task.wait(1) -- Aguarda o resultado do reroll
    return true
end

-- LOOP PRINCIPAL
local function loopBuscarMonarch()
    while ativo do
        status.Text = "🟡 TESTANDO REROLL..."
        status.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        -- Clica no reroll
        if clicarReroll() then
            tentativas = tentativas + 1
            tentativasLabel.Text = "🎲 Tentativas: " .. tentativas
            
            -- Espera aparecer a nova trait
            task.wait(1.5)
            
            -- Verifica se achou Monarch
            if verificarTrait() then
                -- ACHOU! Para o script e avisa
                status.Text = "🎉 MONARCH ENCONTRADA! 🎉"
                status.TextColor3 = Color3.fromRGB(0, 255, 0)
                alvoLabel.Text = "✅ MONARCH ENCONTRADA! Script parou."
                print("🎉🎉🎉 TRAIT MONARCH ENCONTRADA! 🎉🎉🎉")
                ativo = false
                botao.Text = "🔴 INICIAR"
                botao.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                break
            else
                -- Não achou -> REJOIN para voltar com os mesmos rerolls
                status.Text = "🔄 NÃO FOI MONARCH - REJOIN..."
                status.TextColor3 = Color3.fromRGB(255, 100, 0)
                task.wait(1)
                
                -- Dá rejoin (volta com os mesmos rerolls)
                TeleportService:Teleport(game.PlaceId, player)
                break -- Sai do loop pois vai teleportar
            end
        else
            status.Text = "❌ Abra TRAITS e selecione unidade!"
            status.TextColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(2)
        end
    end
end

-- LIGA/DESLIGA
local function alternar()
    ativo = not ativo
    
    if ativo then
        status.Text = "🟢 PROCURANDO MONARCH..."
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
        botao.Text = "🔴 PARAR"
        botao.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        alvoLabel.Text = "🎯 Procurando: MONARCH"
        tentativas = 0
        tentativasLabel.Text = "🎲 Tentativas: 0"
        loopBuscarMonarch()
    else
        status.Text = "❌ PARADO"
        status.TextColor3 = Color3.fromRGB(255, 50, 50)
        botao.Text = "🔴 INICIAR"
        botao.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        alvoLabel.Text = "⚠️ Script parado"
    end
end

botao.MouseButton1Click:Connect(alternar)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        alternar()
    end
end)

print("=" .. string.rep("=", 60))
print("🎯 SCRIPT DE FARM DE TRAITS - PROCURANDO MONARCH")
print("=" .. string.rep("=", 60))
print("📌 COMO FUNCIONA:")
print("   1. Abra a janela TRAITS e selecione uma unidade")
print("   2. Ative o script (E ou botão)")
print("   3. Ele vai clicar em REROLL")
print("   4. Se NÃO for MONARCH -> REJOIN (rerolls voltam)")
print("   5. Se for MONARCH -> Para automaticamente!")
print("=" .. string.rep("=", 60))
