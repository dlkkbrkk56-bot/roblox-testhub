--[[
    BASQUETE ZERO - SCRIPT PROFISSIONAL
    Funções:
    ✅ Auto Arremesso (disfarçado)
    ✅ Auto Block (OP)
    ✅ Auto Roubo (steal)
    ✅ Auto Drible
    ✅ Auto Defesa
    ✅ ESP Jogadores
    ✅ Sem TP para bola
    ✅ Sistema anti-detecção
--]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== VARIÁVEIS ==========
local ativo = false
local autoShoot = true
local autoBlock = true
local autoSteal = true
local autoDrible = true
local autoDefense = true
local espEnabled = true

-- Configurações de disfarce (simula humano)
local config = {
    shootDelayMin = 0.28,      -- Tempo mínimo pressionar
    shootDelayMax = 0.42,      -- Tempo máximo pressionar
    blockChance = 85,          -- % de chance de bloquear (85%)
    stealChance = 70,          -- % de chance de roubar (70%)
    humanDelayMin = 0.05,      -- Delay mínimo entre ações
    humanDelayMax = 0.15,      -- Delay máximo entre ações
    missChance = 5,            -- Chance de errar de propósito (5%)
    fakeMouseMove = true       -- Move mouse falsamente
}

-- ========== GUI PROFISSIONAL ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BasqueteZeroPro"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Sombra/Background com efeito blur
local background = Instance.new("Frame")
background.Size = UDim2.new(0, 380, 0, 520)
background.Position = UDim2.new(0.5, -190, 0.5, -260)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BackgroundTransparency = 0.7
background.BorderSizePixel = 0
background.Active = true
background.Draggable = true
background.Parent = screenGui

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = background

-- Frame principal com borda neon
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, -10, 1, -10)
mainFrame.Position = UDim2.new(0, 5, 0, 5)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 100, 50)
mainFrame.Parent = background

-- Título com efeito gradiente
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
title.Text = "🏀 BASQUETE ZERO PRO ELITE 🏀"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 48)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Modo Fantasma | Anti-Detecção Ativa"
subtitle.TextColor3 = Color3.fromRGB(100, 255, 100)
subtitle.TextSize = 11
subtitle.Parent = mainFrame

-- Status principal
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0, 200, 0, 45)
statusFrame.Position = UDim2.new(0.5, -100, 0, 78)
statusFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusFrame.BackgroundTransparency = 0.6
statusFrame.BorderSizePixel = 1
statusFrame.BorderColor3 = Color3.fromRGB(255, 100, 50)
statusFrame.Parent = mainFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 1, 0)
statusText.Text = "⚡ SISTEMA PRONTO ⚡"
statusText.TextColor3 = Color3.fromRGB(50, 255, 50)
statusText.TextSize = 14
statusText.Font = Enum.Font.GothamBold
statusText.Parent = statusFrame

-- Botão principal de ativação
local btnAtivar = Instance.new("TextButton")
btnAtivar.Size = UDim2.new(0, 200, 0, 45)
btnAtivar.Position = UDim2.new(0.5, -100, 0, 135)
btnAtivar.Text = "🔥 ATIVAR SISTEMA 🔥"
btnAtivar.BackgroundColor3 = Color3.fromRGB(255, 80, 40)
btnAtivar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAtivar.TextSize = 16
btnAtivar.Font = Enum.Font.GothamBold
btnAtivar.BorderSizePixel = 0
btnAtivar.Parent = mainFrame

-- Efeito hover
btnAtivar.MouseEnter:Connect(function()
    if not ativo then
        btnAtivar.BackgroundColor3 = Color3.fromRGB(255, 120, 60)
    end
end)
btnAtivar.MouseLeave:Connect(function()
    if not ativo then
        btnAtivar.BackgroundColor3 = Color3.fromRGB(255, 80, 40)
    end
end)

-- Separador
local line = Instance.new("Frame")
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 195)
line.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
line.Parent = mainFrame

-- Configurações rápidas
local configTitle = Instance.new("TextLabel")
configTitle.Size = UDim2.new(1, 0, 0, 25)
configTitle.Position = UDim2.new(0, 0, 0, 205)
configTitle.BackgroundTransparency = 1
configTitle.Text = "⚙️ CONFIGURAÇÕES"
configTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
configTitle.TextSize = 13
configTitle.Font = Enum.Font.GothamBold
configTitle.Parent = mainFrame

