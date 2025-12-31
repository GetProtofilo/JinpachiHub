-- [[ VEXON TITAN: MOBILE EDITION ]]
-- Optimized for: Delta, Fluxus, Hydrogen, Arceus X

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- [[ 1. MOBILE UI SETUP (Native) ]]
local ScreenGui = Instance.new("ScreenGui")
if game.CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = lp:WaitForChild("PlayerGui")
end
ScreenGui.Name = "VexonMobile"
ScreenGui.ResetOnSpawn = false

-- TOGGLE BUTTON (The small button to open menu)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.9, -60, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
OpenBtn.Text = "V"
OpenBtn.TextSize = 30
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.BorderSizePixel = 2
OpenBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
OpenBtn.Active = true
OpenBtn.Draggable = true -- You can drag this button

local Corner = Instance.new("UICorner", OpenBtn); Corner.CornerRadius = UDim.new(0, 10)

-- MAIN MENU FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 450)
MainFrame.Position = UDim2.new(0.5, -150, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Title.Text = "VEXON TITAN | TSB MOBILE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- SCROLLING CONTAINER
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 4, 0)
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [[ 2. FUNCTION GENERATOR ]]
local function AddButton(text, color, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 45)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        callback()
        -- Visual Click Feedback
        btn.Text = text .. " [ON]"
        task.wait(0.5)
        btn.Text = text
    end)
end

-- [[ 3. FEATURE LOGIC ]]

-- OPEN/CLOSE LOGIC
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- > COMBAT SECTION <
AddButton("🔥 REACH (HITBOX 25)", Color3.fromRGB(150, 0, 0), function()
    -- Mobile Optimized Reach: Expands enemy hitbox locally
    _G.Reach = not _G.Reach
    task.spawn(function()
        while _G.Reach do
            task.wait(0.1)
            pcall(function()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.Character.HumanoidRootPart
                        local mag = (lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if mag < 25 then
                            hrp.Size = Vector3.new(20, 20, 20)
                            hrp.Transparency = 0.8
                            hrp.CanCollide = false
                        else
                            hrp.Size = Vector3.new(2, 2, 1)
                            hrp.Transparency = 1
                        end
                    end
                end
            end)
        end
    end)
end)

AddButton("🛡️ ANTI-RAGDOLL (GOD)", Color3.fromRGB(100, 0, 0), function()
    -- Prevents physics states that knock you down
    lp.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    lp.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    lp.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
end)

AddButton("💀 AUTO-FARM NEAREST", Color3.fromRGB(80, 0, 0), function()
    -- Teleports behind nearest player and punches
    _G.Farm = not _G.Farm
    task.spawn(function()
        while _G.Farm do
            task.wait()
            pcall(function()
                local target, dist = nil, math.huge
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= lp and v.Character and v.Character.Humanoid.Health > 0 then
                        local d = (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then dist = d; target = v end
                    end
                end
                if target then
                    lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait()
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,false,game,1)
                end
            end)
        end
    end)
end)

-- > TECH SECTION (MOBILE BUTTONS) <
AddButton("🌪️ ADD 'TWISTED' BUTTON", Color3.fromRGB(0, 100, 200), function()
    -- Adds a button to your screen specifically for doing the Tech
    local TechBtn = Instance.new("TextButton", ScreenGui)
    TechBtn.Size = UDim2.new(0, 80, 0, 80)
    TechBtn.Position = UDim2.new(0.8, 0, 0.6, 0)
    TechBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    TechBtn.Text = "TWIST"
    TechBtn.Font = Enum.Font.GothamBlack
    TechBtn.TextColor3 = Color3.new(1,1,1)
    local c = Instance.new("UICorner", TechBtn); c.CornerRadius = UDim.new(1,0)
    TechBtn.Draggable = true
    
    TechBtn.MouseButton1Click:Connect(function()
        -- The logic to snap 90 degrees instantly
        local root = lp.Character.HumanoidRootPart
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(90), 0)
        task.wait(0.05)
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(-90), 0)
    end)
end)

AddButton("💨 NO DASH COOLDOWN", Color3.fromRGB(0, 80, 150), function()
    -- Removes Dash Delay
    local hum = lp.Character:FindFirstChild("Humanoid")
    if hum then
        for _, t in pairs(hum:GetPlayingAnimationTracks()) do
            if t.Animation.AnimationId == "rbxassetid://10479335397" then
                t:AdjustSpeed(100)
            end
        end
    end
end)

-- > LAG & MISC <
AddButton("📉 FPS BOOST (REMOVE DEBRIS)", Color3.fromRGB(0, 150, 0), function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Debris" or v.Name == "Stone" or v.Name == "Grass" then
            v:Destroy()
        end
    end
    game.Lighting.GlobalShadows = false
end)

AddButton("👟 SPEED (50)", Color3.fromRGB(0, 100, 0), function()
    lp.Character.Humanoid.WalkSpeed = 50
end)

AddButton("🛫 FLY (MOBILE TOGGLE)", Color3.fromRGB(0, 120, 0), function()
    -- Simple Velocity Fly for Mobile
    _G.Fly = not _G.Fly
    if _G.Fly then
        local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
        bv.Name = "MobileFly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 50, 0) -- Floats up
        task.spawn(function()
            while _G.Fly do
                task.wait()
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
            end
        end)
    else
        if lp.Character.HumanoidRootPart:FindFirstChild("MobileFly") then
            lp.Character.HumanoidRootPart.MobileFly:Destroy()
        end
    end
end)

-- CLOSE BUTTON
local Close = Instance.new("TextButton", MainFrame)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

print("Vexon Mobile Loaded")
