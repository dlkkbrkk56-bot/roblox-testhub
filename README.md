-- SCRIPT COM SEGURANÇA - Testa antes de gastar recursos
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ativo = false
local rerolls = 0

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RerollSafeGUI"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.4
frame.Parent = screenGui

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0, 5)
status.Text = "❌ INATIVO"
status.TextColor3 = Color3.fromRGB(255, 0, 0)
status.Parent = frame

local contador = Instance.new("TextLabel")
contador.Size = UDim2.new(1, 0, 0, 30)
contador.Position = UDim2.new(0, 0, 0, 35)
contador.Text = "Rerolls: 0"
contador.TextColor3 = Color3.fromRGB(255, 255, 255)
contador.Parent = frame

local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, 0, 0, 30)
warningLabel.Position = UDim2.new(0, 0, 0, 65)
warningLabel.Text = "⚠️ Mantenha na tela de Traits"
warningLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
warningLabel.TextSize = 10
warningLabel.Parent = frame

local botao = Instance.new("TextButton")
botao.Size = UDim2.new(0, 100, 0, 30)
botao.Position = UDim2.new(0.5, -50, 0, 95)
botao.Text = "ATIVAR"
botao.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
botao.Parent = frame

-- Verifica se está na tela certa antes de clicar
local function verificarTelaReroll()
    local windows = playerGui:FindFirstChild("Windows")
    if not windows then return false, "Janela Windows não encontrada" end
    
    local traits = windows:FindFirstChild("Traits")
    if not traits then return false, "Janela Traits não encontrada - Abra a janela de Traits primeiro!" end
    
    local rerollBtn = nil
    for _, btn in ipairs(traits:GetDescendants()) do
        if btn:IsA("TextButton") and btn.Text:lower():find("reroll") then
            rerollBtn = btn
            break
        end
    end
    
    if not rerollBtn then return false, "Botão Reroll não encontrado" end
    return true, rerollBtn
end

-- Função segura de reroll
local function fazerReroll()
    local sucesso, resultado = verificarTelaReroll()
    
    if not sucesso then
        warn("⚠️ " .. resultado)
        return false
    end
    
    local rerollBtn = resultado
    
    -- Verifica se o botão está visível e habilitado
    if not rerollBtn.Visible then
        warn("⚠️ Botão Reroll não está visível")
        return false
    end
    
    print("✅ Reroll encontrado! Executando...")
    rerollBtn.MouseButton1Click:Fire()
    
    -- Aguarda o reroll acontecer
    task.wait(2)
    
    return true
end

-- Loop principal
local function loopReroll()
    while ativo do
        status.Text = "🔄 PROCURANDO..."
        status.TextColor3 = Color3.fromRGB(255, 255, 0)
        
        local sucesso = fazerReroll()
        
        if sucesso then
            rerolls = rerolls + 1
            contador.Text = "Rerolls: " .. rerolls
            
            status.Text = "⏳ REJOIN EM 3s..."
            task.wait(3)
            
            -- Teleporta
            TeleportService:Teleport(game.PlaceId, player)
            break -- Sai do loop pois vai teleportar
        else
            status.Text = "❌ ERRO - Abra a janela Traits!"
            status.TextColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(2)
            ativo = false
            status.Text = "❌ INATIVO"
            botao.Text = "ATIVAR"
            botao.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        end
    end
end

-- Controles
botao.MouseButton1Click:Connect(function()
    if ativo then
        ativo = false
        status.Text = "❌ INATIVO"
        status.TextColor3 = Color3.fromRGB(255, 0, 0)
        botao.Text = "ATIVAR"
        botao.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        -- Verifica se está na tela certa antes de ativar
        local sucesso, msg = verificarTelaReroll()
        if sucesso then
            ativo = true
            status.Text = "✅ ATIVO"
            status.TextColor3 = Color3.fromRGB(0, 255, 0)
            botao.Text = "DESATIVAR"
            botao.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            loopReroll()
        else
            status.Text = "⚠️ " .. msg
            status.TextColor3 = Color3.fromRGB(255, 165, 0)
            task.wait(2)
            status.Text = "❌ INATIVO"
            status.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        botao.MouseButton1Click:Fire()
    end
end)

print("✅ SCRIPT SEGURO CARREGADO!")
print("📌 IMPORTANTE: Abra a janela de TRAITS antes de ativar!")
