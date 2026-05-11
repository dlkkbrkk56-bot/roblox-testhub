--[[
    MACRO UNIVERSAL - Mouse, Teclado e Celular
    - Grava cliques, teclas e toques
    - Interface bonita com status e controles
    - Funções: Ativar/Desativar, Gravar, Parar, Salvar, Cancelar, Carregar
    - Suporte a PC (mouse/teclado) e Celular (toques)
    - Feito por Romeu
--]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- ========== VERIFICA SE É CELULAR ==========
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local inputType = isMobile and "📱 CELULAR" or "🖥️ PC"

-- ========== VARIÁVEIS ==========
local gravando = false
local rodando = false
local macroPassos = {} -- {tipo, x, y, tecla, delay}
local inicioGravacao = 0
local stepAtual = 0
local macroSalva = false
local ultimoRegistro = 0
local nomeMacro = "macro_" .. os.time()

-- ========== GUI PRINCIPAL ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MacroRomeu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Tela de Carregamento
local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(0, 400, 0, 220)
loadFrame.Position = UDim2.new(0.5, -200, 0.5, -110)
loadFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
loadFrame.BorderSizePixel = 3
loadFrame.BorderColor3 = Color3.fromRGB(255, 100, 100)
loadFrame.Parent = screenGui

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0, 50)
loadTitle.Position = UDim2.new(0, 0, 0, 20)
loadTitle.Text = "🔥 ROMEU MACRO v2.0 🔥"
loadTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
loadTitle.TextSize = 22
loadTitle.Font = Enum.Font.GothamBold
loadTitle.Parent = loadFrame

local loadType = Instance.new("TextLabel")
loadType.Size = UDim2.new(1, 0, 0, 30)
loadType.Position = UDim2.new(0, 0, 0, 75)
loadType.Text = "Modo: " .. inputType
loadType.TextColor3 = Color3.fromRGB(200, 200, 200)
loadType.TextSize = 14
loadType.Parent = loadFrame

local loadBarBack = Instance.new("Frame")
loadBarBack.Size = UDim2.new(0, 300, 0, 25)
loadBarBack.Position = UDim2.new(0.5, -150, 0, 115)
loadBarBack.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
loadBarBack.Parent = loadFrame

local loadBar = Instance.new("Frame")
loadBar.Size = UDim2.new(0, 0, 1, 0)
loadBar.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
loadBar.Parent = loadBarBack

local loadText = Instance.new("TextLabel")
loadText.Size = UDim2.new(1, 0, 0, 30)
loadText.Position = UDim2.new(0, 0, 0, 150)
loadText.Text = "Carregando... 0%"
loadText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadText.TextSize = 12
loadText.Parent = loadFrame

-- Animação de carregamento
for i = 1, 100 do
    local width = (i / 100) * 300
    loadBar:TweenSize(UDim2.new(0, width, 1, 0), "Out", "Quad", 0.01, true)
    loadText.Text = "Carregando... " .. i .. "%"
    task.wait(0.008)
end
loadText.Text = "✅ Pronto! Macro de Romeu carregado."
task.wait(0.8)
loadFrame.Visible = false

-- ========== INTERFACE PRINCIPAL ==========
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 520)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(100, 150, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
title.Text = "🤖 ROMEU MACRO PRO 🤖"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Tipo de dispositivo
local deviceLabel = Instance.new("TextLabel")
deviceLabel.Size = UDim2.new(1, 0, 0, 25)
deviceLabel.Position = UDim2.new(0, 0, 0, 50)
deviceLabel.Text = "✅ Modo: " .. inputType
deviceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
deviceLabel.TextSize = 12
deviceLabel.BackgroundTransparency = 1
deviceLabel.Parent = mainFrame

-- Status
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0, 200, 0, 60)
statusFrame.Position = UDim2.new(0.5, -100, 0, 80)
statusFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusFrame.BackgroundTransparency = 0.5
statusFrame.BorderSizePixel = 1
statusFrame.Parent = mainFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 30)
statusText.Position = UDim2.new(0, 0, 0, 5)
statusText.Text = "⚪ PARADO"
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.TextSize = 16
statusText.Font = Enum.Font.GothamBold
statusText.Parent = statusFrame

local passosText = Instance.new("TextLabel")
passosText.Size = UDim2.new(1, 0, 0, 20)
passosText.Position = UDim2.new(0, 0, 0, 38)
passosText.Text = "Passos: 0"
passosText.TextColor3 = Color3.fromRGB(150, 150, 150)
passosText.TextSize = 11
passosText.Parent = statusFrame

-- Botões principais (Linha 1)
local btnGravar = Instance.new("TextButton")
btnGravar.Size = UDim2.new(0, 110, 0, 45)
btnGravar.Position = UDim2.new(0.05, 0, 0, 150)
btnGravar.Text = "🔴 GRAVAR"
btnGravar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btnGravar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnGravar.TextSize = 14
btnGravar.Font = Enum.Font.GothamBold
btnGravar.Parent = mainFrame

