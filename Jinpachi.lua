-- Jinpachi.lua - Mobile Optimized with Movable Open/Close Button
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local guiEnabled = false
local flying = false
local speed = 50
local speedBoostEnabled = false
local jumpHeightEnabled = false
local espEnabled = false
local bodyVelocity

-- ScreenGui in CoreGui
local gui = Instance.new("ScreenGui")
gui.Name = "JinpachiHubGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui
gui.DisplayOrder = 999

-- Main Frame (GUI)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 450)
frame.Position = UDim2.new(0.5, -160, 0.5, -225)
frame.BackgroundTransparency = 0.2
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
frame.BorderSizePixel = 4
frame.Visible = guiEnabled
frame.Parent = gui

-- Christmas Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 180, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
gradient.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "🎄 Jinpachi Hub 🎅"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Draggable GUI
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

-- Movable Open/Close Button (Chhota)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 30, 0, 30)  -- Chhota button
toggleButton.Position = UDim2.new(0, 10, 0, 10)  -- Initial position (top-left)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
toggleButton.Text = "🎄"
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextScaled = true
toggleButton.Parent = gui

-- Draggable Button
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

-- Toggle GUI
toggleButton.MouseButton1Click:Connect(function()
    guiEnabled = not guiEnabled
    frame.Visible = guiEnabled
    toggleButton.Text = guiEnabled and "🎅" or "🎄"
    toggleButton.BackgroundColor3 = guiEnabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(255, 215, 0)
end)

-- Tabs (Basic structure, features baad mein add karenge)
local tabs = {"Movement", "Visuals", "Misc"}
local currentTab = "Movement"
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 70)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = frame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 0, 330)
contentFrame.Position = UDim2.new(0, 10, 0, 120)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = frame

local tabButtons = {}
for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*100, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = tabFrame
    tabButtons[name] = btn

    btn.MouseButton1Click:Connect(function()
        currentTab = name
        for _, child in pairs(contentFrame:GetChildren()) do
            child.Visible = child.Name == name
        end
        for n, b in pairs(tabButtons) do
            b.BackgroundColor3 = n == name and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 120, 255)
        end
    end)
end

local function makeTab(name)
    local f = Instance.new("Frame")
    f.Name = name
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundTransparency = 1
    f.Visible = name == currentTab
    f.Parent = contentFrame
    return f
end

-- Placeholder Tabs (Features baad mein)
makeTab("Movement")
makeTab("Visuals")
makeTab("Misc")

-- Notification
print("🎄 Jinpachi Hub Mobile Loaded! Tap the small button to open 🎅")

-- Features will be added once GUI is visible
