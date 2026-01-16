-- [[ 🚲 BI-CYCLE: UNIVERSAL KEYBOARD ]]
-- GRADE: A+ (DYNAMIC KEYBIND ENGINE)
-- SUPPORTS: TAP, HOLD, & CUSTOM KEYS

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer

-- =================================================================
-- 🎨 UI CONFIGURATION
-- =================================================================

local C = {
    Bg      = Color3.fromRGB(15, 15, 20),
    Dark    = Color3.fromRGB(10, 10, 12),
    Accent  = Color3.fromRGB(0, 255, 180), -- Bi-Cycle Mint
    Text    = Color3.fromRGB(240, 240, 240),
    Btn     = Color3.fromRGB(25, 25, 30),
    Hold    = Color3.fromRGB(0, 200, 140)
}

-- Cleanup
if CoreGui:FindFirstChild("BiCycleKey") then CoreGui.BiCycleKey:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "BiCycleKey"
Gui.Parent = CoreGui
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- =================================================================
-- ⚙️ CORE FUNCTIONS
-- =================================================================

-- Draggable Logic
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

-- Key Simulator
local function SimulateKey(keyCode, state)
    -- State: true = down, false = up
    VirtualInputManager:SendKeyEvent(state, keyCode, false, game)
end

-- =================================================================
-- 🖥️ MAIN UI
-- =================================================================

-- > EDITOR BUTTON (The Wrench)
local EditBtn = Instance.new("ImageButton", Gui)
EditBtn.Size = UDim2.new(0, 45, 0, 45)
EditBtn.Position = UDim2.new(0.02, 0, 0.3, 0)
EditBtn.BackgroundColor3 = C.Dark
EditBtn.Image = "rbxassetid://6031154871" -- Wrench Icon
EditBtn.ImageColor3 = C.Accent
EditBtn.Draggable = true
Instance.new("UICorner", EditBtn).CornerRadius = UDim.new(0, 10)
local EditStroke = Instance.new("UIStroke", EditBtn)
EditStroke.Color = C.Accent; EditStroke.Thickness = 2

-- > KEY CONTAINER (The Keyboard)
local KeyFrame = Instance.new("Frame", Gui)
KeyFrame.Name = "KeyContainer"
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -150, 0.7, 0) -- Bottom Center default
KeyFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
KeyFrame.BackgroundTransparency = 0.5
MakeDraggable(KeyFrame) -- You can move the whole keyboard
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)

-- Grid Layout for Keys
local Grid = Instance.new("UIGridLayout", KeyFrame)
Grid.CellSize = UDim2.new(0, 50, 0, 50)
Grid.CellPadding = UDim2.new(0, 5, 0, 5)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.VerticalAlignment = Enum.VerticalAlignment.Center

-- > SETTINGS PANEL (The Editor)
local Editor = Instance.new("Frame", Gui)
Editor.Size = UDim2.new(0, 250, 0, 200)
Editor.Position = UDim2.new(0.1, 0, 0.3, 0)
Editor.BackgroundColor3 = C.Main
Editor.Visible = false
MakeDraggable(Editor)
Instance.new("UICorner", Editor).CornerRadius = UDim.new(0, 10)
local EdStroke = Instance.new("UIStroke", Editor); EdStroke.Color = C.Accent; EdStroke.Thickness = 1.5

-- Editor Header
local EdTitle = Instance.new("TextLabel", Editor)
EdTitle.Size = UDim2.new(1, 0, 0, 30)
EdTitle.Text = "KEYBOARD EDITOR"
EdTitle.Font = Enum.Font.GothamBlack
EdTitle.TextColor3 = C.Accent
EdTitle.BackgroundTransparency = 1

-- Input Box
local Input = Instance.new("TextBox", Editor)
Input.Size = UDim2.new(0.8, 0, 0, 40)
Input.Position = UDim2.new(0.1, 0, 0.25, 0)
Input.BackgroundColor3 = C.Btn
Input.TextColor3 = C.Text
Input.PlaceholderText = "Type Key (e.g. Q, Space)"
Input.Font = Enum.Font.Gotham
Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

