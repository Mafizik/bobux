local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- Íàñòðîéêè
local LOCK_KEY = Enum.KeyCode.R
local BACKPACK_NAME = "BackpackGui"
local CLICK_DELAY = 0.05 -- Ñêîðîñòü êëèêîâ (0.1 ñåê = 10 êëèêîâ â ñåêóíäó)

local isLooping = false -- Ñîñòîÿíèå (âêëþ÷åíî/âûêëþ÷åíî)

-- Ôóíêöèÿ äëÿ âûïîëíåíèÿ îäíîãî êëèêà ÏÊÌ ïî 3-ìó ñëîòó
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
            
            -- Ýìóëÿöèÿ êëèêà
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
        isLooping = not isLooping -- Ïåðåêëþ÷àåì ñîñòîÿíèå
        
        if isLooping then
            print("ÀÂÒÎ-ÇÀÌÎÊ: ÂÊËÞ×ÅÍ")
            
            -- 1. Ñíà÷àëà îäèí ðàç îòêðûâàåì èíâåíòàðü
            local bgui = pGui:FindFirstChild(BACKPACK_NAME)
            local inventory = bgui and bgui:FindFirstChild("Backpack") and bgui.Backpack:FindFirstChild("Inventory")
            if inventory then
                inventory.Visible = true
            end
            
            -- 2. Çàïóñêàåì áåñêîíå÷íûé öèêë â îòäåëüíîì ïîòîêå
            task.spawn(function()
                while isLooping do
                    doLockClick()
                    task.wait(CLICK_DELAY)
                end
                print("ÀÂÒÎ-ÇÀÌÎÊ: ÂÛÊËÞ×ÅÍ")
            end)
        end
    end
end)
