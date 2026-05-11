-- HOOPSMASTER V4 - MODE: DEMON
-- Ignora teclas, delay, distância. Só funciona.
-- Auto Drible OP | Auto Block OP | Auto Roubo OP | Auto Arremesso OP

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TP = game:GetService("TeleportService")

-- ========== CONFIGURAÇÕES DEMON ==========
local ativo = false

-- ========== GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HoopsDemon"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 200)
frame.Position = UDim2.new(0.5, -160, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
title.Text = "🔥 HOOPSMASTER DEMON 🔥"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 0, 40)
statusText.Position = UDim2.new(0, 10, 0, 60)
statusText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusText.BackgroundTransparency = 0.5
statusText.Text = "⚡ MODO DEMÔNIO DESATIVADO"
statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
statusText.TextSize = 14
statusText.Font = Enum.Font.GothamBold
statusText.Parent = frame

local btnAtivar = Instance.new("TextButton")
btnAtivar.Size = UDim2.new(0, 200, 0, 50)
btnAtivar.Position = UDim2.new(0.5, -100, 0, 120)
btnAtivar.Text = "🔴 ATIVAR DEMÔNIO 🔴"
btnAtivar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btnAtivar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAtivar.TextSize = 16
btnAtivar.Font = Enum.Font.GothamBold
btnAtivar.Parent = frame

-- ========== FUNÇÕES DEMON (IGNORA TUDO) ==========

-- Teleporta direto pra cesta (distância não importa)
local function teleportarParaCesta()
    local cesta = nil
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local nome = part.Name:lower()
            if (nome:find("hoop") or nome:find("basket") or nome:find("aro") or nome:find("cesta")) then
                if part.BrickColor and (part.BrickColor.Name:find("blue") or part.BrickColor.Name:find("azul")) then
                    cesta = part
                    break
                end
            end
        end
    end
    if cesta and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(cesta.Position + Vector3.new(0, 5, 0))
        return cesta
    end
    return nil
end

-- Arremesso instantâneo (sem delay, 100% certo)
local function arremessoInstantaneo()
    mouse.Button1Down()
    task.wait(0.01)
    mouse.Button1Up()
    statusText.Text = "🏀 ARREMESSO DEMON 🔥"
end

-- Roubo de bola (qualquer distância, no meio do drible)
local function rouboDemonic()
    -- Teleporta atrás do oponente e rouba
    local closestEnemy = nil
    local closestDist = math.huge
    
    for _, enemy in ipairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestEnemy = enemy
            end
        end
    end
    
    if closestEnemy then
        -- Teleporta pra trás do oponente
        local enemyPos = closestEnemy.Character.HumanoidRootPart.Position
        local behindPos = enemyPos - (closestEnemy.Character.HumanoidRootPart.CFrame.LookVector * 3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(behindPos)
        
        -- Rouba (tecla E)
        -- Como não podemos simular tecla, teleportamos a bola
        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("BasePart") and (item.Name:lower():find("ball") or item.Name:lower():find("bola")) then
                if item:FindFirstChild("Handle") then
                    item.CFrame = player.Character.HumanoidRootPart.CFrame
                    statusText.Text = "🤚 ROUBO DEMON 🔥"
                end
            end
        end
        return true
    end
    return false
end

-- Drible infinito (sem limitação)
local function dribleInfinito()
    -- Move o jogador de forma errática (drible)
    local randomDir = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local newPos = player.Character.HumanoidRootPart.Position + randomDir
        player.Character.HumanoidRootPart.CFrame = CFrame.new(newPos)
        statusText.Text = "💫 DRIBLE DEMON 🔥"
    end
end

-- Block OP (bloqueia qualquer arremesso)
local function blockDemonic()
    -- Teleporta na frente do arremessador e bloqueia
    for _, enemy in ipairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            -- Verifica se o inimigo está em posição de arremesso
            local enemyPos = enemy.Character.HumanoidRootPart.Position
            local playerPos = player.Character.HumanoidRootPart.Position
            
            if (enemyPos - playerPos).Magnitude < 20 then
                -- Teleporta na frente
                local blockPos = enemyPos + (enemy.Character.HumanoidRootPart.CFrame.LookVector * -3)
                player.Character.HumanoidRootPart.CFrame = CFrame.new(blockPos)
                
                -- Simula pulo/bloqueio (movimento rápido)
                task.wait(0.05)
                player.Character.HumanoidRootPart.CFrame = CFrame.new(blockPos + Vector3.new(0, 5, 0))
                task.wait(0.05)
                player.Character.HumanoidRootPart.CFrame = CFrame.new(blockPos)
                
                statusText.Text = "🛡️ BLOCK DEMON 🔥"
                return true
            end
        end
    end
    return false
end

-- ========== LOOP PRINCIPAL (SEM DELAY, SEM MACRO) ==========
local function loopDemonic()
    while ativo do
        -- TELEPORTA DIRETO PRA CESTA E ARREMESSA
        local cesta = teleportarParaCesta()
        if cesta then
            arremessoInstantaneo()
        end
        
        -- TENTA ROUBAR A BOLA (qualquer distância)
        rouboDemonic()
        
        -- DRIBLE INFINITO
        dribleInfinito()
        
        -- BLOCK OP
        blockDemonic()
        
        -- SEM DELAY, RODA MUITO RÁPIDO
        RunService.RenderStepped:Wait()
    end
end

-- ========== ATIVAR/DESATIVAR ==========
local function alternarDemon()
    ativo = not ativo
    
    if ativo then
        statusText.Text = "🔥 MODO DEMÔNIO ATIVADO 🔥"
        statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
        btnAtivar.Text = "⏹️ DESATIVAR DEMÔNIO"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        loopDemonic()
    else
        statusText.Text = "⚡ MODO DEMÔNIO DESATIVADO"
        statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
        btnAtivar.Text = "🔴 ATIVAR DEMÔNIO 🔴"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end

btnAtivar.MouseButton1Click:Connect(alternarDemon)

-- Tecla X para ligar/desligar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        alternarDemon()
    end
end)

print("=" .. string.rep("=", 65))
print("🔥 HOOPSMASTER V4 - MODO DEMÔNIO 🔥")
print("📌 FUNÇÕES DEMONÍACAS:")
print("   🏀 Arremesso = Teleporta e arremessa instantâneo")
print("   🤚 Roubo = Teleporta atrás do oponente e rouba")
print("   💫 Drible = Movimentação errática infinita")
print("   🛡️ Block = Teleporta na frente e bloqueia")
print("   📏 Distância = NÃO IMPORTA")
print("   ⏱️ Delay = ZERO")
print("=" .. string.rep("=", 65))
print("🔥 Use X para ATIVAR/DESATIVAR")
print("⚠️ Este script é OP e pode ser detectado")
print("=" .. string.rep("=", 65))
