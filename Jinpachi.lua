-- [[ 🚲 BI-CYCLE: KEY-NEXUS V2 (FIXED) ]]
-- STATUS: REWRITTEN INPUT ENGINE
-- FIX: TOGGLE BUTTON RESPONSIVENESS

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

-- =================================================================
-- 🛠️ SAFE GUI LOADER
-- =================================================================

-- Try CoreGui first, then PlayerGui (Mobile Executors often block CoreGui)
local Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui
if not pcall(function() local x = Instance.new("ScreenGui", Parent) x:Destroy() end) then
    Parent = lp:WaitForChild("PlayerGui")
end

if Parent:FindFirstChild("BiCycleKeyV2") then 
    Parent.BiCycleKeyV2:Destroy() 
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "BiCycleKeyV2"
Gui.Parent = Parent
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false -- KEEPS IT OPEN AFTER DEATH

-- COLORS
local C = {
    Bg = Color3.fromRGB(15, 15, 20),
    Dark = Color3.fromRGB(10, 10, 12),
    Accent = Color3.fromRGB(0, 255, 180),
    Text = Color3.fromRGB(255, 255, 255),
    Btn = Color3.fromRGB(25, 25, 30)
}

-- =================================================================
-- ⚙️ CORE FUNCTIONS
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

local function SendKey(key, state)
    -- VirtualInputManager is the most reliable method
    pcall(function()
        VirtualInputManager:SendKeyEvent(state, key, false, game)
    end)
end

-- =================================================================
-- 🖥️ UI ELEMENTS
-- =================================================================

-- 1. THE TOGGLE BUTTON (Wheel)
local OpenBtn = Instance.new("ImageButton", Gui)
OpenBtn.Name = "Toggle"
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
OpenBtn.BackgroundColor3 = C.Dark
OpenBtn.Image = "rbxassetid://18644485536" -- Wheel Icon
OpenBtn.ImageColor3 = C.Accent
OpenBtn.Active = true
OpenBtn.Draggable = true -- Native Roblox Dragging for the button itself
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", OpenBtn)
Stroke.Color = C.Accent; Stroke.Thickness = 2

-- Spin Animation
task.spawn(function()
    local rot = 0
    while true do
        rot = rot + 2
        OpenBtn.Rotation = rot
        task.wait(0.01)
    end
end)

-- 2. MAIN PANEL
local Main = Instance.new("Frame", Gui)
Main.Name = "MainPanel"
Main.Size = UDim2.new(0, 520, 0, 320)
Main.Position = UDim2.new(0.5, -260, 0.3, 0)
Main.BackgroundColor3 = C.Bg
Main.Visible = false -- Starts hidden
Main.ClipsDescendants = true
MakeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = C.Accent; MStroke.Thickness = 1.5

-- ❄️ SNOWFLAKE EFFECT ❄️
local SnowContainer = Instance.new("Frame", Main)
SnowContainer.Size = UDim2.new(1,0,1,0)
SnowContainer.BackgroundTransparency = 1
SnowContainer.ZIndex = 0

task.spawn(function()
    while true do
        if Main.Visible then
            local p = Instance.new("Frame", SnowContainer)
            local s = math.random(2,4)
            p.Size = UDim2.new(0,s,0,s)
            p.Position = UDim2.new(math.random(),0,-0.1,0)
            p.BackgroundColor3 = Color3.new(1,1,1)
            p.BackgroundTransparency = 0.5
            p.BorderSizePixel = 0
            Instance.new("UICorner",p).CornerRadius = UDim.new(1,0)
            local dest = UDim2.new(p.Position.X.Scale + (math.random(-10,10)/100),0,1.1,0)
            TweenService:Create(p, TweenInfo.new(math.random(3,6)), {Position = dest, BackgroundTransparency=1}):Play()
            game.Debris:AddItem(p, 6)
        end
        task.wait(0.2)
    end
end)

-- 3. SIDEBAR (CONTROLS)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0.35, 0, 1, 0)
Sidebar.BackgroundColor3 = C.Dark
Sidebar.ZIndex = 2
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

-- Header
local Title = Instance.new("TextLabel", Sidebar)
Title.Text = "BI-CYCLE"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextColor3 = C.Accent
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0.02, 0)
Title.BackgroundTransparency = 1

local Sub = Instance.new("TextLabel", Sidebar)
Sub.Text = "KEYBOARD"
Sub.Font = Enum.Font.Gotham
Sub.TextSize = 10
Sub.TextColor3 = Color3.fromRGB(150,150,150)
Sub.Size = UDim2.new(1, 0, 0, 20)
Sub.Position = UDim2.new(0, 0, 0.1, 0)
Sub.BackgroundTransparency = 1

-- Input Box
local Input = Instance.new("TextBox", Sidebar)
Input.Size = UDim2.new(0.85, 0, 0, 40)
Input.Position = UDim2.new(0.075, 0, 0.22, 0)
Input.BackgroundColor3 = C.Btn
Input.Text = ""
Input.PlaceholderText = "Key (e.g. Q)"
Input.TextColor3 = C.Text
Input.Font = Enum.Font.GothamBold
Input.TextSize = 14
Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

