local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- // 1. OMNI-SCANNER LOGIC (Finds "Actions" not "Names")
local function GetNearestPrompt()
    local Character = game.Players.LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local MyPos = Character.HumanoidRootPart.Position
    local closest, dist = nil, math.huge
    
    -- Scan EVERY prompt in the game
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            -- Check if the prompt is active and has relevant text
            local text = string.lower(prompt.ActionText)
            if string.find(text, "search") or string.find(text, "rob") or string.find(text, "pick") then
                local part = prompt.Parent
                if part and part:IsA("BasePart") then
                    local mag = (MyPos - part.Position).Magnitude
                    if mag < dist then
                        dist = mag
                        closest = prompt
                    end
                end
            end
        end
    end
    return closest
end

-- // 2. UI SETUP
local Window = Fluent:CreateWindow({
    Title = "Westbound Omni-Hunter | 6k Corp",
    SubTitle = "by Badal",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "dollar-sign" }),
    Dev = Window:AddTab({ Title = "Spy (On-Screen)", Icon = "code" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options
local Farming = false
local SpyEnabled = false

-- // 3. AUTO FARM TAB
local ToggleFarm = Tabs.Main:AddToggle("AutoFarm", {Title = "Auto Farm (Universal)", Default = false })

ToggleFarm:OnChanged(function()
    Farming = Options.AutoFarm.Value
    task.spawn(function()
        while Farming do
            local Prompt = GetNearestPrompt()
            
            if Prompt then
                local TargetPart = Prompt.Parent
                Fluent:Notify({Title = "Target Found", Content = "Action: " .. Prompt.ActionText, Duration = 2})
                
                -- Move to Target
                local Character = game.Players.LocalPlayer.Character
                if Character and Character:FindFirstChild("HumanoidRootPart") then
                    -- Teleport slightly above to avoid sticking
                    Character.HumanoidRootPart.CFrame = TargetPart.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.2)
                    
                    -- FIRE THE PROMPT
                    fireproximityprompt(Prompt)
                    task.wait(1) -- Wait for animation
                end
            else
                Fluent:Notify({Title = "Scanning", Content = "No 'Search' prompts found. Waiting...", Duration = 2})
                task.wait(3)
            end
            
            if not Farming then break end
        end
    end)
end)

-- // 4. ON-SCREEN REMOTE SPY TAB (No F9 needed)
-- Create a simple log window inside the UI
local SpyLog = ""
local SpyOutput = Tabs.Dev:AddParagraph({
    Title = "Remote Log",
    Content = "Logs will appear here..."
})

local ToggleSpy = Tabs.Dev:AddToggle("SpyMode", {Title = "Enable Remote Spy", Default = false })

ToggleSpy:OnChanged(function()
    SpyEnabled = Options.SpyMode.Value
    if SpyEnabled then
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if SpyEnabled and (method == "FireServer" or method == "InvokeServer") then
                -- Add to log string
                local logLine = "\n[REMOTE]: " .. tostring(self)
                SpyLog = logLine .. SpyLog -- Newest on top
                
                -- Update UI (Limit to last 500 chars to prevent lag)
                SpyOutput:SetDesc(string.sub(SpyLog, 1, 500))
            end
            
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

-- // FINISH
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

-- Mobile Button for convenience
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled then
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local ToggleBtn = Instance.new("ImageButton", ScreenGui)
    local UICorner = Instance.new("UICorner", ToggleBtn)
    
    ToggleBtn.Name = "WestboundMobileToggle"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0.9, -60, 0.4, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ToggleBtn.Image = "rbxassetid://3926307971"
    UICorner.CornerRadius = UDim.new(1, 0)
    
    ToggleBtn.MouseButton1Click:Connect(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end)
end
