-- [[ 👹 JINPACHI HUB: HYBRID EDITION ]]
-- UNIVERSAL + TSB SOURCE MERGE
-- MOBILE OPTIMIZED (Delta/Fluxus)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local lp = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- =================================================================
-- 🎨 UI ENGINE: JINPACHI STYLE
-- =================================================================

local JinpachiGui = Instance.new("ScreenGui")
JinpachiGui.Name = "JinpachiHybrid"
if game.CoreGui:FindFirstChild("RobloxGui") then
    JinpachiGui.Parent = game.CoreGui
else
    JinpachiGui.Parent = lp:WaitForChild("PlayerGui")
end

-- > DRAG LOGIC
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

-- > OPEN BUTTON
local OpenBtn = Instance.new("TextButton", JinpachiGui)
OpenBtn.Size = UDim2.new(0, 130, 0, 45)
OpenBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "JINPACHI HUB"
OpenBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 14
OpenBtn.Draggable = true
MakeDraggable(OpenBtn)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(200, 0, 0)

-- > MAIN WINDOW
local MainFrame = Instance.new("Frame", JinpachiGui)
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Visible = false
MakeDraggable(MainFrame)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(180, 0, 0)
MainStroke.Thickness = 2

-- > TOP BAR
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "👹 JINPACHI HUB | HYBRID"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 16

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18

-- > SIDE BAR
local SideBar = Instance.new("ScrollingFrame", MainFrame)
SideBar.Size = UDim2.new(0.28, 0, 1, -50)
SideBar.Position = UDim2.new(0, 10, 0, 45)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SideBar.ScrollBarThickness = 0
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 6)

-- > CONTENT AREA
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(0.68, 0, 1, -50)
ContentArea.Position = UDim2.new(0.3, 0, 0, 45)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 6)

-- > TAB GENERATOR
local Tabs = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    
    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.Visible = false
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local list = SideBar:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout", SideBar)
    list.Padding = UDim.new(0, 2)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do v.Page.Visible=false; v.Btn.TextColor3=Color3.fromRGB(150,150,150) end
        page.Visible=true; btn.TextColor3=Color3.fromRGB(255, 0, 0)
    end)
    table.insert(Tabs, {Btn = btn, Page = page})
    return page
end

-- TABS
local UniMain = CreateTab("UNIVERSAL")
local UniVis = CreateTab("VISUALS")
local TsbCombat = CreateTab("TSB COMBAT")
local TsbTech = CreateTab("TSB TECH")
local OptiTab = CreateTab("FPS/OPTI")

-- UI TOGGLES
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenBtn.Visible = true end)

local function AddBtn(p,t,c) local b=Instance.new("TextButton",p);b.Size=UDim2.new(0.95,0,0,38);b.Text=t;b.BackgroundColor3=Color3.fromRGB(30,30,30);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.Gotham;b.TextSize=12;b.MouseButton1Click:Connect(c);Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) end
local function AddToggle(p,t,c) local b=Instance.new("TextButton",p);b.Size=UDim2.new(0.95,0,0,38);b.Text=t.." [OFF]";b.BackgroundColor3=Color3.fromRGB(30,30,30);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.Gotham;b.TextSize=12;Instance.new("UICorner",b).CornerRadius=UDim.new(0,6);local s=false;b.MouseButton1Click:Connect(function()s=not s;b.Text=t..(s and " [ON]" or " [OFF]");b.BackgroundColor3=s and Color3.fromRGB(0,100,0) or Color3.fromRGB(30,30,30);c(s)end) end

-- =================================================================
-- 🌌 UNIVERSAL FEATURES (ANY GAME)
-- =================================================================

AddBtn(UniMain, "SPEED (100)", function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = 100
    end
end)

AddToggle(UniMain, "FLY (MOBILE)", function(s)
    getgenv().Fly = s
    if s then
        local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
        bv.Name = "UniFly"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Velocity = Vector3.zero
        task.spawn(function()
            while getgenv().Fly do task.wait()
                if lp.Character then lp.Character.Humanoid.PlatformStand = true; bv.Velocity = Workspace.CurrentCamera.CFrame.LookVector * 50 end
            end
            lp.Character.Humanoid.PlatformStand = false; bv:Destroy()
        end)
    else
        if lp.Character.HumanoidRootPart:FindFirstChild("UniFly") then lp.Character.HumanoidRootPart.UniFly:Destroy() end
        lp.Character.Humanoid.PlatformStand = false
    end
end)

