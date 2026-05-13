--[[
    #####################################################################
    #                                                                   #
    #    ██████╗  ██████╗ ███╗   ███╗███████╗    ██╗  ██╗██╗   ██╗██████╗ #
    #    ██╔══██╗██╔═══██╗████╗ ████║██╔════╝    ██║  ██║██║   ██║██╔══██╗#
    #    ██████╔╝██║   ██║██╔████╔██║█████╗      ███████║██║   ██║██████╔╝#
    #    ██╔══██╗██║   ██║██║╚██╔╝██║██╔══╝      ██╔══██║██║   ██║██╔══██╗#
    #    ██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗    ██║  ██║╚██████╔╝██████╔╝#
    #    ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ #
    #                                                                   #
    #           ANIME VANGUARDS - ODYSSEY ADVENTURE                      #
    #                   ESTRATÉGIA PROFISSIONAL                          #
    #                                                                   #
    #####################################################################
--]]

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

-- ============================================
-- VARIÁVEIS GLOBAIS
-- ============================================
local ativo = false
local estrategiaAtual = "FARM"
local floorAtual = 1
local hp = 100
local modifiers = {
    LimitBreak = false,
    MonarchBreakthrough = false,
    AllRangeRage = false,
    RagefulArrival = false,
    EliteConquest = false,
    TreasureMap = false
}

-- Configurações das funções
local autoMove = true
local autoBattle = true
local autoChooseCard = true
local autoUpgrade = false

-- ============================================
-- INTERFACE PRINCIPAL (ROME HUB)
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RomeHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame Principal (Vermelho Vinho com Transparência)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 580)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 10, 15) -- Vermelho Vinho
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(200, 60, 80)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Sombra/Blur
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
title.Text = "🔥 ROME HUB 🔥"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Subtítulo
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 50)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Anime Vanguards - Odyssey Strategy"
subtitle.TextColor3 = Color3.fromRGB(200, 150, 160)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = mainFrame

-- ============================================
-- ABAS (TABS)
-- ============================================
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.Position = UDim2.new(0, 0, 0, 80)
tabFrame.BackgroundColor3 = Color3.fromRGB(20, 8, 12)
tabFrame.BackgroundTransparency = 0.3
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

-- Botões das Abas
local aba1 = Instance.new("TextButton")
aba1.Size = UDim2.new(0.33, -2, 1, -4)
aba1.Position = UDim2.new(0, 2, 0, 2)
aba1.Text = "🎮 AUTO-PLAY"
aba1.BackgroundColor3 = Color3.fromRGB(200, 50, 70)
aba1.TextColor3 = Color3.fromRGB(255, 255, 255)
aba1.TextSize = 13
aba1.Font = Enum.Font.GothamBold
aba1.Parent = tabFrame

local aba2 = Instance.new("TextButton")
aba2.Size = UDim2.new(0.33, -2, 1, -4)
aba2.Position = UDim2.new(0.33, 2, 0, 2)
aba2.Text = "🧠 ESTRATÉGIA"
aba2.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
aba2.TextColor3 = Color3.fromRGB(200, 200, 200)
aba2.TextSize = 13
aba2.Font = Enum.Font.GothamBold
aba2.Parent = tabFrame

local aba3 = Instance.new("TextButton")
aba3.Size = UDim2.new(0.33, -2, 1, -4)
aba3.Position = UDim2.new(0.66, 4, 0, 2)
aba3.Text = "📊 MODIFIERS"
aba3.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
aba3.TextColor3 = Color3.fromRGB(200, 200, 200)
aba3.TextSize = 13
aba3.Font = Enum.Font.GothamBold
aba3.Parent = tabFrame

-- ============================================
-- CONTEÚDO DAS ABAS
-- ============================================
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 0, 380)
contentFrame.Position = UDim2.new(0, 10, 0, 125)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ABA 1: AUTO-PLAY
local autoPlayFrame = Instance.new("Frame")
autoPlayFrame.Size = UDim2.new(1, 0, 1, 0)
autoPlayFrame.BackgroundTransparency = 1
autoPlayFrame.Visible = true
autoPlayFrame.Parent = contentFrame

