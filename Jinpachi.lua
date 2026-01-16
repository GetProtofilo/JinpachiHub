-- [[ 🚲 BI-CYCLE: KEY-NEXUS ]]
-- STATUS: FIXED & UNIVERSAL
-- TYPE: VIRTUAL KEYBOARD OVERLAY

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer

-- =================================================================
-- 🎨 SAFE UI SETUP
-- =================================================================

-- 1. Attempt to find a secure parent for the UI
local Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui or lp:WaitForChild("PlayerGui")

-- 2. Cleanup old instances
if Parent:FindFirstChild("BiCycleKeyboard") then 
    Parent.BiCycleKeyboard:Destroy() 
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "BiCycleKeyboard"
Gui.Parent = Parent
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- COLORS
local C = {
    Bg = Color3.fromRGB(12, 12, 15),
    Sidebar = Color3.fromRGB(18, 18, 22),
    Accent = Color3.fromRGB(0, 255, 180), -- Mint
    Text = Color3.fromRGB(240, 240, 240),
    Btn = Color3.fromRGB(25, 25, 30),
    Pressed = Color3.fromRGB(0, 200, 140)
}

-- =================================================================
-- ⚙️ HELPER FUNCTIONS
-- =================================================================

local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function SimulateKey(keyCode, isDown)
    pcall(function()
        VirtualInputManager:SendKeyEvent(isDown, keyCode, false, game)
    end)
end

-- =================================================================
-- 🖥️ UI ELEMENTS
-- =================================================================

-- > OPEN/CLOSE TOGGLE
local ToggleBtn = Instance.new("TextButton", Gui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = C.Bg
ToggleBtn.Text = "🎹"
ToggleBtn.TextSize = 25
ToggleBtn.Draggable = true -- Native draggable for the toggle
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 12)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = C.Accent
ToggleStroke.Thickness = 2

-- > MAIN PANEL
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 500, 0, 300)
Main.Position = UDim2.new(0.5, -250, 0.3, 0)
Main.BackgroundColor3 = C.Bg
Main.Visible = false
MakeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = C.Accent
MainStroke.Thickness = 1

-- > SIDEBAR (CONTROLS)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0.35, 0, 1, 0)
Sidebar.BackgroundColor3 = C.Sidebar
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

-- Header
local Title = Instance.new("TextLabel", Sidebar)
Title.Text = "KEY-NEXUS"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextColor3 = C.Accent
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1

-- Input Box
local InputBox = Instance.new("TextBox", Sidebar)
InputBox.Size = UDim2.new(0.85, 0, 0, 40)
InputBox.Position = UDim2.new(0.075, 0, 0.2, 0)
InputBox.BackgroundColor3 = C.Btn
InputBox.Text = ""
InputBox.PlaceholderText = "Type Key (e.g. F)"
InputBox.TextColor3 = C.Text
InputBox.Font = Enum.Font.GothamBold
InputBox.TextSize = 14
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 6)

-- Add Button
local AddBtn = Instance.new("TextButton", Sidebar)
AddBtn.Size = UDim2.new(0.85, 0, 0, 35)
AddBtn.Position = UDim2.new(0.075, 0, 0.35, 0)
AddBtn.BackgroundColor3 = C.Accent
AddBtn.Text = "ADD KEY"
AddBtn.TextColor3 = Color3.fromRGB(0,0,0)
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 14
Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0, 6)

-- Presets Label
local PresetLabel = Instance.new("TextLabel", Sidebar)
PresetLabel.Text = "QUICK PRESETS"
PresetLabel.Size = UDim2.new(1, 0, 0, 30)
PresetLabel.Position = UDim2.new(0, 0, 0.55, 0)
PresetLabel.TextColor3 = C.TextDim
PresetLabel.BackgroundTransparency = 1
PresetLabel.Font = Enum.Font.GothamBold
PresetLabel.TextSize = 12

-- Preset Buttons
local function CreatePresetBtn(text, pos, callback)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.4, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = C.Btn
    btn.Text = text
    btn.TextColor3 = C.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- > KEYBOARD AREA (Where keys appear)
