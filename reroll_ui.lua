-- HOOPSMASTER V5 - CORRIGIDO (SERVIDOR PRIVADO)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== VARIÁVEIS ==========
local ativo = false

-- ========== GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HoopsDemon"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 180)
frame.Position = UDim2.new(0.5, -160, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
title.Text = "🔥 HOOPS DEMON V5 🔥"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 0, 40)
statusText.Position = UDim2.new(0, 10, 0, 60)
statusText.Text = "⚡ DESATIVADO"
statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
statusText.TextSize = 14
statusText.Font = Enum.Font.GothamBold
statusText.Parent = frame

local btnAtivar = Instance.new("TextButton")
btnAtivar.Size = UDim2.new(0, 200, 0, 45)
btnAtivar.Position = UDim2.new(0.5, -100, 0, 115)
btnAtivar.Text = "🔴 ATIVAR 🔴"
btnAtivar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btnAtivar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAtivar.TextSize = 16
btnAtivar.Font = Enum.Font.GothamBold
btnAtivar.Parent = frame

-- ========== FUNÇÕES CORRIGIDAS ==========

-- Só encontra a cesta adversária (ignora NPC)
local function encontrarCesta()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name:lower():find("hoop") then
            -- Tenta identificar cesta adversária (azul/vermelho)
            if part.BrickColor and (part.BrickColor.Name:find("blue") or part.BrickColor.Name == "Really blue") then
                return part
            end
        end
    end
    return nil
end

-- Só encontra jogadores de verdade (ignora NPC)
local function encontrarJogadores()
    local jogadores = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- Ignora NPC (NPC não tem PlayerGui)
            if p:FindFirstChild("PlayerGui") then
                table.insert(jogadores, p)
            end
        end
    end
    return jogadores
end

-- Teleporta pra cesta e arremessa
local function arremessar()
    local cesta = encontrarCesta()
    if cesta and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(cesta.Position + Vector3.new(0, 3, 0))
        task.wait(0.05)
        mouse.Button1Down()
        task.wait(0.05)
        mouse.Button1Up()
        statusText.Text = "🏀 ARREMESSO!"
        return true
    end
    return false
end

-- Rouba do jogador mais próximo
local function roubar()
    local alvo = nil
    local menorDist = math.huge
    
    for _, enemy in ipairs(encontrarJogadores()) do
        if enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
            if dist < menorDist and dist < 30 then
                menorDist = dist
                alvo = enemy
            end
        end
    end
    
    if alvo and alvo.Character then
        -- Teleporta pra trás do oponente
        local enemyPos = alvo.Character.HumanoidRootPart.Position
        local behindPos = enemyPos - (alvo.Character.HumanoidRootPart.CFrame.LookVector * 4)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(behindPos)
        
        -- Tenta pegar a bola (se existir)
        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("BasePart") and (item.Name:lower():find("ball") or item.Name:lower():find("bola")) then
                if item:FindFirstChild("Handle") then
                    item.CFrame = player.Character.HumanoidRootPart.CFrame
                end
            end
        end
        statusText.Text = "🤚 ROUBOU!"
        return true
    end
    return false
end

-- Drible errático
local function driblar()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local randomDir = Vector3.new(math.random(-15, 15), 0, math.random(-15, 15))
        local newPos = player.Character.HumanoidRootPart.Position + randomDir
        player.Character.HumanoidRootPart.CFrame = CFrame.new(newPos)
        statusText.Text = "💫 DRIBLE"
    end
end

-- Bloqueia arremesso
local function bloquear()
    for _, enemy in ipairs(encontrarJogadores()) do
        if enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
            if dist < 15 then
                -- Teleporta na frente
                local enemyPos = enemy.Character.HumanoidRootPart.Position
                local blockPos = enemyPos + (enemy.Character.HumanoidRootPart.CFrame.LookVector * -3)
                player.Character.HumanoidRootPart.CFrame = CFrame.new(blockPos)
                statusText.Text = "🛡️ BLOQUEIOU!"
                return true
            end
        end
    end
    return false
end

-- ========== LOOP DEMON ==========
local function loopDemon()
    while ativo do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            arremessar()
            roubar()
            driblar()
            bloquear()
        end
        RunService.RenderStepped:Wait()
    end
end

-- ========== ATIVAR ==========
local function alternar()
    ativo = not ativo
    if ativo then
        statusText.Text = "🔥 ATIVADO 🔥"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
        btnAtivar.Text = "⏹️ DESATIVAR"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        loopDemon()
    else
        statusText.Text = "⚡ DESATIVADO"
        statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
        btnAtivar.Text = "🔴 ATIVAR 🔴"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end

btnAtivar.MouseButton1Click:Connect(alternar)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        alternar()
    end
end)

print("=" .. string.rep("=", 60))
print("🔥 HOOPS DEMON V5 - CORRIGIDO 🔥")
print("✅ Só mira em JOGADORES (ignora NPC)")
print("✅ Teleporta pra cesta e arremessa")
print("✅ Rouba bola de verdade")
print("✅ Drible errático")
print("✅ Block OP")
print("=" .. string.rep("=", 60))
print("🔥 Pressione X para ATIVAR")
