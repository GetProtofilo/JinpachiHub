-- [[ ❄️ JINPACHI: FROSTBITE UNIVERSAL ]]
-- THE ULTIMATE WINTER ANIME HUB
-- FIXED: INF JUMP, FPS BOOST | ADDED: ANIME UI, MORE FEATURES

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

local lp = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = lp:GetMouse()

-- =================================================================
-- 🎨 UI ENGINE: ANIME WINTER THEME
-- =================================================================

local FrostGui = Instance.new("ScreenGui")
FrostGui.Name = "JinpachiFrostbite"
if CoreGui:FindFirstChild("RobloxGui") then
    FrostGui.Parent = CoreGui
else
    FrostGui.Parent = lp:WaitForChild("PlayerGui")
end

-- > ASSETS
local ANIME_ICON_ID = "http://www.roblox.com/asset/?id=16020546681" -- Cool Anime Eye/Icon
local THEME_COLOR = Color3.fromRGB(120, 220, 255) -- Icy Blue
local BG_COLOR = Color3.fromRGB(15, 15, 20) -- Deep Dark
local BTN_COLOR = Color3.fromRGB(25, 25, 30)

-- > DRAGGABLE FUNCTION
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- > OPEN BUTTON (Anime Icon)
local OpenBtn = Instance.new("ImageButton", FrostGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = BG_COLOR
OpenBtn.Image = ANIME_ICON_ID
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0) -- Circle
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = THEME_COLOR
OpenStroke.Thickness = 2
OpenStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- > MAIN FRAME
local MainFrame = Instance.new("Frame", FrostGui)
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.3, 0)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MakeDraggable(MainFrame)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = THEME_COLOR
MainStroke.Thickness = 1.5

-- > SNOWFALL ENGINE ❄️
local SnowContainer = Instance.new("Frame", MainFrame)
SnowContainer.Size = UDim2.new(1, 0, 1, 0)
SnowContainer.BackgroundTransparency = 1
SnowContainer.ZIndex = 1

task.spawn(function()
    while true do
        if MainFrame.Visible then
            local snow = Instance.new("Frame", SnowContainer)
            snow.Size = UDim2.new(0, math.random(2,5), 0, math.random(2,5))
            snow.Position = UDim2.new(math.random(), 0, -0.1, 0)
            snow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            snow.BackgroundTransparency = 0.4
            snow.BorderSizePixel = 0
            Instance.new("UICorner", snow).CornerRadius = UDim.new(1,0)
            
            local duration = math.random(2, 5)
            local targetPos = UDim2.new(snow.Position.X.Scale + (math.random(-5,5)/100), 0, 1.1, 0)
            
            TweenService:Create(snow, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Position = targetPos, BackgroundTransparency = 1}):Play()
            game.Debris:AddItem(snow, duration)
        end
        task.wait(0.05)
    end
end)

-- > SIDEBAR (Left)
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0.25, 0, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
SideBar.ZIndex = 2
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

-- > LOGO AREA
local LogoIcon = Instance.new("ImageLabel", SideBar)
LogoIcon.Size = UDim2.new(0, 80, 0, 80)
LogoIcon.Position = UDim2.new(0.5, -40, 0.02, 0)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Image = ANIME_ICON_ID
LogoIcon.ZIndex = 3

local LogoText = Instance.new("TextLabel", SideBar)
LogoText.Size = UDim2.new(1, 0, 0, 20)
LogoText.Position = UDim2.new(0, 0, 0.25, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "JINPACHI"
LogoText.Font = Enum.Font.GothamBlack
LogoText.TextColor3 = THEME_COLOR
LogoText.TextSize = 16
LogoText.ZIndex = 3

-- > CONTENT AREA
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(0.73, 0, 0.96, 0)
ContentArea.Position = UDim2.new(0.26, 0, 0.02, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 2

-- > CLOSE BUTTON
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = THEME_COLOR
CloseBtn.TextSize = 30
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.ZIndex = 10

-- > TAB GENERATOR
local Tabs = {}
local TabContainer = Instance.new("ScrollingFrame", SideBar)
TabContainer.Size = UDim2.new(1, 0, 0.65, 0)
TabContainer.Position = UDim2.new(0, 0, 0.32, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.ZIndex = 3

local TabListLayout = Instance.new("UIListLayout", TabContainer)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.Padding = UDim.new(0, 8)

local function CreateTab(name, icon)
    -- Tab Button
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    -- Page Frame
    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
    page.ZIndex = 3
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    btn.MouseButton1Click:Connect(function()
        for _,v in pairs(Tabs) do 
            v.Page.Visible = false
            TweenService:Create(v.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35), TextColor3 = Color3.fromRGB(150,150,150)}):Play()
        end
        page.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = THEME_COLOR, TextColor3 = Color3.fromRGB(0,0,0)}):Play()
    end)
    
    table.insert(Tabs, {Btn = btn, Page = page})
    return page
end

-- HELPER: TOGGLES & BUTTONS
local function AddBtn(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.BackgroundColor3 = BTN_COLOR
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.ZIndex = 4
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(50,50,60)
    Instance.new("UIStroke", btn).Thickness = 1
    
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.9, 0, 0, 35)}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 40)}):Play()
        callback()
    end)
end

local function AddToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.BackgroundColor3 = BTN_COLOR
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.ZIndex = 4
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local status = Instance.new("Frame", btn)
    status.Size = UDim2.new(0, 10, 0, 10)
    status.Position = UDim2.new(0.9, 0, 0.5, -5)
    status.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Instance.new("UICorner", status).CornerRadius = UDim.new(1,0)
    
    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        if on then
            TweenService:Create(status, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 255, 50)}):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
        else
            TweenService:Create(status, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = BTN_COLOR}):Play()
        end
        callback(on)
    end)
