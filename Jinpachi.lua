-- JinpachiHub.lua (The Strongest Battlegrounds Script with Christmas-themed UI)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local guiEnabled = true
local flying = false
local speed = 50
local bodyVelocity

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "JinpachiHubGUI"
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

-- Main Frame (Christmas Theme)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(200, 20, 20) -- Christmas Red
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 0) -- Christmas Green
frame.Visible = guiEnabled
frame.Parent = gui

-- Christmas Decor: UIGradient for festive look
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 20, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
gradient.Rotation = 45
gradient.Parent = frame

-- Draggable Frame
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Open/Close Button
local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Size = UDim2.new(0, 50, 0, 50)
toggleGuiButton.Position = UDim2.new(0, 10, 0, 10)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
toggleGuiButton.Text = "X"
toggleGuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiButton.TextScaled = true
toggleGuiButton.Parent = player.PlayerGui
toggleGuiButton.MouseButton1Click:Connect(function()
    guiEnabled = not guiEnabled
    frame.Visible = guiEnabled
    toggleGuiButton.Text = guiEnabled and "X" or "O"
end)

-- Title (Christmas-themed)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 280, 0, 50)
titleLabel.Position = UDim2.new(0.5, -140, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🎄 Jinpachi Hub 🎅"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.Parent = frame

-- Tab System
local tabs = {"Combat", "Movement", "Visuals", "Misc"}
local currentTab = "Combat"
local tabButtons = {}

-- Tab Frame
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(0, 280, 0, 30)
tabFrame.Position = UDim2.new(0.5, -140, 0, 60)
tabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabFrame.BackgroundTransparency = 0.5
tabFrame.Parent = frame

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 280, 0, 280)
contentFrame.Position = UDim2.new(0.5, -140, 0, 100)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = frame

-- Create Tabs
for i, tab in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 70, 0, 30)
    tabButton.Position = UDim2.new(0, (i-1)*70, 0, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    tabButton.Text = tab
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextScaled = true
    tabButton.Parent = tabFrame
    tabButtons[tab] = tabButton

    tabButton.MouseButton1Click:Connect(function()
        currentTab = tab
        for _, content in pairs(contentFrame:GetChildren()) do
            content.Visible = content.Name == tab
        end
        for t, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = t == tab and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 120, 255)
        end
    end)
end

-- Feature Content
local function createTabContent(tabName)
    local content = Instance.new("Frame")
    content.Name = tabName
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = tabName == currentTab
    content.Parent = contentFrame
    return content
end

-- Combat Tab
local combatTab = createTabContent("Combat")
local autoAttack = Instance.new("TextButton")
autoAttack.Size = UDim2.new(0, 260, 0, 40)
autoAttack.Position = UDim2.new(0.5, -130, 0, 10)
autoAttack.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
autoAttack.Text = "Auto Attack: OFF"
autoAttack.TextColor3 = Color3.fromRGB(255, 255, 255)
autoAttack.TextScaled = true
autoAttack.Parent = combatTab
local autoAttackEnabled = false
autoAttack.MouseButton1Click:Connect(function()
    autoAttackEnabled = not autoAttackEnabled
    autoAttack.Text = "Auto Attack: " .. (autoAttackEnabled and "ON" or "OFF")
    autoAttack.BackgroundColor3 = autoAttackEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    -- Auto Attack Logic (Simplified)
    while autoAttackEnabled and player.Character do
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            -- Simulate attack (game-specific)
            game:GetService("ReplicatedStorage"):FireServer("Attack")
        end
        wait(0.1)
    end
end)

-- Movement Tab
local movementTab = createTabContent("Movement")
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 260, 0, 40)
flyButton.Position = UDim2.new(0.5, -130, 0, 10)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
flyButton.Text = "Fly: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Parent = movementTab
local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(0, 260, 0, 40)
speedSlider.Position = UDim2.new(0.5, -130, 0, 60)
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.Text = "50"
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.TextScaled = true
speedSlider.Parent = movementTab
speedSlider.FocusLost:Connect(function()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed then speed = newSpeed end
end)

-- Fly Logic
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    flyButton.Text = "Fly: " .. (flying and "ON" or "OFF")
    flyButton.BackgroundColor3 = flying and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    if flying then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = player.Character.HumanoidRootPart
    else
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end)
game:GetService("RunService").RenderStepped:Connect(function()
    if flying and player.Character and player.Character.HumanoidRootPart then
        local cam = workspace.CurrentCamera
        local direction = cam.CFrame.LookVector * speed
        bodyVelocity.Velocity = direction
    end
end)

-- Visuals Tab
local visualsTab = createTabContent("Visuals")
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 260, 0, 40)
espButton.Position = UDim2.new(0.5, -130, 0, 10)
espButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
espButton.Text = "ESP: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextScaled = true
espButton.Parent = visualsTab
local espEnabled = false
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    -- ESP Logic
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            local highlight = p.Character:FindFirstChild("JinpachiHighlight")
            if espEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "JinpachiHighlight"
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = p.Character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- Misc Tab
local miscTab = createTabContent("Misc")
local godModeButton = Instance.new("TextButton")
godModeButton.Size = UDim2.new(0, 260, 0, 40)
godModeButton.Position = UDim2.new(0.5, -130, 0, 10)
godModeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
godModeButton.Text = "God Mode: OFF"
godModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
godModeButton.TextScaled = true
godModeButton.Parent = miscTab
local godModeEnabled = false
godModeButton.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    godModeButton.Text = "God Mode: " .. (godModeEnabled and "ON" or "OFF")
    godModeButton.BackgroundColor3 = godModeEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    if godModeEnabled and player.Character then
        player.Character.Humanoid.Health = math.huge
    end
end)

-- Notification
print("🎄 Jinpachi Hub Loaded! Use the UI to toggle features. 🎅")
