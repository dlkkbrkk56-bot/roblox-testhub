-- ============================================================
-- ROLLBACK DUPE - ANIME EXPEDITIONS (VERSÃO ESTÁVEL)
-- ============================================================
-- AVISO: EXPLOIT - Use por sua conta e risco.
-- Use APENAS em conta secundária.
-- ============================================================

local player = game.Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")

-- ============================================================
-- CONFIGURAÇÕES
-- ============================================================
local CONFIG = {
    targetTrait = "Unbound",   -- Nome exato (case-sensitive)
    targetUnit = "Puppet",     -- Nome da unidade
    rerollDelay = 1.5,
    checkDelay = 0.8,
    maxAttempts = 1000,
}

-- ============================================================
-- UTILITÁRIO: Obter texto de um objeto com segurança
-- ============================================================
local function getObjectText(obj)
    if not obj then return "" end
    -- TextLabel, TextButton, TextBox
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        return obj.Text or ""
    end
    -- ImageButton não tem Text, usa Name como fallback
    if obj:IsA("ImageButton") then
        return obj.Name or ""
    end
    return ""
end

-- ============================================================
-- FUNÇÃO: Clicar em um ClickDetector (único método confiável)
-- ============================================================
local function clickDetector(detector)
    if not detector or not detector:IsA("ClickDetector") then
        return false
    end
    fireclickdetector(detector)
    return true
end

-- ============================================================
-- FUNÇÃO: Encontrar ClickDetector associado a um botão da GUI
-- ============================================================
local function findClickDetectorForButton(btn)
    if not btn then return nil end
    -- Verificar se o próprio botão tem um ClickDetector filho
    local det = btn:FindFirstChildOfClass("ClickDetector")
    if det then return det end
    -- Verificar no pai
    if btn.Parent then
        det = btn.Parent:FindFirstChildOfClass("ClickDetector")
        if det then return det end
    end
    -- Verificar se há um ClickDetector com mesmo nome ou próximo
    for _, child in ipairs(btn:GetChildren()) do
        if child:IsA("ClickDetector") then
            return child
        end
    end
    return nil
end

-- ============================================================
-- FUNÇÃO: Encontrar a GUI de rerroll (usando hierarquia real)
-- ============================================================
local function findRerollGUI()
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return nil end

    -- Procurar por uma GUI que contenha um botão "Reroll" com ClickDetector
    for _, gui in ipairs(playerGui:GetDescendants()) do
        if gui:IsA("ScreenGui") or gui:IsA("Frame") then
            local hasReroll = false
            local hasFilters = false
            local hasIndex = false

            for _, child in ipairs(gui:GetDescendants()) do
                if child:IsA("TextButton") or child:IsA("ImageButton") then
                    local text = getObjectText(child):lower()
                    if text:find("reroll") then hasReroll = true end
                    if text:find("filters") then hasFilters = true end
                    if text:find("index") then hasIndex = true end
                end
            end

            if hasReroll and hasFilters and hasIndex then
                -- Verificar se existe ao menos um ClickDetector associado
                local hasDetector = false
                for _, child in ipairs(gui:GetDescendants()) do
                    if child:IsA("ClickDetector") then
                        hasDetector = true
                        break
                    end
                end
                if hasDetector then
                    return gui
                end
            end
        end
    end
    return nil
end

-- ============================================================
-- FUNÇÃO: Encontrar botão por texto (case-insensitive)
-- ============================================================
local function findButtonByText(gui, textPattern)
    if not gui then return nil end
    local pattern = textPattern:lower()
    for _, child in ipairs(gui:GetDescendants()) do
        if child:IsA("TextButton") or child:IsA("ImageButton") then
            local text = getObjectText(child):lower()
            if text:find(pattern) then
                return child
            end
        end
    end
    return nil
end