-- Checkbox Auto Move
local autoMoveBox = Instance.new("TextButton")
autoMoveBox.Size = UDim2.new(0, 180, 0, 35)
autoMoveBox.Position = UDim2.new(0.5, -90, 0, 10)
autoMoveBox.Text = "✅  MOVER AUTOMÁTICO"
autoMoveBox.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
autoMoveBox.TextColor3 = Color3.fromRGB(150, 255, 150)
autoMoveBox.TextSize = 12
autoMoveBox.Font = Enum.Font.GothamBold
autoMoveBox.Parent = autoPlayFrame

local autoBattleBox = Instance.new("TextButton")
autoBattleBox.Size = UDim2.new(0, 180, 0, 35)
autoBattleBox.Position = UDim2.new(0.5, -90, 0, 55)
autoBattleBox.Text = "✅  BATALHA AUTOMÁTICA"
autoBattleBox.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
autoBattleBox.TextColor3 = Color3.fromRGB(150, 255, 150)
autoBattleBox.TextSize = 12
autoBattleBox.Font = Enum.Font.GothamBold
autoBattleBox.Parent = autoPlayFrame

local autoCardBox = Instance.new("TextButton")
autoCardBox.Size = UDim2.new(0, 180, 0, 35)
autoCardBox.Position = UDim2.new(0.5, -90, 0, 100)
autoCardBox.Text = "✅  ESCOLHER CARTAS"
autoCardBox.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
autoCardBox.TextColor3 = Color3.fromRGB(150, 255, 150)
autoCardBox.TextSize = 12
autoCardBox.Font = Enum.Font.GothamBold
autoCardBox.Parent = autoPlayFrame

local autoUpgradeBox = Instance.new("TextButton")
autoUpgradeBox.Size = UDim2.new(0, 180, 0, 35)
autoUpgradeBox.Position = UDim2.new(0.5, -90, 0, 145)
autoUpgradeBox.Text = "✅  UPGRADE AUTOMÁTICO"
autoUpgradeBox.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
autoUpgradeBox.TextColor3 = Color3.fromRGB(150, 255, 150)
autoUpgradeBox.TextSize = 12
autoUpgradeBox.Font = Enum.Font.GothamBold
autoUpgradeBox.Parent = autoPlayFrame

-- ABA 2: ESTRATÉGIA
local strategyFrame = Instance.new("Frame")
strategyFrame.Size = UDim2.new(1, 0, 1, 0)
strategyFrame.BackgroundTransparency = 1
strategyFrame.Visible = false
strategyFrame.Parent = contentFrame

local estrategiaText = Instance.new("TextLabel")
estrategiaText.Size = UDim2.new(1, -20, 0, 40)
estrategiaText.Position = UDim2.new(0, 10, 0, 10)
estrategiaText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
estrategiaText.BackgroundTransparency = 0.5
estrategiaText.Text = "📊 ESTRATÉGIA ATUAL: FARM"
estrategiaText.TextColor3 = Color3.fromRGB(255, 200, 100)
estrategiaText.TextSize = 13
estrategiaText.Font = Enum.Font.GothamBold
estrategiaText.Parent = strategyFrame

local estrategiaInfo = Instance.new("TextLabel")
estrategiaInfo.Size = UDim2.new(1, -20, 0, 250)
estrategiaInfo.Position = UDim2.new(0, 10, 0, 60)
estrategiaInfo.BackgroundTransparency = 1
estrategiaInfo.Text = "🗺️ Prioriza nós BRANCOS (Battle)\n🎯 Foco em farmar moedas\n🛡️ Evita Elites no começo"
estrategiaInfo.TextColor3 = Color3.fromRGB(200, 180, 180)
estrategiaInfo.TextSize = 12
estrategiaInfo.TextXAlignment = Enum.TextXAlignment.Left
estrategiaInfo.TextYAlignment = Enum.TextYAlignment.Top
estrategiaInfo.Parent = strategyFrame

-- ABA 3: MODIFIERS
local modifiersFrame = Instance.new("Frame")
modifiersFrame.Size = UDim2.new(1, 0, 1, 0)
modifiersFrame.BackgroundTransparency = 1
modifiersFrame.Visible = false
modifiersFrame.Parent = contentFrame

