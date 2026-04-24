local player = game:GetService("Players").LocalPlayer
local pGui = player:WaitForChild("PlayerGui")


local screen = pGui:FindFirstChild("TraderControl") or Instance.new("ScreenGui")
screen.Name = "TraderControl"
screen.ResetOnSpawn = false
screen.Parent = pGui

local mainFrame = screen:FindFirstChild("Main") or Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 180, 0, 60)
mainFrame.Position = UDim2.new(0, 10, 0.5, -30)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screen

local openBtn = mainFrame:FindFirstChild("OpenBtn") or Instance.new("TextButton")
openBtn.Name = "OpenBtn"
openBtn.Size = UDim2.new(1, -10, 1, -10)
openBtn.Position = UDim2.new(0, 5, 0, 5)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
openBtn.Text = "ОТКРЫТЬ ТОРГОВЦА"
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.SourceSansBold
openBtn.TextSize = 14
openBtn.Parent = mainFrame

local function activateMerchant()
    local targets = {"ListingsGui", "LimitedShop"}
    
    for _, name in pairs(targets) do
        local gui = pGui:FindFirstChild(name)
        if gui then
            gui.Enabled = true
            -- Сначала делаем все контейнеры видимыми
            for _, child in pairs(gui:GetChildren()) do
                if child:IsA("Frame") or child:IsA("ScrollingFrame") then
                    child.Visible = true
                    child.Size = UDim2.new(0.6, 0, 0.7, 0)
                    child.Position = UDim2.new(0.5, 0, 0.5, 0)
                    child.AnchorPoint = Vector2.new(0.5, 0.5)
                end
            end


            for _, item in pairs(gui:GetDescendants()) do
                if item:IsA("Frame") and item.Parent:IsA("ScrollingFrame") then
                    local isExpired = false
                    -- Проверяем текст внутри карточки товара
                    for _, subItem in pairs(item:GetDescendants()) do
                        if (subItem:IsA("TextLabel") or subItem:IsA("TextButton")) then
                            local t = subItem.Text:lower()
                            if t:find("истёк") or t:find("распродано") or t:find("expired") or t:find("sold out") then
                                isExpired = true
                                break
                            end
                        end
                    end
                    
                    item.Visible = not isExpired
                end
            end
        end
    end
end

if openBtn then
    openBtn.MouseButton1Click:Connect(activateMerchant)
else
    warn("Кнопка OpenBtn не найдена!")
end
