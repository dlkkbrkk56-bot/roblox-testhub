-- HOOPSMASTER V3 - BASED ON REAL CONTROLS
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== VARIÁVEIS ==========
local ativo = false
local autoShoot = true
local autoDrible = true
local autoSteal = true
local autoDefense = true
local autoLayup = true
local autoPass = false

-- ========== GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HoopsMaster"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 380)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 100, 50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
title.Text = "🏀 HOOPSMASTER V3 🏀"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 0, 35)
statusText.Position = UDim2.new(0, 10, 0, 55)
statusText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusText.BackgroundTransparency = 0.5
statusText.Text = "⚡ DESATIVADO"
statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
statusText.TextSize = 14
statusText.Font = Enum.Font.GothamBold
statusText.Parent = frame

-- Botão principal
local btnAtivar = Instance.new("TextButton")
btnAtivar.Size = UDim2.new(0, 200, 0, 45)
btnAtivar.Position = UDim2.new(0.5, -100, 0, 100)
btnAtivar.Text = "🔥 ATIVAR 🔥"
btnAtivar.BackgroundColor3 = Color3.fromRGB(255, 80, 40)
btnAtivar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAtivar.TextSize = 16
btnAtivar.Font = Enum.Font.GothamBold
btnAtivar.Parent = frame

-- Toggles
local function criarToggle(texto, yPos, cor)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 180, 0, 32)
    toggle.Position = UDim2.new(0.5, -90, 0, yPos)
    toggle.Text = "✅ " .. texto
    toggle.BackgroundColor3 = cor or Color3.fromRGB(40, 80, 40)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 11
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame
    return toggle
end

local shootToggle = criarToggle("🏀 AUTO ARREMESSO", 160, Color3.fromRGB(40, 80, 40))
local dribleToggle = criarToggle("💫 AUTO DRIBLE (Q)", 197, Color3.fromRGB(40, 80, 40))
local layupToggle = criarToggle("⬆️ AUTO LAYUP/DUNK (SPACE)", 234, Color3.fromRGB(40, 80, 40))
local stealToggle = criarToggle("🤚 AUTO ROUBO (E)", 271, Color3.fromRGB(40, 80, 40))
local defenseToggle = criarToggle("🔒 AUTO DEFESA", 308, Color3.fromRGB(40, 80, 40))

-- Info
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 35)
info.Position = UDim2.new(0, 10, 0, 345)
info.BackgroundTransparency = 1
info.Text = "🎯 Pressione X para ligar/desligar"
info.TextColor3 = Color3.fromRGB(255, 200, 100)
info.TextSize = 11
info.Parent = frame

-- ========== FUNÇÕES PRINCIPAIS (CONTROLES REAIS) ==========

-- Verifica se tem a bola
local function temBola()
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("ball") or part.Name:lower():find("bola")) then
                return true
            end
        end
    end
    return false
end

-- Encontra a cesta adversária
local function encontrarCestaAdversaria()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local nome = part.Name:lower()
            if (nome:find("hoop") or nome:find("basket") or nome:find("aro") or nome:find("cesta")) then
                if part.BrickColor and (part.BrickColor.Name:find("blue") or part.BrickColor.Name:find("azul")) then
                    return part
                end
            end
        end
    end
    return nil
end

-- Verifica se está perto da cesta (para layup/dunk)
local function pertoDaCesta()
    local cesta = encontrarCestaAdversaria()
    if not cesta or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    local dist = (player.Character.HumanoidRootPart.Position - cesta.Position).Magnitude
    return dist < 15
end

-- AUTO ARREMESSO (Clique Esquerdo - Hold)
local function arremessar()
    if not autoShoot then return false end
    if not temBola() then return false end
    if pertoDaCesta() then return false end -- Se perto, usa layup/dunk
    
    local cesta = encontrarCestaAdversaria()
    if not cesta then return false end
    
    local playerPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerPos then return false end
    
    -- Mira na cesta
    local lookAt = CFrame.lookAt(playerPos.Position, cesta.Position + Vector3.new(0, 2, 0))
    playerPos.CFrame = lookAt
    
    task.wait(math.random(1, 3) / 10)
    
    -- SEGURA O CLIQUE ESQUERDO (arremesso)
    mouse.Button1Down()
    local holdTime = math.random(25, 45) / 100  -- 0.25 a 0.45 segundos
    task.wait(holdTime)
    mouse.Button1Up()
    
    statusText.Text = "🏀 ARREMESSOU!"
    return true
