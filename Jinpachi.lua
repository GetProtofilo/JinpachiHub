local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Multi-Tool | PC & Mobile",
   LoadingTitle = "Loading Systems...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GeminiScripts", 
      FileName = "MainHub"
   },
   KeySystem = false -- Set to true if you want a key system
})

-- Variables for Features
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local Flying = false
local SpeedValue = 16
local FlySpeed = 50
local ESPEnabled = false

-- TAB: Main Controls
local MainTab = Window:CreateTab("Main Features", 4483362458) -- Icon ID

-- 1. Speed Adjustment
MainTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      SpeedValue = Value
      if Character:FindFirstChild("Humanoid") then
         Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- 2. ESP (Highlight Players)
MainTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      ESPEnabled = Value
      local function applyESP(plr)
         if plr ~= LocalPlayer and plr.Character then
            if ESPEnabled then
               local highlight = plr.Character:FindFirstChild("ESPHighlight") or Instance.new("Highlight", plr.Character)
               highlight.Name = "ESPHighlight"
               highlight.FillColor = Color3.fromRGB(255, 0, 0)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            else
               if plr.Character:FindFirstChild("ESPHighlight") then
                  plr.Character.ESPHighlight:Destroy()
               end
            end
         end
      end

      for _, plr in pairs(Players:GetPlayers()) do applyESP(plr) end
   end,
})

-- 3. Fly Script (Mobile & PC Friendly)
MainTab:CreateToggle({
   Name = "Fly Mode",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      Flying = Value
      local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
      
      if Flying then
         local bv = Instance.new("BodyVelocity", HumanoidRootPart)
         bv.Velocity = Vector3.new(0,0,0)
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         bv.Name = "FlyVelocity"
         
         task.spawn(function()
            while Flying do
               local Cam = workspace.CurrentCamera
               local moveDir = Character.Humanoid.MoveDirection
               bv.Velocity = (Cam.CFrame.LookVector * (moveDir.Z * -FlySpeed)) + (Cam.CFrame.RightVector * (moveDir.X * FlySpeed))
               if moveDir == Vector3.new(0,0,0) then bv.Velocity = Vector3.new(0,0.1,0) end
               task.wait()
            end
            bv:Destroy()
         end)
      end
   end,
})

Rayfield:Notify({
   Title = "Script Loaded!",
   Content = "Press the side button to hide/show GUI.",
   Duration = 5,
   Image = 4483362458,
})