local modifiersList = Instance.new("ScrollingFrame")
modifiersList.Size = UDim2.new(1, -10, 1, -10)
modifiersList.Position = UDim2.new(0, 5, 0, 5)
modifiersList.BackgroundColor3 = Color3.fromRGB(15, 8, 12)
modifiersList.BackgroundTransparency = 0.3
modifiersList.BorderSizePixel = 1
modifiersList.CanvasSize = UDim2.new(0, 0, 0, 400)
modifiersList.ScrollBarThickness = 6
modifiersList.Parent = modifiersFrame

local function atualizarListaModifiers()
    for _, child in ipairs(modifiersList:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    local altura = 5
    for nome, ativoMod in pairs(modifiers) do
        local modLabel = Instance.new("TextLabel")
        modLabel.Size = UDim2.new(1, -10, 0, 25)
        modLabel.Position = UDim2.new(0, 5, 0, altura)
        modLabel.BackgroundColor3 = Color3.fromRGB(25, 12, 18)
        modLabel.Text = (ativoMod and "✅ " or "❌ ") .. nome
        modLabel.TextColor3 = ativoMod and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 100, 100)
        modLabel.TextSize = 11
        modLabel.Parent = modifiersList
        altura = altura + 28
    end
    modifiersList.CanvasSize = UDim2.new(0, 0, 0, altura + 10)
end

-- Botão principal de ativação
local btnAtivar = Instance.new("TextButton")
btnAtivar.Size = UDim2.new(0, 200, 0, 45)
btnAtivar.Position = UDim2.new(0.5, -100, 0, 520)
btnAtivar.Text = "🔴 ATIVAR ROME HUB"
btnAtivar.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
btnAtivar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAtivar.TextSize = 14
btnAtivar.Font = Enum.Font.GothamBold
btnAtivar.Parent = mainFrame

-- Status
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 0, 30)
statusText.Position = UDim2.new(0, 10, 0, 490)
statusText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusText.BackgroundTransparency = 0.5
statusText.Text = "⚡ ROME HUB DESATIVADO"
statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
statusText.TextSize = 12
statusText.Font = Enum.Font.GothamBold
statusText.Parent = mainFrame

-- ============================================
-- FUNÇÕES DOS CHECKBOXES
-- ============================================
autoMoveBox.MouseButton1Click:Connect(function()
    autoMove = not autoMove
    autoMoveBox.Text = autoMove and "✅  MOVER AUTOMÁTICO" or "❌  MOVER AUTOMÁTICO"
    autoMoveBox.TextColor3 = autoMove and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 100, 100)
end)

autoBattleBox.MouseButton1Click:Connect(function()
    autoBattle = not autoBattle
    autoBattleBox.Text = autoBattle and "✅  BATALHA AUTOMÁTICA" or "❌  BATALHA AUTOMÁTICA"
    autoBattleBox.TextColor3 = autoBattle and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 100, 100)
end)

autoCardBox.MouseButton1Click:Connect(function()
    autoChooseCard = not autoChooseCard
    autoCardBox.Text = autoChooseCard and "✅  ESCOLHER CARTAS" or "❌  ESCOLHER CARTAS"
    autoCardBox.TextColor3 = autoChooseCard and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 100, 100)
end)

autoUpgradeBox.MouseButton1Click:Connect(function()
    autoUpgrade = not autoUpgrade
    autoUpgradeBox.Text = autoUpgrade and "✅  UPGRADE AUTOMÁTICO" or "❌  UPGRADE AUTOMÁTICO"
    autoUpgradeBox.TextColor3 = autoUpgrade and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 100, 100)
end)

