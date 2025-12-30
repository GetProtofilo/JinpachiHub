-- [[ 1. LOAD REDZ LIBRARY ]]
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RedzLibV5/main/Source.Lua"))()

-- [[ 2. WINDOW ]]
local Window = redzlib:MakeWindow({
    Title = "Gemini Hub : TSB",
    SubTitle = "Tease & Toxic Edition",
    SaveFolder = "Gemini_TSB_Tease.lua"
})

-- [[ 3. SETTINGS ]]
_G.AutoTease = false
_G.TeaseChat = false
_G.TeaseEmote = false
_G.ToxicMessages = {
    "Is that it?",
    "Easy.",
    "Go back to the lobby.",
    "Are you lagging or just bad?",
    "Nice try, I guess.",
    "Stick to the training dummies."
}

-- [[ 4. TABS ]]
local MainTab = Window:MakeTab({"Tease Settings", "Skull"})
local MiscTab = Window:MakeTab({"Misc", "Settings"})

-- [[ 5. TEASE FEATURES ]]
MainTab:AddSection({"Kill Teaser"})

MainTab:AddToggle({
    Name = "Enable Auto Tease",
    Description = "Triggers actions when you kill someone",
    Default = false,
    Callback = function(v) _G.AutoTease = v end
})

MainTab:AddToggle({
    Name = "Toxic Chat Message",
    Description = "Automatically chats after a kill",
    Default = false,
    Callback = function(v) _G.TeaseChat = v end
})

MainTab:AddToggle({
    Name = "Auto Emote (G/7)",
    Description = "Uses your equipped emote after kill",
    Default = false,
    Callback = function(v) _G.TeaseEmote = v end
})

-- [[ 6. THE LOGIC ENGINE ]]
-- This script monitors the kills via the "Killed" event in TSB
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoTease then
            pcall(function()
                -- Detect when a nearby player's health hits 0
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                        local hum = player.Character.Humanoid
                        local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        
                        -- If player died close to you (meaning you likely killed them)
                        if hum.Health <= 0 and dist < 25 then
                            
                            -- 1. Toxic Chat
                            if _G.TeaseChat then
                                local msg = _G.ToxicMessages[math.random(1, #_G.ToxicMessages)]
                                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
                            end
                            
                            -- 2. Emote Tease (Simulates pressing G or 7)
                            if _G.TeaseEmote then
                                -- TSB Emote Keybind trigger
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.G, false, game)
                                task.wait(0.1)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.G, false, game)
                            end
                            
                            -- Cooldown to prevent spamming
                            task.wait(5)
                        end
                    end
                end
            end)
        end
    end
end)

-- [[ 7. ADD DISCORD ]]
MainTab:AddDiscordInvite({
    Name = "Gemini Hub TSB",
    Description = "Get the latest TSB toxic scripts",
    Logo = "rbxassetid://15298567397",
    Invite = "https://discord.gg/gemini"
})
