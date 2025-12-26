-- Jinpachi.lua (Flying Script with UI for Delta)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local flying = false
local speed = 50
local bodyVelocity

-- Create UI
local gui = Instance.new("ScreenGui")
gui.Name = "JinpachiFlyGUI"
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0.5, -100, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 255)  -- Neon cyan border
frame.Parent = gui

-- Make Frame Draggable
local dragging
local dragInput
local dragStart
local startPos

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

-- Toggle Fly Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 180, 0, 50)
toggleButton.Position = UDim2.new(0.5, -90, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
toggleButton.Text = "Toggle Fly (F)"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Parent = frame

-- Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 180, 0, 30)
speedLabel.Position = UDim2.new(0.5, -90, 0, 80)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 50"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Parent = frame

-- Speed Slider (TextBox)
local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(0, 180, 0, 30)
speedSlider.Position = UDim2.new(0.5, -90, 0, 110)
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.Text = "50"
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.TextScaled = true
speedSlider.Parent = frame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 180, 0, 30)
titleLabel.Position = UDim2.new(0.5, -90, 0, -30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Jinpachi Fly v1.0"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
titleLabel.TextScaled = true
titleLabel.Parent = frame

-- Flying Logic
local function toggleFly()
    flying = not flying
    if flying then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = player.Character.HumanoidRootPart
        toggleButton.Text = "Flying: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        toggleButton.Text = "Flying: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end

-- Update Speed
speedSlider.FocusLost:Connect(function()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed then
        speed = newSpeed
        speedLabel.Text = "Speed: " .. speed
    else
        speedSlider.Text = tostring(speed)
    end
end)

-- Toggle Fly on Button Click or Key Press
toggleButton.MouseButton1Click:Connect(toggleFly)
mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then
        toggleFly()
    end
end)

-- Flying Direction
game:GetService("RunService").RenderStepped:Connect(function()
    if flying and player.Character and player.Character.HumanoidRootPart then
        local cam = workspace.CurrentCamera
        local direction = cam.CFrame.LookVector * speed
        bodyVelocity.Velocity = direction
    end
end)

-- Notification
print("Jinpachi Fly v1.0 Loaded! Press F or use the UI to fly.")
