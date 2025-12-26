-- // CONFIGURATION
local WebhookURL = "YOUR_WEBHOOK_HERE"
local AutoFruitHopper = false
local AutoMirageFinder = false -- NEW: Hops until Mirage Island is found
local AutoFullMoonFinder = false -- NEW: Hops until Full Moon is detected

local GoodFruits = {
    ["Dough-Dough"] = true, ["Dragon-Dragon"] = true, ["Leopard-Leopard"] = true,
    ["Kitsune-Kitsune"] = true, ["T-Rex-T-Rex"] = true, ["Buddha-Buddha"] = true
}

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "Gemini Hub | God Edition", LoadingTitle = "Bypassing 2025 Anti-Cheat..."})

-- SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // DISCORD WEBHOOK PROXY
local function SendWebhook(title, desc)
    local data = {["embeds"] = {{["title"] = title, ["description"] = desc, ["color"] = 16711680}}}
    local url = WebhookURL:gsub("discord.com", "webhook.lewisakura.moe")
    pcall(function()
        request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
    end)
end

-- // SERVER HOPPER
local function ServerHop()
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local srv = HttpService:JSONDecode(game:HttpGet(Api))
    for _, s in pairs(srv.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
            break
        end
    end
end

-- // MAIN SCRIPT LOGIC (Fruit, Mirage, Full Moon)
task.spawn(function()
    while task.wait(5) do
        -- 1. Fruit Check
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and GoodFruits[v.Name] then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                task.wait(0.5)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                SendWebhook("🍎 RARE FRUIT STORED", "Stored: " .. v.Name .. "\nServer: " .. game.JobId)
            end
        end

        -- 2. Mirage Island Check
        if AutoMirageFinder and game.Workspace:FindFirstChild("Mirage Island") then
            SendWebhook("🏝️ MIRAGE ISLAND FOUND", "Join now: " .. game.JobId)
            AutoMirageFinder = false
        end

        -- 3. Full Moon Check
        if AutoFullMoonFinder and game:GetService("Lighting").Sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then
            SendWebhook("🌕 FULL MOON DETECTED", "Server: " .. game.JobId)
            AutoFullMoonFinder = false
        end

        -- 4. Hopping Logic
        if (AutoFruitHopper or AutoMirageFinder or AutoFullMoonFinder) then
            ServerHop()
        end
    end
end)

-- // UI TABS
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local SniperTab = Window:CreateTab("Sniper Tech", 4483362458)

SniperTab:CreateToggle({
   Name = "Auto-Hop Fruit Sniper",
   CurrentValue = false,
   Callback = function(Value) AutoFruitHopper = Value end,
})

SniperTab:CreateToggle({
   Name = "Auto-Hop Mirage Finder",
   CurrentValue = false,
   Callback = function(Value) AutoMirageFinder = Value end,
})

SniperTab:CreateToggle({
   Name = "Auto-Hop Full Moon Finder",
   CurrentValue = false,
   Callback = function(Value) AutoFullMoonFinder = Value end,
})

-- // SEA EVENTS (Auto-Sea Beast/Ship)
FarmTab:CreateButton({
   Name = "Auto-Attack Sea Events",
   Callback = function()
       task.spawn(function()
           while task.wait() do
               for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                   if v.Name == "Sea Beast" or v.Name:find("Ship") then
                       LocalPlayer.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame * CFrame.new(0, 40, 0)
                       -- Add your attack remote here
                   end
               end
           end
       end)
   end,
})