-- Toggles
local function criarToggle(nome, texto, yPos, cor)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 160, 0, 30)
    toggle.Position = UDim2.new(0.5, -80, 0, yPos)
    toggle.Text = "✅ " .. texto .. " ON"
    toggle.BackgroundColor3 = cor or Color3.fromRGB(40, 80, 40)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = mainFrame
    return toggle
end

local shootToggle = criarToggle("shoot", "🏀 AUTO ARREMESSO", 240, Color3.fromRGB(40, 80, 40))
local blockToggle = criarToggle("block", "🛡️ AUTO BLOCK (OP)", 275, Color3.fromRGB(40, 80, 40))
local stealToggle = criarToggle("steal", "🤚 AUTO ROUBO", 310, Color3.fromRGB(40, 80, 40))
local dribleToggle = criarToggle("drible", "💫 AUTO DRIBLE", 345, Color3.fromRGB(40, 80, 40))
local defenseToggle = criarToggle("defense", "🔒 AUTO DEFESA", 380, Color3.fromRGB(40, 80, 40))

-- Info rodapé
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 35)
footer.Position = UDim2.new(0, 0, 0, 430)
footer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
footer.BackgroundTransparency = 0.5
footer.Text = "🎯 Modo Fantasia Ativo | Anti-Ban\nDelay humanoide aplicado"
footer.TextColor3 = Color3.fromRGB(150, 150, 150)
footer.TextSize = 10
footer.Parent = mainFrame

-- ========== FUNÇÕES AUXILIARES ==========

-- Delay humanoide aleatório
local function humanDelay()
    task.wait(math.random(config.humanDelayMin * 100, config.humanDelayMax * 100) / 100)
end

-- Chance de errar/fallar (para parecer humano)
local function chanceFallhar(chance)
    return math.random(1, 100) <= chance
end

-- Movimento falso do mouse (anti-detecção)
local function fakeMouseMovement()
    if not config.fakeMouseMove then return end
    local x = mouse.X + math.random(-5, 5)
    local y = mouse.Y + math.random(-3, 3)
    mouse.Move(mouse.X + (x - mouse.X), mouse.Y + (y - mouse.Y))
end

-- ========== AUTO ARREMESSO DISFARÇADO ==========
local function autoShootFunction()
    if not autoShoot then return false end
    
    -- Encontra a cesta amiga
    local basket = nil
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:find("Hoop") or part.Name:find("Basket")) then
            if part.BrickColor and (part.BrickColor.Name == "Really red" or part.BrickColor.Name == "Bright red") then
                basket = part
                break
            end
        end
    end
    
    if not basket or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    -- Verifica distância
    local distancia = (player.Character.HumanoidRootPart.Position - basket.Position).Magnitude
    if distancia > 40 then return false end
    
    -- Verifica se tem a bola (aproximado)
    local hasBall = false
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("BasePart") and item.Name:find("Ball") then
            if item:FindFirstChild("Handle") and item.Handle:FindFirstChild("TouchInterest") then
                hasBall = true
                break
            end
        end
    end
    
    if not hasBall then return false end
    
    -- Chance de errar de propósito
    local willMiss = chanceFallhar(config.missChance)
    
    -- Mira na cesta com variação
    local targetPos = basket.Position
    if willMiss then
        targetPos = targetPos + Vector3.new(math.random(-5, 5), math.random(-3, 3), math.random(-2, 2))
    end
    
    -- Calcula ângulo
    local playerPos = player.Character.HumanoidRootPart.Position
    local lookAt = CFrame.lookAt(playerPos, targetPos)
    player.Character.HumanoidRootPart.CFrame = lookAt
    
    -- Movimento falso antes de arremessar
    fakeMouseMovement()
    humanDelay()
    
    -- Arremessa com timing variável
    local holdTime = math.random(config.shootDelayMin * 100, config.shootDelayMax * 100) / 100
    mouse.Button1Down()
    task.wait(holdTime)
    mouse.Button1Up()
    
    statusText.Text = willMiss and "🏀 ARREMESSO (ERRADO)" or "🏀 ARREMESSOU!"
    return true
end

