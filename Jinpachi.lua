local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Gemini Hub | Blox Fruits",
   LoadingTitle = "Scanning for Fruits...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local FruitTab = Window:CreateTab("Fruit Finder", 4483362458)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variables
local AutoFarm = false
local BringMob = false
local FastAttack = false
local FruitESP = false

-- 1. FRUIT FINDER LOGIC
local function CheckFruits()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
            if not v:FindFirstChild("FruitHighlight") and FruitESP then
                local b = Instance.new("Highlight", v)
                b.Name = "FruitHighlight"
                b.FillColor = Color3.fromRGB(0, 255, 0)
                
                Rayfield:Notify({
                    Title = "Fruit Found!",
                    Content = "A " .. v.Name .. " has been detected on the map!",
                    Duration = 10,
                    Image = 4483362458,
                })
            end
        end
    end
end

-- 2. AUTO FARM ENGINE
task.spawn(function()
    while task.wait() do
        CheckFruits() -- Constantly scan for fruits
        
        if AutoFarm then
            pcall(function()
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local Root = LocalPlayer.Character.HumanoidRootPart
                        -- Teleport Above NPC (Safe Zone)
                        Root.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                        
                        if BringMob then
                            for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                                if (mob.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude < 150 then
                                    mob.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                                    mob.HumanoidRootPart.CanCollide = false
                                end
                            end
                        end
                        
                        if FastAttack then
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                        end
                        break
                    end
                end
            end)
        end
    end
end)

-- UI: FARMING
FarmTab:CreateToggle({
   Name = "Auto Farm (Must Have Quest)",
   CurrentValue = false,
   Callback = function(Value) AutoFarm = Value end,
})

FarmTab:CreateToggle({
   Name = "Bring Mobs (Stack NPCs)",
   CurrentValue = false,
   Callback = function(Value) BringMob = Value end,
})

FarmTab:CreateToggle({
   Name = "Fast Attack",
   CurrentValue = false,
   Callback = function(Value) FastAttack = Value end,
})

-- UI: FRUIT FINDER
FruitTab:CreateToggle({
   Name = "Fruit ESP & Notifier",
   CurrentValue = false,
   Callback = function(Value) FruitESP = Value end,
})

FruitTab:CreateButton({
   Name = "Teleport to Fruit",
   Callback = function()
       local found = false
       for _, v in pairs(game.Workspace:GetChildren()) do
           if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
               LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
               found = true
               break
           end
       end
       if not found then
           Rayfield:Notify({Title = "No Fruit", Content = "No fruits found on the ground.", Duration = 3})
       end
   end,
})

FruitTab:CreateButton({
   Name = "Server Hop (Find New Fruits)",
   Callback = function()
       local Http = game:GetService("HttpService")
       local TPS = game:GetService("TeleportService")
       local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
       local _srv = Http:JSONDecode(game:HttpGet(Api))
       for _, s in pairs(_srv.data) do
           if s.playing < s.maxPlayers then
               TPS:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
               break
           end
       end
   end,
})
