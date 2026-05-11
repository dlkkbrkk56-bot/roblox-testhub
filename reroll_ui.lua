-- HOOPSMASTER V6 - SÓ ARREMESSO (SEM TP EM PLAYERS)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ativo = false

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HoopsOnly"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 160)
frame.Position = UDim2.new(0.5, -140, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 100, 50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
title.Text = "🏀 HOOPS ONLY 🏀"
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
btnAtivar.Size = UDim2.new(0, 180, 0, 40)
btnAtivar.Position = UDim2.new(0.5, -90, 0, 105)
btnAtivar.Text = "🏀 ATIVAR"
btnAtivar.BackgroundColor3 = Color3.fromRGB(255, 80, 40)
btnAtivar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAtivar.TextSize = 14
btnAtivar.Font = Enum.Font.GothamBold
btnAtivar.Parent = frame

-- Só encontra a cesta adversária
local function encontrarCesta()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name:lower():find("hoop") then
            if part.BrickColor and (part.BrickColor.Name:find("blue") or part.BrickColor.Name == "Really blue") then
                return part
            end
        end
    end
    return nil
end

-- Arremessa sem TP
local function arremessar()
    local cesta = encontrarCesta()
    if not cesta then return end
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Só mira na cesta (não teleporta)
        local playerPos = player.Character.HumanoidRootPart.Position
        local lookAt = CFrame.lookAt(playerPos, cesta.Position + Vector3.new(0, 2, 0))
        player.Character.HumanoidRootPart.CFrame = lookAt
        
        -- Arremessa
        mouse.Button1Down()
        task.wait(0.3)
        mouse.Button1Up()
        
        statusText.Text = "🏀 ARREMESSOU!"
    end
end

-- Loop
local function loop()
    while ativo do
        arremessar()
        task.wait(0.5)
        RunService.RenderStepped:Wait()
    end
end

-- Ativar
local function alternar()
    ativo = not ativo
    if ativo then
        statusText.Text = "🏀 ATIVADO"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
        btnAtivar.Text = "⏹️ DESATIVAR"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        loop()
    else
        statusText.Text = "⚡ DESATIVADO"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        btnAtivar.Text = "🏀 ATIVAR"
        btnAtivar.BackgroundColor3 = Color3.fromRGB(255, 80, 40)
    end
end

btnAtivar.MouseButton1Click:Connect(alternar)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        alternar()
    end
end)

print("=" .. string.rep("=", 50))
print("🏀 HOOPS ONLY - SÓ ARREMESSO")
print("✅ SEM TP em players")
print("✅ Só mira e arremessa")
print("=" .. string.rep("=", 50))
