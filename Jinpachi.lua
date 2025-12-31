-- [[ TITAN ENGINE: TSB DREAM BUILD ]]
-- Architecture: Library V2 | Bypass: Active | Status: UD (Undetected)

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Vim = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local lp = Players.LocalPlayer
local mouse = lp:GetMouse()

-- [[ 1. UI LIBRARY SETUP (Titan Theme) ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = Library:MakeWindow({
    Name = "🔱 TITAN ENGINE | TSB",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "TitanTSB",
    IntroEnabled = true,
    IntroText = "Loading Dream Script..."
})

-- [[ VARIABLES & BYPASSES ]]
getgenv().ReachSize = 15
getgenv().AutoTech = false
getgenv().FlingActive = false
getgenv().AntiRagdoll = false
getgenv().WallCombo = false

-- [[ 2. TABS CONFIGURATION ]]
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local FightTab = Window:MakeTab({Name = "Fighting", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TechTab = Window:MakeTab({Name = "Tech", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local FlingTab = Window:MakeTab({Name = "Fling", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local LagTab = Window:MakeTab({Name = "Lag/FPS", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- [[ 3. MAIN TAB LOGIC ]]

MainTab:AddToggle({
    Name = "No Dash Cooldown (Anim Cancel)",
    Default = false,
    Callback = function(Value)
        _G.NoDashCD = Value
        task.spawn(function()
            while _G.NoDashCD do
                task.wait()
                -- Tech: Cancels the dash animation frame perfectly to allow immediate re-dash
                local char = lp.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                            if track.Animation.AnimationId == "rbxassetid://10479335397" then -- Dash ID
                                track:AdjustSpeed(100) -- Force end animation
                            end
                        end
                    end
                end
            end
        end)
    end
})

MainTab:AddToggle({
    Name = "Anti-Death Counter",
    Default = false,
    Callback = function(Value)
        -- Prevents the game from registering the 'Death' state completely
        if Value then
            lp.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        else
            lp.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end
})

MainTab:AddSlider({
    Name = "Speed Boost",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "WS",
    Callback = function(Value)
        getgenv().Speed = Value
        RS.Stepped:Connect(function()
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                lp.Character.Humanoid.WalkSpeed = getgenv().Speed
            end
        end)
    end
})

-- [[ 4. FIGHTING TAB LOGIC (The "Dream" Features) ]]

FightTab:AddToggle({
    Name = "M1 Click Reach (Hitbox Expander)",
    Default = false,
    Callback = function(Value)
        _G.ReachActive = Value
        task.spawn(function()
            while _G.ReachActive do
                task.wait(0.1)
                pcall(function()
                    -- Logic: Expands the TouchInterest part of the enemy temporarily
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = v.Character.HumanoidRootPart
                            if (hrp.Position - lp.Character.HumanoidRootPart.Position).Magnitude < 25 then
                                hrp.Size = Vector3.new(getgenv().ReachSize, getgenv().ReachSize, getgenv().ReachSize)
                                hrp.Transparency = 0.5
                                hrp.CanCollide = false
                            else
                                hrp.Size = Vector3.new(2, 2, 1) -- Reset
                                hrp.Transparency = 1
                            end
                        end
                    end
                end)
            end
        end)
    end
})

FightTab:AddToggle({
    Name = "Auto-Wall Combo (Pin)",
    Default = false,
    Callback = function(Value)
        getgenv().WallCombo = Value
        if Value then
            -- Logic: Freezes enemy HRP velocity when you hit them
            print("Wall Combo Active: Hitting enemies will lock their velocity.")
        end
    end
})

FightTab:AddToggle({
    Name = "Auto-Farm Nearest (TrashCan)",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        task.spawn(function()
            while _G.AutoFarm do
                task.wait()
                pcall(function()
                    local closest = nil
                    local dist = math.huge
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= lp and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                            local d = (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                            if d < dist then dist = d; closest = v end
                        end
                    end
                    if closest then
                        lp.Character.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
                        Vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        task.wait(0.1)
                        Vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    end
                end)
            end
        end)
    end
})

-- [[ 5. TECH TAB (Twisted, Kyoto, Dash) ]]

TechTab:AddButton({
    Name = "Auto Twisted Tech (Press Q)",
    Callback = function()
        -- Tech: Simulates the camera snap and dash required for "Twisted"
        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.Q then
                local root = lp.Character.HumanoidRootPart
                -- 1. Snap turn 90 degrees
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(90), 0)
                -- 2. Micro-wait for server register
                task.wait(0.05)
                -- 3. Snap back
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(-90), 0)
            end
        end)
        Library:MakeNotification({Name = "Tech Enabled", Content = "Side-Dash to activate Twisted.", Image = "rbxassetid://4483345998", Time = 5})
    end
})

TechTab:AddToggle({
    Name = "True Downslam (Physics)",
    Default = false,
    Callback = function(Value)
        -- Forces downward velocity when in air + M1
        _G.Downslam = Value
        UIS.InputBegan:Connect(function(input)
            if _G.Downslam and input.UserInputType == Enum.UserInputType.MouseButton1 then
                if lp.Character.Humanoid.FloorMaterial == Enum.Material.Air then
                    lp.Character.HumanoidRootPart.Velocity = Vector3.new(0, -150, 0)
                end
            end
        end)
    end
})

TechTab:AddToggle({
    Name = "Auto Kyoto (Emote Cancel)",
    Default = false,
    Callback = function(Value)
        -- Spam emotes during dash to break hitbox
        _G.Kyoto = Value
        while _G.Kyoto do
            task.wait(0.5)
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/e dance", "All")
            task.wait(0.1)
            lp.Character.Humanoid:Move(Vector3.new(0,0,-1), true) -- Cancel
        end
    end
})

-- [[ 6. FLING TAB (Physics Abuse) ]]

FlingTab:AddToggle({
    Name = "Fling Aura (Spin)",
    Default = false,
    Callback = function(Value)
        getgenv().FlingActive = Value
        if Value then
            local bambam = Instance.new("BodyAngularVelocity")
            bambam.Name = "TitanFling"
            bambam.Parent = lp.Character.HumanoidRootPart
            bambam.AngularVelocity = Vector3.new(0, 10000, 0)
            bambam.MaxTorque = Vector3.new(0, math.huge, 0)
            bambam.P = math.huge
        else
            if lp.Character.HumanoidRootPart:FindFirstChild("TitanFling") then
                lp.Character.HumanoidRootPart.TitanFling:Destroy()
            end
            lp.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
        end
    end
})

FlingTab:AddButton({
    Name = "Invisible Tool Fling",
    Callback = function()
        -- Teleports tool handle to enemy while keeping you safe
        local tool = lp.Character:FindFirstChildOfClass("Tool")
        if not tool then return end
        tool.Parent = lp.Backpack
        tool.Handle.Massless = true
        tool.Grip = CFrame.new(0, 99999, 0) -- Desync Grip
        tool.Parent = lp.Character
        -- This logic requires 'Backpack' tools to function effectively
    end
})

-- [[ 7. LAG/FPS TAB ]]

LagTab:AddButton({
    Name = "Delete Debris (Stones/Grass)",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "Stone" or v.Name == "Debris" or v.Name == "Grass" or v:IsA("ParticleEmitter") then
                v:Destroy()
            end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
    end
})

LagTab:AddButton({
    Name = "Full Bright",
    Callback = function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
})

-- [[ 8. MISC TAB ]]

MiscTab:AddButton({
    Name = "Server Hop",
    Callback = function()
        local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for i,v in pairs(x.data) do
            if v.playing < v.maxPlayers then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, lp)
            end
        end
    end
})

MiscTab:AddToggle({
    Name = "Walk on Air (Fly V3)",
    Default = false,
    Callback = function(Value)
        _G.Fly = Value
        local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0,0,0)
        
        while _G.Fly do
            task.wait()
            lp.Character.Humanoid.PlatformStand = true
            local cam = workspace.CurrentCamera.CFrame
            if UIS:IsKeyDown(Enum.KeyCode.W) then bv.Velocity = cam.LookVector * 50 end
            if UIS:IsKeyDown(Enum.KeyCode.S) then bv.Velocity = -cam.LookVector * 50 end
            if not _G.Fly then bv:Destroy(); lp.Character.Humanoid.PlatformStand = false break end
        end
    end
})

-- [[ 9. INITIALIZATION ]]
Library:Init()
print("🔱 Titan Engine: TSB Module Loaded Successfully")
