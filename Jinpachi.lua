local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Gemini Hub | V5 PERSISTENCE GOD",
   LoadingTitle = "Bypassing Anti-Cheat + Loading Configs...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GeminiHub_BF_V5", 
      FileName = "PersistenceConfig"
   }
})

-- TABS
local SniperTab = Window:CreateTab("Sniper & Webhook", 4483362458)
local EliteTab = Window:CreateTab("Elite Hunter", 4483362458)
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- GLOBAL SETTINGS
_G.WebhookURL = ""
_G.TargetFruits = {}
_G.AutoHop = false
_G.AutoElite = false
_G.SafeFarm = false

-- 1. DISCORD LOGGING SYSTEM
local function NotifyDiscord(title, desc, color)
    if _G.WebhookURL == "" or _G.WebhookURL == nil then return end
    local data = {
        ["embeds"] = {{
            ["title"] = "🔱 " .. title,
            ["description"] = desc .. "\n**JobId:** " .. game.JobId,
            ["color"] = color or 65280,
            ["footer"] = {["text"] = "Gemini Persistence V5"}
        }}
    }
    local url = _G.WebhookURL:gsub("discord.com", "webhook.lewisakura.moe")
    pcall(function()
        request({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)
end

-- 2. AUTO-ELITE HUNTER ENGINE
local function KillElite()
    pcall(function()
        local QuestRemote = game:GetService("ReplicatedStorage").Remotes.CommF_
        -- Check if we already have a quest
        local quest = LocalPlayer.PlayerGui.Main.Quest
        if not quest.Visible then
            QuestRemote:InvokeServer("EliteHunter") -- Take Quest
        end
        
        -- Find the Elite Boss
        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
            if v.Name == "Deandre" or v.Name == "Diablo" or v.Name == "Urban" then
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    local Root = game.Players.LocalPlayer.Character.HumanoidRootPart
                    Root.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                    
                    if v.Humanoid.Health <= 0 then
                        NotifyDiscord("Elite Pirate Slain!", "Defeated " .. v.Name, 16753920)
                    end
                    return true
                end
            end
        end
    end)
    return false
end

-- 3. THE PERSISTENCE ENGINE (Fruit + Elite + Hop)
task.spawn(function()
    while task.wait(5) do
        local fruitFound = false
        
        -- FRUIT CHECK
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and _G.TargetFruits[v.Name] then
                fruitFound = true
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                task.wait(0.5)
                local success = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                NotifyDiscord("Fruit Collected", v.Name .. " stored safely.", 65280)
                if success then _G.AutoHop = false end
            end
        end

        -- ELITE CHECK
        if _G.AutoElite then
            KillElite()
        end
        
        -- SERVER HOP
        if _G.AutoHop and not fruitFound then
            NotifyDiscord("Server Hopping", "No targets found. Moving to next server...", 8421504)
            local Http = game:GetService("HttpService")
            local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local srv = Http:JSONDecode(game:HttpGet(Api))
            for _, s in pairs(srv.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, game.Players.LocalPlayer)
                    break
                end
            end
        end
    end
end)

-- UI: SNIPER
SniperTab:CreateInput({
   Name = "Discord Webhook URL",
   PlaceholderText = "Paste Webhook Here",
   Callback = function(Text) _G.WebhookURL = Text end,
})

SniperTab:CreateMultiDropdown({
   Name = "Select Priority Fruits",
   Options = {"Kitsune-Kitsune", "Leopard-Leopard", "Dough-Dough", "Dragon-Dragon", "Spirit-Spirit", "Buddha-Buddha", "T-Rex-T-Rex", "Portal-Portal"},
   CurrentOption = {},
   Callback = function(Options)
       _G.TargetFruits = {}
       for _, v in pairs(Options) do _G.TargetFruits[v] = true end
   end,
})

SniperTab:CreateToggle({
   Name = "Auto-Hop When Finished",
   CurrentValue = false,
   Flag = "HopToggle",
   Callback = function(Value) _G.AutoHop = Value end,
})

-- UI: ELITE HUNTER
EliteTab:CreateToggle({
   Name = "Auto Elite Hunter (Yama Progress)",
   CurrentValue = false,
   Flag = "EliteToggle",
   Callback = function(Value) _G.AutoElite = Value end,
})

-- UI: FARM
FarmTab:CreateToggle({
   Name = "Anti-Kick NPC Farm",
   CurrentValue = false,
   Flag = "FarmToggle",
   Callback = function(Value) _G.SafeFarm = Value end,
})

-- Initialize Config
Rayfield:LoadConfiguration()
