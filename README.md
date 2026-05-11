-- SCRIPT REROLL - VERSÃO FINAL CORRIGIDA
loadstring(game:HttpGet("https://pastebin.com/raw/SEU_LINK"))()

-- Ou use este código direto:
local player = game.Players.LocalPlayer
local ativo = false
local rerolls = 0

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BackgroundTransparency = 0.5
frame.Parent = gui

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0,5)
status.Text = "❌ INATIVO"
status.TextColor3 = Color3.fromRGB(255,0,0)
status.Parent = frame

local count = Instance.new("TextLabel")
count.Size = UDim2.new(1,0,0,30)
count.Position = UDim2.new(0,0,0,35)
count.Text = "Rerolls: 0"
count.TextColor3 = Color3.fromRGB(255,255,255)
count.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,100,0,30)
btn.Position = UDim2.new(0.5,-50,0,70)
btn.Text = "ATIVAR"
btn.Parent = frame

-- Função que NÃO usa .Text em ImageButton
function clicarReroll()
    local traits = player.PlayerGui:FindFirstChild("Windows") and player.PlayerGui.Windows:FindFirstChild("Traits")
    if not traits then return false end
    
    -- Procura SOMENTE pelo nome (sem verificar texto)
    for _, botao in ipairs(traits:GetDescendants()) do
        if (botao:IsA("ImageButton") or botao:IsA("TextButton")) and botao.Name and botao.Name:lower() == "reroll" then
            if botao.Visible then
                botao.MouseButton1Click:Fire()
                return true
            end
        end
    end
    return false
end

function loop()
    while ativo do
        status.Text = "🔄 PROCURANDO..."
        if clicarReroll() then
            rerolls = rerolls + 1
            count.Text = "Rerolls: " .. rerolls
            status.Text = "✅ REJOIN..."
            task.wait(2)
            game:GetService("TeleportService"):Teleport(game.PlaceId, player)
            break
        else
            status.Text = "❌ Selecione unidade!"
            task.wait(2)
        end
    end
end

btn.MouseButton1Click:Connect(function()
    ativo = not ativo
    if ativo then
        status.Text = "✅ ATIVO"
        status.TextColor3 = Color3.fromRGB(0,255,0)
        btn.Text = "PARAR"
        loop()
    else
        status.Text = "❌ INATIVO"
        status.TextColor3 = Color3.fromRGB(255,0,0)
        btn.Text = "ATIVAR"
    end
end)

print("✅ Script pronto! Só selecionar a unidade e ativar!")
