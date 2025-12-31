-- [[ VEXON TITAN: ULTIMATE DREAM v7.4 ]]
-- TARGET: THE STRONGEST BATTLEGROUNDS
-- MOBILE OPTIMIZED | TRUE DOWNSLAM FIXED

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Vim = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local mouse = lp:GetMouse()

-- [[ 1. UI ENGINE ]]
local VexonGui = Instance.new("ScreenGui")
VexonGui.Name = "VexonUltimate"
if game.CoreGui:FindFirstChild("RobloxGui") then
    VexonGui.Parent = game.CoreGui
else
    VexonGui.Parent = lp:WaitForChild("PlayerGui")
end

-- TOGGLE BUTTON
local ToggleBtn = Instance.new("TextButton", VexonGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.Text = "🔱"
ToggleBtn.TextSize = 30
ToggleBtn.TextColor3 = Color3.new(1,0,0)
ToggleBtn.BorderSizePixel = 2
ToggleBtn.BorderColor3 = Color3.new(1,0,0)
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)

-- MAIN FRAME
local MainFrame = Instance.new("Frame", VexonGui)
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(150, 0, 0)
MainFrame.Visible = false

-- SIDE BAR
local SideBar = Instance.new("ScrollingFrame", MainFrame)
SideBar.Size = UDim2.new(0.25, 0, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SideBar.ScrollBarThickness = 0
SideBar.CanvasSize = UDim2.new(0, 0, 3, 0)

local TabList = Instance.new("UIListLayout", SideBar)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 5)

-- CONTENT AREA
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(0.75, 0, 1, 0)
ContentArea.Position = UDim2.new(0.25, 0, 0, 0)
ContentArea.BackgroundTransparency = 1

-- TAB GENERATOR
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
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
    page.CanvasSize = UDim2.new(0, 0, 6, 0)
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do v.Page.Visible = false; v.Btn.TextColor3 = Color3.fromRGB(150, 150, 150) end
        page.Visible = true
        btn.TextColor3 = Color3.fromRGB(255, 0, 0)
    end)
    
    table.insert(Tabs, {Btn = btn, Page = page})
    return page
end

local MainP = CreateTab("MAIN")
local FightP = CreateTab("FIGHT")
local TechP = CreateTab("TECH")
local EmoteP = CreateTab("EMOTES")
local LagP = CreateTab("LAG/FPS")
local FlingP = CreateTab("FLING")
local MiscP = CreateTab("MISC")

-- HELPER FUNCTIONS
local function AddBtn(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(callback)
end

local function AddToggle(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = text .. " [OFF]"
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        if on then b.Text = text.." [ON]"; b.BackgroundColor3 = Color3.fromRGB(0, 100, 0); callback(true)
        else b.Text = text.." [OFF]"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); callback(false) end
    end)
end

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- =================================================================
-- 🔱  FEATURES & LOGIC
-- =================================================================

-- [[ 1. MAIN TAB ]]
AddToggle(MainP, "NO STUN (GOD MODE)", function(s)
    getgenv().NoStun = s
    task.spawn(function()
        while getgenv().NoStun do task.wait()
            if lp.Character then
                for _,v in pairs(lp.Character:GetChildren()) do
                    if v.Name == "Stun" or v.Name == "Freeze" or v.Name == "Ragdoll" then v:Destroy() end
                end
                if lp.Character.Humanoid.WalkSpeed < 10 then lp.Character.Humanoid.WalkSpeed = 16 end
            end
        end
    end)
end)

AddToggle(MainP, "ANTI-RAGDOLL", function(s)
    if s then
        lp.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        lp.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    else
        lp.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        lp.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    end
end)

AddBtn(MainP, "SPEED (100)", function() lp.Character.Humanoid.WalkSpeed = 100 end)

-- [[ 2. FIGHTING TAB ]]

-- >> TRUE DOWNSLAM LOGIC <<
AddToggle(FightP, "TRUE DOWNSLAM (AUTO-JUMP)", function(s)
    getgenv().TrueDownslam = s
    local m1_count = 0
    local last_click = 0
    
    if s then
        -- We connect to input began to count clicks
        getgenv().TDSConnection = UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local now = tick()
                if now - last_click > 1.5 then m1_count = 0 end -- Reset if too slow
                last_click = now
                m1_count = m1_count + 1
                
                if m1_count == 2 then
                    -- ON 2ND CLICK: JUMP
                    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                        lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                elseif m1_count >= 3 then
                    -- ON 3RD CLICK: RESET (The attack will naturally be a downslam because we are in air)
                    m1_count = 0
                end
            end
        end)
    else
        if getgenv().TDSConnection then getgenv().TDSConnection:Disconnect() end
    end
