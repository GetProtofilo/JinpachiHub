-- [[ 🚲 BI-CYCLE: DIRECT-KEY ]]
-- STATUS: UNIVERSAL & RELIABLE
-- NO LOGO | DIRECT INTERFACE | MINIMIZABLE

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- =================================================================
-- 🛠️ SAFE UI SETUP (NO CRASH)
-- =================================================================

-- 1. Find Safe Parent
local Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui
if not pcall(function() local x = Instance.new("ScreenGui", Parent) x:Destroy() end) then
    Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- 2. Delete Old
if Parent:FindFirstChild("BiCycleDirect") then 
    Parent.BiCycleDirect:Destroy() 
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "BiCycleDirect"
Gui.Parent = Parent
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false

-- 3. THEME CONFIG
local C = {
    Bg = Color3.fromRGB(12, 12, 15),       -- Dark Background
    Header = Color3.fromRGB(18, 18, 22),   -- Title Bar
    Accent = Color3.fromRGB(0, 255, 180),  -- Mint Green
    Text = Color3.fromRGB(240, 240, 240),
    Btn = Color3.fromRGB(30, 30, 35),
    Pressed = Color3.fromRGB(0, 200, 140)
}

-- =================================================================
-- ⚙️ CORE FUNCTIONS
-- =================================================================

-- Drag Function
local function EnableDrag(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function() 
                if input.UserInputState == Enum.UserInputState.End then dragging = false end 
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
            dragInput = input 
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Key Simulator (The Engine)
local function SendKey(key, state)
    pcall(function()
        VirtualInputManager:SendKeyEvent(state, key, false, game)
    end)
end

-- =================================================================
-- 🖥️ UI CONSTRUCTION
-- =================================================================

-- > MAIN FRAME
local Main = Instance.new("Frame", Gui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 550, 0, 320)
Main.Position = UDim2.new(0.5, -275, 0.3, 0) -- Center Screen
Main.BackgroundColor3 = C.Bg
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = C.Accent
Stroke.Thickness = 2

-- > TITLE BAR (Draggable Area)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = C.Header
EnableDrag(Main, TopBar) -- Drag by TopBar
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

-- Fix bottom corners of TopBar
local Fix = Instance.new("Frame", TopBar)
Fix.Size = UDim2.new(1, 0, 0, 5)
Fix.Position = UDim2.new(0, 0, 1, -5)
Fix.BackgroundColor3 = C.Header
Fix.BorderSizePixel = 0

-- > LOGO TEXT
local Title = Instance.new("TextLabel", TopBar)
Title.Text = "BI-CYCLE HUB"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextColor3 = C.Accent
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- > WINDOW CONTROLS
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 40, 1, 0)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 40, 1, 0)
MinBtn.Position = UDim2.new(1, -80, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.TextColor3 = C.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 25

-- > CONTENT CONTAINER
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, 0, 0.88, 0)
Content.Position = UDim2.new(0, 0, 0.12, 0)
Content.BackgroundTransparency = 1

-- > CONTROLS SIDEBAR (Left)
local Sidebar = Instance.new("Frame", Content)
Sidebar.Size = UDim2.new(0.3, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Sidebar.BorderSizePixel = 0

-- Input Box
local Input = Instance.new("TextBox", Sidebar)
Input.Size = UDim2.new(0.9, 0, 0, 40)
Input.Position = UDim2.new(0.05, 0, 0.05, 0)
Input.BackgroundColor3 = C.Btn
Input.Text = ""
Input.PlaceholderText = "Key (e.g. Q)"
Input.TextColor3 = C.Text
Input.Font = Enum.Font.GothamBold
Input.TextSize = 14
Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

-- Add Button
local AddKeyBtn = Instance.new("TextButton", Sidebar)
AddKeyBtn.Size = UDim2.new(0.9, 0, 0, 35)
AddKeyBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
AddKeyBtn.BackgroundColor3 = C.Accent
AddKeyBtn.Text = "ADD KEY (+)"
AddKeyBtn.TextColor3 = Color3.fromRGB(0,0,0)
AddKeyBtn.Font = Enum.Font.GothamBold
AddKeyBtn.TextSize = 14
Instance.new("UICorner", AddKeyBtn).CornerRadius = UDim.new(0, 6)

-- Preset Header
local PresetHeader = Instance.new("TextLabel", Sidebar)
PresetHeader.Text = "QUICK ACTIONS"
PresetHeader.Size = UDim2.new(1, 0, 0, 20)
PresetHeader.Position = UDim2.new(0, 0, 0.38, 0)
PresetHeader.TextColor3 = Color3.fromRGB(150, 150, 150)
PresetHeader.BackgroundTransparency = 1
PresetHeader.Font = Enum.Font.GothamBold
PresetHeader.TextSize = 11

-- Preset Buttons Function
local function AddPreset(text, pos, func)
    local p = Instance.new("TextButton", Sidebar)
    p.Size = UDim2.new(0.9, 0, 0, 30)
    p.Position = pos
    p.BackgroundColor3 = C.Btn
    p.Text = text
    p.TextColor3 = C.Text
    p.Font = Enum.Font.GothamSemibold
    p.TextSize = 12
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 6)
    p.MouseButton1Click:Connect(func)