-- ============================================================
-- FUNÇÃO: Encontrar botão que contém um TextLabel com um texto específico
-- ============================================================
local function findButtonWithLabel(gui, labelText)
    if not gui then return nil end
    for _, child in ipairs(gui:GetDescendants()) do
        if child:IsA("TextLabel") and child.Text and child.Text:find(labelText) then
            local parent = child.Parent
            if parent then
                -- O pai pode ser o botão
                if parent:IsA("TextButton") or parent:IsA("ImageButton") then
                    return parent
                end
                -- Ou o botão pode ser irmão
                for _, sibling in ipairs(parent:GetChildren()) do
                    if sibling:IsA("TextButton") or sibling:IsA("ImageButton") then
                        return sibling
                    end
                end
            end
        end
    end
    return nil
end

-- ============================================================
-- FUNÇÃO: Selecionar a unidade
-- ============================================================
local function selectUnit(gui, unitName)
    -- Encontrar o botão que abre a lista de unidades
    local changeBtn = findButtonWithLabel(gui, "Click to change unit")
    if not changeBtn then
        changeBtn = findButtonByText(gui, "change unit")
    end
    if not changeBtn then
        print("[Rollback] ❌ Botão de troca de unidade não encontrado.")
        return false
    end

    -- Clicar no botão via ClickDetector
    local det = findClickDetectorForButton(changeBtn)
    if det then
        clickDetector(det)
        task.wait(0.5)
    else
        print("[Rollback] ⚠️ Nenhum ClickDetector encontrado para o botão de troca.")
        return false
    end

    -- Agora deve aparecer a lista de unidades
    -- Procurar pela unidade desejada
    local unitBtn = findButtonByText(gui, unitName)
    if unitBtn then
        local det2 = findClickDetectorForButton(unitBtn)
        if det2 then
            clickDetector(det2)
            task.wait(0.3)
            return true
        end
    end

    print("[Rollback] ❌ Unidade '" .. unitName .. "' não encontrada na lista.")
    return false
end

-- ============================================================
-- FUNÇÃO: Obter a trait atual (lendo a GUI)
-- ============================================================
local function getCurrentTraitFromGUI(gui)
    if not gui then return nil end

    -- Procurar por um TextLabel com "Roll Chance" e identificar a trait
    for _, child in ipairs(gui:GetDescendants()) do
        if child:IsA("TextLabel") and child.Text and child.Text:find("Roll Chance") then
            local parent = child.Parent
            if parent then
                -- Verificar irmãos
                for _, sibling in ipairs(parent:GetChildren()) do
                    if sibling:IsA("TextLabel") and sibling ~= child then
                        local text = sibling.Text or ""
                        local traits = {"Unbound", "Primordial", "Forsaken", "Draconic"}
                        for _, trait in ipairs(traits) do
                            if text:find(trait) then
                                return trait
                            end
                        end
                    end
                end
                -- Verificar no pai do pai
                local grandParent = parent.Parent
                if grandParent then
                    for _, sibling in ipairs(grandParent:GetChildren()) do
                        if sibling:IsA("TextLabel") and sibling ~= parent then
                            local text = sibling.Text or ""
                            local traits = {"Unbound", "Primordial", "Forsaken", "Draconic"}
                            for _, trait in ipairs(traits) do
                                if text:find(trait) then
                                    return trait
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Fallback: procurar por "Pity" próximo a uma trait
    for _, child in ipairs(gui:GetDescendants()) do
        if child:IsA("TextLabel") and child.Text and child.Text:find("Pity") then
            local parent = child.Parent
            if parent then
                for _, sibling in ipairs(parent:GetChildren()) do
                    if sibling:IsA("TextLabel") and sibling ~= child then
                        local text = sibling.Text or ""
                        local traits = {"Unbound", "Primordial", "Forsaken", "Draconic"}
                        for _, trait in ipairs(traits) do
                            if text:find(trait) then
                                return trait
                            end
                        end
                    end
                end
            end
        end
    end

    return nil
end

