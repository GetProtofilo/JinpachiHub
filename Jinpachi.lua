-- [[ 1. NATIVE UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", Main)
local Status = Instance.new("TextLabel", Main)
local ToggleBtn = Instance.new("TextButton", Main)
local EmoteBtn = Instance.new("TextButton", Main)

-- Style
Main.Size = UDim2.new(0, 220, 0, 180)
Main.Position = UDim2.new(0.5, -110, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true

Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "GEMINI TSB: NATIVE"
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.new(1, 1, 1)

Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0, 30)
Status.Text = "Teases This Session: 0"
Status.TextColor3 = Color3.fromRGB(0, 255, 150)
Status.BackgroundTransparency = 1

-- [[ 2. BUTTON LOGIC ]]
local function StyleButton(btn, text, pos)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    btn.TextColor3 = Color3.new(1, 1, 1)
end

StyleButton(ToggleBtn, "Auto Toxic", 70)
StyleButton(EmoteBtn, "Auto Emote", 115)

-- [[ 3. SETTINGS & DATA ]]
local Settings = {Toxic = false, Emote = false, Count = 0}
local Phrases = {"Free.", "Sit down.", "Stick to the training dummies.", "Mid.", "Was that it?", "Try again."}
local LastVictim = ""

ToggleBtn.MouseButton1Click:Connect(function()
    Settings.Toxic = not Settings.Toxic
    ToggleBtn.Text = "Auto Toxic: " .. (Settings.Toxic and "ON" or "OFF")
    ToggleBtn.BackgroundColor3 = Settings.Toxic and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
end)

EmoteBtn.MouseButton1Click:Connect(function()
    Settings.Emote = not Settings.Emote
    EmoteBtn.Text = "Auto Emote: " .. (Settings.Emote and "ON" or "OFF")
    EmoteBtn.BackgroundColor3 = Settings.Emote and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
end)

-- [[ 4. THE CORE ENGINE ]]
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            if not char then return end

            for _, target in pairs(game.Players:GetPlayers()) do
                if target ~= lp and target.Character and target.Character:FindFirstChild("Humanoid") then
                    local hum = target.Character.Humanoid
                    local root = target.Character:FindFirstChild("HumanoidRootPart")

                    if root and hum.Health <= 0 then
                        local dist = (char.HumanoidRootPart.Position - root.Position).Magnitude
                        
                        -- Detection Range: 35 studs
                        if dist <= 35 and LastVictim ~= target.Name then
                            LastVictim = target.Name
                            
                            -- Update Count
                            Settings.Count = Settings.Count + 1
                            Status.Text = "Teases This Session: " .. tostring(Settings.Count)

                            -- Action: Chat
                            if Settings.Toxic then
                                local msg = Phrases[math.random(1, #Phrases)]
                                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
                            end

                            -- Action: Emote (G Key)
                            if Settings.Emote then
                                task.wait(0.2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.G, false, game)
                                task.wait(0.1)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.G, false, game)
                            end
                            
                            task.wait(5) -- Cooldown for same kill
                        end
                    end
                end
            end
        end)
    end
end)
