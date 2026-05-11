-- BASKETBALL ZERO - SCRIPT CORRIGIDO (FUNCIONANDO)
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")

-- ========== VARIÁVEIS ==========
local ativo = false

-- ========== GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BBZScript"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 160)
frame.Position = UDim2.new(0.5, -140, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
title.Text = "🏀 BBZ SCRIPT 🏀"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 0, 35)
statusText.Position = UDim2.new(0, 10, 0, 55)
statusText.Text = "⚡ DESATIVADO"
statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
statusText.TextSize = 14
statusText.Font = Enum.Font.GothamBold
statusText.Parent = frame

local btnAtivar = Instance.new("TextButton")
btnAtivar.Size = UDim2.new(0, 160, 0, 40)
btnAtivar.Position = UDim2.new(0.5, -80, 0, 105)
btnAtivar.Text = "🏀 ATIVAR"
btnAtivar.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
btnAtivar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAtivar.TextSize = 14
btnAtivar.Font = Enum.Font.GothamBold
btnAtivar.Parent = frame

-- ========== FUNÇÕES ==========

-- Encontra a cesta adversária (procura por cor vermelha)
local function encontrarCesta()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Procura por partes com cor vermelha (time adversário)
            if part.BrickColor and (part.BrickColor.Name:lower():find("red") or part.BrickColor.Name:lower():find("crimson") or part.BrickColor.Name:lower():find("bright red")) then
                -- Verifica se é uma estrutura de cesta (tamanho Y > 3)
                if part.Size.Y > 3 and part.Size.Y < 10 then
                    return part
                end
            end
            -- Tenta por nome
            local nome = part.Name:lower()
            if nome:find("hoop") or nome:find("basket") or nome:find("rim") then
                return part
            end
        end
    end
    return nil
end

-- Verifica se tem a bola (pela animação ou parte)
local function temBola()
    if not player.Character then return false end
    
    -- Verifica se o Humanoid está com bola
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid:FindFirstChild("Ball") then
        return true
    end
    
    -- Verifica se tem bola como parte do corpo
    for _, part in ipairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("ball") or part.Name:lower():find("bola")) then
            return true
        end
    end
    return false
end

-- Simula clique na tela (posição atual do mouse)
local function clicarArremesso()
    -- Simula pressionar o botão esquerdo
    VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, Enum.UserInputState.Begin, Vector2.new(500, 500))
    task.wait(0.2)
    VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, Enum.UserInputState.End, Vector2.new(500, 500))
end

-- Arremessar
local function arremessar()
    local cesta = encontrarCesta()
    if not cesta then
        statusText.Text = "🔍 CESTA NÃO ENCONTRADA"
        return false
    end
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    -- Mira na cesta
    local playerPos = player.Character.HumanoidRootPart.Position
    local cestaPos = cesta.Position
    local lookAt = CFrame.lookAt(playerPos, cestaPos + Vector3.new(0, 2, 0))
    player.Character.HumanoidRootPart.CFrame = lookAt
    
    -- Arremessa
    clicarArremesso()
    
    statusText.Text = "🏀 ARREMESSOU!"
    return true
end

-- Loop principal
local function loop()
    while ativo do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if temBola() then
                arremessar()
                task.wait(0.8)
            else
                statusText.Text = "⚡ PROCURANDO BOLA..."
                task.wait(0.5)
            end
        else
            task.wait(0.5)
        end
        RunService.RenderStepped:Wait()
    end
end

-- Ativar/Desativar
local function alternar()
    ativo = not ativo
    if ativo then
        statusText.Text = "✅ ATIVADO"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
        btnAtivar.Text = "⏹️ DESATIVAR"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        loop()
    else
        statusText.Text = "⚡ DESATIVADO"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        btnAtivar.Text = "🏀 ATIVAR"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
end

btnAtivar.MouseButton1Click:Connect(alternar)

-- Tecla X para ligar/desligar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        alternar()
    end
end)

print("=" .. string.rep("=", 60))
print("🏀 BASKETBALL ZERO - SCRIPT CORRIGIDO!")
print("📌 Pressione X para ATIVAR")
print("📌 Correção: erro 'table value' resolvido")
print("=" .. string.rep("=", 60))
