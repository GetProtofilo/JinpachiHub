-- [[ 1. STABILITY BOOTSTRAP ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

-- [[ 2. GLOBAL SETTINGS ]]
_G.Settings = {
    Webhook = "",
    Fruits = {},
    AutoHop = false,
    AutoElite = false,
    ChestFarm = false,
    AutoFarm = false,
    TweenSpeed = 250
}

-- [[ 3. THE UI ENGINE (STABLE MOBILE VERSION) ]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Gemini Hub V9 | ULTIMATE", HidePremium = true, SaveConfig = true, ConfigFolder = "GeminiV9"})

-- [[ 4. WEBHOOK SYSTEM ]]
local function NotifyDiscord(title, desc)
    if _G.Settings.Webhook == "" or not _G.Settings.Webhook:find("http") then return end
    local url = _G.Settings.Webhook:gsub("discord.com", "webhook.lewisakura.moe")
    local data = {["embeds"] = {{["title"] = "🔱 " .. title, ["description"] = desc .. "\n**JobId:** " .. game.JobId, ["color"] = 65280}}}
    pcall(function()
        request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
    end)
end

-- [[ 5. MOVEMENT ENGINE ]]
local function SafeMove(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local dist = (char.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    if dist < 5 then return end
    local tween = TweenService:Create(char.HumanoidRootPart, TweenInfo.new(dist/_G.Settings.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- [[ 6. SNIPER TAB ]]
local SniperTab = Window:MakeTab({Name = "Fruit Sniper", Icon = "rbxassetid://4483362458"})

SniperTab:AddTextbox({
	Name = "Discord Webhook",
	Default = "",
	TextDisappear = false,
	Callback = function(v) _G.Settings.Webhook = v end
})

SniperTab:AddToggle({
	Name = "Auto-Hop Sniper",
	Default = false,
	Callback = function(v) _G.Settings.AutoHop = v end
})

-- Fruit Whitelist (Long list for maximum coverage)
local fruitList = {"Kitsune-Kitsune", "Leopard-Leopard", "Dough-Dough", "Dragon-Dragon", "Spirit-Spirit", "Control-Control", "Venom-Venom", "Shadow-Shadow", "Buddha-Buddha", "Portal-Portal", "T-Rex-T-Rex", "Mammoth-Mammoth"}
for _, fruit in pairs(fruitList) do
    SniperTab:AddToggle({
        Name = "Collect: " .. fruit,
        Default = false,
        Callback = function(v) _G.Settings.Fruits[fruit] = v end
    })
end

-- [[ 7. FARMING TAB ]]
local FarmTab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483362458"})

FarmTab:AddToggle({Name = "Auto Elite Hunter", Default = false, Callback = function(v) _G.Settings.AutoElite = v end})
FarmTab:AddToggle({Name = "Infinite Chest Farm", Default = false, Callback = function(v) _G.Settings.ChestFarm = v end})
FarmTab:AddToggle({Name = "Safe NPC Farm", Default = false, Callback = function(v) _G.Settings.AutoFarm = v end})

FarmTab:AddSlider({
	Name = "Tween Speed",
	Min = 100,
	Max = 350,
	Default = 250,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(v) _G.Settings.TweenSpeed = v end    
})

-- [[ 8. CORE LOGIC ENGINES ]]

-- LOOP: Fruits & Chests
task.spawn(function()
    while task.wait(2) do
        local busy = false
        
        -- Check Chests
        if _G.Settings.ChestFarm then
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") then
                    busy = true; SafeMove(v.CFrame); task.wait(0.5)
                end
            end
        end

        -- Check Fruits
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and _G.Settings.Fruits[v.Name] then
                busy = true; SafeMove(v.Handle.CFrame); task.wait(1)
                local s = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                NotifyDiscord("Fruit Secured", "Collected and Stored: " .. v.Name)
                if s then _G.Settings.AutoHop = false end
            end
        end

        -- Server Hop
        if _G.Settings.AutoHop and not busy then
            local srv = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, s in pairs(srv.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    break
                end
            end
        end
    end
end)

-- LOOP: Combat (NPC/Elite)
task.spawn(function()
    while task.wait() do
        if _G.Settings.AutoFarm or _G.Settings.AutoElite then
            pcall(function()
                if _G.Settings.AutoElite and not LocalPlayer.PlayerGui.Main.Quest.Visible then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
                end
                for _, boss in pairs(game.Workspace.Enemies:GetChildren()) do
                    if (boss.Name == "Deandre" or boss.Name == "Diablo" or boss.Name == "Urban" or _G.Settings.AutoFarm) and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                        break
                    end
                end
            end)
        end
    end
end)

OrionLib:Init()
