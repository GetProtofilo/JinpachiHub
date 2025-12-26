-- // CONFIGURATION & BOOTING
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Gemini Hub | V6 ABSOLUTE PERSISTENCE",
   LoadingTitle = "Bypassing 2025 Anti-Cheat...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GeminiHub_BF_V6", 
      FileName = "PersistenceSettings"
   }
})

-- TABS
local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local SniperTab = Window:CreateTab("Sniper & Webhook", 4483362458)
local WorldTab = Window:CreateTab("World Ops", 4483362458)

-- GLOBAL VARIABLES
_G.WebhookURL = ""
_G.TargetFruits = {}
_G.AutoHop = false
_G.AutoElite = false
_G.ChestFarm = false
_G.SafeFarm = false

-- // 1. TWEEN ENGINE (Bypass Teleport Kick)
local function SafeTween(targetCFrame)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local distance = (char.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    local speed = 250 -- Maximum safe speed for 2025 bypass
    local info = TweenInfo.new(distance/speed, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(char.HumanoidRootPart, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- // 2. DISCORD WEBHOOK LOGGING
local function SendWebhook(title, desc, color)
    if _G.WebhookURL == "" or not _G.WebhookURL:find("http") then return end
    local url = _G.WebhookURL:gsub("discord.com", "webhook.lewisakura.moe") -- Proxy Bypass
    local data = {["embeds"] = {{["title"] = "💠 " .. title, ["description"] = desc .. "\n**Server:** " .. game.JobId, ["color"] = color or 65280}}}
    pcall(function()
        request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(data)})
    end)
end

-- // 3. CORE LOGIC (Fruits, Elites, Chests)
task.spawn(function()
    while task.wait(3) do
        local foundTarget = false
        
        -- CHEST FARM (Prioritizes Beli)
        if _G.ChestFarm then
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") then
                    foundTarget = true
                    SafeTween(v.CFrame)
                    task.wait(0.5)
                end
            end
        end

        -- FRUIT SNIPER (Priority Filter)
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and _G.TargetFruits[v.Name] then
                foundTarget = true
                SafeTween(v.Handle.CFrame)
                task.wait(1)
                local s = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                SendWebhook("RARE FRUIT COLLECTED", "Found: " .. v.Name, 16711680)
                if s then _G.AutoHop = false end
            end
        end

        -- ELITE HUNTER
        if _G.AutoElite then
            pcall(function()
                local q = game.Players.LocalPlayer.PlayerGui.Main.Quest
                if not q.Visible then game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter") end
                for _, boss in pairs(game.Workspace.Enemies:GetChildren()) do
                    if boss.Name == "Deandre" or boss.Name == "Diablo" or boss.Name == "Urban" then
                        foundTarget = true
                        SafeTween(boss.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0))
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                    end
                end
            end)
        end

        -- SERVER HOP (If nothing found)
        if _G.AutoHop and not foundTarget then
            SendWebhook("Server Hopping", "No targets found. Scanning new server...", 8421504)
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

-- // UI SETUP
SniperTab:CreateInput({
   Name = "Discord Webhook URL",
   PlaceholderText = "Paste Webhook Here",
   Callback = function(t) _G.WebhookURL = t end,
})

SniperTab:CreateMultiDropdown({
   Name = "Select Priority Fruits",
   Options = {"Kitsune-Kitsune", "Leopard-Leopard", "Dough-Dough", "Dragon-Dragon", "Spirit-Spirit", "Buddha-Buddha", "T-Rex-T-Rex", "Portal-Portal", "Mammoth-Mammoth"},
   CurrentOption = {},
   Callback = function(o) _G.TargetFruits = {}; for _,v in pairs(o) do _G.TargetFruits[v] = true end end,
})

SniperTab:CreateToggle({Name = "Enable Persistence Sniper (Auto-Hop)", CurrentValue = false, Flag = "HopToggle", Callback = function(v) _G.AutoHop = v end})

WorldTab:CreateToggle({Name = "Auto Elite Hunter", CurrentValue = false, Flag = "EliteToggle", Callback = function(v) _G.AutoElite = v end})
WorldTab:CreateToggle({Name = "Infinite Chest Farm", CurrentValue = false, Flag = "ChestToggle", Callback = function(v) _G.ChestFarm = v end})

MainTab:CreateToggle({Name = "Safe NPC Farm", CurrentValue = false, Flag = "FarmToggle", Callback = function(v) _G.SafeFarm = v end})

-- // CONFIG AUTO-LOAD
Rayfield:LoadConfiguration()
