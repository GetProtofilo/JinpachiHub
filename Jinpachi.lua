-- [[ 1. REDZ LIBRARY V5 BOOT ]]
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RedzLibV5/main/Source.Lua"))()

-- [[ 2. WINDOW INITIALIZATION ]]
local Window = redzlib:MakeWindow({
    Title = "Gemini Hub : Blox Fruits",
    SubTitle = "Complete Redz Clone | 2025",
    SaveFolder = "Gemini_Ultra_V18.lua"
})

-- [[ 3. STATE CONTROLLER ]]
_G.Settings = {
    FarmLevel = false, FarmMastery = false, FastAttack = true,
    ChestMagnet = false, EliteHunter = false,
    FruitSniper = false, FruitRain = false,
    AutoStats = false, StatType = "Melee",
    ESP_Players = false, ESP_Fruits = false
}

-- [[ 4. TABS (All Redz Hub Categories) ]]
local MainTab = Window:MakeTab({"Main", "Home"})
local MasteryTab = Window:MakeTab({"Mastery", "Flame"})
local WorldTab = Window:MakeTab({"World", "Globe"})
local FruitTab = Window:MakeTab({"Fruits", "Apple"})
local StatsTab = Window:MakeTab({"Stats", "Plus"})
local VisualTab = Window:MakeTab({"Visuals", "Eye"})

-- [[ 5. MAIN FARMING ]]
MainTab:AddSection({"Level Grinding"})
MainTab:AddToggle({Name = "Auto Farm Level", Default = false, Callback = function(v) _G.Settings.FarmLevel = v end})
MainTab:AddToggle({Name = "Fast Attack (Validator)", Default = true, Callback = function(v) _G.Settings.FastAttack = v end})

-- [[ 6. MASTERY ]]
MasteryTab:AddSection({"Weapon Mastery"})
MasteryTab:AddToggle({Name = "Auto Mastery (Fruit/Sword)", Default = false, Callback = function(v) _G.Settings.FarmMastery = v end})

-- [[ 7. WORLD & CHEST MAGNET ]]
WorldTab:AddSection({"Global Operations"})
WorldTab:AddToggle({Name = "Infinite Chest Magnet", Default = false, Callback = function(v) _G.Settings.ChestMagnet = v end})
WorldTab:AddToggle({Name = "Auto Elite Pirate", Default = false, Callback = function(v) _G.Settings.EliteHunter = v end})

-- [[ 8. FRUIT SNIPER & RAIN ]]
FruitTab:AddSection({"Fruit Utilities"})
FruitTab:AddToggle({Name = "Fruit Sniper (Auto-Store)", Default = false, Callback = function(v) _G.Settings.FruitSniper = v end})
FruitTab:AddButton({"Bring All Fruits", function() 
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") then v.Handle.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame end
    end
end})

-- [[ 9. VISUALS (ESP) ]]
VisualTab:AddSection({"Visual Assistance"})
VisualTab:AddToggle({Name = "Player ESP", Default = false, Callback = function(v) _G.Settings.ESP_Players = v end})
VisualTab:AddToggle({Name = "Fruit ESP", Default = false, Callback = function(v) _G.Settings.ESP_Fruits = v end})

-- [[ 10. THE ENGINE ]]
task.spawn(function()
    while task.wait() do
        pcall(function()
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            
            -- CHEST MAGNET ENGINE
            if _G.Settings.ChestMagnet then
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v.Name:find("Chest") then
                        char.HumanoidRootPart.CFrame = v.CFrame
                        task.wait(0.15)
                    end
                end
            end

            -- LEVEL FARM ENGINE
            if _G.Settings.FarmLevel then
                if not lp.PlayerGui.Main.Quest.Visible then
                    -- Auto-Quest Selector based on Level
                    local lvl = lp.Data.Level.Value
                    local qN, qI = "BanditQuest1", 1
                    if lvl >= 15 then qN, qI = "MonkeyQuest1", 1 end
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", qN, qI)
                end
                for _, e in pairs(game.Workspace.Enemies:GetChildren()) do
                    if e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                        char.HumanoidRootPart.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                        if _G.Settings.FastAttack then
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                            game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.floor(tick()))
                        end
                        break
                    end
                end
            end
        end)
    end
end)

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://124818170296880", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0, 6) }
})
