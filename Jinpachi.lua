local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Westbound Premium | 6k Community",
   LoadingTitle = "Initializing...",
   LoadingSubtitle = "by Badal",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "WestboundBadal",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false, 
})

local MainTab = Window:CreateTab("Main Farm", 4483362458) 

-- // Logic Variables
local isFarming = false

-- // Auto Farm Logic
local function TumbleweedFarm()
    task.spawn(function()
        while isFarming do
            pcall(function()
                -- 1. Spawn Tumbleweed (Paste your remote here)
                -- game:GetService("ReplicatedStorage").ExampleRemote:FireServer()
                
                task.wait(0.5)

                -- 2. Tween to Coord
                local TweenService = game:GetService("TweenService")
                local Player = game.Players.LocalPlayer
                local Root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                
                if Root then
                    -- REPLACE X,Y,Z with the real coordinates
                    local targetCFrame = CFrame.new(100, 50, 100) 
                    
                    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(Root, tweenInfo, {CFrame = targetCFrame})
                    tween:Play()
                    tween.Completed:Wait()
                end

                -- 3. Rob Loop
                for i = 1, 5 do 
                    if not isFarming then break end
                    -- game:GetService("ReplicatedStorage").RobRemote:FireServer()
                    task.wait(0.1)
                end

                -- 4. Return to Safezone
                -- game:GetService("ReplicatedStorage").SafezoneRemote:FireServer()
            end)
            
            task.wait(1)
        end
    end)
end

local Toggle = MainTab:CreateToggle({
   Name = "Auto Farm Tumbleweed",
   CurrentValue = false,
   Flag = "AutoFarm", 
   Callback = function(Value)
      isFarming = Value
      if Value then
          TumbleweedFarm()
      end
   end,
})

Rayfield:LoadConfiguration()