-- Add Button
local AddBtn = Instance.new("TextButton", Sidebar)
AddBtn.Size = UDim2.new(0.85, 0, 0, 35)
AddBtn.Position = UDim2.new(0.075, 0, 0.38, 0)
AddBtn.BackgroundColor3 = C.Accent
AddBtn.Text = "ADD BUTTON"
AddBtn.TextColor3 = Color3.fromRGB(0,0,0)
AddBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0, 6)

-- Presets
local PLabel = Instance.new("TextLabel", Sidebar)
PLabel.Text = "PRESETS"
PLabel.Size = UDim2.new(1,0,0,20)
PLabel.Position = UDim2.new(0,0,0.55,0)
PLabel.BackgroundTransparency = 1
PLabel.TextColor3 = Color3.fromRGB(100,100,100)
PLabel.Font = Enum.Font.GothamBold
PLabel.TextSize = 11

local function MakePreset(name, pos, func)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0.4, 0, 0, 30)
    b.Position = pos
    b.BackgroundColor3 = C.Btn
    b.Text = name
    b.TextColor3 = C.Text
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(func)
end

-- 4. KEY AREA
local KeyScroll = Instance.new("ScrollingFrame", Main)
KeyScroll.Size = UDim2.new(0.62, 0, 0.85, 0)
KeyScroll.Position = UDim2.new(0.37, 0, 0.05, 0)
KeyScroll.BackgroundTransparency = 1
KeyScroll.ScrollBarThickness = 2
KeyScroll.ZIndex = 2
local Grid = Instance.new("UIGridLayout", KeyScroll)
Grid.CellSize = UDim2.new(0, 65, 0, 65)
Grid.CellPadding = UDim2.new(0, 10, 0, 10)

-- Close X
local CloseX = Instance.new("TextButton", Main)
CloseX.Text = "×"
CloseX.TextColor3 = Color3.fromRGB(200,50,50)
CloseX.BackgroundTransparency = 1
CloseX.TextSize = 25
CloseX.Size = UDim2.new(0,30,0,30)
CloseX.Position = UDim2.new(1,-35,0,5)
CloseX.ZIndex = 10

-- =================================================================
-- ⚡ FUNCTIONALITY
-- =================================================================

-- Toggle Logic (Robust)
local function ToggleUI()
    Main.Visible = not Main.Visible
    -- Safety: If it opens off-screen, reset it
    if Main.Visible then
        Main.Position = UDim2.new(0.5, -260, 0.3, 0)
    end
end

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ToggleUI()
    end
end)

CloseX.MouseButton1Click:Connect(function() Main.Visible = false end)

-- Key Creator
local function AddKey(keyStr)
    -- Normalize
    local k = keyStr:upper()
    if #k > 1 then k = k:sub(1,1):upper() .. k:sub(2):lower() end -- e.g. Leftshift
    
    local success, code = pcall(function() return Enum.KeyCode[k] end)
    if not success and #k == 1 then -- Try pure upper for single letters
        success, code = pcall(function() return Enum.KeyCode[k:upper()] end)
    end
    
    if not code then
        Input.Text = "INVALID"
        task.wait(0.5)
        Input.Text = ""
        return
    end
    
    local KB = Instance.new("TextButton", KeyScroll)
    KB.BackgroundColor3 = C.Btn
    KB.Text = k:upper()
    if #k > 4 then KB.Text = k:sub(1,3).."." end -- Shorten long names
    KB.TextColor3 = C.Text
    KB.Font = Enum.Font.GothamBold
    KB.TextSize = 14
    KB.ZIndex = 5
    Instance.new("UICorner", KB).CornerRadius = UDim.new(0, 8)
    local S = Instance.new("UIStroke", KB)
    S.Color = C.Accent
    S.Thickness = 1
    
    -- Hold Logic
    KB.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(KB, TweenInfo.new(0.1), {BackgroundColor3 = C.Accent, TextColor3 = Color3.new(0,0,0)}):Play()
            SendKey(code, true) -- Down
        end
    end)
    
    KB.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(KB, TweenInfo.new(0.1), {BackgroundColor3 = C.Btn, TextColor3 = C.Text}):Play()
            SendKey(code, false) -- Up
        end
    end)
end

AddBtn.MouseButton1Click:Connect(function()
    if Input.Text ~= "" then
        AddKey(Input.Text)
        Input.Text = ""
    end
end)

-- Presets
MakePreset("WASD", UDim2.new(0.075,0,0.65,0), function()
    AddKey("W"); AddKey("A"); AddKey("S"); AddKey("D"); AddKey("Space")
end)

MakePreset("COMBAT", UDim2.new(0.525,0,0.65,0), function()
    AddKey("One"); AddKey("Two"); AddKey("Three"); AddKey("F"); AddKey("R")
end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "BI-CYCLE V2",
    Text = "Keyboard Loaded. Click the Wheel.",
    Duration = 5
})
