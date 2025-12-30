-- [[ 1. BOOTING RAYFIELD V2 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "GEMINI TSB: THE FINISHER",
   LoadingTitle = "Initializing Kill Tracking...",
   LoadingSubtitle = "By Gemini | 2025",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GeminiTSB_Data",
      FileName = "FinisherConfig"
   }
})

-- [[ 2. DATA & STATS ]]
_G.TeaseCount = 0
_G.Settings = {
    AutoToxic = false,
    AutoEmote = false,
    SafeDist = 30
}

-- [[ 3. TABS ]]
local MainTab = Window:CreateTab("Combat Tease", 4483362458)
local StatsTab = Window:CreateTab("Session Stats", 4483362458)

-- [[ 4. STATS PANEL ]]
local KillLabel = StatsTab:CreateLabel("Total Teases This Session: 0")

-- [[ 5. COMBAT TEASE ELEMENTS ]]
MainTab:CreateSection("Tease Configuration")

MainTab:CreateToggle({
   Name = "Toxic Chat On Kill",
   CurrentValue = false,
   Flag = "ToxicChat",
   Callback = function(v) _G.Settings.AutoToxic = v end,
})

MainTab:CreateToggle({
   Name = "Emote On Kill (G Key)",
   CurrentValue = false,
   Flag = "EmoteKill",
   Callback = function(v) _G.Settings.AutoEmote = v end,
})

MainTab:CreateSlider({
   Name = "Kill Detection Range",
   Min = 5,
   Max = 100,
   CurrentValue = 30,
   Flag = "RangeSlider",
   Callback = function(v) _G.Settings.SafeDist = v end,
})

-- [[ 6. TOXIC DICTIONARY ]]
local Phrases = {
    "Is that your main account or a bot?",
    "Free 1v1 lesson. You're welcome.",
    "I've seen training dummies with better movement.",
    "Maybe try a different character?",
    "That was mid at best.",
    "Log off and stay off.",
    "GG (Get Good).",
    "Was that supposed to be a combo?"
}

-- [[ 7. THE FINISHER ENGINE ]]
local LastVictim = nil

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local lp = game.Players.LocalPlayer
            local myChar = lp.Character
            if not myChar then return end

            for _, target in pairs(game.Players:GetPlayers()) do
                if target ~= lp and target.Character and target.Character:FindFirstChild("Humanoid") then
                    local hum = target.Character.Humanoid
                    local root = target.Character:FindFirstChild("HumanoidRootPart")
                    
                    if root and hum.Health <= 0 then
                        local dist = (myChar.HumanoidRootPart.Position - root.Position).Magnitude
                        
                        -- Verification: Within range and hasn't been teased yet
                        if dist <= _G.Settings.SafeDist and LastVictim ~= target.Name then
                            LastVictim = target.Name
                            
                            -- Update Stats
                            _G.TeaseCount = _G.TeaseCount + 1
                            KillLabel:Set("Total Teases This Session: " .. tostring(_G.TeaseCount))
                            
                            -- Trigger Chat
                            if _G.Settings.AutoToxic then
                                local msg = Phrases[math.random(1, #Phrases)]
                                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
                            end
                            
                            -- Trigger Emote
                            if _G.Settings.AutoEmote then
                                task.wait(0.2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.G, false, game)
                                task.wait(0.1)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.G, false, game)
                            end
                            
                            -- Cooldown to prevent multi-trigger on same body
                            task.wait(4)
                        end
                    end
                end
            end
        end)
    end
end)

Rayfield:LoadConfiguration()