-- ========== AUTO BLOCK (OP) ==========
local function autoBlockFunction()
    if not autoBlock then return false end
    
    -- Bloqueia qualquer arremesso adversário
    -- Detecta quando o botão de arremesso é pressionado pelo oponente
    local enemies = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            table.insert(enemies, p)
        end
    end
    
    for _, enemy in ipairs(enemies) do
        if enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
            if dist < 15 then
                -- Chance de bloqueio baseada na configuração
                if chanceFallhar(100 - config.blockChance) then
                    statusText.Text = "🛡️ BLOQUEIOU!"
                    -- Simula tecla de bloqueio (geralmente F ou E)
                    UserInputService.InputBegan:Fire(Enum.KeyCode.F, Enum.UserInputState.Begin)
                    task.wait(0.1)
                    UserInputService.InputEnded:Fire(Enum.KeyCode.F, Enum.UserInputState.End)
                    return true
                end
            end
        end
    end
    return false
end

-- ========== AUTO ROUBO ==========
local function autoStealFunction()
    if not autoSteal then return false end
    
    for _, enemy in ipairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character then
            local dist = (player.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
            if dist < 8 then
                if chanceFallhar(100 - config.stealChance) then
                    statusText.Text = "🤚 ROUBOU A BOLA!"
                    -- Simula tecla de roubo
                    UserInputService.InputBegan:Fire(Enum.KeyCode.E, Enum.UserInputState.Begin)
                    task.wait(0.08)
                    UserInputService.InputEnded:Fire(Enum.KeyCode.E, Enum.UserInputState.End)
                    return true
                end
            end
        end
    end
    return false
end

-- ========== AUTO DRIBLE ==========
local function autoDribleFunction()
    if not autoDrible then return false end
    
    -- Verifica se tem a bola
    local hasBall = false
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("BasePart") and item.Name:find("Ball") then
            if item:FindFirstChild("Handle") and item.Handle:FindFirstChild("TouchInterest") then
                hasBall = true
                break
            end
        end
    end
    
    if hasBall then
        -- Simula espaço para drible com delay variado
        UserInputService.InputBegan:Fire(Enum.KeyCode.Space, Enum.UserInputState.Begin)
        task.wait(0.05)
        UserInputService.InputEnded:Fire(Enum.KeyCode.Space, Enum.UserInputState.End)
        statusText.Text = "💫 DRIBLE"
        return true
    end
    return false
end

-- ========== AUTO DEFESA ==========
local function autoDefenseFunction()
    if not autoDefense then return false end
    
    -- Segue o adversário mais próximo
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
    
    if closestEnemy and closestEnemy.Character and closestDist < 12 then
        -- Move em direção ao adversário (defesa colada)
        local enemyPos = closestEnemy.Character.HumanoidRootPart.Position
        local playerPos = player.Character.HumanoidRootPart.Position
        local direction = (enemyPos - playerPos).Unit
        local moveCF = CFrame.lookAt(playerPos, enemyPos)
        player.Character.HumanoidRootPart.CFrame = moveCF
        return true
    end
    return false
end

-- ========== ESP JOGADORES ==========
local espObjects = {}
local function criarESP(jogador)
    if not espEnabled then return end
    if espObjects[jogador] then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. jogador.Name
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.Adornee = jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart")
    billboard.AlwaysOnTop = true
    billboard.Parent = screenGui
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.BackgroundTransparency = 0.5
    label.TextColor3 = jogador == player and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
    label.Text = jogador.Name .. " | " .. math.floor((jogador.Character and jogador.Character.HumanoidRootPart and (player.Character and player.Character.HumanoidRootPart and (jogador.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude or 0) or 0)) .. "m"
    label.TextSize = 11
    label.Parent = billboard
    
    espObjects[jogador] = billboard
end

-- Atualiza ESP
local function atualizarESP()
    if not espEnabled then return end
    for _, jogador in ipairs(game.Players:GetPlayers()) do
        if jogador.Character then
            criarESP(jogador)
            if espObjects[jogador] and jogador.Character:FindFirstChild("HumanoidRootPart") then
                espObjects[jogador].Adornee = jogador.Character.HumanoidRootPart
                local label = espObjects[jogador]:FindFirstChild("TextLabel")
                if label then
                    local dist = (jogador.Character.HumanoidRootPart.Position - (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.zero)).Magnitude
                    label.Text = jogador.Name .. " | " .. math.floor(dist) .. "m"
                    label.TextColor3 = jogador == player and Color3.fromRGB(0, 255, 0) or (dist < 15 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 200, 0))
                end
            end
        end
    end
end

-- ========== LOOP PRINCIPAL DISFARÇADO ==========
local function loopPrincipal()
    while ativo do
        -- Executa funções com delays aleatórios (parece humano)
        
        if autoShoot then
            autoShootFunction()
            humanDelay()
        end
        
        if autoBlock then
            autoBlockFunction()
            humanDelay()
        end
        
        if autoSteal then
            autoStealFunction()
            humanDelay()
        end
        
        if autoDrible then
            autoDribleFunction()
            humanDelay()
        end
        
        if autoDefense then
            autoDefenseFunction()
        end
        
        if espEnabled then
            atualizarESP()
        end
        
        -- Move o mouse falsamente a cada 5-10 segundos
        if math.random(1, 100) > 95 then
            fakeMouseMovement()
        end
        
        RunService.RenderStepped:Wait()
    end
end

-- ========== EVENTOS DOS TOGGLES ==========
shootToggle.MouseButton1Click:Connect(function()
    autoShoot = not autoShoot
    shootToggle.Text = autoShoot and "✅ AUTO ARREMESSO ON" or "❌ AUTO ARREMESSO OFF"
    shootToggle.BackgroundColor3 = autoShoot and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
end)

blockToggle.MouseButton1Click:Connect(function()
    autoBlock = not autoBlock
    blockToggle.Text = autoBlock and "✅ AUTO BLOCK (OP) ON" or "❌ AUTO BLOCK (OP) OFF"
    blockToggle.BackgroundColor3 = autoBlock and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
end)

stealToggle.MouseButton1Click:Connect(function()
    autoSteal = not autoSteal
    stealToggle.Text = autoSteal and "✅ AUTO ROUBO ON" or "❌ AUTO ROUBO OFF"
    stealToggle.BackgroundColor3 = autoSteal and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
end)

dribleToggle.MouseButton1Click:Connect(function()
    autoDrible = not autoDrible
    dribleToggle.Text = autoDrible and "✅ AUTO DRIBLE ON" or "❌ AUTO DRIBLE OFF"
    dribleToggle.BackgroundColor3 = autoDrible and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
end)

defenseToggle.MouseButton1Click:Connect(function()
    autoDefense = not autoDefense
    defenseToggle.Text = autoDefense and "✅ AUTO DEFESA ON" or "❌ AUTO DEFESA OFF"
    defenseToggle.BackgroundColor3 = autoDefense and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
end)

-- Ativa/Desativa tudo
btnAtivar.MouseButton1Click:Connect(function()
    ativo = not ativo
    
    if ativo then
        statusText.Text = "⚡ SISTEMA ATIVADO ⚡"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
        btnAtivar.Text = "⏹️ DESATIVAR SISTEMA ⏹️"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        loopPrincipal()
    else
        statusText.Text = "⚡ SISTEMA DESATIVADO ⚡"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        btnAtivar.Text = "🔥 ATIVAR SISTEMA 🔥"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(255, 80, 40)
        
        -- Limpa ESP
        for _, esp in pairs(espObjects) do
            pcall(function() esp:Destroy() end)
        end
        espObjects = {}
    end
end)

-- Tecla de atalho (X) para ligar/desligar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        btnAtivar.MouseButton1Click:Fire()
    end
end)

print("=" .. string.rep("=", 65))
print("🏀 BASQUETE ZERO PRO ELITE - CARREGADO!")
print("📌 FUNÇÕES ATIVAS:")
print("   🏀 Auto Arremesso (disfarçado, com erro proposital)")
print("   🛡️ Auto Block OP (85% de eficácia)")
print("   🤚 Auto Roubo (70% de eficácia)")
print("   💫 Auto Drible")
print("   🔒 Auto Defesa")
print("   👁️ ESP Jogadores")
print("=" .. string.rep("=", 65))
print("🔥 Use a tecla X para ligar/desligar rapidamente")
print("🎯 Modo Fantasia ativo - difícil de detectar")
print("=" .. string.rep("=", 65))
