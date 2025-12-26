-- [[ 1. STABILITY BOOT ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- [[ 2. STATUS DATA ]]
local StartBeli = LocalPlayer.Data.Beli.Value
local StartLevel = LocalPlayer.Data.Level.Value
local StartTime = tick()

-- [[ 3. UI ENGINE (REDZ-CORE STABLE) ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "GEMINI V13 | BEAST MODE",
   LoadingTitle = "Initializing Persistence & Status Panels...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GeminiV13_Data",
      FileName = "MainConfig"
   }
})

-- [[ 4. GLOBAL SETTINGS ]]
_G.Settings = {
    Webhook = "",
    Fruits = {},
    AutoHop = false,
    AutoElite = false,
    ChestFarm = false,
    AutoFarm = false,
    FastAttack = true
}

-- [[ 5. STATUS PANEL (Visual Beli/Hour) ]]
local StatusTab = Window:CreateTab("Status & Logs", 4483362458)
local BeliLabel = StatusTab:CreateLabel("Beli Earned: 0")
local LevelLabel = StatusTab:CreateLabel("Levels Gained: 0")
local BeliPerHourLabel = StatusTab:CreateLabel("Beli/Hour: 0")

task.spawn(function()
    while task.wait(1) do
        local CurrentBeli = LocalPlayer.Data.Beli.Value
        local CurrentLevel = LocalPlayer.Data.Level.Value
        local Elapsed = tick() - StartTime
        
        local EarnedBeli = CurrentBeli - StartBeli
        local EarnedLevel = CurrentLevel - StartLevel
        local BeliPerHour = math.floor((EarnedBeli / Elapsed) * 3600)
        
        BeliLabel:Set("Beli Earned: " .. tostring(EarnedBeli))
        LevelLabel:Set("Levels Gained: " .. tostring(EarnedLevel))
        BeliPerHourLabel:Set("Beli/Hour: " .. tostring(BeliPerHour))
    end
end)

-- [[ 6. TABS ]]
local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local SniperTab = Window:CreateTab("Sniper Tech", 4483362458)
local WorldTab = Window:CreateTab("World Ops", 4483362458)

-- [[ 7. AUTO FARM ELEMENTS ]]
MainTab:CreateToggle({Name = "Auto Farm (Quest + Kill)", CurrentValue = false, Flag = "FarmToggle", Callback = function(v) _G.Settings.AutoFarm = v end})
MainTab:CreateToggle({Name = "Fast Attack (Validator Bypass)", CurrentValue = true, Flag = "FastToggle", Callback = function(v) _G.Settings.FastAttack = v end})

-- [[ 8. SNIPER TECH ELEMENTS ]]
SniperTab:CreateInput({Name = "Webhook URL", PlaceholderText = "Paste Here", Callback = function(v) _G.Settings.Webhook = v end})
SniperTab:CreateToggle({Name = "Auto-Hop Sniper", CurrentValue = false, Flag = "HopToggle", Callback = function(v) _G.Settings.AutoHop = v end})
SniperTab:CreateMultiDropdown({
    Name = "Select Fruits",
    Options = {"Kitsune-Kitsune", "Leopard-Leopard", "Dough-Dough", "Dragon-Dragon", "Spirit-Spirit", "Buddha-Buddha", "Portal-Portal"},
    Callback = function(o) _G.Settings.Fruits = {}; for _,v in pairs(o) do _G.Settings.Fruits[v] = true end end
})

-- [[ 9. WORLD OPS ]]
WorldTab:CreateToggle({Name = "Auto Elite Hunter", CurrentValue = false, Flag = "EliteToggle", Callback = function(v) _G.Settings.AutoElite = v end})
WorldTab:CreateToggle({Name = "Infinite Chest Farm", CurrentValue = false, Flag = "ChestToggle", Callback = function(v) _G.Settings.ChestFarm = v end})

-- [[ 10. BEAST MODE ENGINES ]]
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.Settings.AutoFarm or _G.Settings.AutoElite then
                local target = nil
                
                -- Auto-Quest for Elite
                if _G.Settings.AutoElite and not LocalPlayer.PlayerGui.Main.Quest.Visible then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
                end

                -- Target Search
                for _, e in pairs(game.Workspace.Enemies:GetChildren()) do
                    if e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                        if _G.Settings.AutoElite and (e.Name == "Deandre" or e.Name == "Diablo" or e.Name == "Urban") then
                            target = e break
                        elseif _G.Settings.AutoFarm then
                            target = e break
                        end
                    end
                end

                if target then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
                    if _G.Settings.FastAttack then
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                        game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.floor(tick()))
                    end
                end
            end
        end)
    end
end)

-- [[ 11. FRUIT & CHEST LOGIC ]]
task.spawn(function()
    while task.wait(2) do
        local busy = false
        for _, c in pairs(game.Workspace:GetChildren()) do
            if c.Name:find("Chest") and _G.Settings.ChestFarm then
                busy = true; LocalPlayer.Character.HumanoidRootPart.CFrame = c.CFrame; task.wait(0.2)
            end
        end
        for _, f in pairs(game.Workspace:GetChildren()) do
            if f:IsA("Tool") and _G.Settings.Fruits[f.Name] then
                busy = true; LocalPlayer.Character.HumanoidRootPart.CFrame = f.Handle.CFrame; task.wait(0.5)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", f.Name, f)
            end
        end
        if _G.Settings.AutoHop and not busy then
            local srv = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, s in pairs(srv.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    break
                end
            end
        end
    end
end)

Rayfield:LoadConfiguration()
