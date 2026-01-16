-- [[ 🚲 BI-CYCLE: NEXUS (V3) ]]
-- FEATURE: DYNAMIC CLONING & LOCKING
-- UI: ONYX DARK THEME

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- =================================================================
-- 🛠️ SETUP & SAFE LOADING
-- =================================================================

local Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui
if not pcall(function() local x = Instance.new("ScreenGui", Parent) x:Destroy() end) then
    Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

if Parent:FindFirstChild("BiCycleNexus") then 
    Parent.BiCycleNexus:Destroy() 
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "BiCycleNexus"
Gui.Parent = Parent
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false

-- THEME
local C = {
    Bg = Color3.fromRGB(15, 15, 20),
    Header = Color3.fromRGB(10, 10, 12),
    Accent = Color3.fromRGB(0, 255, 180), -- Mint
    Text = Color3.fromRGB(255, 255, 255),
    Dim = Color3.fromRGB(150, 150, 150),
    Btn = Color3.fromRGB(25, 25, 30),
    Pressed = Color3.fromRGB(0, 200, 140)
}

-- STATE
local IsEditing = true -- determines if keys are draggable

-- =================================================================
-- ⚙️ CORE ENGINE
-- =================================================================

local DynamicKeys = {} -- Store all clone buttons here

local function SendKey(key, state)
    pcall(function()
        VirtualInputManager:SendKeyEvent(state, key, false, game)
    end)
end

-- Draggable Logic (Toggleable)
local function EnableDrag(obj, dragHandle)
    local dragging, dragInput, dragStart, startPos
    local handle = dragHandle or obj
    
    handle.InputBegan:Connect(function(input)
        if not IsEditing then return end -- Locked Mode
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging and IsEditing then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- =================================================================
-- 🖥️ UI CONSTRUCTION
-- =================================================================

-- 1. MAIN PANEL
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 550, 0, 320)
Main.Position = UDim2.new(0.5, -275, 0.3, 0)
Main.BackgroundColor3 = C.Bg
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = C.Accent
Stroke.Thickness = 1.5

-- 2. TITLE BAR (Draggable)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = C.Header
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
-- Hide bottom rounded corners
local Fix = Instance.new("Frame", TopBar)
Fix.Size = UDim2.new(1,0,0,10); Fix.Position = UDim2.new(0,0,1,-10); Fix.BackgroundColor3 = C.Header; Fix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "BI-CYCLE NEXUS"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextColor3 = C.Accent
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Controls
local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Text = "-"
MinBtn.TextColor3 = C.Text
MinBtn.BackgroundTransparency = 1
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 25
MinBtn.Size = UDim2.new(0,40,1,0)
MinBtn.Position = UDim2.new(1,-80,0,0)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255,60,60)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 25
CloseBtn.Size = UDim2.new(0,40,1,0)
CloseBtn.Position = UDim2.new(1,-40,0,0)

-- Make Main Draggable by TopBar
EnableDrag(Main, TopBar)

-- 3. CONTENT AREA
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, 0, 0.85, 0)
Content.Position = UDim2.new(0, 0, 0.15, 0)
Content.BackgroundTransparency = 1

-- LEFT PANEL (CLONER)
local LeftPanel = Instance.new("Frame", Content)
LeftPanel.Size = UDim2.new(0.35, 0, 0.9, 0)
LeftPanel.Position = UDim2.new(0.03, 0, 0.05, 0)
LeftPanel.BackgroundColor3 = C.Header
Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 8)

local CloneTitle = Instance.new("TextLabel", LeftPanel)
CloneTitle.Text = "DYNAMIC CLONER"
CloneTitle.Font = Enum.Font.GothamBold
CloneTitle.TextSize = 12
CloneTitle.TextColor3 = C.Dim
CloneTitle.Size = UDim2.new(1,0,0,30)
CloneTitle.BackgroundTransparency = 1

local Input = Instance.new("TextBox", LeftPanel)
Input.Size = UDim2.new(0.9, 0, 0, 40)
Input.Position = UDim2.new(0.05, 0, 0.15, 0)
Input.BackgroundColor3 = C.Btn
Input.Text = ""
Input.PlaceholderText = "Type Key (e.g. F)"
Input.TextColor3 = C.Text
Input.Font = Enum.Font.GothamBold
Input.TextSize = 14
Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

local CloneBtn = Instance.new("TextButton", LeftPanel)
CloneBtn.Size = UDim2.new(0.9, 0, 0, 40)
CloneBtn.Position = UDim2.new(0.05, 0, 0.32, 0)
CloneBtn.BackgroundColor3 = C.Accent
CloneBtn.Text = "SPAWN CLONE (A+)"
CloneBtn.TextColor3 = Color3.fromRGB(10,10,10)
CloneBtn.Font = Enum.Font.GothamBlack
CloneBtn.TextSize = 12
Instance.new("UICorner", CloneBtn).CornerRadius = UDim.new(0, 6)

local HelpText = Instance.new("TextLabel", LeftPanel)
HelpText.Text = "• Type a key & spawn it.\n• Drag it anywhere.\n• Minimize this menu to LOCK it in place."
HelpText.Size = UDim2.new(0.9, 0, 0, 60)
HelpText.Position = UDim2.new(0.05, 0, 0.5, 0)
HelpText.BackgroundTransparency = 1
HelpText.TextColor3 = C.Dim
HelpText.TextSize = 11
HelpText.Font = Enum.Font.Gotham
HelpText.TextXAlignment = Enum.TextXAlignment.Left
HelpText.TextWrapped = true

