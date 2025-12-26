local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TSB: Elite Combat Hub",
   LoadingTitle = "Loading Combat Modules...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Combat & Movement", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager") -- Used for Auto-Block
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- State Variables
local SpeedValue = 16
local SpeedEnabled = false
local InfiniteDash = false
local AutoBlockEnabled = false
local ESPEnabled = false

-- 1. SPEED & AUTO-BLOCK LOOP
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        -- Speed Control
        if SpeedEnabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
        end

        -- Auto-Block Logic
        if AutoBlockEnabled then
            local targetFound = false
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 15 then -- Block if enemy is closer than 15 studs
                        targetFound = true
                        break
                    end
                end
            end
            
            if targetFound then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) -- Press F
            else
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game) -- Release F
            end
        end
    end
end)

-- 2. INFINITE DASH (Q KEY)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if InfiniteDash and input.KeyCode == Enum.KeyCode.Q then
        local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local Hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Root and Hum then
            local DashVelocity = Instance.new("BodyVelocity", Root)
            DashVelocity.MaxForce = Vector3.new(1, 0, 1) * 500000
            DashVelocity.Velocity = Hum.MoveDirection * 110 
            task.wait(0.15)
            DashVelocity:Destroy()
        end
    end
end)

-- UI CONTROLS: COMBAT
MainTab:CreateToggle({
   Name = "Auto-Block (15 Studs)",
   CurrentValue = false,
   Callback = function(Value) AutoBlockEnabled = Value end,
})

MainTab:CreateToggle({
   Name = "Infinite Dash (Q)",
   CurrentValue = false,
   Callback = function(Value) InfiniteDash = Value end,
})

MainTab:CreateSection("Movement")

MainTab:CreateToggle({
   Name = "Fast Run",
   CurrentValue = false,
   Callback = function(Value) SpeedEnabled = Value end,
})

MainTab:CreateSlider({
   Name = "Speed Multiplier",
   Range = {16, 65},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value) SpeedValue = Value end,
})

-- UI CONTROLS: VISUALS
VisualTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(Value)
      ESPEnabled = Value
      -- Script will refresh highlights automatically
   end,
})

-- ESP Refresh Loop
task.spawn(function()
    while task.wait(1) do
        if ESPEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("TSB_ESP") then
                    local h = Instance.new("Highlight", plr.Character)
                    h.Name = "TSB_ESP"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
end)