AddToggle(UniMain, "NOCLIP", function(s)
    getgenv().Noclip = s
    task.spawn(function()
        while getgenv().Noclip do task.wait()
            if lp.Character then for _,v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end
        end
    end)
end)

AddToggle(UniVis, "ESP (BOX)", function(s)
    getgenv().ESP = s
    if s then
        task.spawn(function()
            while getgenv().ESP do task.wait(1)
                for _,v in pairs(Players:GetPlayers()) do
                    if v ~= lp and v.Character and not v.Character:FindFirstChild("JinpachiESP") then
                        local h = Instance.new("Highlight", v.Character); h.Name="JinpachiESP"; h.FillColor=Color3.fromRGB(255,0,0); h.OutlineColor=Color3.fromRGB(255,255,255)
                    end
                end
            end
        end)
    else
        for _,v in pairs(Players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("JinpachiESP") then v.Character.JinpachiESP:Destroy() end end
    end
end)

-- =================================================================
-- ⚔️ TSB FEATURES (FROM YOUR FILES)
-- =================================================================

-- Source: aimlock mere.txt
AddToggle(TsbCombat, "MERE AIMLOCK (YAW)", function(s)
    getgenv().MereAim = s
    task.spawn(function()
        while getgenv().MereAim do task.wait()
            local closest, dist = nil, math.huge
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (v.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; closest = v end
                end
            end
            if closest and closest.Character:FindFirstChild("Head") then
                local targetPos = closest.Character.Head.Position
                TweenService:Create(Camera, TweenInfo.new(0.05, Enum.EasingStyle.Sine), {CFrame = CFrame.new(Camera.CFrame.Position, targetPos)}):Play()
            end
        end
    end)
end)

-- Source: aimlock so bunzzz.txt
AddToggle(TsbCombat, "BUNZ LOCK (FACE ENEMY)", function(s)
    getgenv().BunzAim = s
    task.spawn(function()
        while getgenv().BunzAim do task.wait()
            local closest, dist = nil, math.huge
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character then
                    local d = (v.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; closest = v end
                end
            end
            if closest then
                local hrp = lp.Character.HumanoidRootPart
                local look = Vector3.new(closest.Character.HumanoidRootPart.Position.X, hrp.Position.Y, closest.Character.HumanoidRootPart.Position.Z)
                hrp.CFrame = CFrame.new(hrp.Position, look)
            end
        end
    end)
end)

-- Source: Kyoto.txt
AddBtn(TsbTech, "KYOTO (DASH + 2)", function()
    local dashDistance = 22.5
    local hrp = lp.Character.HumanoidRootPart
    hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * dashDistance
    task.spawn(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
    end)
end)

-- Source: Kibav4
AddToggle(TsbTech, "KIBA V4 (AUTO-COUNTER)", function(s)
    getgenv().KibaActive = s
    if s then
        local function onAnim(track)
            if not getgenv().KibaActive then return end
            if track.Animation.AnimationId:find("10503381238") then
                task.delay(0.1, function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                end)
            end
        end
        for _,v in pairs(Players:GetPlayers()) do if v~=lp and v.Character then v.Character.Humanoid.AnimationPlayed:Connect(onAnim) end end
    end
end)

-- Source: instnat twistedd.txt
AddToggle(TsbTech, "INSTANT TWISTED (AUTO)", function(s)
    getgenv().TwistActive = s
    if s then
        local char = lp.Character or lp.CharacterAdded:Wait()
        char:WaitForChild("Humanoid").AnimationPlayed:Connect(function(track)
            if track.Animation.AnimationId:find("13294471966") then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
            end
        end)
    end
end)

-- =================================================================
-- ⚡ FPS OPTIMIZATION (FROM FILE)
-- =================================================================

-- Source: fps booster.txt
AddBtn(OptiTab, "SWEEP MAP (BOOST)", function()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Terrain") or v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("MeshPart") then
            v:Destroy()
        end
        if v:IsA("Trail") then v.Enabled = false end
    end
end)

AddToggle(OptiTab, "NIGHT MODE", function(s)
    if s then Lighting.TimeOfDay = "00:00:00"; Lighting.Brightness = 0
    else Lighting.TimeOfDay = "14:00:00"; Lighting.Brightness = 2 end
end)

Tabs[1].Page.Visible = true; Tabs[1].Btn.TextColor3 = Color3.fromRGB(0, 255, 255)
print("👹 JINPACHI HUB HYBRID LOADED")