end

-- AUTO LAYUP/DUNK (Espaço perto do aro)
local function fazerLayup()
    if not autoLayup then return false end
    if not temBola() then return false end
    if not pertoDaCesta() then return false end
    
    -- Pressiona ESPAÇO para layup/dunk
    local inputService = game:GetService("UserInputService")
    inputService.InputBegan:Fire(Enum.KeyCode.Space, Enum.UserInputState.Begin)
    task.wait(0.05)
    inputService.InputEnded:Fire(Enum.KeyCode.Space, Enum.UserInputState.End)
    
    statusText.Text = "⬆️ LAYUP/DUNK!"
    return true
end

-- AUTO DRIBLE (Tecla Q - máximo 3 dribles)
local function driblar()
    if not autoDrible then return false end
    if not temBola() then return false end
    
    -- Pressiona Q para driblar
    UserInputService.InputBegan:Fire(Enum.KeyCode.Q, Enum.UserInputState.Begin)
    task.wait(0.05)
    UserInputService.InputEnded:Fire(Enum.KeyCode.Q, Enum.UserInputState.End)
    
    statusText.Text = "💫 DRIBLE (Q)"
    return true
end

-- AUTO ROUBO (Tecla E)
local function roubar()
    if not autoSteal then return false end
    
    -- Encontra adversário mais próximo
    local closestEnemy = nil
    local closestDist = math.huge
    
    for _, enemy in ipairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDist and dist < 12 then
                    closestDist = dist
                    closestEnemy = enemy
                end
            end
        end
    end
    
    if closestEnemy then
        -- Pressiona E para roubar
        UserInputService.InputBegan:Fire(Enum.KeyCode.E, Enum.UserInputState.Begin)
        task.wait(0.05)
        UserInputService.InputEnded:Fire(Enum.KeyCode.E, Enum.UserInputState.End)
        statusText.Text = "🤚 TENTOU ROUBAR (E)"
        return true
    end
    return false
end

