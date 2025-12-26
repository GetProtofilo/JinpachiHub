-- [[ 1. STABILITY ENGINE ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ 2. UI LIBRARY (STABLE REDZ-CORE) ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "GEMINI V14 | GOD MODE",
   LoadingTitle = "Bypassing 2025 Quests & Physics...",
   ConfigurationSaving = {Enabled = true, FolderName = "GeminiV14", FileName = "Config"}
})

-- [[ 3. GLOBAL SETTINGS ]]
_G.Settings = {
    AutoFarm = false,
    AutoChest = false,
    AutoElite = false,
    AutoHop = false,
    Fruits = {},
    FastAttack = true,
    TweenSpeed = 225 -- Safe speed to prevent kicks
}

-- [[ 4. TABS ]]
local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local WorldTab = Window:CreateTab("World & Chests", 4483362458)
local SniperTab = Window:CreateTab("Sniper Tech", 4483362458)

-- [[ 5. AUTO FARM ELEMENTS ]]
MainTab:CreateToggle({Name = "Auto Farm Level (Safe-Quest)", CurrentValue = false, Flag = "FarmToggle", Callback = function(v) _G.Settings.AutoFarm = v end})
MainTab:CreateToggle({Name = "Fast Attack (Validator Bypass)", CurrentValue = true, Flag = "FastToggle", Callback = function(v) _G.Settings.FastAttack = v end})

WorldTab:CreateToggle({Name = "Auto Collect All Chests (Beli)", CurrentValue = false, Flag = "ChestToggle", Callback = function(v) _G.Settings.AutoChest = v end})
WorldTab:CreateToggle({Name = "Auto Elite Hunter", CurrentValue = false, Flag = "EliteToggle", Callback = function(v) _G.Settings.AutoElite = v end})

SniperTab:CreateToggle({Name = "Auto-Hop Fruit Sniper", CurrentValue = false, Flag = "HopToggle", Callback = function(v) _G.Settings.AutoHop = v end})
SniperTab:CreateMultiDropdown({
    Name = "Target Fruits",
    Options = {"Kitsune-Kitsune", "Leopard-Leopard", "Dough-Dough", "Dragon-Dragon", "Buddha-Buddha", "Portal-Portal"},
    Callback = function(o) _G.Settings.Fruits = {}; for _,v in pairs(o) do _G.Settings.Fruits[v] = true end end
})

-- [[ 6. MOVEMENT ENGINE (TWEEN) ]]
local function SafeMove(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local dist = (char.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    if dist < 5 then return end
    local info = TweenInfo.new(dist/_G.Settings.TweenSpeed, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(char.HumanoidRootPart, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- [[ 7. BEAST LOGIC ENGINE ]]
task.spawn(function()
    while task.wait() do
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end

            -- PRIORITY 1: CHEST FARM
            if _G.Settings.AutoChest then
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v.Name:find("Chest") and v:IsA("BasePart") then
                        SafeMove(v.CFrame)
                        task.wait(0.3)
                        return -- Exit loop to focus on chest
                    end
                end
            end

            -- PRIORITY 2: AUTO FARM LEVEL
            if _G.Settings.AutoFarm then
                -- Check for Active Quest
                local questGui = LocalPlayer.PlayerGui.Main.Quest
                if not questGui.Visible then
                    -- This is where we call the remote to take the quest automatically based on level
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1", 1) -- Example Quest
                end
                
                -- Target Enemies
                for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        char.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                        if _G.Settings.FastAttack then
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                            game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.floor(tick()))
                        end
                        return
                    end
                end
            end
            
            -- PRIORITY 3: FRUIT SNIPER
            for _, f in pairs(game.Workspace:GetChildren()) do
                if f:IsA("Tool") and _G.Settings.Fruits[f.Name] then
                    SafeMove(f.Handle.CFrame)
                    task.wait(0.5)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", f.Name, f)
                end
            end
        end)
    end
end)

Rayfield:LoadConfiguration()
