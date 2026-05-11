-- SCRIPT CORRIGIDO - Só rejoin após clicar
local player = game.Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local ativo = false
local tentativas = 0

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RerollGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
frame.Parent = gui

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

local botao = Instance.new("TextButton")
botao.Size = UDim2.new(0, 120, 0, 35)
botao.Position = UDim2.new(0.5, -60, 0, 90)
botao.Text = "🔴 INICIAR"
botao.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
botao.TextColor3 = Color3.fromRGB(255, 255, 255)
botao.TextSize = 14
botao.Font = Enum.Font.GothamBold
botao.BorderSizePixel = 0
botao.Parent = frame

-- FUNÇÃO PARA CLICAR NO REROLL
local function clicarReroll()
    local windows = player.PlayerGui:FindFirstChild("Windows")
    if not windows then 
        status.Text = "❌ Janela Windows não encontrada"
        return false 
    end
    
    local traits = windows:FindFirstChild("Traits")
    if not traits then 
        status.Text = "❌ Abra a janela TRAITS!"
        return false 
    end
    
    -- Procura o botão Reroll
    for _, b in ipairs(traits:GetDescendants()) do
        if (b:IsA("ImageButton") or b:IsA("TextButton")) and b.Name and b.Name:lower() == "reroll" then
            if b.Visible then
                b.MouseButton1Click:Fire()
                print("✅ Clicou no Reroll!")
                return true
            end
        end
    end
    
    status.Text = "🔴 Selecione uma UNIDADE primeiro!"
    return false
end

-- LOOP PRINCIPAL (SÓ REJOIN DEPOIS DE CLICAR)
local function loopReroll()
    while ativo do
        -- Verifica se está na tela certa
        local windows = player.PlayerGui:FindFirstChild("Windows")
        if not windows or not windows:FindFirstChild("Traits") then
            status.Text = "❌ Abra a janela TRAITS"
            status.TextColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(2)
        else
            status.Text = "🟡 PRONTO PARA REROLLAR..."
            status.TextColor3 = Color3.fromRGB(255, 200, 0)
            
            -- TENTA CLICAR NO REROLL
            local clicou = clicarReroll()
            
            if clicou then
                tentativas = tentativas + 1
                tentativasLabel.Text = "🎲 Tentativas: " .. tentativas
                
                -- SÓ DÁ REJOIN SE CLICOU!
                status.Text = "🔄 REJOIN EM 1s..."
                status.TextColor3 = Color3.fromRGB(0, 255, 255)
                task.wait(1)
                
                print("🔄 Dando rejoin após " .. tentativas .. " tentativas")
                TeleportService:Teleport(game.PlaceId, player)
                break -- Sai do loop porque vai teleportar
            else
                -- Não clicou: espera e tenta de novo (SEM REJOIN)
                status.TextColor3 = Color3.fromRGB(255, 0, 0)
                task.wait(2)
            end
        end
    end
end

-- LIGA/DESLIGA
local function alternar()
    ativo = not ativo
    
    if ativo then
        status.Text = "🟢 ATIVO - Pronto!"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
        botao.Text = "🔴 PARAR"
        botao.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        tentativas = 0
        tentativasLabel.Text = "🎲 Tentativas: 0"
        loopReroll()
    else
        status.Text = "❌ PARADO"
        status.TextColor3 = Color3.fromRGB(255, 50, 50)
        botao.Text = "🔴 INICIAR"
        botao.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
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
print("✅ SCRIPT CORRIGIDO!")
print("📌 SÓ DÁ REJOIN DEPOIS QUE CLICAR NO REROLL")
print("=" .. string.rep("=", 60))
