-- [[ 👹 JINPACHI HUB: MASTER COLLECTION ]]
-- REBUILT FROM 10 SOURCE FILES
-- TARGET: THE STRONGEST BATTLEGROUNDS

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local lp = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- [[ 1. UI ENGINE: DRAGGABLE & SMOOTH ]]
local JinpachiGui = Instance.new("ScreenGui")
JinpachiGui.Name = "JinpachiHubUI"
if game.CoreGui:FindFirstChild("RobloxGui") then
    JinpachiGui.Parent = game.CoreGui
else
    JinpachiGui.Parent = lp:WaitForChild("PlayerGui")
end

-- > OPEN BUTTON (JINPACHI HUB)
local OpenBtn = Instance.new("TextButton", JinpachiGui)
OpenBtn.Name = "JinpachiButton"
OpenBtn.Size = UDim2.new(0, 120, 0, 40)
OpenBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "JINPACHI HUB"
OpenBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 12
OpenBtn.BorderSizePixel = 0
OpenBtn.Draggable = true
OpenBtn.AutoButtonColor = true

local BtnStroke = Instance.new("UIStroke", OpenBtn)
BtnStroke.Color = Color3.fromRGB(255, 0, 0)
BtnStroke.Thickness = 1.5
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)

-- > MAIN WINDOW
local MainFrame = Instance.new("Frame", JinpachiGui)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false
MainFrame.Draggable = true
MainFrame.Active = true

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(200, 0, 0)
MainStroke.Thickness = 2
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- > TITLE BAR
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "👹 JINPACHI HUB | MASTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 16

-- > CLOSE BUTTON (X)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18

-- > SIDE BAR
local SideBar = Instance.new("ScrollingFrame", MainFrame)
SideBar.Size = UDim2.new(0.25, 0, 1, -50)
SideBar.Position = UDim2.new(0, 10, 0, 45)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SideBar.ScrollBarThickness = 0
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 6)

-- > CONTENT AREA
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(0.72, 0, 1, -50)
ContentArea.Position = UDim2.new(0.27, 0, 0, 45)
ContentArea.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 6)

-- > TAB SYSTEM
local Tabs = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(1, 0, 0, 35)
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
        page.Visible=true; btn.TextColor3=Color3.fromRGB(255,0,0)
    end)
    
    table.insert(Tabs, {Btn = btn, Page = page})
    return page
end

-- [[ TABS DEFINITION ]]
local CombatTab = CreateTab("COMBAT") -- Aimlock
local KyotoTab = CreateTab("KYOTO")   -- Kyoto Tech
local KibaTab = CreateTab("KIBA")     -- Auto-Dash
local TwistTab = CreateTab("TWISTED") -- Instant Twisted
local FpsTab = CreateTab("FPS/OPTI")  -- Booster

-- UI LOGIC
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenBtn.Visible = true end)

-- BUTTON CREATORS
local function AddBtn(p,t,c) 
    local b=Instance.new("TextButton",p);b.Size=UDim2.new(0.95,0,0,40);b.Text=t;b.BackgroundColor3=Color3.fromRGB(35,35,35)
    b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.Gotham;b.TextSize=12;b.MouseButton1Click:Connect(c)
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
end
local function AddToggle(p,t,c)
    local b=Instance.new("TextButton",p);b.Size=UDim2.new(0.95,0,0,40);b.Text=t.." [OFF]"
    b.BackgroundColor3=Color3.fromRGB(35,35,35);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.Gotham;b.TextSize=12
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    local s=false
    b.MouseButton1Click:Connect(function()
        s=not s; b.Text=t..(s and " [ON]" or " [OFF]"); b.BackgroundColor3=s and Color3.fromRGB(0,120,0) or Color3.fromRGB(35,35,35); c(s)
    end)
end

-- =================================================================
-- 👹 JINPACHI ENGINE: LOGIC FROM YOUR FILES
-- =================================================================

-- [[ 1. AIMLOCK TAB (Logic from: aimlock mere.txt) ]]
AddToggle(CombatTab, "MERE AIMLOCK (YAW HEAD)", function(s)
    getgenv().Aimlock = s
    task.spawn(function()
        while getgenv().Aimlock do
            task.wait()
            local closest = nil
            local minDist = math.huge
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (v.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                    if dist < minDist then minDist = dist; closest = v end
                end
            end
            if closest and closest.Character:FindFirstChild("Head") then
                -- Merebeenie's Smooth Tween Logic
                local targetPos = closest.Character.Head.Position
                local lookCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                TweenService:Create(Camera, TweenInfo.new(0.05, Enum.EasingStyle.Sine), {CFrame = lookCFrame}):Play()
            end
        end
    end)
end)

AddBtn(CombatTab, "FORCE UNLOCK", function() getgenv().Aimlock = false end)

-- [[ 2. KYOTO TAB (Logic from: Kyoto.txt) ]]
AddBtn(KyotoTab, "EXECUTE KYOTO (DASH + 2)", function()
    -- Logic: LookVector * 22.5 + Key 2
    local dashDistance = 22.5
    local hrp = lp.Character.HumanoidRootPart
    hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * dashDistance
    task.spawn(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
    end)
end)

-- [[ 3. KIBA TAB (Logic from: Kibav4) ]]
AddToggle(KibaTab, "KIBA AUTO-COUNTER (PASSIVE)", function(s)
    getgenv().KibaActive = s
    if s then
        -- Logic: Listen for Anim 10503381238 -> Press W+Q
        local function onAnim(track)
            if not getgenv().KibaActive then return end
            if track.Animation.AnimationId:find("10503381238") or track.Animation.AnimationId:find("13379003796") then
                task.delay(0.1, function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                end)
            end
        end
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= lp and v.Character then v.Character.Humanoid.AnimationPlayed:Connect(onAnim) end
        end
        Players.PlayerAdded:Connect(function(v) v.CharacterAdded:Connect(function(c) c:WaitForChild("Humanoid").AnimationPlayed:Connect(onAnim) end) end)
    end
end)

-- [[ 4. TWISTED TAB (Logic from: instnat twistedd.txt) ]]
AddToggle(TwistTab, "INSTANT TWISTED (ANIM LISTEN)", function(s)
    getgenv().TwistActive = s
    local triggerID = "13294471966" --
    
    if s then
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        getgenv().TwistConn = hum.AnimationPlayed:Connect(function(track)
            if track.Animation.AnimationId:find(triggerID) then
                -- Shift Lock Simulation
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
            end
        end)
    else
        if getgenv().TwistConn then getgenv().TwistConn:Disconnect() end
    end
end)

AddBtn(TwistTab, "MANUAL TWITQ (DASH 20)", function()
    -- Logic: Dash 20 studs forward
    local hrp = lp.Character.HumanoidRootPart
    hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 20
end)

-- [[ 5. FPS TAB (Logic from: fps booster.txt) ]]
AddBtn(FpsTab, "MEREBEENIE SWEEP (BOOST)", function()
    -- Logic: Destroy specific classes
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Terrain") or v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("MeshPart") then
            v:Destroy()
        end
        if v:IsA("Trail") then v.Enabled = false end
    end
end)

AddToggle(FpsTab, "NIGHT MODE", function(s)
    if s then Lighting.TimeOfDay = "00:00:00"; Lighting.Brightness = 0
    else Lighting.TimeOfDay = "14:00:00"; Lighting.Brightness = 2 end
end)

Tabs[1].Page.Visible = true
Tabs[1].Btn.TextColor3 = Color3.fromRGB(255, 0, 0)

print("👹 JINPACHI HUB LOADED")
