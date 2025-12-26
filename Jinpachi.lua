local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TSB: Kyoto Tech Edition",
   LoadingTitle = "Loading Combo Resets...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Combat Tech", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483362458)

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variables
local KyotoMacro = false
local HitboxEnabled = false
local HitboxSize = 2
local AntiRagdoll = false
local SpeedEnabled = false
local SpeedValue = 16

-- 1. THE CORE ENGINE
RunService.RenderStepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char then return end
    local Hum = Char:FindFirstChild("Humanoid")
    local Root = Char:FindFirstChild("HumanoidRootPart")

    if SpeedEnabled and Hum then Hum.WalkSpeed = SpeedValue end

    if AntiRagdoll and Hum then
        if Hum:GetState() == Enum.HumanoidStateType.Physics or Hum:GetState() == Enum.HumanoidStateType.FallingDown then
            Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end

    if HitboxEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local target = plr.Character.HumanoidRootPart
                target.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                target.Transparency = 0.8
                target.CanCollide = false
            end
        end
    end
end)

-- 2. KYOTO TECH MACRO (M1 Reset Assist)
-- This automatically side-dashes when you click to help reset your combo
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if KyotoMacro and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if Root then
            local SideDir = Root.CFrame.RightVector -- Resets using a right-side burst
            local BV = Instance.new("BodyVelocity", Root)
            BV.MaxForce = Vector3.new(100000, 0, 100000)
            BV.Velocity = SideDir * 40 -- Small burst to reset M1 animation
            task.wait(0.05)
            BV:Destroy()
        end
    end
end)

-- UI: COMBAT TECH
MainTab:CreateToggle({
   Name = "Kyoto Tech Macro (M1 Reset)",
   CurrentValue = false,
   Callback = function(Value) KyotoMacro = Value end,
})

MainTab:CreateToggle({
   Name = "Anti-Ragdoll",
   CurrentValue = false,
   Callback = function(Value) AntiRagdoll = Value end,
})

MainTab:CreateSection("Hitboxes")

MainTab:CreateToggle({
   Name = "Enable Hitbox",
   CurrentValue = false,
   Callback = function(Value) HitboxEnabled = Value end,
})

MainTab:CreateSlider({
   Name = "Reach Size",
   Range = {2, 15},
   Increment = 1,
   CurrentValue = 2,
   Callback = function(Value) HitboxSize = Value end,
})

-- UI: MOVEMENT
MovementTab:CreateToggle({
   Name = "Enable Speed",
   CurrentValue = false,
   Callback = function(Value) SpeedEnabled = Value end,
})

MovementTab:CreateSlider({
   Name = "Speed Amount",
   Range = {16, 75},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value) SpeedValue = Value end,
})

MovementTab:CreateButton({
   Name = "Fast Respawn",
   Callback = function() if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end end,
})
