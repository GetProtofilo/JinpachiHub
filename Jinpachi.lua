-- // WESTBOUND WARLORD PREMIUM // --
-- // UI Library: Fluent (Best Available) // --
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- // Mobile Button Logic (So you can open/close on phone) // --
if game:GetService("UserInputService").TouchEnabled then
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local Button = Instance.new("ImageButton", ScreenGui)
    local UICorner = Instance.new("UICorner", Button)
    
    Button.Name = "ToggleUI"
    Button.Size = UDim2.new(0, 50, 0, 50)
    Button.Position = UDim2.new(0.9, -60, 0.5, 0)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Image = "rbxassetid://3926307971" -- Settings Icon
    Button.ImageRectOffset = Vector2.new(324, 124)
    Button.ImageRectSize = Vector2.new(36, 36)
    UICorner.CornerRadius = UDim.new(1, 0)
    
    Button.MouseButton1Click:Connect(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end)
    
    -- Draggable
    local dragging, dragInput, dragStart, startPos
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Button.Position
        end
    end)
    Button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local Window = Fluent:CreateWindow({
    Title = "Westbound Warlord | 6k Community",
    SubTitle = "by Badal",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- Disabled for Mobile Performance
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "dollar-sign" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- // LOGIC VARIABLES // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Options = Fluent.Options
local Farming = false
local SilentAim = false

-- // FUNCTIONS // --

local function GetClosestTumbleweed()
    local closest, dist = nil, 99999
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "Tumbleweed" and v:FindFirstChild("HumanoidRootPart") then -- Adjust name if needed
            local mag = (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                closest = v
                dist = mag
            end
        end
    end
    return closest
end

local function TweenTo(targetCFrame)
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Root = Character.HumanoidRootPart
    local Distance = (Root.Position - targetCFrame.Position).Magnitude
    local Speed = 80 -- Safe speed to prevent kicking
    local Time = Distance / Speed
    
    local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
    local Tween = TweenService:Create(Root, Info, {CFrame = targetCFrame})
    
    -- NoClip to prevent death by hitting walls
    local NoClipLoop
    NoClipLoop = RunService.Stepped:Connect(function()
        if not Tween.PlaybackState == Enum.PlaybackState.Playing then 
            NoClipLoop:Disconnect() 
        end
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
    
    Tween:Play()
    Tween.Completed:Wait()
    if NoClipLoop then NoClipLoop:Disconnect() end
end

-- // TABS SETUP // --

-- [ AUTO FARM ]
local ToggleFarm = Tabs.Main:AddToggle("AutoTumble", {Title = "Auto Farm Tumbleweed (Safe)", Default = false })

ToggleFarm:OnChanged(function()
    Farming = Options.AutoTumble.Value
    task.spawn(function()
        while Farming do
            local Weed = GetClosestTumbleweed()
            if Weed and Weed:FindFirstChild("HumanoidRootPart") then
                Fluent:Notify({Title = "Farming", Content = "Found Tumbleweed! Tweening...", Duration = 2})
                TweenTo(Weed.HumanoidRootPart.CFrame)
                
                -- Attempt to Interact (Try ProximityPrompt first, then Remote)
                if Weed:FindFirstChildWhichIsA("ProximityPrompt", true) then
                    fireproximityprompt(Weed:FindFirstChildWhichIsA("ProximityPrompt", true))
                else
                    -- Fallback: Use the specific remote if prompt fails
                    -- game.ReplicatedStorage.GeneralEvents.Rob:FireServer("Tumbleweed", Weed) 
                end
                task.wait(1.5)
            else
                Fluent:Notify({Title = "Searching", Content = "No Tumbleweeds found. Waiting...", Duration = 2})
                task.wait(3)
            end
            if not Farming then break end
        end
    end)
end)

-- [ COMBAT ]
local ToggleAim = Tabs.Combat:AddToggle("SilentAim", {Title = "Silent Aim (Head)", Default = false })

ToggleAim:OnChanged(function()
    SilentAim = Options.SilentAim.Value
end)

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" and SilentAim and tostring(self) == "RemoteNameHere" then -- REPLACE 'RemoteNameHere' with gun remote name
        -- Find Closest Player logic here
        -- args[1] = ClosestPlayerHead
        -- return self.FireServer(self, unpack(args))
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [ VISUALS ]
local ToggleESP = Tabs.Visuals:AddToggle("ESP", {Title = "Player ESP", Default = false })

ToggleESP:OnChanged(function()
    if Options.ESP.Value then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local hl = Instance.new("Highlight")
                hl.Parent = v.Character
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    else
        -- Clear Highlights
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Highlight") then
                v.Character.Highlight:Destroy()
            end
        end
    end
end)

-- [ SETTINGS ]
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Westbound Warlord Loaded",
    Content = "Welcome back, Captain.",
    Duration = 5
})
