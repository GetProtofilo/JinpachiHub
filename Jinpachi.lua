-- [[ ❄️ VEXON UNIVERSAL: WINTER EDITION ]]
-- PURE UNIVERSAL SCRIPT | SNOWFALL UI
-- WORKS IN ALL GAMES

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = lp:GetMouse()

-- =================================================================
-- ❄️ UI ENGINE: SNOWFALL SYSTEM
-- =================================================================

local VexonGui = Instance.new("ScreenGui")
VexonGui.Name = "VexonWinter"
if CoreGui:FindFirstChild("RobloxGui") then
    VexonGui.Parent = CoreGui
else
    VexonGui.Parent = lp:WaitForChild("PlayerGui")
end

-- > OPEN BUTTON
local OpenBtn = Instance.new("TextButton", VexonGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.Text = "❄️"
OpenBtn.TextSize = 25
OpenBtn.Draggable = true
OpenBtn.AutoButtonColor = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(100, 200, 255)

-- > MAIN WINDOW
local MainFrame = Instance.new("Frame", VexonGui)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.ClipsDescendants = true -- Keeps snow inside
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 150, 255)
MainStroke.Thickness = 1.5
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- > SNOWFALL EFFECT
local SnowContainer = Instance.new("Frame", MainFrame)
SnowContainer.Size = UDim2.new(1, 0, 1, 0)
SnowContainer.BackgroundTransparency = 1
SnowContainer.ZIndex = 1

task.spawn(function()
    while true do
        if MainFrame.Visible then
            local snow = Instance.new("Frame", SnowContainer)
            snow.Size = UDim2.new(0, math.random(2,4), 0, math.random(2,4))
            snow.Position = UDim2.new(math.random(), 0, -0.1, 0)
            snow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            snow.BackgroundTransparency = 0.3
            snow.BorderSizePixel = 0
            Instance.new("UICorner", snow).CornerRadius = UDim.new(1,0)
            
            local duration = math.random(3, 6)
            local targetPos = UDim2.new(snow.Position.X.Scale + (math.random(-10,10)/100), 0, 1.1, 0)
            
            TweenService:Create(snow, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Position = targetPos, BackgroundTransparency = 1}):Play()
            game.Debris:AddItem(snow, duration)
        end
        task.wait(0.1)
    end
end)

-- > TOP BAR
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TopBar.ZIndex = 2
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "❄️ VEXON UNIVERSAL"
Title.TextColor3 = Color3.fromRGB(220, 240, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 18
Title.ZIndex = 3

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.ZIndex = 3

-- > SIDE BAR
local SideBar = Instance.new("ScrollingFrame", MainFrame)
SideBar.Size = UDim2.new(0.25, 0, 1, -55)
SideBar.Position = UDim2.new(0, 10, 0, 50)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
SideBar.ScrollBarThickness = 0
SideBar.ZIndex = 2
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 6)

-- > CONTENT AREA
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(0.71, 0, 1, -55)
ContentArea.Position = UDim2.new(0.28, 0, 0, 50)
ContentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ContentArea.ZIndex = 2
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 6)

-- > TAB SYSTEM
local Tabs = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(150, 150, 170)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 3
    
    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.Visible = false
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ZIndex = 3
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local list = SideBar:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout", SideBar)
    list.Padding = UDim.new(0, 2)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do v.Page.Visible=false; v.Btn.TextColor3=Color3.fromRGB(150,150,170) end
        page.Visible=true; btn.TextColor3=Color3.fromRGB(100, 200, 255)
    end)
    table.insert(Tabs, {Btn = btn, Page = page})
    return page
end

local PlayerTab = CreateTab("PLAYER")
local CombatTab = CreateTab("COMBAT")
local VisualsTab = CreateTab("VISUALS")
local MiscTab = CreateTab("MISC")

-- UI TOGGLES
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenBtn.Visible = true end)

local function AddBtn(p,t,c) local b=Instance.new("TextButton",p);b.Size=UDim2.new(0.95,0,0,38);b.Text=t;b.BackgroundColor3=Color3.fromRGB(35,35,40);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.Gotham;b.TextSize=12;b.ZIndex=3;b.MouseButton1Click:Connect(c);Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) end
local function AddToggle(p,t,c) local b=Instance.new("TextButton",p);b.Size=UDim2.new(0.95,0,0,38);b.Text=t.." [OFF]";b.BackgroundColor3=Color3.fromRGB(35,35,40);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.Gotham;b.TextSize=12;b.ZIndex=3;Instance.new("UICorner",b).CornerRadius=UDim.new(0,6);local s=false;b.MouseButton1Click:Connect(function()s=not s;b.Text=t..(s and " [ON]" or " [OFF]");b.BackgroundColor3=s and Color3.fromRGB(0,100,150) or Color3.fromRGB(35,35,40);c(s)end) end