end)

AddToggle(FightP, "M1 REACH (25 STUDS)", function(s)
    getgenv().Reach = s
    task.spawn(function()
        while getgenv().Reach do task.wait(0.1)
            pcall(function()
                for _,v in pairs(Players:GetPlayers()) do
                    if v~=lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        if (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude < 25 then
                            v.Character.HumanoidRootPart.Size = Vector3.new(20,20,20)
                            v.Character.HumanoidRootPart.Transparency = 0.8
                            v.Character.HumanoidRootPart.CanCollide = false
                        else
                            v.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
                            v.Character.HumanoidRootPart.Transparency = 1
                        end
                    end
                end
            end)
        end
    end)
end)

-- [[ 3. TECH TAB (KYOTO) ]]
AddBtn(TechP, "SPAWN 'AUTO KYOTO' BUTTON", function()
    local KyotoBtn = Instance.new("TextButton", VexonGui)
    KyotoBtn.Size = UDim2.new(0, 90, 0, 90)
    KyotoBtn.Position = UDim2.new(0.8, -20, 0.55, 0)
    KyotoBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    KyotoBtn.Text = "AUTO\nKYOTO"
    KyotoBtn.Font = Enum.Font.GothamBlack
    KyotoBtn.TextSize = 18
    KyotoBtn.TextColor3 = Color3.new(1,1,1)
    KyotoBtn.Draggable = true
    Instance.new("UICorner", KyotoBtn).CornerRadius = UDim.new(1, 0)
    
    KyotoBtn.MouseButton1Click:Connect(function()
        local char = lp.Character
        local hrp = char.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(90), 0)
        Vim:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
        task.wait()
        Vim:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
        task.wait(0.18) 
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(-90), 0)
        Vim:SendMouseButtonEvent(0,0,0,true,game,1)
        task.wait(0.1)
        Vim:SendMouseButtonEvent(0,0,0,false,game,1)
    end)
end)

-- [[ 4. EMOTES TAB ]]
AddBtn(EmoteP, "UNLOCK ALL SLOTS (CLIENT)", function()
    local gui = lp.PlayerGui:FindFirstChild("ScreenGui")
    if gui then
        for _, v in pairs(gui:GetDescendants()) do
            if v.Name:find("Slot") or v.Name:find("Lock") then
                if v:IsA("ImageButton") or v:IsA("Frame") then
                    v.Visible = true; v.Active = true
                    if v:FindFirstChild("LockIcon") then v.LockIcon.Visible = false end
                end
            end
        end
    end
end)

-- [[ 5. FLING TAB (STABILIZED) ]]
AddToggle(FlingP, "FLING AURA", function(s)
    if s then
        local hrp = lp.Character.HumanoidRootPart
        local b = Instance.new("BodyAngularVelocity", hrp)
        b.Name="SpinFling"; b.MaxTorque=Vector3.new(0,math.huge,0); b.AngularVelocity=Vector3.new(0,15000,0)
        local stab = Instance.new("BodyVelocity", hrp)
        stab.Name="FlingStab"; stab.MaxForce = Vector3.new(0, math.huge, 0); stab.Velocity = Vector3.new(0,0,0)
        getgenv().FlingClip = true
        task.spawn(function()
            while getgenv().FlingClip do task.wait()
                if lp.Character then
                    for _,v in pairs(lp.Character:GetChildren()) do
                        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.CanCollide = false end
                    end
                end
            end
        end)
    else
        getgenv().FlingClip = false
        if lp.Character.HumanoidRootPart:FindFirstChild("SpinFling") then lp.Character.HumanoidRootPart.SpinFling:Destroy() end
        if lp.Character.HumanoidRootPart:FindFirstChild("FlingStab") then lp.Character.HumanoidRootPart.FlingStab:Destroy() end
    end
end)

-- [[ 6. MISC ]]
AddBtn(LagP, "DESTROY DEBRIS", function()
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name=="Stone" or v.Name=="Grass" or v.Name=="Debris" then v:Destroy() end
    end
end)

AddBtn(MiscP, "SERVER HOP", function()
    local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for i,v in pairs(x.data) do
        if v.playing < v.maxPlayers then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, lp) end
    end
end)

Tabs[1].Page.Visible = true; Tabs[1].Btn.TextColor3 = Color3.fromRGB(255, 0, 0)
print("VEXON TITAN v7.4 LOADED")
