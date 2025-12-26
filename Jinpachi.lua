-- JinpachiHub.lua (The Strongest Battlegrounds Script with Christmas-themed UI)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local guiEnabled = false -- Start closed
local flying = false
local speed = 50
local speedBoost = 1.0 -- Default speed multiplier
local jumpHeight = 7.2 -- Default jump height
local bodyVelocity

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "JinpachiHubGUI"
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

-- Main Frame (Christmas Theme with Transparency)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundTransparency = 0.3
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 20)), -- Red
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)), -- Green
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)) -- White
})
gradient.Rotation = 90
gradient.Parent = frame
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 215, 0) -- Gold border
frame.Visible = guiEnabled
frame.Parent = gui

-- Draggable Frame (Optimized)
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        frame.ZIndex = 10 -- Bring to front
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
        frame.ZIndex = 1
    end
end)

-- Open/Close Button (Fixed)
local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Size = UDim2.new(0, 40, 0, 40)
toggleGuiButton.Position = UDim2.new(0, 10, 0, 10)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
toggleGuiButton.Text = "🎄"
toggleGuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiButton.TextScaled = true
toggleGuiButton.Parent = player.PlayerGui
toggleGuiButton.MouseButton1Click:Connect(function()
    guiEnabled = not guiEnabled
    frame.Visible = guiEnabled
    toggleGuiButton.Text = guiEnabled and "🎅" or "🎄"
end)

-- Title (Christmas-themed)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 280, 0, 50)
titleLabel.Position = UDim2.new(0.5, -140, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🎄 Jinpachi Hub 🎅"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
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
tabFrame.BackgroundTransparency = 0.7
tabFrame.Parent = frame

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 280, 0, 300)
contentFrame.Position = UDim2.new(0.5, -140, 0, 90)
contentFrame.BackgroundTransparency = 0.5
contentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
            btn.BackgroundColor3 = t == tab and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 120, 255)
        end
    end)
end

-- Feature Content
local function createTabContent(tabName)
    local content = Instance.new("Frame")
    content.Name = tabName
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 0.7
    content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    content.Visible = tabName == currentTab
    content.Parent = contentFrame
    return content
end

-- Combat Tab (Empty for now)
local combatTab = createTabContent("Combat")
local placeholder = Instance.new("TextLabel")
placeholder.Size = UDim2.new(0, 260, 0, 40)
placeholder.Position = UDim2.new(0.5, -130, 0, 10)
placeholder.BackgroundTransparency = 1
placeholder.Text = "Combat features coming soon!"
placeholder.TextColor3 = Color3.fromRGB(255, 255, 255)
placeholder.TextScaled = true
placeholder.Parent = combatTab

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
local speedBoostButton = Instance.new("TextButton")
speedBoostButton.Size = UDim2.new(0, 260, 0, 40)
speedBoostButton.Position = UDim2.new(0.5, -130, 0, 110)
speedBoostButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
speedBoostButton.Text = "Speed Boost: OFF"
speedBoostButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBoostButton.TextScaled = true
speedBoostButton.Parent = movementTab
local speedBoostEnabled = false
speedBoostButton.MouseButton1Click:Connect(function()
    speedBoostEnabled = not speedBoostEnabled
    speedBoostButton.Text = "Speed Boost: " .. (speedBoostEnabled and "ON" or "OFF")
    speedBoostButton.BackgroundColor3 = speedBoostEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    if speedBoostEnabled and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 * speedBoost -- Default 16, boost to 32x
        end
    else
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 -- Reset to default
        end
    end
end)
local jumpHeightButton = Instance.new("TextButton")
jumpHeightButton.Size = UDim2.new(0, 260, 0, 40)
jumpHeightButton.Position = UDim2.new(0.5, -130, 0, 160)
jumpHeightButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
jumpHeightButton.Text = "Jump Height: OFF"
jumpHeightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpHeightButton.TextScaled = true
jumpHeightButton.Parent = movementTab
local jumpHeightEnabled = false
jumpHeightButton.MouseButton1Click:Connect(function()
    jumpHeightEnabled = not jumpHeightEnabled
    jumpHeightButton.Text = "Jump Height: " .. (jumpHeightEnabled and "ON" or "OFF")
    jumpHeightButton.BackgroundColor3 = jumpHeightEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    if jumpHeightEnabled and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = jumpHeight * 10 -- Default 7.2, boost to 72
        end
    else
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 7.2 -- Reset to default
        end
    end
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
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
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
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 260, 0, 40)
teleportButton.Position = UDim2.new(0.5, -130, 0, 10)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
teleportButton.Text = "Teleport to Player: OFF"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Parent = miscTab
local teleportEnabled = false
teleportButton.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    teleportButton.Text = "Teleport to Player: " .. (teleportEnabled and "ON" or "OFF")
    teleportButton.BackgroundColor3 = teleportEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    if teleportEnabled and player.Character then
        local target = game.Players:GetPlayers()[math.random(1, #game.Players:GetPlayers())]
        if target and target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
        teleportEnabled = false -- One-time teleport
        teleportButton.Text = "Teleport to Player: OFF"
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    end
end)

-- Notification
print("🎄 Jinpachi Hub Loaded! Use the UI to toggle features. 🎅")