end

-- > KEYBOARD GRID (Right)
local KeyScroll = Instance.new("ScrollingFrame", Content)
KeyScroll.Size = UDim2.new(0.68, 0, 0.95, 0)
KeyScroll.Position = UDim2.new(0.31, 0, 0.025, 0)
KeyScroll.BackgroundTransparency = 1
KeyScroll.ScrollBarThickness = 2
local Grid = Instance.new("UIGridLayout", KeyScroll)
Grid.CellSize = UDim2.new(0, 60, 0, 60)
Grid.CellPadding = UDim2.new(0, 8, 0, 8)

-- =================================================================
-- ⚡ LOGIC & EVENTS
-- =================================================================

-- 1. ADD KEY LOGIC
local function SpawnKey(keyName)
    -- Normalize
    local k = keyName:gsub(" ", ""):upper()
    if #k > 1 then k = k:sub(1,1)..k:sub(2):lower() end -- E.g. "LEFTCONTROL" -> "Leftcontrol"
    
    -- Find Enum
    local code = nil
    pcall(function() code = Enum.KeyCode[k] end)
    if not code then pcall(function() code = Enum.KeyCode[k:upper()] end) end

    if not code then
        Input.Text = "INVALID KEY"
        task.wait(0.5)
        Input.Text = ""
        return
    end

    -- Create Button
    local Btn = Instance.new("TextButton", KeyScroll)
    Btn.BackgroundColor3 = C.Btn
    Btn.Text = k:upper()
    if #k > 4 then Btn.Text = k:sub(1,3) end -- Short text
    Btn.TextColor3 = C.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    local S = Instance.new("UIStroke", Btn); S.Color = C.Accent; S.Thickness = 1

    -- Remove Button (Right Click / Long Press)
    Btn.MouseButton2Click:Connect(function() Btn:Destroy() end)

    -- INPUT HANDLING (TOUCH & CLICK)
    local function Down()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Pressed}):Play()
        SendKey(code, true)
    end
    
    local function Up()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Btn}):Play()
        SendKey(code, false)
    end

    Btn.InputBegan:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then
            Down()
        end
    end)
    
    Btn.InputEnded:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then
            Up()
        end
    end)
end

-- 2. BUTTON CONNECTIONS
AddKeyBtn.MouseButton1Click:Connect(function()
    if Input.Text ~= "" then
        SpawnKey(Input.Text)
        Input.Text = ""
    end
end)

-- 3. MINIMIZE / CLOSE
local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 550, 0, 40)}):Play()
        Content.Visible = false
        MinBtn.Text = "+"
    else
        TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 550, 0, 320)}):Play()
        Content.Visible = true
        MinBtn.Text = "-"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

-- 4. PRESETS
AddPreset("WASD (Movement)", UDim2.new(0.05, 0, 0.45, 0), function()
    SpawnKey("W"); SpawnKey("A"); SpawnKey("S"); SpawnKey("D"); SpawnKey("Space")
end)

AddPreset("ARROWS", UDim2.new(0.05, 0, 0.58, 0), function()
    SpawnKey("Up"); SpawnKey("Down"); SpawnKey("Left"); SpawnKey("Right")
end)

AddPreset("COMBAT (1-4, F, R)", UDim2.new(0.05, 0, 0.71, 0), function()
    SpawnKey("One"); SpawnKey("Two"); SpawnKey("Three"); SpawnKey("Four"); SpawnKey("F"); SpawnKey("R")
end)

AddPreset("UTILITY (Shift, Tab)", UDim2.new(0.05, 0, 0.84, 0), function()
    SpawnKey("LeftShift"); SpawnKey("Tab"); SpawnKey("LeftControl"); SpawnKey("Backspace")
end)