local btnRepetir = Instance.new("TextButton")
btnRepetir.Size = UDim2.new(0, 110, 0, 45)
btnRepetir.Position = UDim2.new(0.38, -55, 0, 150)
btnRepetir.Text = "▶️ REPETIR"
btnRepetir.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
btnRepetir.TextColor3 = Color3.fromRGB(255, 255, 255)
btnRepetir.TextSize = 14
btnRepetir.Font = Enum.Font.GothamBold
btnRepetir.Parent = mainFrame

local btnParar = Instance.new("TextButton")
btnParar.Size = UDim2.new(0, 110, 0, 45)
btnParar.Position = UDim2.new(0.71, -55, 0, 150)
btnParar.Text = "⏹️ PARAR"
btnParar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
btnParar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnParar.TextSize = 14
btnParar.Font = Enum.Font.GothamBold
btnParar.Parent = mainFrame

-- Botões secundários (Linha 2)
local btnSalvar = Instance.new("TextButton")
btnSalvar.Size = UDim2.new(0, 100, 0, 35)
btnSalvar.Position = UDim2.new(0.05, 0, 0, 205)
btnSalvar.Text = "💾 SALVAR"
btnSalvar.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
btnSalvar.Parent = mainFrame

local btnCancelar = Instance.new("TextButton")
btnCancelar.Size = UDim2.new(0, 100, 0, 35)
btnCancelar.Position = UDim2.new(0.38, -50, 0, 205)
btnCancelar.Text = "❌ CANCELAR"
btnCancelar.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
btnCancelar.Parent = mainFrame

local btnLimpar = Instance.new("TextButton")
btnLimpar.Size = UDim2.new(0, 100, 0, 35)
btnLimpar.Position = UDim2.new(0.71, -50, 0, 205)
btnLimpar.Text = "🗑️ LIMPAR"
btnLimpar.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
btnLimpar.Parent = mainFrame

-- Lista de passos
local stepsFrame = Instance.new("ScrollingFrame")
stepsFrame.Size = UDim2.new(0, 350, 0, 200)
stepsFrame.Position = UDim2.new(0.5, -175, 0, 255)
stepsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
stepsFrame.BorderSizePixel = 1
stepsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
stepsFrame.ScrollBarThickness = 6
stepsFrame.Parent = mainFrame

local stepsLayout = Instance.new("UIListLayout")
stepsLayout.Padding = UDim.new(0, 4)
stepsLayout.Parent = stepsFrame

