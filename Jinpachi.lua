-- [[ 1. BOOTSTRAP & INITIALIZATION ]]
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ 2. CONFIGURATION ENGINE ]]
local Window = Rayfield:CreateWindow({
   Name = "Gemini Hub | V7 GOD EDITION",
   LoadingTitle = "Bypassing Anti-Cheat [2025]...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GeminiV7_Configs", 
      FileName = "MainSettings"
   }
})

-- [[ 3. GLOBAL STATE ]]
_G.WebhookURL = ""
_G.TargetFruits = {}
_G.AutoHop = false
_G.AutoElite = false
_G.ChestFarm = false
_G.AutoFarm = false
_G.TweenSpeed = 250

-- [[ 4. UTILITY FUNCTIONS ]]

-- WEBHOOK PROXY (Ensures Discord receives messages)
local function NotifyDiscord(title, desc, color)
    if _G.WebhookURL == "" or not _G.WebhookURL:find("http") then return end
    local url = _G.WebhookURL:gsub("discord.com", "webhook.lewisakura.moe")
    local data = {
        ["embeds"] = {{
            ["title"] = "💠 " .. title,
            ["description"] = desc .. "\n**Server:** " .. game.JobId,
            ["color"] = color or 65280,
            ["footer"] = {["text"] = "Gemini Hub V7"}
        }}
    }
    pcall(function()
        request({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)
end

-- TWEEN ENGINE (Anti-Kick Movement)
local function SafeTween(targetCFrame)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local dist = (char.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    local info = TweenInfo.new(dist/_G.TweenSpeed, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(char.HumanoidRootPart, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- [[ 5. CREATING TABS ]]
local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local SniperTab = Window:CreateTab("Sniper Tech", 4483362458)
local WorldTab = Window:CreateTab("World Ops", 4483362458)

-- [[ 6. SNIPER TAB ELEMENTS ]]
SniperTab:CreateSection("Webhook Settings")

SniperTab:CreateInput({
   Name = "Discord Webhook URL",
   PlaceholderText = "Paste Here...",
   Callback = function(t) _G.WebhookURL = t end,
})

SniperTab:CreateSection("Fruit Selection")

SniperTab:CreateMultiDropdown({
   Name = "Target Fruits",
   Options = {"Kitsune-Kitsune", "Leopard-Leopard", "Dough-Dough", "Dragon-Dragon", "Spirit-Spirit", "Buddha-Buddha", "T-Rex-T-Rex", "Portal-Portal", "Mammoth-Mammoth"},
   CurrentOption = {},
   Callback = function(o) 
       _G.TargetFruits = {}
       for _,v in pairs(o) do _G.TargetFruits[v] = true end 
   end,
})

SniperTab:CreateToggle({
   Name = "Enable Server-Hop Sniper",
   CurrentValue = false,
   Flag = "HopFlag",
   Callback = function(v) _G.AutoHop = v end
})

-- [[ 7. WORLD OPS ELEMENTS ]]
WorldTab:CreateSection("Elite Hunting")

WorldTab:CreateToggle({
   Name = "Auto Elite Hunter",
   CurrentValue = false,
   Flag = "EliteFlag",
   Callback = function(v) _G.AutoElite = v end
})

WorldTab:CreateSection("Economy")

WorldTab:CreateToggle({
   Name = "Infinite Chest Farm",
   CurrentValue = false,
   Flag = "ChestFlag",
   Callback = function(v) _G.ChestFarm = v end
})

-- [[ 8. AUTO FARM ELEMENTS ]]
MainTab:CreateSection("Grinding")

MainTab:CreateToggle({
   Name = "Safe NPC Farm (Above NPC)",
   CurrentValue = false,
   Flag = "FarmFlag",
   Callback = function(v) _G.AutoFarm = v end
})

MainTab:CreateSlider({
   Name = "Movement Speed",
   Min = 100,
   Max = 350,
   CurrentValue = 250,
   Flag = "SpeedFlag",
   Callback = function(Value) _G.TweenSpeed = Value end,
})

-- [[ 9. CORE LOGIC ENGINES ]]

-- LOOP 1: Movement & Collection (Fruit, Chest, Elite)
task.spawn(function()
    while task.wait(3) do
        local targetFound = false
        
        -- CHEST LOGIC
        if _G.ChestFarm then
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") then
                    targetFound = true
                    SafeTween(v.CFrame)
                    task.wait(0.5)
                end
            end
        end

        -- FRUIT LOGIC
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and _G.TargetFruits[v.Name] then
                targetFound = true
                SafeTween(v.Handle.CFrame)
                task.wait(1)
                local s = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                SendWebhook("FRUIT SECURED", "Stored: " .. v.Name)
                if s then _G.AutoHop = false end
            end
        end

        -- SERVER HOP LOGIC
        if _G.AutoHop and not targetFound then
            local srv = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, s in pairs(srv.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, game.Players.LocalPlayer)
                    break
                end
            end
        end
    end
end)

-- LOOP 2: NPC Combat
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm or _G.AutoElite then
            pcall(function()
                -- Auto Quest Logic for Elite
                if _G.AutoElite then
                    local q = game.Players.LocalPlayer.PlayerGui.Main.Quest
                    if not q.Visible then game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter") end
                end

                for _, boss in pairs(game.Workspace.Enemies:GetChildren()) do
                    if (boss.Name == "Deandre" or boss.Name == "Diablo" or boss.Name == "Urban" or _G.AutoFarm) and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                        break
                    end
                end
            end)
        end
    end
end)

-- [[ 10. AUTO-LOAD CONFIGS ]]
Rayfield:LoadConfiguration()
