-- ROME ULTIMATE v1.0 - SÓ O QUE FUNCIONA
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local ativo = false
local prioridadeCartas = {
    "Limit Break",
    "Monarch's Breakthrough",
    "Elite Conquest",
    "All Range Rage",
    "Rageful Arrival",
    "Placement Shockwave",
    "Escalating Fury",
    "Rage Slots"
}

-- Função para clicar em objeto
local function click(obj)
    if not obj or not obj.Parent then return false end
    local pos = obj.AbsolutePosition
    local size = obj.AbsoluteSize
    VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, true, game, 1)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, false, game, 1)
    return true
end

-- Autopicker
local function pickCard()
    for _, cardName in ipairs(prioridadeCartas) do
        for _, obj in ipairs(player.PlayerGui:GetDescendants()) do
            if obj:IsA("TextButton") and obj.Visible and obj.Text and obj.Text:find(cardName) then
                click(obj)
                return true
            end
        end
    end
    return false
end

-- Auto-place (Regnow)
local function placeUnits()
    for _, obj in ipairs(player.PlayerGui:GetDescendants()) do
        if obj:IsA("ImageButton") and obj.Visible and obj.Active then
            local nome = obj.Name:lower()
            if nome:find("slot") or nome:find("placement") or nome:find("unit") then
                click(obj)
                task.wait(0.3)
            end
        end
    end
end

-- Auto-upgrade
local function upgradeUnits()
    for _, obj in ipairs(player.PlayerGui:GetDescendants()) do
        if obj:IsA("TextButton") and obj.Visible and (obj.Text:lower():find("upgrade") or obj.Name:lower():find("upgrade")) then
            click(obj)
            task.wait(0.2)
        end
    end
end

-- Loop principal
local function loop()
    while ativo do
        pickCard()
        placeUnits()
        upgradeUnits()
        task.wait(0.5)
    end
end

-- Interface simples
local gui = Instance.new("ScreenGui")
gui.Name = "RomeUltimate"
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 150, 0, 40)
btn.Position = UDim2.new(1, -160, 0, 10)
btn.Text = "🔴 ATIVAR"
btn.BackgroundColor3 = Color3.fromRGB(180, 30, 50)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Parent = gui

btn.MouseButton1Click:Connect(function()
    ativo = not ativo
    if ativo then
        btn.Text = "⏹️ PARAR"
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        task.spawn(loop)
    else
        btn.Text = "🔴 ATIVAR"
        btn.BackgroundColor3 = Color3.fromRGB(180, 30, 50)
    end
end)

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        ativo = not ativo
        btn.Text = ativo and "⏹️ PARAR" or "🔴 ATIVAR"
        btn.BackgroundColor3 = ativo and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(180, 30, 50)
        if ativo then task.spawn(loop) end
    end
end)

print("🔥 ROME ULTIMATE - SÓ O QUE FUNCIONA")
print("✅ Escolhe cartas, posiciona e upa")
print("❌ Navegação no mapa é MANUAL (você clica)")
print("🎮 Pressione X para ativar/desativar")
