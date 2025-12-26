-- Jinpachi.lua - GPO Auto Farm Mythic Chest Script
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local guiEnabled = false
local autoFarmEnabled = false
local flying = false
local speed = 50
local bodyVelocity

-- ScreenGui in CoreGui
local gui = Instance.new("ScreenGui")
gui.Name = "JinpachiHubGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui
gui.DisplayOrder = 999

-- Main Frame (Christmas Theme)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 300)
frame.Position = UDim2.new(0.5, -175, 0.5, -150)
frame.BackgroundTransparency = 0.3
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
gradient.Parent = frame
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
frame.Visible = guiEnabled
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "🎄 Jinpachi Hub 🎅"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Draggable Frame
local draggingFrame = false
local dragInputFrame, dragStartFrame, startPosFrame
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingFrame = true
        dragStartFrame = input.Position
        startPosFrame = frame.Position
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInputFrame = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if draggingFrame and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartFrame
        frame.Position = UDim2.new(startPosFrame.X.Scale, startPosFrame.X.Offset + delta.X, startPosFrame.Y.Scale, startPosFrame.Y.Offset + delta.Y)
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingFrame = false
    end
end)

-- Movable Open/Close Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(1, -40, 1, -40)  -- Bottom-right
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
toggleButton.Text = "🎄"
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextScaled = true
toggleButton.Parent = gui

local draggingButton = false
local dragInputButton, dragStartButton, startPosButton
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingButton = true
        dragStartButton = input.Position
        startPosButton = toggleButton.Position
    end
end)
toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInputButton = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if draggingButton and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartButton
        toggleButton.Position = UDim2.new(startPosButton.X.Scale, startPosButton.X.Offset + delta.X, startPosButton.Y.Scale, startPosButton.Y.Offset + delta.Y)
    end
end)
toggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingButton = false
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    guiEnabled = not guiEnabled
    frame.Visible = guiEnabled
    toggleButton.Text = guiEnabled and "🎅" or "🎄"
    toggleButton.BackgroundColor3 = guiEnabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(255, 215, 0)
end)

-- Tabs
local tabs = {"Movement", "Auto Farm", "Visuals"}
local currentTab = "Movement"
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 60)
tabFrame.BackgroundTransparency = 0.5
tabFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tabFrame.Parent = frame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 0, 200)
contentFrame.Position = UDim2.new(0, 10, 0, 110)
contentFrame.BackgroundTransparency = 0.5
contentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
contentFrame.Parent = frame

local tabButtons = {}
for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*105, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    btn.Text = tab
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Parent = tabFrame
    tabButtons[tab] = btn

    btn.MouseButton1Click:Connect(function()
        currentTab = tab
        for _, child in pairs(contentFrame:GetChildren()) do
            child.Visible = child.Name == tab
        end
        for t, b in pairs(tabButtons) do
            b.BackgroundColor3 = t == tab and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 120, 255)
        end
    end)
end

-- Tab Content
local function createTab(name)
    local tab = Instance.new("Frame")
    tab.Name = name
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.BackgroundTransparency = 1
    tab.Visible = name == currentTab
    tab.Parent = contentFrame
    return tab
end

local movementTab = createTab("Movement")
local autoFarmTab = createTab("Auto Farm")
local visualsTab = createTab("Visuals")

-- Movement Features
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(1, -20, 0, 50)
flyBtn.Position = UDim2.new(0, 10, 0, 10)
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
flyBtn.Text = "Fly: OFF"
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.TextScaled = true
flyBtn.Parent = movementTab
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "Fly: " .. (flying and "ON" or "OFF")
    flyBtn.BackgroundColor3 = flying and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 200, 0)
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVelocity.Parent = player.Character.HumanoidRootPart
    else
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end)
RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local cam = workspace.CurrentCamera
        bodyVelocity.Velocity = cam.CFrame.LookVector * speed
    end
end)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, -20, 0, 50)
speedBox.Position = UDim2.new(0, 10, 0, 70)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.Text = "50"
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.TextScaled = true
speedBox.Parent = movementTab
speedBox.FocusLost:Connect(function()
    local n = tonumber(speedBox.Text)
    if n then speed = n end
end)

-- Auto Farm Feature
local autoFarmBtn = Instance.new("TextButton")
autoFarmBtn.Size = UDim2.new(1, -20, 0, 50)
autoFarmBtn.Position = UDim2.new(0, 10, 0, 10)
autoFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
autoFarmBtn.Text = "Auto Farm Mythic: OFF"
autoFarmBtn.TextColor3 = Color3.new(1, 1, 1)
autoFarmBtn.TextScaled = true
autoFarmBtn.Parent = autoFarmTab
autoFarmBtn.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    autoFarmBtn.Text = "Auto Farm Mythic: " .. (autoFarmEnabled and "ON" or "OFF")
    autoFarmBtn.BackgroundColor3 = autoFarmEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 200, 0)
end)

-- Auto Farm Logic
RunService.RenderStepped:Connect(function()
    if autoFarmEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local chest = workspace:FindFirstChild("MythicChest") -- Adjust name if different
        if chest and chest:IsA("Model") then
            player.Character.HumanoidRootPart.CFrame = chest:FindFirstChild("Handle") and chest.Handle.CFrame * CFrame.new(0, 2, 0) or chest.CFrame * CFrame.new(0, 2, 0)
            -- Simulate interact (GPO specific remote needed)
            -- Example: game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer("Interact", chest)
            -- Note: Exact remote name unknown, need game analysis
            wait(1) -- Delay to avoid spam
        end
    end
end)

-- Visuals Feature
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(1, -20, 0, 50)
espBtn.Position = UDim2.new(0, 10, 0, 10)
espBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
espBtn.Text = "ESP: OFF"
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.TextScaled = true
espBtn.Parent = visualsTab
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 200, 0)
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hl = p.Character:FindFirstChild("JinpachiESP")
            if espEnabled then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "JinpachiESP"
                    hl.FillTransparency = 0.5
                    hl.FillColor = Color3.fromRGB(0, 255, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = p.Character
                end
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)

print("🎄 Jinpachi Hub for GPO Loaded! Tap the small button to open 🎅")
