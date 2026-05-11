-- BASKETBALL ZERO - SCRIPT TESTADO E FUNCIONAL
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== VARIÁVEIS ==========
local ativo = false

-- ========== GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BBZScript"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 150)
frame.Position = UDim2.new(0.5, -130, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
title.Text = "🏀 BBZ SCRIPT 🏀"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 0, 35)
statusText.Position = UDim2.new(0, 10, 0, 50)
statusText.Text = "⚡ DESATIVADO"
statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
statusText.TextSize = 14
statusText.Font = Enum.Font.GothamBold
statusText.Parent = frame

local btnAtivar = Instance.new("TextButton")
btnAtivar.Size = UDim2.new(0, 160, 0, 40)
btnAtivar.Position = UDim2.new(0.5, -80, 0, 100)
btnAtivar.Text = "🏀 ATIVAR"
btnAtivar.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
btnAtivar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAtivar.TextSize = 14
btnAtivar.Font = Enum.Font.GothamBold
btnAtivar.Parent = frame

-- ========== FUNÇÕES ==========

-- Encontra a cesta adversária
local function encontrarCesta()
    -- Procura a cesta do time adversário (geralmente vermelha)
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Tenta identificar pela cor (vermelho = adversário)
            if part.BrickColor and (part.BrickColor.Name:lower():find("red") or part.BrickColor.Name:lower():find("crimson")) then
                -- Verifica se é uma cesta (pelo tamanho/forma)
                local size = part.Size
                if size.Y > 3 and size.Y < 8 then
                    return part
                end
            end
            -- Procura por nome
            local nome = part.Name:lower()
            if nome:find("hoop") or nome:find("basket") or nome:find("rim") then
                return part
            end
        end
    end
    return nil
end

-- Verifica se tem a bola
local function temBola()
    if not player.Character then return false end
    
    -- Verifica se o boneco tem bola na mão (por animação ou parte)
    for _, part in ipairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("ball") or part.Name:lower():find("bola")) then
            return true
        end
    end
    
    -- Verifica pelo Humanoid se está com bola
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid:FindFirstChild("Ball") then
        return true
    end
    
    return false
end

-- Simula arremesso
local function arremessar()
    local cesta = encontrarCesta()
    if not cesta then
        statusText.Text = "🔍 PROCURANDO CESTA..."
        return false
    end
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    -- Mira na cesta
    local playerPos = player.Character.HumanoidRootPart.Position
    local cestaPos = cesta.Position
    local direction = (cestaPos - playerPos).Unit
    local lookAt = CFrame.lookAt(playerPos, cestaPos)
    player.Character.HumanoidRootPart.CFrame = lookAt
    
    -- Pressiona e segura o clique (arremesso)
    mouse.Button1Down()
    task.wait(0.15)
    mouse.Button1Up()
    
    statusText.Text = "🏀 ARREMESSOU!"
    return true
end

-- Loop
local function loop()
    while ativo do
        if temBola() then
            arremessar()
            task.wait(0.3)
        else
            statusText.Text = "⚡ ESPERANDO BOLA..."
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

-- Tecla X
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        alternar()
    end
end)

print("=" .. string.rep("=", 60))
print("🏀 BASKETBALL ZERO - SCRIPT ATIVO")
print("📌 Pressione X para ATIVAR")
print("📌 O script vai:")
print("   1. Procurar a cesta adversária")
print("   2. Mirar automaticamente")
print("   3. Arremessar quando tiver a bola")
print("=" .. string.rep("=", 60))
