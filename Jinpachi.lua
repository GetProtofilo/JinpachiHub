local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- // 1. MOBILE BUTTON (Keeping this since it works perfectly for you)
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled then
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local ToggleBtn = Instance.new("ImageButton", ScreenGui)
    local UICorner = Instance.new("UICorner", ToggleBtn)
    
    ToggleBtn.Name = "TSBMobileToggle"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0.9, -60, 0.4, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    ToggleBtn.Image = "rbxassetid://3926307971"
    UICorner.CornerRadius = UDim.new(1, 0)
    
    ToggleBtn.MouseButton1Click:Connect(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end)
end

-- // 2. UI SETUP
local Window = Fluent:CreateWindow({
    Title = "TSB Warlord | 6k Community",
    SubTitle = "by Badal",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Farming = Window:AddTab({ Title = "Farming", Icon = "hammer" }), 
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- // 3. FARMING LOGIC (UPDATED)
-- Scans for Trash Cans, Dumpsters, and Vending Machines
local function GetBreakable()
    local Character = game.Players.LocalPlayer.Character
    if not Character then return nil end
    local MyPos = Character.HumanoidRootPart.Position
    local closest, dist = nil, 9999

    for _, v in pairs(workspace:GetDescendants()) do
        -- Check if it's a model with 'Trash', 'Dumpster', or 'Bench' in the name
        if v:IsA("Model") and (string.find(v.Name, "Trash") or string.find(v.Name, "Dumpster") or string.find(v.Name, "Bench")) then
            local Part = v:FindFirstChild("Part") or v:FindFirstChild("Body") or v:FindFirstChild("MeshPart")
            if Part then
                local mag = (MyPos - Part.Position).Magnitude
                if mag < dist then
                    dist = mag
                    closest = v
                end
            end
        end
    end
    return closest
end

-- // 4. TAB CONTENTS (FIXED: Added Sections to make buttons show up)

-- [ FARMING TAB ]
local FarmSection = Tabs.Farming:AddSection("Object Farming") -- THIS FIXES THE EMPTY TAB

local ToggleTrash = Tabs.Farming:AddToggle("TrashFarm", {Title = "Auto Break Trash/Props", Default = false })

ToggleTrash:OnChanged(function()
    local Farming = Options.TrashFarm.Value
    if Farming then
        Fluent:Notify({Title = "Farming Started", Content = "Scanning for trash cans...", Duration = 3})
    end
    
    task.spawn(function()
        while Options.TrashFarm.Value do
            local Target = GetBreakable()
            if Target then
                local Root = game.Players.LocalPlayer.Character.HumanoidRootPart
                local TargetPart = Target:FindFirstChild("Part") or Target:FindFirstChild("Body") or Target:FindFirstChild("MeshPart")
                
                if Root and TargetPart then
                    -- Teleport to it
                    Root.CFrame = TargetPart.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.1)
                    
                    -- PUNCH
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(900, 500))
                end
            end
            task.wait(0.3) -- Attack speed
        end
    end)
end)

-- [ COMBAT TAB ]
local CombatSection = Tabs.Main:AddSection("PVP Enhancements")

local ToggleLock = Tabs.Main:AddToggle("GodLock", {Title = "God Lock (Aim Assist)", Default = false })
ToggleLock:OnChanged(function()
    task.spawn(function()
        while Options.GodLock.Value do
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local closest, dist = nil, 100
            
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local mag = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if mag < dist then
                        dist = mag
                        closest = v
                    end
                end
            end
            
            if closest then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Character.HumanoidRootPart.Position)
            end
            task.wait()
        end
    end)
end)

local ToggleBlock = Tabs.Main:AddToggle("AutoBlock", {Title = "Auto Block (Predictive)", Default = false })
ToggleBlock:OnChanged(function()
    task.spawn(function()
        while Options.AutoBlock.Value do
            -- Simple logic: if anyone is close (<15 studs), block.
            local danger = false
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                   local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                   if mag < 15 then danger = true end
                end
            end
            
            if danger then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
            else
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end
            task.wait(0.1)
        end
    end)
end)

-- [ VISUALS ]
local VisualsSection = Tabs.Visuals:AddSection("ESP")
local ToggleESP = Tabs.Visuals:AddToggle("ESP", {Title = "Player ESP", Default = false })

ToggleESP:OnChanged(function()
    if Options.ESP.Value then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character then
                local hl = Instance.new("Highlight", v.Character)
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.Name = "ESPHighlight"
            end
        end
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("ESPHighlight") then v.Character.ESPHighlight:Destroy() end
        end
    end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Script Fixed",
    Content = "Tabs are now visible. Good luck, Captain.",
    Duration = 5
})