-- Add Button
local AddBtn = Instance.new("TextButton", Editor)
AddBtn.Size = UDim2.new(0.8, 0, 0, 35)
AddBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
AddBtn.BackgroundColor3 = C.Accent
AddBtn.Text = "ADD KEY"
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextColor3 = C.Main
Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0, 6)

-- Presets
local PresetLabel = Instance.new("TextLabel", Editor)
PresetLabel.Size = UDim2.new(1, 0, 0, 20)
PresetLabel.Position = UDim2.new(0, 0, 0.7, 0)
PresetLabel.Text = "PRESETS"
PresetLabel.Font = Enum.Font.Gotham
PresetLabel.TextColor3 = C.TextDim
PresetLabel.BackgroundTransparency = 1

local WASDBtn = Instance.new("TextButton", Editor)
WASDBtn.Size = UDim2.new(0.35, 0, 0, 30)
WASDBtn.Position = UDim2.new(0.1, 0, 0.82, 0)
WASDBtn.BackgroundColor3 = C.Btn
WASDBtn.Text = "WASD"
WASDBtn.TextColor3 = C.Text
Instance.new("UICorner", WASDBtn).CornerRadius = UDim.new(0, 6)

local CombatBtn = Instance.new("TextButton", Editor)
CombatBtn.Size = UDim2.new(0.35, 0, 0, 30)
CombatBtn.Position = UDim2.new(0.55, 0, 0.82, 0)
CombatBtn.BackgroundColor3 = C.Btn
CombatBtn.Text = "Combat"
CombatBtn.TextColor3 = C.Text
Instance.new("UICorner", CombatBtn).CornerRadius = UDim.new(0, 6)

-- =================================================================
-- ⚡ LOGIC
-- =================================================================

local function CreateKeyButton(keyName)
    -- Normalize KeyName
    local success, keyCode = pcall(function() return Enum.KeyCode[keyName] end)
    
    -- Handle special cases or casing
    if not success or not keyCode then
        -- Try uppercase first char
        keyName = keyName:sub(1,1):upper() .. keyName:sub(2):lower()
        success, keyCode = pcall(function() return Enum.KeyCode[keyName] end)
        
        -- Try all upper
        if not success then
            keyName = keyName:upper()
            success, keyCode = pcall(function() return Enum.KeyCode[keyName] end)
        end
    end

    if not success then 
        Input.Text = "INVALID KEY" 
        task.wait(1)
        Input.Text = ""
        return 
    end

    -- Create Button
    local Btn = Instance.new("TextButton", KeyFrame)
    Btn.Name = keyName
    Btn.BackgroundColor3 = C.Btn
    Btn.Text = keyName:sub(1,3) -- Shorten long names (e.g. LeftShift -> Lef)
    if #keyName <= 3 then Btn.Text = keyName end
    Btn.TextColor3 = C.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Btn); Stroke.Color = C.Accent; Stroke.Transparency = 0.8

    -- Input Handling (Hold Support)
    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Hold}):Play()
            SimulateKey(keyCode, true) -- Key Down
        end
    end)

    Btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Btn}):Play()
            SimulateKey(keyCode, false) -- Key Up
        end
    end)
    
    -- Update Grid Frame Size dynamically
    local count = #KeyFrame:GetChildren() - 1 -- minus grid layout
    -- Logic to resize container if needed, but Grid handles layout mostly.
end

-- > EVENTS
EditBtn.MouseButton1Click:Connect(function()
    Editor.Visible = not Editor.Visible
end)

AddBtn.MouseButton1Click:Connect(function()
    if Input.Text ~= "" then
        CreateKeyButton(Input.Text)
        Input.Text = ""
    end
end)

WASDBtn.MouseButton1Click:Connect(function()
    local keys = {"W", "A", "S", "D", "Space"}
    for _, k in pairs(keys) do CreateKeyButton(k) end
end)

CombatBtn.MouseButton1Click:Connect(function()
    local keys = {"One", "Two", "Three", "Four", "R", "F", "Z", "X", "C"}
    for _, k in pairs(keys) do CreateKeyButton(k) end
end)

-- Initial Setup
Input.FocusLost:Connect(function(enter)
    if enter and Input.Text ~= "" then
        CreateKeyButton(Input.Text)
        Input.Text = ""
    end
end)

print("🚲 BI-CYCLE KEYBOARD: LOADED")
