-- [[ 1. MASTER NATIVE UI ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
local MiniBtn = Instance.new("TextButton", ScreenGui)

Main.Size = UDim2.new(0, 250, 0, 450)
Main.Position = UDim2.new(0.5, -125, 0.05, 0)
Main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true

MiniBtn.Size = UDim2.new(0, 40, 0, 40)
MiniBtn.Position = UDim2.new(0.5, -20, 0, 20)
MiniBtn.Text = "👹"
MiniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MiniBtn.TextColor3 = Color3.new(1, 0, 0)
MiniBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function Style(obj, text, pos, isBtn)
    obj.Size = UDim2.new(0.9, 0, 0, 24)
    obj.Position = UDim2.new(0.05, 0, 0, pos)
    obj.Text = text
    obj.TextColor3 = Color3.new(1, 1, 1)
    obj.Font = Enum.Font.Code
    if isBtn then
        obj.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
        obj.BorderSizePixel = 0
    else
        obj.BackgroundTransparency = 1
    end
end

-- [[ UI Elements ]]
local StatLabel = Instance.new("TextLabel", Main) Style(StatLabel, "DOMINANCE: 0", 10, false)
local BtnRevenge = Instance.new("TextButton", Main) Style(BtnRevenge, "REVENGE TRACKER: OFF", 40, true)
local BtnRadar = Instance.new("TextButton", Main) Style(BtnRadar, "RUNNER RADAR: OFF", 70, true)
local BtnShadow = Instance.new("TextButton", Main) Style(BtnShadow, "SHADOW MODE: OFF", 100, true)
local BtnMimic = Instance.new("TextButton", Main) Style(BtnMimic, "SARCASM MIMIC: OFF", 130, true)
local BtnSpin = Instance.new("TextButton", Main) Style(BtnSpin, "SPIN-BOT TAUNT: OFF", 160, true)
local BtnBounty = Instance.new("TextButton", Main) Style(BtnBounty, "SHOW BOUNTY BOARD", 190, true)
local BtnToxic = Instance.new("TextButton", Main) Style(BtnToxic, "BRUTAL CHAT: OFF", 220, true)
local BtnEmote = Instance.new("TextButton", Main) Style(BtnEmote, "AUTO EMOTE: OFF", 250, true)
local BtnDance = Instance.new("TextButton", Main) Style(BtnDance, "CORPSE DANCE: OFF", 280, true)

-- [[ 2. DATA & LOGIC ]]
local Settings = {Revenge=false, Radar=false, Shadow=false, Mimic=false, Spin=false, Toxic=false, Emote=false, Dance=false, Count=0}
local Victims = {}
local RecentKills = {}
local Killer = nil

-- [[ 3. FEATURE BINDING ]]
local function Bind(btn, key, text)
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = text .. ": " .. (Settings[key] and "ON" or "OFF")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
    end)
end

Bind(BtnRevenge, "Revenge", "REVENGE")
Bind(BtnRadar, "Radar", "RUNNER RADAR")
Bind(BtnShadow, "Shadow", "SHADOW MODE")
Bind(BtnMimic, "Mimic", "MIMIC")
Bind(BtnSpin, "Spin", "SPIN TAUNT")
Bind(BtnToxic, "Toxic", "BRUTAL")
Bind(BtnEmote, "Emote", "EMOTE")
Bind(BtnDance, "Dance", "DANCE")

-- [[ 4. CORE ENGINE FUNCTIONS ]]

-- Sarcasm Mimic
game:GetService("TextChatService").MessageReceived:Connect(function(msg)
    if Settings.Mimic and msg.TextSource.UserId ~= game.Players.LocalPlayer.UserId then
        local text = msg.Text:lower()
        if text:find("hacker") or text:find("bad") or text:find("spam") then
            local sarcastic = ""
            for i = 1, #msg.Text do
                local char = msg.Text:sub(i,i)
                sarcastic = sarcastic .. (i%2==0 and char:upper() or char:lower())
            end
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(sarcastic)
        end
    end
end)

-- Revenge Tracker Death Detect
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(function()
        -- Logic to find who killed you in TSB can be complex, usually proximity based
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and (p.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude < 15 then
                Killer = p.Name
            end
        end
    end)
end)

-- [[ 5. THE MAIN LOOP ]]
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local lp = game.Players.LocalPlayer
            local myChar = lp.Character
            if not myChar then return end

            -- Shadow Mode
            if Settings.Shadow then
                for _, part in pairs(myChar:GetChildren()) do
                    if part:IsA("BasePart") then part.Color = Color3.new(0,0,0) end
                end
            end

            -- Spin Taunt
            if Settings.Spin then
                myChar.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
            end

            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") then
                    local hum = p.Character.Humanoid
                    local root = p.Character:FindFirstChild("HumanoidRootPart")
                    local dist = (myChar.HumanoidRootPart.Position - root.Position).Magnitude

                    -- Highlighting (Revenge & Radar)
                    if Settings.Revenge and p.Name == Killer then
                        if not root:FindFirstChild("Highlight") then
                            local h = Instance.new("Highlight", root); h.FillColor = Color3.new(1,0,0)
                        end
                    elseif Settings.Radar and hum.Health < 20 and hum.Health > 0 then
                        if not root:FindFirstChild("Highlight") then
                            local h = Instance.new("Highlight", root); h.FillColor = Color3.new(0,1,0)
                        end
                    else
                        if root:FindFirstChild("Highlight") then root.Highlight:Destroy() end
                    end

                    -- KILL EVENT
                    if hum.Health <= 0 and dist < 25 and not Victims[p.Name] then
                        Victims[p.Name] = true
                        Settings.Count = Settings.Count + 1
                        StatLabel.Text = "DOMINANCE: "..Settings.Count
                        
                        -- Friend Bait
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/friend "..p.Name, "All")
                        
                        -- Mercy Timer Chat
                        if Settings.Toxic then
                            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("I'll give you 60 seconds to practice before I kill you again.")
                        end

                        if Settings.Dance then
                            for i = 1, 8 do
                                myChar.HumanoidRootPart.CFrame = root.CFrame * CFrame.Angles(0, math.rad(i*45), 0) * CFrame.new(0,0,4)
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end
        end)
    end
end)