end

-- =================================================================
-- 🌌 CREATING TABS & FEATURES
-- =================================================================

local PlayerP = CreateTab("PLAYER")
local CombatP = CreateTab("COMBAT")
local VisualP = CreateTab("VISUALS")
local WorldP = CreateTab("WORLD/FPS")
local MiscP = CreateTab("MISC")

-- [[ 1. PLAYER FEATURES (FIXED) ]]
AddBtn(PlayerP, "WALKSPEED (50)", function() 
    if lp.Character then lp.Character.Humanoid.WalkSpeed = 50 end 
end)
AddBtn(PlayerP, "WALKSPEED (100)", function() 
    if lp.Character then lp.Character.Humanoid.WalkSpeed = 100 end 
end)

-- FIXED INFINITE JUMP
AddToggle(PlayerP, "INFINITE JUMP (FIXED)", function(s)
    getgenv().InfJump = s
    if s then
        getgenv().InfJumpConn = UserInputService.JumpRequest:Connect(function()
            if getgenv().InfJump and lp.Character then
                lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if getgenv().InfJumpConn then getgenv().InfJumpConn:Disconnect() end
    end
end)

AddToggle(PlayerP, "NOCLIP (WALLHACK)", function(s)
    getgenv().Noclip = s
    task.spawn(function()
        while getgenv().Noclip do task.wait()
            if lp.Character then
                for _,v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
                end
            end
        end
    end)
end)

AddToggle(PlayerP, "FLY (MOBILE V2)", function(s)
    getgenv().Fly = s
    if s then
        local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
        bv.Name = "FrostFly"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Velocity = Vector3.zero
        task.spawn(function()
            while getgenv().Fly do task.wait()
                if lp.Character then 
                    lp.Character.Humanoid.PlatformStand = true
                    bv.Velocity = Workspace.CurrentCamera.CFrame.LookVector * 60 
                end
            end
            if lp.Character then lp.Character.Humanoid.PlatformStand = false end; bv:Destroy()
        end)
    else
        if lp.Character.HumanoidRootPart:FindFirstChild("FrostFly") then lp.Character.HumanoidRootPart.FrostFly:Destroy() end
        if lp.Character then lp.Character.Humanoid.PlatformStand = false end
    end
end)

-- [[ 2. COMBAT FEATURES ]]
AddToggle(CombatP, "AIMBOT (CLOSEST)", function(s)
    getgenv().Aimbot = s
    task.spawn(function()
        while getgenv().Aimbot do task.wait()
            local closest, dist = nil, 500 -- Max Dist 500
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    -- Team Check
                    if v.Team ~= lp.Team or v.Team == nil then
                        local d = (v.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then dist = d; closest = v end
                    end
                end
            end
            if closest then
                TweenService:Create(Camera, TweenInfo.new(0.05), {CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.HumanoidRootPart.Position)}):Play()
            end
        end
    end)
end)

AddToggle(CombatP, "HITBOX EXPANDER (15)", function(s)
    getgenv().BigHitbox = s
    task.spawn(function()
        while getgenv().BigHitbox do task.wait(1)
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Team ~= lp.Team then
                    v.Character.HumanoidRootPart.Size = Vector3.new(15,15,15)
                    v.Character.HumanoidRootPart.Transparency = 0.7
                    v.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end)
end)

-- [[ 3. VISUALS ]]
AddToggle(VisualP, "ESP (HIGHLIGHT)", function(s)
    getgenv().ESP = s
    if s then
        task.spawn(function()
            while getgenv().ESP do task.wait(1)
                for _,v in pairs(Players:GetPlayers()) do
                    if v ~= lp and v.Character and not v.Character:FindFirstChild("FrostESP") then
                        local h = Instance.new("Highlight", v.Character)
                        h.Name = "FrostESP"
                        h.FillColor = THEME_COLOR
                        h.OutlineColor = Color3.new(1,1,1)
                    end
                end
            end
        end)
    else
        for _,v in pairs(Players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("FrostESP") then v.Character.FrostESP:Destroy() end end
    end
end)

AddBtn(VisualP, "FOV: 120 (WIDE)", function() Camera.FieldOfView = 120 end)
AddBtn(VisualP, "FOV: 70 (NORMAL)", function() Camera.FieldOfView = 70 end)

-- [[ 4. WORLD & FPS (FIXED) ]]
-- Replaced broken "Destroy" method with "Potato Mode"
AddToggle(WorldP, "FPS BOOSTER (POTATO MODE)", function(s)
    if s then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("Terrain") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
    end
end)

AddToggle(WorldP, "FULLBRIGHT", function(s)
    if s then Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.GlobalShadows=false; Lighting.Ambient=Color3.new(1,1,1)
    else Lighting.Brightness=1; Lighting.GlobalShadows=true end
end)

AddBtn(WorldP, "TIME: NIGHT", function() Lighting.TimeOfDay = "00:00:00" end)
AddBtn(WorldP, "TIME: DAY", function() Lighting.TimeOfDay = "12:00:00" end)

-- [[ 5. MISC ]]
AddToggle(MiscP, "ANTI-AFK", function(s)
    getgenv().AntiAFK = s
    if s then
        lp.Idled:Connect(function()
            if getgenv().AntiAFK then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end
end)

AddBtn(MiscP, "REJOIN SERVER", function() game:GetService("TeleportService"):Teleport(game.PlaceId, lp) end)

-- UI LOGIC
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenBtn.Visible = true end)

-- INIT
Tabs[1].Page.Visible = true
TweenService:Create(Tabs[1].Btn, TweenInfo.new(0.2), {BackgroundColor3 = THEME_COLOR, TextColor3 = Color3.fromRGB(0,0,0)}):Play()

print("❄️ JINPACHI FROSTBITE LOADED")
