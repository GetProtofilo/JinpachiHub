-- // MOBILE OPTIMIZATION PATCH // --

-- 1. Disable Acrylic for performance on mobile
Window.Acrylic = false 

-- 2. Create a Toggle Button (Draggable & Animated)
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local MobileGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

MobileGui.Name = "WestboundMobileGui"
MobileGui.Parent = game.CoreGui

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MobileGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.2, 0) -- Initial position
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Image = "rbxassetid://3926307971" -- Settings Icon
ToggleBtn.ImageRectOffset = Vector2.new(324, 124)
ToggleBtn.ImageRectSize = Vector2.new(36, 36)

UICorner.CornerRadius = UDim.new(0.5, 0)
UICorner.Parent = ToggleBtn

UIStroke.Parent = ToggleBtn
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Animation on Click
ToggleBtn.MouseButton1Click:Connect(function()
    -- Simulates pressing "LeftControl" to toggle the Fluent UI
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    
    -- Button bounce animation
    TweenService:Create(ToggleBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 40, 0, 40)}):Play()
    task.wait(0.1)
    TweenService:Create(ToggleBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)

-- Draggable Logic (Smooth)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