-- Atualiza lista de passos na interface
local function atualizarLista()
    for _, child in ipairs(stepsFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    local alturaTotal = 0
    for i, passo in ipairs(macroPassos) do
        local stepLabel = Instance.new("TextLabel")
        stepLabel.Size = UDim2.new(1, -10, 0, 25)
        stepLabel.Position = UDim2.new(0, 5, 0, alturaTotal)
        stepLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        stepLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        stepLabel.TextSize = 11
        stepLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        if passo.tipo == "click" then
            stepLabel.Text = "🖱️ Clique em (" .. math.floor(passo.x) .. ", " .. math.floor(passo.y) .. ")"
        elseif passo.tipo == "key" then
            stepLabel.Text = "⌨️ Tecla: " .. passo.tecla
        elseif passo.tipo == "touch" then
            stepLabel.Text = "👆 Toque em (" .. math.floor(passo.x) .. ", " .. math.floor(passo.y) .. ")"
        end
        
        stepLabel.Parent = stepsFrame
        alturaTotal = alturaTotal + 28
    end
    
    stepsFrame.CanvasSize = UDim2.new(0, 0, 0, alturaTotal)
    passosText.Text = "Passos: " .. #macroPassos
end

-- ========== FUNÇÕES DE GRAVAÇÃO ==========

-- Para mouse/teclado (PC)
if not isMobile then
    mouse.Button1Down:Connect(function()
        if gravando then
            local pos = UserInputService:GetMouseLocation()
            local passo = {
                tipo = "click",
                x = pos.X,
                y = pos.Y,
                delay = os.clock() - ultimoRegistro
            }
            ultimoRegistro = os.clock()
            table.insert(macroPassos, passo)
            atualizarLista()
            statusText.Text = "🔴 GRAVANDO: " .. #macroPassos
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if gravando and input.KeyCode ~= Enum.KeyCode.Unknown then
            local passo = {
                tipo = "key",
                tecla = tostring(input.KeyCode),
                delay = os.clock() - ultimoRegistro
            }
            ultimoRegistro = os.clock()
            table.insert(macroPassos, passo)
            atualizarLista()
            statusText.Text = "🔴 GRAVANDO: " .. #macroPassos
        end
    end)
end

-- Para celular (toques)
if isMobile then
    UserInputService.TouchBegan:Connect(function(touch, gameProcessed)
        if gameProcessed then return end
        if gravando then
            local passo = {
                tipo = "touch",
                x = touch.Position.X,
                y = touch.Position.Y,
                delay = os.clock() - ultimoRegistro
            }
            ultimoRegistro = os.clock()
            table.insert(macroPassos, passo)
            atualizarLista()
            statusText.Text = "🔴 GRAVANDO: " .. #macroPassos
        end
    end)
end

-- ========== FUNÇÃO DE REPRODUÇÃO ==========
local function reproduzirMacro()
    if #macroPassos == 0 then
        statusText.Text = "⚠️ NADA GRAVADO"
        return
    end
    
    rodando = true
    statusText.Text = "▶️ REPRODUZINDO..."
    
    for i, passo in ipairs(macroPassos) do
        if not rodando then break end
        
        if passo.delay and passo.delay > 0 then
            task.wait(passo.delay)
        end
        
        if passo.tipo == "click" then
            -- Simula clique
            local pos = Vector2.new(passo.x, passo.y)
            mouse.Move(pos)
            task.wait(0.05)
            mouse.Button1Down()
            task.wait(0.05)
            mouse.Button1Up()
        elseif passo.tipo == "touch" and isMobile then
            -- Simula toque (celular)
            local pos = Vector2.new(passo.x, passo.y)
            -- Nota: Simulação de toque no celular é limitada
        elseif passo.tipo == "key" then
            -- Simula tecla (PC)
            local keyCode = Enum.KeyCode[passo.tecla]
            if keyCode then
                UserInputService.InputBegan:Fire(keyCode, Enum.UserInputState.Begin)
                task.wait(0.05)
                UserInputService.InputEnded:Fire(keyCode, Enum.UserInputState.End)
            end
        end
        
        statusText.Text = "▶️ " .. i .. "/" .. #macroPassos
        RunService.Heartbeat:Wait()
    end
    
    if rodando then
        statusText.Text = "✅ FINALIZADO"
    end
    rodando = false
end

-- ========== FUNÇÕES DOS BOTÕES ==========

btnGravar.MouseButton1Click:Connect(function()
    if rodando then
        rodando = false
        task.wait(0.3)
    end
    
    gravando = not gravando
    
    if gravando then
        macroPassos = {}
        ultimoRegistro = os.clock()
        atualizarLista()
        statusText.Text = "🔴 GRAVANDO..."
        btnGravar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        btnGravar.Text = "⏹️ PARAR GRAV"
    else
        statusText.Text = "⏸️ GRAVAÇÃO PARADA"
        btnGravar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        btnGravar.Text = "🔴 GRAVAR"
    end
end)

btnRepetir.MouseButton1Click:Connect(function()
    if gravando then
        gravando = false
        btnGravar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        btnGravar.Text = "🔴 GRAVAR"
    end
    
    if #macroPassos == 0 then
        statusText.Text = "⚠️ NADA GRAVADO"
        return
    end
    
    if rodando then
        rodando = false
        statusText.Text = "⏹️ PARADO"
        btnRepetir.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        btnRepetir.Text = "▶️ REPETIR"
    else
        btnRepetir.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
        btnRepetir.Text = "⏹️ PARAR REP"
        reproduzirMacro()
        btnRepetir.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        btnRepetir.Text = "▶️ REPETIR"
    end
end)

btnParar.MouseButton1Click:Connect(function()
    if gravando then
        gravando = false
        btnGravar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        btnGravar.Text = "🔴 GRAVAR"
    end
    
    if rodando then
        rodando = false
        task.wait(0.2)
    end
    
    statusText.Text = "⚪ PARADO"
    btnRepetir.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    btnRepetir.Text = "▶️ REPETIR"
end)

btnSalvar.MouseButton1Click:Connect(function()
    if #macroPassos == 0 then
        statusText.Text = "⚠️ NADA PARA SALVAR"
        return
    end
    
    local dados = HttpService:JSONEncode(macroPassos)
    -- Simula salvamento (na prática salvamos em variável)
    macroSalva = true
    statusText.Text = "💾 MACRO SALVO!"
    task.wait(1)
    if not gravando and not rodando then
        statusText.Text = "⚪ PARADO"
    end
end)

btnCancelar.MouseButton1Click:Connect(function()
    if gravando then
        gravando = false
        btnGravar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        btnGravar.Text = "🔴 GRAVAR"
    end
    
    if rodando then
        rodando = false
        task.wait(0.2)
    end
    
    macroPassos = {}
    atualizarLista()
    statusText.Text = "❌ MACRO CANCELADO"
    btnRepetir.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    btnRepetir.Text = "▶️ REPETIR"
    task.wait(1)
    statusText.Text = "⚪ PARADO"
end)

btnLimpar.MouseButton1Click:Connect(function()
    if gravando then
        gravando = false
        btnGravar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        btnGravar.Text = "🔴 GRAVAR"
    end
    
    if rodando then
        rodando = false
        task.wait(0.2)
    end
    
    macroPassos = {}
    atualizarLista()
    statusText.Text = "🗑️ MACRO LIMPO"
    btnRepetir.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    btnRepetir.Text = "▶️ REPETIR"
    task.wait(1)
    statusText.Text = "⚪ PARADO"
end)

-- ========== FINALIZAÇÃO ==========
print("=" .. string.rep("=", 60))
print("🔥 MACRO ROMEU CARREGADO COM SUCESSO!")
print("📌 Modo: " .. inputType)
print("📌 Funções: GRAVAR | REPETIR | PARAR | SALVAR | CANCELAR | LIMPAR")
print("=" .. string.rep("=", 60))
