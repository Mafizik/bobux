local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- Настройки
local BACKPACK_NAME = "BackpackGui"
local CLICK_DELAY = 0.05 

local isLooping = false 

-- === СОЗДАНИЕ КНОПКИ НА ЭКРАНЕ ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoLockGui"
screenGui.Parent = pGui
screenGui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.25, -25) -- Слева по центру
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Красный (выключено)
toggleButton.Text = "AUTO-LOCK: OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Parent = screenGui

-- Скругление углов для красоты
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = toggleButton

-- Функция клика (оставил без изменений)
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
            
            VirtualInputManager:SendMouseMoveEvent(x, y, game)
            VirtualInputManager:SendMouseButtonEvent(x, y, 1, true, game, 1)
            task.wait(0.02)
            VirtualInputManager:SendMouseButtonEvent(x, y, 1, false, game, 1)
        end
    end
end

-- Логика переключения
toggleButton.MouseButton1Click:Connect(function()
    isLooping = not isLooping
    
    if isLooping then
        -- Включено
        toggleButton.Text = "AUTO-LOCK: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- Зеленый
        
        local bgui = pGui:FindFirstChild(BACKPACK_NAME)
        local inventory = bgui and bgui:FindFirstChild("Backpack") and bgui.Backpack:FindFirstChild("Inventory")
        if inventory then
            inventory.Visible = true
        end
        
        task.spawn(function()
            while isLooping do
                doLockClick()
                task.wait(CLICK_DELAY)
            end
        end)
    else
        -- Выключено
        toggleButton.Text = "AUTO-LOCK: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Красный
    end
end)
