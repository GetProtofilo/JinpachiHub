-- // THE STRONGEST BATTLEGROUNDS: WARLORD EDITION // --
-- // Developed for 6k Community by Badal // --

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- // 1. MOBILE OPTIMIZATION (Floating Button) // --
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled then
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local ToggleBtn = Instance.new("ImageButton", ScreenGui)
    local UICorner = Instance.new("UICorner", ToggleBtn)
    
    ToggleBtn.Name = "TSBMobileToggle"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0.9, -60, 0.4, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Red for Combat
    ToggleBtn.Image = "rbxassetid://3926307971"
    UICorner.CornerRadius = UDim.new(1, 0)
    
    ToggleBtn.MouseButton1Click:Connect(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end)
    
    -- Draggable
    local dragging, dragInput, dragStart, startPos
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = ToggleBtn.Position
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

-- // 2. UI SETUP // --
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
    Main = Window:AddTab({ Title = "Combat (God)", Icon = "swords" }),
    Farming = Window:AddTab({ Title = "Farming", Icon = "hammer" }), 
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- // VARIABLES // --
local GodLock = false
local AutoBlock = false
local TrashFarm = false
local SelectedPlayer = nil

-- // 3. COMBAT LOGIC // --

-- [ GOD LOCK ]
local function GetClosestPlayer()
    local closest, dist = nil, 200 -- Max range 200
    local Mouse = LocalPlayer:GetMouse()
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                closest = v
            end
        end
    end
    return closest
end

local ToggleLock = Tabs.Main:AddToggle("GodLock", {Title = "God Lock (Aim Assist)", Default = false })
ToggleLock:OnChanged(function()
    GodLock = Options.GodLock.Value
    RunService.RenderStepped:Connect(function()
        if GodLock then
            local Target = GetClosestPlayer()
            if Target and Target.Character then
                -- Lock Camera to Target
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, Target.Character.HumanoidRootPart.Position)
            end
        end
    end)
end)

-- [ AUTO BLOCK ]
local ToggleBlock = Tabs.Main:AddToggle("AutoBlock", {Title = "Auto Block (Predictive)", Default = false })
ToggleBlock:OnChanged(function()
    AutoBlock = Options.AutoBlock.Value
    task.spawn(function()
        while AutoBlock do
            local Target = GetClosestPlayer()
            if Target and Target.Character then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - Target.Character.HumanoidRootPart.Position).Magnitude
                
                -- Logic: If enemy is close (within 15 studs), hold block
                if dist < 15 then
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendKeyEvent(true, Enum.KeyCode.F, false, game) -- Hold F
                else
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendKeyEvent(false, Enum.KeyCode.F, false, game) -- Release F
                end
            end
            task.wait(0.1)
            if not AutoBlock then 
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                break 
            end
        end
    end)
end)

-- [ FLASH STEP ]
Tabs.Main:AddParagraph("Flash Step", "Press 'Z' to teleport behind the closest enemy.")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Z then
        local Target = GetClosestPlayer()
        if Target and Target.Character and LocalPlayer.Character then
            local BehindCFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4) -- 4 studs behind
            LocalPlayer.Character.HumanoidRootPart.CFrame = BehindCFrame
        end
    end
end)

-- // 4. FARMING LOGIC // --

-- [ TRASH CAN FARM ]
local function GetTrashCan()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (string.find(v.Name, "Trash") or string.find(v.Name, "Dumpster")) then
            if v:FindFirstChild("Part") or v:FindFirstChild("Meshes/Trash Can") then
                return v
            end
        end
    end
    return nil
end

local ToggleTrash = Tabs.Farming:AddToggle("TrashFarm", {Title = "Trash Can Farm", Default = false })
ToggleTrash:OnChanged(function()
    TrashFarm = Options.TrashFarm.Value
    task.spawn(function()
        while TrashFarm do
            local Trash = GetTrashCan()
            if Trash then
                local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local TrashPart = Trash:FindFirstChild("Part") or Trash:FindFirstChildWhichIsA("BasePart", true)
                
                if Root and TrashPart then
                    -- Teleport to Trash
                    Root.CFrame = TrashPart.CFrame * CFrame.new(0, 2, 0)
                    
                    -- Auto Punch
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(900, 500))
                    
                    Fluent:Notify({Title = "Farming", Content = "Breaking: " .. Trash.Name, Duration = 0.5})
                end
            end
            task.wait(0.5)
            if not TrashFarm then break end
        end
    end)
end)

-- // 5. VISUALS // --
local ToggleESP = Tabs.Visuals:AddToggle("ESP", {Title = "Player ESP", Default = false })
ToggleESP:OnChanged(function()
    if Options.ESP.Value then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local hl = Instance.new("Highlight")
                hl.Parent = v.Character
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Name = "ESPHighlight"
            end
        end
    else
        for _, v in pairs(Players:GetPlayers()) do
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
    Title = "TSB Warlord Loaded",
    Content = "Welcome back, Captain.",
    Duration = 5
})