-- AUTO DEFESA (segue a bola ou oponente)
local function defender()
    if not autoDefense then return false end
    
    local target = nil
    local closestDist = math.huge
    
    -- Procura pela bola primeiro
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("ball") or part.Name:lower():find("bola")) then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - part.Position).Magnitude
                if dist < closestDist and dist < 20 then
                    closestDist = dist
                    target = part
                end
            end
        end
    end
    
    -- Se não achou bola, procura adversário com bola
    if not target then
        for _, enemy in ipairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                -- Verifica se o adversário tem a bola
                local enemyHasBall = false
                for _, part in ipairs(enemy.Character:GetDescendants()) do
                    if part:IsA("BasePart") and (part.Name:lower():find("ball") or part.Name:lower():find("bola")) then
                        enemyHasBall = true
                        break
                    end
                end
                
                if enemyHasBall then
                    local dist = (player.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
                    if dist < closestDist and dist < 15 then
                        closestDist = dist
                        target = enemy.Character.HumanoidRootPart
                    end
                end
            end
        end
    end
    
    -- Move em direção ao alvo
    if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local playerPos = player.Character.HumanoidRootPart.Position
        local targetPos = target.Position
        local direction = (targetPos - playerPos).Unit
        local newPos = playerPos + direction * 4
        
        player.Character.HumanoidRootPart.CFrame = CFrame.new(newPos, targetPos)
        return true
    end
    return false
end

-- ========== LOOP PRINCIPAL ==========
local function loop()
    local lastDrible = 0
    local driblesCount = 0
    
    while ativo do
        if temBola() then
            -- Com a bola: prioriza layup perto da cesta
            if pertoDaCesta() then
                fazerLayup()
                task.wait(0.3)
            else
                -- Fora do garrafão: decide entre arremessar ou driblar
                local cesta = encontrarCestaAdversaria()
                if cesta and autoShoot then
                    local dist = (player.Character.HumanoidRootPart.Position - cesta.Position).Magnitude
                    if dist < 25 then
                        arremessar()
                        task.wait(0.5)
                    else
                        -- Longe: dribla e se aproxima
                        if autoDrible then
                            driblar()
                            task.wait(0.2)
                        end
                        -- Move em direção à cesta
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local lookAt = CFrame.lookAt(player.Character.HumanoidRootPart.Position, cesta.Position + Vector3.new(0, 2, 0))
                            player.Character.HumanoidRootPart.CFrame = lookAt
                        end
                    end
                else
                    if autoDrible then
                        driblar()
                        task.wait(0.3)
                    end
                end
            end
        else
            -- Sem bola: tenta roubar ou defende
            if autoSteal then
                roubar()
            end
            if autoDefense then
                defender()
            end
            task.wait(0.1)
        end
        
        RunService.RenderStepped:Wait()
    end
end

-- ========== EVENTOS ==========
local function alternarAtivo()
    ativo = not ativo
    if ativo then
        statusText.Text = "⚡ ATIVADO"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
        btnAtivar.Text = "⏹️ DESATIVAR"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        loop()
    else
        statusText.Text = "⚡ DESATIVADO"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        btnAtivar.Text = "🔥 ATIVAR 🔥"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(255, 80, 40)
    end
end

btnAtivar.MouseButton1Click:Connect(alternarAtivo)

shootToggle.MouseButton1Click:Connect(function()
    autoShoot = not autoShoot
    shootToggle.Text = autoShoot and "✅ 🏀 AUTO ARREMESSO" or "❌ 🏀 AUTO ARREMESSO"
    shootToggle.BackgroundColor3 = autoShoot and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
end)

dribleToggle.MouseButton1Click:Connect(function()
    autoDrible = not autoDrible
    dribleToggle.Text = autoDrible and "✅ 💫 AUTO DRIBLE (Q)" or "❌ 💫 AUTO DRIBLE (Q)"
    dribleToggle.BackgroundColor3 = autoDrible and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
end)

layupToggle.MouseButton1Click:Connect(function()
    autoLayup = not autoLayup
    layupToggle.Text = autoLayup and "✅ ⬆️ AUTO LAYUP/DUNK" or "❌ ⬆️ AUTO LAYUP/DUNK"
    layupToggle.BackgroundColor3 = autoLayup and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
end)

stealToggle.MouseButton1Click:Connect(function()
    autoSteal = not autoSteal
    stealToggle.Text = autoSteal and "✅ 🤚 AUTO ROUBO (E)" or "❌ 🤚 AUTO ROUBO (E)"
    stealToggle.BackgroundColor3 = autoSteal and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
end)

defenseToggle.MouseButton1Click:Connect(function()
    autoDefense = not autoDefense
    defenseToggle.Text = autoDefense and "✅ 🔒 AUTO DEFESA" or "❌ 🔒 AUTO DEFESA"
    defenseToggle.BackgroundColor3 = autoDefense and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
end)

-- Tecla X para ligar/desligar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        alternarAtivo()
    end
end)

print("=" .. string.rep("=", 65))
print("🏀 HOOPSMASTER V3 - BASEADO NOS CONTROLES REAIS!")
print("📌 CONTROLES IMPLEMENTADOS:")
print("   🏀 Arremesso = Clique Esquerdo (Hold)")
print("   💫 Drible = Tecla Q")
print("   ⬆️ Layup/Dunk = Espaço (perto do aro)")
print("   🤚 Roubo = Tecla E")
print("   🔒 Defesa = Segue bola/oponente")
print("=" .. string.rep("=", 65))
print("🔥 Use a tecla X para ligar/desligar")
print("=" .. string.rep("=", 65))