-- RIGHT PANEL (STATIC KEYS)
local RightPanel = Instance.new("ScrollingFrame", Content)
RightPanel.Size = UDim2.new(0.55, 0, 0.9, 0)
RightPanel.Position = UDim2.new(0.42, 0, 0.05, 0)
RightPanel.BackgroundTransparency = 1
RightPanel.ScrollBarThickness = 2
local Grid = Instance.new("UIGridLayout", RightPanel)
Grid.CellSize = UDim2.new(0, 55, 0, 55)
Grid.CellPadding = UDim2.new(0, 8, 0, 8)

-- =================================================================
-- ⚡ CLONE ENGINE
-- =================================================================

local function CreateButton(keyName, isDynamic)
    -- 1. Validate Key
    local k = keyName:gsub(" ", ""):upper()
    if #k > 1 then k = k:sub(1,1)..k:sub(2):lower() end
    
    local code = nil
    pcall(function() code = Enum.KeyCode[k] end)
    if not code then pcall(function() code = Enum.KeyCode[k:upper()] end) end
    
    if not code then return end -- Invalid

    -- 2. Determine Parent (Dynamic vs Static)
    local ParentFrame = isDynamic and Gui or RightPanel
    
    -- 3. Create Button
    local Btn = Instance.new("TextButton", ParentFrame)
    Btn.BackgroundColor3 = C.Btn
    Btn.Text = k:upper()
    if #k > 4 then Btn.Text = k:sub(1,3) end
    Btn.TextColor3 = C.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    local S = Instance.new("UIStroke", Btn)
    S.Color = C.Accent
    S.Thickness = 1.5
    
    if isDynamic then
        Btn.Size = UDim2.new(0, 60, 0, 60)
        Btn.Position = UDim2.new(0.5, -30, 0.5, -30) -- Spawn center
        Btn.ZIndex = 100 -- On top of everything
        table.insert(DynamicKeys, Btn) -- Track it
        
        -- Add "Drag Handle" visual
        local DragIcon = Instance.new("ImageLabel", Btn)
        DragIcon.Size = UDim2.new(0, 15, 0, 15)
        DragIcon.Position = UDim2.new(1, -15, 0, 0)
        DragIcon.BackgroundTransparency = 1
        DragIcon.Image = "rbxassetid://3944676352" -- Move icon
        DragIcon.ImageColor3 = C.Accent
        
        -- Enable Dragging Logic
        EnableDrag(Btn)
        
        -- Update Visuals based on Editing Mode
        local function UpdateVisuals()
            if IsEditing then
                S.Color = Color3.fromRGB(255, 200, 0) -- Yellow = Edit Mode
                DragIcon.Visible = true
                Btn.AutoButtonColor = false -- Disable click flash while moving
            else
                S.Color = C.Accent -- Mint = Locked/Active
                DragIcon.Visible = false
                Btn.AutoButtonColor = true
            end
        end
        
        -- Hook into global update loop
        RunService.Heartbeat:Connect(UpdateVisuals)
    end
    
    -- 4. Input Logic (The Works)
    Btn.InputBegan:Connect(function(io)
        if IsEditing and isDynamic then return end -- Don't click while editing
        if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Pressed}):Play()
            SendKey(code, true) -- HOLD
        end
    end)
    
    Btn.InputEnded:Connect(function(io)
        if IsEditing and isDynamic then return end
        if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Btn}):Play()
            SendKey(code, false) -- RELEASE
        end
    end)
    
    -- Right click to delete dynamic keys
    if isDynamic then
        Btn.MouseButton2Click:Connect(function() Btn:Destroy() end)
    end
end

-- =================================================================
-- ⚡ EVENTS
-- =================================================================

-- Toggle Main UI (and Lock/Unlock Keys)
local function SetState(open)
    Main.Visible = open
    IsEditing = open -- If open, we are editing. If closed, we are locked.
    
    if not open then
        -- Minimized State: Show a small "Open" button
        local Open = Instance.new("TextButton", Gui)
        Open.Name = "Reopen"
        Open.Size = UDim2.new(0, 120, 0, 40)
        Open.Position = UDim2.new(0.5, -60, 0, 10)
        Open.BackgroundColor3 = C.Bg
        Open.Text = "BI-CYCLE ▲"
        Open.TextColor3 = C.Accent
        Open.Font = Enum.Font.GothamBold
        Instance.new("UICorner", Open).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", Open).Color = C.Accent
        
        Open.MouseButton1Click:Connect(function()
            Open:Destroy()
            SetState(true)
        end)
    end
end

MinBtn.MouseButton1Click:Connect(function() SetState(false) end)
CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)

CloneBtn.MouseButton1Click:Connect(function()
    if Input.Text ~= "" then
        CreateButton(Input.Text, true) -- TRUE = DYNAMIC
        Input.Text = ""
    end
end)

-- Add some default static keys
local Defaults = {"Space", "W", "A", "S", "D", "R", "F", "Shift", "Q"}
for _, k in pairs(Defaults) do CreateButton(k, false) end

-- Init
SetState(true)
print("🚲 BI-CYCLE NEXUS LOADED")
