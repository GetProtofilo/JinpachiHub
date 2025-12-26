-- JinpachiHub.lua - Debug Version for Mobile
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local guiEnabled = false

-- ScreenGui in CoreGui (force render)
local gui = Instance.new("ScreenGui")
gui.Name = "JinpachiHubGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui
gui.DisplayOrder = 999 -- Force on top
print("ScreenGui created")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 450)
frame.Position = UDim2.new(0.5, -160, 0.5, -225)
frame.BackgroundTransparency = 0.2
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
frame.BorderSizePixel = 4
frame.Visible = false
frame.Parent = gui
print("Frame created")

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
print("Title added")

-- Draggable (touch support)
local dragging = false
local dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        print("Dragging started")
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        print("Dragging in progress")
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        print("Dragging ended")
    end
end)

-- Mobile Open/Close Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 60)
toggleButton.Position = UDim2.new(1, -130, 1, -70)  -- Bottom-right
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
toggleButton.Text = "Open Hub 🎄"
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = gui
print("Toggle button created")

toggleButton.MouseButton1Click:Connect(function()
    guiEnabled = not guiEnabled
    frame.Visible = guiEnabled
    toggleButton.Text = guiEnabled and "Close Hub 🎅" or "Open Hub 🎄"
    toggleButton.BackgroundColor3 = guiEnabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(255, 215, 0)
    print("GUI toggled to " .. (guiEnabled and "ON" or "OFF"))
end)

-- Notification
print("🎄 Jinpachi Hub Debug Loaded! Tap bottom-right button to open 🎅")
