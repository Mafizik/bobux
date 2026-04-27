local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- Настройки
local LOCK_KEY = Enum.KeyCode.R
local BACKPACK_NAME = "BackpackGui"
local CLICK_DELAY = 0.1 -- Скорость кликов (0.1 сек = 10 кликов в секунду)

local isLooping = false -- Состояние (включено/выключено)

-- Функция для выполнения одного клика ПКМ по 3-му слоту
local function doLockClick()
    local bgui = pGui:FindFirstChild(BACKPACK_NAME)
    local hotbar = bgui and bgui:FindFirstChild("Hotbar", true)
    
    if hotbar then
        local slots = {}
        for _, v in pairs(hotbar:GetChildren()) do
            if v:IsA("GuiObject") and v.Visible and v.AbsoluteSize.X > 5 then
                table.insert(slots, v)
            end
        end

        table.sort(slots, function(a, b)
            return a.AbsolutePosition.X < b.AbsolutePosition.X
        end)

        local slot3 = slots[3]

        if slot3 then
            local x = slot3.AbsolutePosition.X + (slot3.AbsoluteSize.X / 2)
            local y = slot3.AbsolutePosition.Y + (slot3.AbsoluteSize.Y / 2) + 58
            
            -- Эмуляция клика
            VirtualInputManager:SendMouseMoveEvent(x, y, game)
            VirtualInputManager:SendMouseButtonEvent(x, y, 1, true, game, 1)
            task.wait(0.02)
            VirtualInputManager:SendMouseButtonEvent(x, y, 1, false, game, 1)
        end
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == LOCK_KEY then
        isLooping = not isLooping -- Переключаем состояние
        
        if isLooping then
            print("АВТО-ЗАМОК: ВКЛЮЧЕН")
            
            -- 1. Сначала один раз открываем инвентарь
            local bgui = pGui:FindFirstChild(BACKPACK_NAME)
            local inventory = bgui and bgui:FindFirstChild("Backpack") and bgui.Backpack:FindFirstChild("Inventory")
            if inventory then
                inventory.Visible = true
            end
            
            -- 2. Запускаем бесконечный цикл в отдельном потоке
            task.spawn(function()
                while isLooping do
                    doLockClick()
                    task.wait(CLICK_DELAY)
                end
                print("АВТО-ЗАМОК: ВЫКЛЮЧЕН")
            end)
        end
    end
end)
