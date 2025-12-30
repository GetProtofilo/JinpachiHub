-- [[ 1. UI CORE ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
local MiniBtn = Instance.new("TextButton", ScreenGui)

Main.Size = UDim2.new(0, 220, 0, 480)
Main.Position = UDim2.new(0.5, -110, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

MiniBtn.Size = UDim2.new(0, 40, 0, 40)
MiniBtn.Position = UDim2.new(0.5, -20, 0, 5)
MiniBtn.Text = "👹"
MiniBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
MiniBtn.TextColor3 = Color3.new(1, 1, 1)
MiniBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function Style(obj, text, pos, isBtn)
    obj.Size = UDim2.new(0.9, 0, 0, 24)
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
local StatLabel = Instance.new("TextLabel", Main) Style(StatLabel, "DOMINANCE: 0", 10, false)
local BtnToxic = Instance.new("TextButton", Main) Style(BtnToxic, "BRUTAL CHAT: OFF", 40, true)
local BtnSystem = Instance.new("TextButton", Main) Style(BtnSystem, "FAKE SYSTEM: OFF", 70, true)
local BtnRevenge = Instance.new("TextButton", Main) Style(BtnRevenge, "KILLER ESP: OFF", 100, true)
local BtnRadar = Instance.new("TextButton", Main) Style(BtnRadar, "RUNNER RADAR: OFF", 130, true)
local BtnAudio = Instance.new("TextButton", Main) Style(BtnAudio, "PHONK MUSIC: OFF", 160, true)
local BtnVoice = Instance.new("TextButton", Main) Style(BtnVoice, "VILLAIN VOICE: OFF", 190, true)
local BtnShadow = Instance.new("TextButton", Main) Style(BtnShadow, "SHADOW MODE: OFF", 220, true)
local BtnSpin = Instance.new("TextButton", Main) Style(BtnSpin, "SPIN TAUNT: OFF", 250, true)
local BtnEmote = Instance.new("TextButton", Main) Style(BtnEmote, "AUTO EMOTE: OFF", 280, true)
local BtnDance = Instance.new("TextButton", Main) Style(BtnDance, "CORPSE DANCE: OFF", 310, true)
local BtnSlow = Instance.new("TextButton", Main) Style(BtnSlow, "SLOW-WALK: OFF", 340, true)
local BtnBait = Instance.new("TextButton", Main) Style(BtnBait, "OMNI-BAIT (CLICK)", 370, true)

-- [[ 2. DATA & AUDIO ]]
local Settings = {Toxic=false, System=false, Revenge=false, Radar=false, Audio=false, Voice=false, Shadow=false, Spin=false, Emote=false, Dance=false, Slow=false, Count=0, Streak=0}
local Victims = {}
local KillerName = ""

local Phonk = Instance.new("Sound", game.CoreGui)
Phonk.SoundId = "rbxassetid://15243147575"; Phonk.Looped = true; Phonk.Volume = 0

local Voices = {"rbxassetid://9114753549", "rbxassetid://5532591605", "rbxassetid://6566804599"}
local Phrases = {"Sit.", "Free.", "Log out.", "Embarrassing.", "Uninstall.", "Just a filler character."}

-- [[ 3. TOGGLES ]]
local function Bind(btn, key, text)
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = text .. ": " .. (Settings[key] and "ON" or "OFF")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        if key == "Slow" then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Settings.Slow and 8 or 16 end
    end)
end

Bind(BtnToxic, "Toxic", "BRUTAL CHAT")
Bind(BtnSystem, "System", "FAKE SYSTEM")
Bind(BtnRevenge, "Revenge", "KILLER ESP")
Bind(BtnRadar, "Radar", "RUNNER RADAR")
Bind(BtnAudio, "Audio", "PHONK MUSIC")
Bind(BtnVoice, "Voice", "VILLAIN VOICE")
Bind(BtnShadow, "Shadow", "SHADOW MODE")
Bind(BtnSpin, "Spin", "SPIN TAUNT")
Bind(BtnEmote, "Emote", "AUTO EMOTE")
Bind(BtnDance, "Dance", "CORPSE DANCE")
Bind(BtnSlow, "Slow", "SLOW-WALK")

BtnBait.MouseButton1Click:Connect(function()
    local s = Instance.new("Sound", game.Players.LocalPlayer.Character.PrimaryPart)
    s.SoundId = "rbxassetid://1312372067"; s:Play(); game.Debris:AddItem(s, 2)
    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("...")
end)

-- [[ 4. ENGINE ]]
game.Players.LocalPlayer.CharacterAdded:Connect(function(c)
    Settings.Streak = 0
    c:WaitForChild("Humanoid").Died:Connect(function()
        Settings.Streak = 0
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (p.Character.HumanoidRootPart.Position - c.PrimaryPart.Position).Magnitude < 25 then
                    KillerName = p.Name
                end
            end
        end
    end)
end)

task.spawn(function()
    while task.wait(0.3) do
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

        -- Audio Volume Logic
        if Settings.Audio and Settings.Streak >= 3 then
            if not Phonk.IsPlaying then Phonk:Play() end
            Phonk.Volume = 1
        else
            Phonk.Volume = 0
        end

        -- Shadow & Spin
        if Settings.Shadow then for _,v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.Color = Color3.new(0,0,0) end end end
        if Settings.Spin then char.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(45), 0) end

        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character.Humanoid
                local root = p.Character.HumanoidRootPart
                local dist = (char.HumanoidRootPart.Position - root.Position).Magnitude

                -- FIXED HIGHLIGHTING
                local existing = root:FindFirstChild("MenaceHighlight")
                if Settings.Revenge and p.Name == KillerName then
                    if not existing then
                        local h = Instance.new("Highlight", root); h.Name = "MenaceHighlight"; h.FillColor = Color3.new(1,0,0); h.OutlineColor = Color3.new(1,1,1)
                    end
                elseif Settings.Radar and hum.Health < 30 and hum.Health > 0 then
                    if not existing then
                        local h = Instance.new("Highlight", root); h.Name = "MenaceHighlight"; h.FillColor = Color3.new(0,1,0); h.OutlineColor = Color3.new(1,1,1)
                    end
                else
                    if existing then existing:Destroy() end
                end

                -- KILL TRIGGER
                if hum.Health <= 0 and dist < 28 and not Victims[p.Name] then
                    Victims[p.Name] = true
                    Settings.Count = Settings.Count + 1
                    Settings.Streak = Settings.Streak + 1
                    StatLabel.Text = "DOMINANCE: "..Settings.Count.." | STREAK: "..Settings.Streak

                    if Settings.Toxic then game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(Phrases[math.random(1,#Phrases)]) end
                    if Settings.System then game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("[SYSTEM]: "..p.Name.." is being ignored due to skill gap.") end
                    if Settings.Voice then
                        local s = Instance.new("Sound", game.CoreGui); s.SoundId = Voices[math.random(1,#Voices)]; s.Volume = 3; s:Play(); game.Debris:AddItem(s, 3)
                    end
                    if Settings.Dance then
                        for i=1,6 do char.HumanoidRootPart.CFrame = root.CFrame * CFrame.Angles(0,math.rad(i*60),0) * CFrame.new(0,0,5); task.wait(0.05) end
                    end
                    if Settings.Emote then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.G, false, game)
                        task.wait(0.1); game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.G, false, game)
                    end
                elseif hum.Health > 0 or dist > 60 then
                    Victims[p.Name] = nil
                end
            end
        end
    end
end)