-- ============================================
-- FUNÇÕES DE ESTRATÉGIA (IA)
-- ============================================
local function atualizarEstrategia()
    if modifiers.LimitBreak then
        estrategiaAtual = "CAÇAR_ELITE"
        estrategiaText.Text = "📊 ESTRATÉGIA ATUAL: CAÇAR ELITE 🔴"
        estrategiaInfo.Text = "🎯 Priorize nós VERMELHOS (Elite Boss)\n⚔️ Ganhe slots permanentes\n💀 Risco alto, recompensa maior"
    elseif floorAtual <= 10 then
        estrategiaAtual = "FARM"
        estrategiaText.Text = "📊 ESTRATÉGIA ATUAL: FARM 🟡"
        estrategiaInfo.Text = "🗺️ Priorize nós BRANCOS (Battle)\n💰 Foco em farmar moedas\n🛡️ Evite Elites no começo"
    elseif hp > 70 then
        estrategiaAtual = "ARISCADO"
        estrategiaText.Text = "📊 ESTRATÉGIA ATUAL: ARISCADO 🔥"
        estrategiaInfo.Text = "🎯 Priorize ELITES > LOJA > BATALHA\n⚔️ Busque cartas de dano\n💀 Meta é destruir chefes"
    else
        estrategiaAtual = "SOBREVIVENCIA"
        estrategiaText.Text = "📊 ESTRATÉGIA ATUAL: SOBREVIVÊNCIA 🛡️"
        estrategiaInfo.Text = "🏥 Priorize LOJAS e CURAS\n🛡️ Foque em Base Shield\n⚠️ Evite combates desnecessários"
    end
end

-- ============================================
-- IA PRINCIPAL (INTEGRADA)
-- ============================================
local function loopIA()
    while ativo do
        atualizarEstrategia()
        
        -- Auto-mover no mapa
        if autoMove then
            -- Lógica de escolha de caminho baseada na estratégia
            -- (implementação real dependeria de detecção de UI)
        end
        
        -- Auto-batalha
        if autoBattle then
            -- Coloca unidades automaticamente
        end
        
        -- Auto-escolha de cartas
        if autoChooseCard then
            -- Prioriza cartas do meta
            local prioridadeCartas = {
                "Limit Break", "Monarch's Breakthrough", "All Range Rage",
                "Rageful Arrival", "Elite Conquest", "Treasure Map"
            }
            -- (detecção real de cartas na tela)
        end
        
        task.wait(0.5)
    end
end

-- ============================================
-- ATIVAÇÃO/DESATIVAÇÃO
-- ============================================
local function alternarAtivacao()
    ativo = not ativo
    if ativo then
        statusText.Text = "✅ ROME HUB ATIVADO"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
        btnAtivar.Text = "⏹️ DESATIVAR"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        loopIA()
    else
        statusText.Text = "⚡ ROME HUB DESATIVADO"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        btnAtivar.Text = "🔴 ATIVAR ROME HUB"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
    end
end

btnAtivar.MouseButton1Click:Connect(alternarAtivacao)

-- ============================================
-- TROCAR ABAS
-- ============================================
aba1.MouseButton1Click:Connect(function()
    autoPlayFrame.Visible = true
    strategyFrame.Visible = false
    modifiersFrame.Visible = false
    aba1.BackgroundColor3 = Color3.fromRGB(200, 50, 70)
    aba2.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
    aba3.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
end)

aba2.MouseButton1Click:Connect(function()
    autoPlayFrame.Visible = false
    strategyFrame.Visible = true
    modifiersFrame.Visible = false
    atualizarEstrategia()
    aba1.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
    aba2.BackgroundColor3 = Color3.fromRGB(200, 50, 70)
    aba3.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
end)

aba3.MouseButton1Click:Connect(function()
    autoPlayFrame.Visible = false
    strategyFrame.Visible = false
    modifiersFrame.Visible = true
    atualizarListaModifiers()
    aba1.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
    aba2.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
    aba3.BackgroundColor3 = Color3.fromRGB(200, 50, 70)
end)

-- Tecla de atalho (X)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        alternarAtivacao()
    end
end)

-- Inicialização
atualizarListaModifiers()
atualizarEstrategia()

print("=" .. string.rep("=", 60))
print("🔥 ROME HUB - ANIME VANGUARDS ODYSSEY 🔥")
print("✅ Interface carregada com sucesso!")
print("📌 Tecla X para ativar/desativar")
print("📌 Abas funcionais e checkboxes configurados")
print("=" .. string.rep("=", 60))