-- =================================================================
-- 🌌 UNIVERSAL FEATURES
-- =================================================================

-- [[ 1. PLAYER TAB ]]
AddBtn(PlayerTab, "SPEED (50)", function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = 50
    end
end)

AddBtn(PlayerTab, "SPEED (100)", function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = 100
    end
end)

AddBtn(PlayerTab, "JUMP POWER (100)", function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.UseJumpPower = true
        lp.Character.Humanoid.JumpPower = 100
    end
end)

AddToggle(PlayerTab, "FLY (MOBILE)", function(s)
    getgenv().Fly = s
    if s then
        local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
        bv.Name = "UniFly"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Velocity = Vector3.zero
        task.spawn(function()
            while getgenv().Fly do task.wait()
                if lp.Character then lp.Character.Humanoid.PlatformStand = true; bv.Velocity = Workspace.CurrentCamera.CFrame.LookVector * 50 end
            end
            if lp.Character then lp.Character.Humanoid.PlatformStand = false end; bv:Destroy()
        end)
    else
        if lp.Character.HumanoidRootPart:FindFirstChild("UniFly") then lp.Character.HumanoidRootPart.UniFly:Destroy() end
        if lp.Character then lp.Character.Humanoid.PlatformStand = false end
    end
end)

AddToggle(PlayerTab, "NOCLIP", function(s)
    getgenv().Noclip = s
    task.spawn(function()
        while getgenv().Noclip do task.wait()
            if lp.Character then for _,v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end
        end
    end)
end)

AddToggle(PlayerTab, "INFINITE JUMP", function(s)
    getgenv().InfJump = s
    UserInputService.JumpRequest:Connect(function()
        if getgenv().InfJump and lp.Character then lp.Character.Humanoid:ChangeState("Jumping") end
    end)
end)

-- [[ 2. COMBAT TAB ]]
AddToggle(CombatTab, "UNIVERSAL AIMBOT", function(s)
    getgenv().Aimbot = s
    task.spawn(function()
        while getgenv().Aimbot do task.wait()
            local closest, dist = nil, math.huge
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (v.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; closest = v end
                end
            end
            if closest then
                -- Merebeenie Smooth Tween Logic
                local target = closest.Character:FindFirstChild("Head") or closest.Character:FindFirstChild("HumanoidRootPart")
                if target then
                    TweenService:Create(Camera, TweenInfo.new(0.05, Enum.EasingStyle.Sine), {CFrame = CFrame.new(Camera.CFrame.Position, target.Position)}):Play()
                end
            end
        end
    end)
end)

AddToggle(CombatTab, "HITBOX EXPANDER", function(s)
    getgenv().Hitbox = s
    task.spawn(function()
        while getgenv().Hitbox do task.wait(1)
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(10,10,10)
                    v.Character.HumanoidRootPart.Transparency = 0.7
                    v.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end)
end)

-- [[ 3. VISUALS TAB ]]
AddToggle(VisualsTab, "ESP (BOX)", function(s)
    getgenv().ESP = s
    if s then
        task.spawn(function()
            while getgenv().ESP do task.wait(1)
                for _,v in pairs(Players:GetPlayers()) do
                    if v ~= lp and v.Character and not v.Character:FindFirstChild("UniESP") then
                        local h = Instance.new("Highlight", v.Character)
                        h.Name = "UniESP"
                        h.FillColor = Color3.fromRGB(100, 200, 255)
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
        end)
    else
        for _,v in pairs(Players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("UniESP") then v.Character.UniESP:Destroy() end end
    end
end)

AddToggle(VisualsTab, "FULLBRIGHT", function(s)
    if s then Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.GlobalShadows=false
    else Lighting.Brightness=1; Lighting.GlobalShadows=true end
end)

-- [[ 4. MISC TAB ]]
AddBtn(MiscTab, "FPS BOOSTER (CLEAR MAP)", function()
    -- Merebeenie Sweep Logic
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Terrain") then
            v:Destroy()
        end
    end
    Lighting.GlobalShadows = false
end)

AddBtn(MiscTab, "REJOIN SERVER", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
end)

AddBtn(MiscTab, "SERVER HOP", function()
    local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for i,v in pairs(x.data) do
        if v.playing < v.maxPlayers then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, lp) end
    end
end)

-- INIT
Tabs[1].Page.Visible = true
Tabs[1].Btn.TextColor3 = Color3.fromRGB(100, 200, 255)
print("❄️ VEXON UNIVERSAL LOADED")