local KeyArea = Instance.new("ScrollingFrame", Main)
KeyArea.Size = UDim2.new(0.63, 0, 0.9, 0)
KeyArea.Position = UDim2.new(0.36, 0, 0.05, 0)
KeyArea.BackgroundTransparency = 1
KeyArea.ScrollBarThickness = 2
local Grid = Instance.new("UIGridLayout", KeyArea)
Grid.CellSize = UDim2.new(0, 60, 0, 60)
Grid.CellPadding = UDim2.new(0, 10, 0, 10)

-- Close X
local CloseX = Instance.new("TextButton", Main)
CloseX.Text = "X"
CloseX.Size = UDim2.new(0, 30, 0, 30)
CloseX.Position = UDim2.new(1, -30, 0, 0)
CloseX.BackgroundTransparency = 1
CloseX.TextColor3 = Color3.fromRGB(200, 50, 50)
CloseX.Font = Enum.Font.GothamBold
CloseX.TextSize = 18

-- =================================================================
-- ⚡ LOGIC ENGINE
-- =================================================================

-- Function to add a key to the grid
local function AddKeyToGrid(keyName)
    -- Normalize the key name to find the Enum
    local cleanName = keyName:gsub(" ", "")
    local keyCode = nil
    
    -- Try direct match
    pcall(function() keyCode = Enum.KeyCode[cleanName] end)
    
    -- Try uppercase match (e.g. "e" -> "E")
    if not keyCode then
        pcall(function() keyCode = Enum.KeyCode[cleanName:upper()] end)
    end
    
    if not keyCode then
        InputBox.Text = "INVALID!"
        task.wait(1)
        InputBox.Text = ""
        return
    end

    -- Create Button
    local KeyBtn = Instance.new("TextButton", KeyArea)
    KeyBtn.BackgroundColor3 = C.Btn
    KeyBtn.Text = keyName:upper()
    KeyBtn.TextColor3 = C.Text
    KeyBtn.Font = Enum.Font.GothamBlack
    KeyBtn.TextSize = 16
    Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", KeyBtn)
    Stroke.Color = C.Accent
    Stroke.Thickness = 1
    
    -- INPUT HANDLING (The Magic)
    KeyBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(KeyBtn, TweenInfo.new(0.1), {BackgroundColor3 = C.Pressed}):Play()
            SimulateKey(keyCode, true) -- HOLD DOWN
        end
    end)

    KeyBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(KeyBtn, TweenInfo.new(0.1), {BackgroundColor3 = C.Btn}):Play()
            SimulateKey(keyCode, false) -- RELEASE
        end
    end)
end

-- EVENTS
AddBtn.MouseButton1Click:Connect(function()
    if InputBox.Text ~= "" then
        AddKeyToGrid(InputBox.Text)
        InputBox.Text = ""
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

CloseX.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- PRESETS
CreatePresetBtn("WASD", UDim2.new(0.075, 0, 0.65, 0), function()
    AddKeyToGrid("W")
    AddKeyToGrid("A")
    AddKeyToGrid("S")
    AddKeyToGrid("D")
    AddKeyToGrid("Space")
end)

CreatePresetBtn("COMBAT", UDim2.new(0.525, 0, 0.65, 0), function()
    AddKeyToGrid("One")
    AddKeyToGrid("Two")
    AddKeyToGrid("Three")
    AddKeyToGrid("Four")
    AddKeyToGrid("F")
    AddKeyToGrid("R")
end)

CreatePresetBtn("ARROWS", UDim2.new(0.075, 0, 0.8, 0), function()
    AddKeyToGrid("Up")
    AddKeyToGrid("Down")
    AddKeyToGrid("Left")
    AddKeyToGrid("Right")
end)

CreatePresetBtn("UTILITY", UDim2.new(0.525, 0, 0.8, 0), function()
    AddKeyToGrid("LeftShift")
    AddKeyToGrid("LeftControl")
    AddKeyToGrid("Tab")
    AddKeyToGrid("Q")
end)

-- NOTIFICATION
print("🚲 BI-CYCLE KEY-NEXUS LOADED")
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "BI-CYCLE",
    Text = "Keyboard Loaded! Click 🎹 to open.",
    Duration = 5
})