-- ============================================================
-- FUNÇÃO: Rerrolar
-- ============================================================
local function performReroll(gui)
    local rerollBtn = findButtonByText(gui, "reroll")
    if not rerollBtn then
        print("[Rollback] ❌ Botão 'Reroll' não encontrado.")
        return false
    end

    local det = findClickDetectorForButton(rerollBtn)
    if det then
        clickDetector(det)
        task.wait(CONFIG.checkDelay)
        return true
    else
        print("[Rollback] ⚠️ Nenhum ClickDetector encontrado para o botão Reroll.")
        return false
    end
end

-- ============================================================
-- FUNÇÃO: Forçar rollback (reconectar)
-- ============================================================
local function forceRollback()
    print("[Rollback] 🔄 Forçando rollback...")
    local placeId = game.PlaceId
    TeleportService:Teleport(placeId, player)
    -- O script encerra aqui. Ao reconectar, re-execute manualmente.
end

-- ============================================================
-- FUNÇÃO: Verificar se a GUI ainda existe
-- ============================================================
local function isGuiValid(gui)
    if not gui then return false end
    return gui:IsDescendantOf(game) and gui.Parent ~= nil
end

-- ============================================================
-- FUNÇÃO PRINCIPAL
-- ============================================================
local function main()
    print("=" .. string.rep("=", 50))
    print("[Rollback] 🚀 INICIANDO ROLLBACK DUPE")
    print("[Rollback] 🎯 Trait alvo: " .. CONFIG.targetTrait)
    print("[Rollback] 👤 Unidade: " .. CONFIG.targetUnit)
    print("=" .. string.rep("=", 50))

    task.wait(3)

    local gui = findRerollGUI()
    if not gui then
        print("[Rollback] ❌ GUI de rerroll não encontrada.")
        print("[Rollback] Certifique-se de que a interface está aberta.")
        return
    end
    print("[Rollback] ✅ GUI encontrada!")

    print("[Rollback] Selecionando unidade: " .. CONFIG.targetUnit)
    if not selectUnit(gui, CONFIG.targetUnit) then
        print("[Rollback] ❌ Falha ao selecionar unidade.")
        return
    end
    task.wait(1)

    local rollCount = 0
    local traitFound = false

    while not traitFound and rollCount < CONFIG.maxAttempts do
        rollCount = rollCount + 1
        print(string.format("[Rollback] 🔄 Tentativa #%d", rollCount))

        if not isGuiValid(gui) then
            print("[Rollback] ❌ GUI foi destruída. Abra-a novamente e reinicie o script.")
            return
        end

        if not performReroll(gui) then
            print("[Rollback] ❌ Falha no rerroll. Tentando novamente...")
            task.wait(CONFIG.rerollDelay)
            goto continue
        end

        local currentTrait = getCurrentTraitFromGUI(gui)
        if currentTrait then
            print(string.format("[Rollback] 🎲 Trait atual: %s", currentTrait))
            if string.lower(currentTrait) == string.lower(CONFIG.targetTrait) then
                print(string.format("[Rollback] 🎉 TRAIT ENCONTRADA! %s", currentTrait))
                traitFound = true
                break
            else
                print(string.format("[Rollback] ❌ Não é %s. Rollback...", CONFIG.targetTrait))
                forceRollback()
                return
            end
        else
            print("[Rollback] ⚠️ Não foi possível detectar a trait. Tentando novamente...")
            task.wait(CONFIG.rerollDelay)
        end

        ::continue::
    end

    if traitFound then
        print("=" .. string.rep("=", 50))
        print(string.format("[Rollback] 🎉 SUCESSO! Trait %s encontrada após %d tentativas!", CONFIG.targetTrait, rollCount))
        print("=" .. string.rep("=", 50))
    else
        print("[Rollback] ❌ Limite de tentativas atingido.")
    end
end

-- ============================================================
-- EXECUTAR (sem pcall para ver erros)
-- ============================================================
main()
