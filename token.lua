local STAT_NAME = "Trade Tokens" 
local MAX_DISTANCE = 70 -- Дистанция видимости

local function createESP(player, character)
    local head = character:WaitForChild("Head", 10)
    if not head or head:FindFirstChild("TokenESP") then return end

    local bgui = Instance.new("BillboardGui", head)
    bgui.Name = "TokenESP"
    bgui.Size = UDim2.new(0, 250, 0, 50)
    bgui.StudsOffset = Vector3.new(0, 4, 0)
    bgui.AlwaysOnTop = true
    bgui.MaxDistance = MAX_DISTANCE

    local label = Instance.new("TextLabel", bgui)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0
    label.TextSize = 24 
    label.Font = Enum.Font.GothamBold
    label.Text = ""

    task.spawn(function()
        while character and character.Parent do
            local stats = player:FindFirstChild("leaderstats")
            local stat = stats and stats:FindFirstChild(STAT_NAME)
            
            if stat then
                -- Теперь пишет Tokens вместо Токены
                label.Text = "tokens: " .. tostring(stat.Value)
            end
            task.wait(1)
        end
    end)
end

local function setupPlayer(p)
    if p == game.Players.LocalPlayer then return end
    p.CharacterAdded:Connect(function(c) createESP(p, c) end)
    if p.Character then createESP(p, p.Character) end
end

game.Players.PlayerAdded:Connect(setupPlayer)
for _, p in pairs(game.Players:GetPlayers()) do
    setupPlayer(p)
end
