-- MACRO ROMEU - VERSÃO SIMPLES E FUNCIONAL
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")

-- ========== VARIÁVEIS ==========
local gravando = false
local rodando = false
local passos = {} -- {x, y, delay, tipo}
local tempoInicio = 0
local ultimoTempo = 0

-- ========== GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MacroRomeu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 100, 100)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
title.Text = "🎬 ROMEU MACRO 🎬"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 40)
status.Position = UDim2.new(0, 10, 0, 50)
status.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
status.Text = "⚪ PARADO"
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.TextSize = 14
status.Font = Enum.Font.GothamBold
status.Parent = frame

local contador = Instance.new("TextLabel")
contador.Size = UDim2.new(1, -20, 0, 30)
contador.Position = UDim2.new(0, 10, 0, 95)
contador.Text = "Passos: 0"
contador.TextColor3 = Color3.fromRGB(150, 150, 150)
contador.TextSize = 12
contador.Parent = frame

-- Botão GRAVAR
local btnGravar = Instance.new("TextButton")
btnGravar.Size = UDim2.new(0, 120, 0, 40)
btnGravar.Position = UDim2.new(0.1, 0, 0, 135)
btnGravar.Text = "🔴 GRAVAR"
btnGravar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btnGravar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnGravar.TextSize = 14
btnGravar.Font = Enum.Font.GothamBold
btnGravar.Parent = frame

-- Botão REPETIR
local btnRepetir = Instance.new("TextButton")
btnRepetir.Size = UDim2.new(0, 120, 0, 40)
btnRepetir.Position = UDim2.new(0.55, -60, 0, 135)
btnRepetir.Text = "▶️ REPETIR"
btnRepetir.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
btnRepetir.TextColor3 = Color3.fromRGB(255, 255, 255)
btnRepetir.TextSize = 14
btnRepetir.Font = Enum.Font.GothamBold
btnRepetir.Parent = frame

-- ========== FUNÇÃO PARA ATUALIZAR DISPLAY ==========
local function atualizarDisplay()
    contador.Text = "Passos: " .. #passos
end

-- ========== GRAVAÇÃO DE CLIQUE ==========
mouse.Button1Down:Connect(function()
    if gravando then
        local agora = tick()
        local delay = agora - ultimoTempo
        ultimoTempo = agora
        
        local posicao = UserInputService:GetMouseLocation()
        table.insert(passos, {
            tipo = "click",
            x = posicao.X,
            y = posicao.Y,
            delay = delay
        })
        atualizarDisplay()
        status.Text = "🔴 GRAVANDO: " .. #passos .. " cliques"
        print("✅ Clique gravado em: " .. posicao.X .. ", " .. posicao.Y)
    end
end)

-- ========== REPRODUZIR MACRO ==========
local function reproduzir()
    if #passos == 0 then
        status.Text = "⚠️ NENHUM PASSO GRAVADO"
        return
    end
    
    rodando = true
    status.Text = "▶️ REPRODUZINDO..."
    btnRepetir.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    btnRepetir.Text = "⏹️ PARAR"
    
    for i, passo in ipairs(passos) do
        if not rodando then break end
        
        status.Text = "▶️ PASSO " .. i .. "/" .. #passos
        
        -- Aguarda o delay
        if passo.delay and passo.delay > 0 then
            task.wait(passo.delay)
        end
        
        if passo.tipo == "click" then
            -- Move o mouse e clica
            local pos = Vector2.new(passo.x, passo.y)
            mousemoverel(pos.X, pos.Y)
            task.wait(0.05)
            
            -- Pressiona e solta o clique
            mouse.Button1Down()
            task.wait(0.05)
            mouse.Button1Up()
        end
        
        task.wait(0.1)
    end
    
    if rodando then
        status.Text = "✅ FINALIZADO"
    end
    rodando = false
    btnRepetir.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    btnRepetir.Text = "▶️ REPETIR"
end

-- Função para mover o mouse (alternativa)
local function mousemoverel(x, y)
    local vpSize = workspace.CurrentCamera.ViewportSize
    local relX = (x / vpSize.X) * 2 - 1
    local relY = (y / vpSize.Y) * 2 - 1
    mouse.Move(mouse.X + (relX * 100), mouse.Y + (relY * 100))
end

-- ========== EVENTOS DOS BOTÕES ==========
btnGravar.MouseButton1Click:Connect(function()
    if rodando then
        rodando = false
        task.wait(0.3)
    end
    
    gravando = not gravando
    
    if gravando then
        passos = {}
        ultimoTempo = tick()
        atualizarDisplay()
        status.Text = "🔴 GRAVANDO..."
        btnGravar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        btnGravar.Text = "⏹️ PARAR"
    else
        status.Text = "⏸️ GRAVAÇÃO PARADA"
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
    
    if rodando then
        rodando = false
        status.Text = "⚪ PARADO"
        btnRepetir.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        btnRepetir.Text = "▶️ REPETIR"
    else
        if #passos == 0 then
            status.Text = "⚠️ GRAVE ALGO PRIMEIRO"
        else
            reproduzir()
        end
    end
end)

print("=" .. string.rep("=", 60))
print("✅ MACRO ROMEU CARREGADO!")
print("📌 Como usar:")
print("   1. Clique em GRAVAR")
print("   2. Faça seus cliques na tela")
print("   3. Clique em PARAR")
print("   4. Clique em REPETIR")
print("=" .. string.rep("=", 60))
