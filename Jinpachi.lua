-- [[ 1. NATIVE MASTER UI ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
local MiniBtn = Instance.new("TextButton", ScreenGui)

Main.Size = UDim2.new(0, 240, 0, 420)
Main.Position = UDim2.new(0.5, -120, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

MiniBtn.Size = UDim2.new(0, 40, 0, 40)
MiniBtn.Position = UDim2.new(0.5, -20, 0.02, 0)
MiniBtn.Text = "☣️"
MiniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MiniBtn.TextColor3 = Color3.new(1, 0, 0)
MiniBtn.Font = Enum.Font.GothamBold

MiniBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function Style(obj, text, pos, isBtn)
    obj.Size = UDim2.new(0.9, 0, 0, 26)
    obj.Position = UDim2.new(0.05, 0, 0, pos)
    obj.Text = text
    obj.TextColor3 = Color3.new(1, 1, 1)
    obj.Font = Enum.Font.Code
    if isBtn then
        obj.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        obj.BorderSizePixel = 0
    else
        obj.BackgroundTransparency = 1
    end
end

-- UI Setup
local StatLabel = Instance.new("TextLabel", Main) Style(StatLabel, "KILLS: 0 | STREAK: 0", 10, false)
local BtnToxic = Instance.new("TextButton", Main) Style(BtnToxic, "TOXIC CHAT: OFF", 45, true)
local BtnSystem = Instance.new("TextButton", Main) Style(BtnSystem, "FAKE SYSTEM: OFF", 80, true)
local BtnStreak = Instance.new("TextButton", Main) Style(BtnStreak, "STREAK CHAT: OFF", 115, true)
local BtnEmote = Instance.new("TextButton", Main) Style(BtnEmote, "AUTO EMOTE: OFF", 150, true)
local BtnDance = Instance.new("TextButton", Main) Style(BtnDance, "CORPSE DANCE: OFF", 185, true)
local BtnSlow = Instance.new("TextButton", Main) Style(BtnSlow, "SLOW-WALK: OFF", 220, true)
local BtnBait = Instance.new("TextButton", Main) Style(BtnBait, "OMNI-BAIT (CLICK)", 255, true)
local QuitLabel = Instance.new("TextLabel", Main) Style(QuitLabel, "Rage-Quit Watcher: ON", 295, false)

-- [[ 2. DATA & TABLES ]]
local Settings = {Toxic=false, System=false, StreakChat=false, Emote=false, Dance=false, Slow=false, Count=0, Streak=0}
local Victims = {}
local RecentKills = {} 
local Phrases = {"Sit.", "Free.", "Log out.", "Nice try.", "Stick to the tutorial.", "Free clips."}

-- [[ 3. TOGGLE HANDLERS ]]
local function Bind(btn, key, text)
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = text .. ": " .. (Settings[key] and "ON" or "OFF")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        if key == "Slow" then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Settings.Slow and 8 or 16 end
    end)
end

Bind(BtnToxic, "Toxic", "TOXIC CHAT")
Bind(BtnSystem, "System", "FAKE SYSTEM")
Bind(BtnStreak, "StreakChat", "STREAK CHAT")
Bind(BtnEmote, "Emote", "AUTO EMOTE")
Bind(BtnDance, "Dance", "CORPSE DANCE")
Bind(BtnSlow, "Slow", "SLOW-WALK")

BtnBait.MouseButton1Click:Connect(function()
    local s = Instance.new("Sound", game.Players.LocalPlayer.Character.HumanoidRootPart)
    s.SoundId = "rbxassetid://1312372067"
    s:Play()
    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("...")
end)

-- [[ 4. RAGE-QUIT WATCHER ]]
game.Players.PlayerRemoving:Connect(function(player)
    if RecentKills[player.Name] then
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("LMAO " .. player.Name .. " ACTUALLY RAGE QUIT!")
    end
end)

-- [[ 5. CORE MENACE ENGINE ]]
task.spawn(function()
    while task.wait(0.4) do
        pcall(function()
            local lp = game.Players.LocalPlayer
            local myChar = lp.Character
            if not myChar then return end

            if myChar.Humanoid.Health <= 0 then Settings.Streak = 0 end

            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") then
                    local hum = p.Character.Humanoid
                    local root = p.Character:FindFirstChild("HumanoidRootPart")
                    local dist = (myChar.HumanoidRootPart.Position - root.Position).Magnitude
                    
                    if hum.Health > 0 or dist > 55 then Victims[p.Name] = nil end

                    if hum.Health <= 0 and dist < 28 and not Victims[p.Name] then
                        Victims[p.Name] = true
                        RecentKills[p.Name] = tick()
                        Settings.Count = Settings.Count + 1
                        Settings.Streak = Settings.Streak + 1
                        StatLabel.Text = "KILLS: "..Settings.Count.." | STREAK: "..Settings.Streak

                        -- 1. Toxic Chat (Incl. Low HP check)
                        if Settings.Toxic then
                            local msg = (myChar.Humanoid.Health < 20) and "Imagine losing to me while I'm red health." or Phrases[math.random(1, #Phrases)]
                            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg)
                        end

                        -- 2. Fake System
                        if Settings.System then
                            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("[SYSTEM]: User " .. p.Name .. " has been flagged for 'Severe Skill Gap'.")
                        end

                        -- 3. Streak Announcement
                        if Settings.StreakChat and Settings.Streak % 3 == 0 then
                            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("🔥 UNSTOPPABLE: " .. Settings.Streak .. " KILLSTREAK! 🔥")
                        end

                        -- 4. Corpse Dance
                        if Settings.Dance then
                            for i = 1, 10 do
                                myChar.HumanoidRootPart.CFrame = root.CFrame * CFrame.Angles(0, math.rad(i*36), 0) * CFrame.new(0,0,4)
                                task.wait(0.04)
                            end
                        end

                        -- 5. Auto Emote
                        if Settings.Emote then
                            task.wait(0.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.G, false, game)
                            task.wait(0.1)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.G, false, game)
                        end

                        task.delay(15, function() RecentKills[p.Name] = nil end)
                    end
                end
            end
        end)
    end
end)
