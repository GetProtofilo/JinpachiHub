-- // WESTBOUND WARLORD: GOD MODE EDITION // --
-- // Library: Fluent (Premium) // --

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- // 1. MOBILE OPTIMIZATION (Floating Toggle Button) // --
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled then
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local ToggleBtn = Instance.new("ImageButton", ScreenGui)
    local UICorner = Instance.new("UICorner", ToggleBtn)
    
    ToggleBtn.Name = "WestboundMobileToggle"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0.9, -60, 0.4, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ToggleBtn.Image = "rbxassetid://3926307971" -- Gear Icon
    ToggleBtn.ImageRectOffset = Vector2.new(324, 124)
    ToggleBtn.ImageRectSize = Vector2.new(36, 36)
    UICorner.CornerRadius = UDim.new(1, 0)
    
    ToggleBtn.MouseButton1Click:Connect(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end)
    
    -- Draggable Logic
    local dragging, dragInput, dragStart, startPos
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ToggleBtn.Position
        end
    end)
    ToggleBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- // 2. UI CONSTRUCTION // --
local Window = Fluent:CreateWindow({
    Title = "Westbound Warlord | 6k Corp",
    SubTitle = "by Badal",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- Disabled for stability on mobile
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "dollar-sign" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Dev = Window:AddTab({ Title = "Dev Tools", Icon = "code" }), -- Added for finding remotes
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options
local Farming = false
local SilentAim = false
local SpyEnabled = false

-- // 3. CORE LOGIC FUNCTIONS // --

-- [AGGRESSIVE SCANNER] - Finds ANYTHING with "tumble" in the name
local function GetTumbleweed()
    local Character = game.Players.LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return nil end
    local MyPos = Character.HumanoidRootPart.Position
    
    local closest, dist = nil, math.huge
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and string.find(string.lower(v.Name), "tumble") then
            local Root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Part") or v:FindFirstChild("Main")
            if Root then
                local mag = (MyPos - Root.Position).Magnitude
                if mag < dist then
                    dist = mag
                    closest = v
                end
            end
        end
    end
    return closest
end

-- [SAFE TWEEN] - Prevents Kicking/Banning
local function SafeTween(targetPos)
    local Character = game.Players.LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Root = Character.HumanoidRootPart
    local Distance = (Root.Position - targetPos).Magnitude
    
    -- Speed Calculation: 60 studs/sec is safe. 200+ gets you kicked.
    local Speed = 60 
    local Time = Distance / Speed
    
    local TweenService = game:GetService("TweenService")
    local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
    local Tween = TweenService:Create(Root, Info, {CFrame = CFrame.new(targetPos)})
    
    -- Noclip (Don't die hitting walls)
    local connection
    connection = game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
    
    Tween:Play()
    Tween.Completed:Wait()
    connection:Disconnect()
end

-- // 4. FEATURE TABS // --

-- [ MAIN FARM ]
local ToggleFarm = Tabs.Main:AddToggle("AutoFarm", {Title = "Auto Farm Tumbleweed (God Mode)", Default = false })

ToggleFarm:OnChanged(function()
    Farming = Options.AutoFarm.Value
    task.spawn(function()
        while Farming do
            local Weed = GetTumbleweed()
            
            if Weed then
                Fluent:Notify({Title = "Target Acquired", Content = "Moving to: " .. Weed.Name, Duration = 2})
                
                -- 1. Move to it
                local TargetPart = Weed:FindFirstChild("HumanoidRootPart") or Weed:FindFirstChild("Part")
                if TargetPart then
                    SafeTween(TargetPart.Position)
                end
                
                -- 2. Interact (Try Universal ProximityPrompt First)
                local Prompt = Weed:FindFirstChildWhichIsA("ProximityPrompt", true)
                if Prompt then
                    fireproximityprompt(Prompt)
                else
                    -- Fallback: If no prompt, try the standard remote path
                    local args = {
                        [1] = "Tumbleweed",
                        [2] = Weed
                    }
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("GeneralEvents"):WaitForChild("Rob"):FireServer(unpack(args))
                    end)
                end
                task.wait(1)
            else
                Fluent:Notify({Title = "Scanning", Content = "No Tumbleweeds found. Retrying...", Duration = 1.5})
                
                -- AUTO SPAWN (If you find the remote name using Dev Tools, uncomment below)
                -- game:GetService("ReplicatedStorage").YOUR_REMOTE_HERE:FireServer()
                
                task.wait(2)
            end
            
            if not Farming then break end
        end
    end)
end)

-- [ COMBAT ]
local ToggleAim = Tabs.Combat:AddToggle("SilentAim", {Title = "Silent Aim (Headshot)", Default = false })
ToggleAim:OnChanged(function() SilentAim = Options.SilentAim.Value end)

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if SilentAim and method == "FireServer" and tostring(self) == "FireBullet" then -- Check "Dev Tools" for real name
        -- Auto-Target Closest Player Logic would go here
        -- This requires finding the specific gun remote structure
    end
    
    if SpyEnabled and method == "FireServer" then
        print("REMOTE FIRED: " .. tostring(self))
        for i,v in pairs(args) do print("ARG["..i.."]: ", v) end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [ DEV TOOLS - REMOTE SPY ]
Tabs.Dev:AddParagraph("Remote Spy", "Turn this on, then manually spawn a tumbleweed or shoot. Press F9 (Console) to see the remote name.")
local ToggleSpy = Tabs.Dev:AddToggle("SpyMode", {Title = "Enable Remote Spy", Default = false })
ToggleSpy:OnChanged(function() SpyEnabled = Options.SpyMode.Value end)

-- [ VISUALS ]
local ToggleESP = Tabs.Visuals:AddToggle("ESP", {Title = "Player ESP", Default = false })
ToggleESP:OnChanged(function()
    if Options.ESP.Value then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character then
                local hl = Instance.new("Highlight")
                hl.Parent = v.Character
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.Name = "ESPHighlight"
            end
        end
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("ESPHighlight") then
                v.Character.ESPHighlight:Destroy()
            end
        end
    end
end)

-- // FINISH // --
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Westbound Warlord Active",
    Content = "Script loaded successfully.",
    Duration = 5
})
