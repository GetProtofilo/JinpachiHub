-- [[ 1. NATIVE UI (GUARANTEED LOAD) ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
local Status = Instance.new("TextLabel", Main)
local ToggleBtn = Instance.new("TextButton", Main)
local EmoteBtn = Instance.new("TextButton", Main)

Main.Size = UDim2.new(0, 200, 0, 150)
Main.Position = UDim2.new(0.5, -100, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true

Status.Size = UDim2.new(1, 0, 0, 30)
Status.Text = "Status: Monitoring Kills"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

local function Style(btn, text, pos, color)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
end

Style(ToggleBtn, "Toxic Chat: OFF", 40, Color3.fromRGB(80, 20, 20))
Style(EmoteBtn, "Auto Emote: OFF", 85, Color3.fromRGB(80, 20, 20))

-- [[ 2. LOGIC VARIABLES ]]
local Settings = {Toxic = false, Emote = false}
local LastVictim = ""
local Phrases = {"Sit.", "Free.", "Is that it?", "Stick to the tutorial.", "Free clips.", "Log out."}

-- [[ 3. BUTTON CONNECTIONS ]]
ToggleBtn.MouseButton1Click:Connect(function()
    Settings.Toxic = not Settings.Toxic
    ToggleBtn.Text = "Toxic Chat: " .. (Settings.Toxic and "ON" or "OFF")
    ToggleBtn.BackgroundColor3 = Settings.Toxic and Color3.fromRGB(20, 80, 20) or Color3.fromRGB(80, 20, 20)
end)

EmoteBtn.MouseButton1Click:Connect(function()
    Settings.Emote = not Settings.Emote
    EmoteBtn.Text = "Auto Emote: " .. (Settings.Emote and "ON" or "OFF")
    EmoteBtn.BackgroundColor3 = Settings.Emote and Color3.fromRGB(20, 80, 20) or Color3.fromRGB(80, 20, 20)
end)

-- [[ 4. THE 2025 BYPASS ENGINE ]]
local function Tease(targetName)
    -- NEW CHAT SYSTEM (TextChatService)
    if Settings.Toxic then
        local msg = Phrases[math.random(1, #Phrases)]
        local textChannel = game:GetService("TextChatService").TextChannels.RBXGeneral
        textChannel:SendAsync(msg)
    end

    -- EMOTE BYPASS (TSB Key-Event Simulation)
    if Settings.Emote then
        task.wait(0.2)
        -- Simulates a clean G-key press that TSB 2025 recognizes
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.G, false, game)
        task.wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.G, false, game)
    end
end

-- [[ 5. KILL DETECTION ]]
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local lp = game.Players.LocalPlayer
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") then
                    local hum = p.Character.Humanoid
                    local root = p.Character:FindFirstChild("HumanoidRootPart")
                    
                    -- Detection: If they are dead and you are within 25 studs
                    if hum.Health <= 0 and (lp.Character.HumanoidRootPart.Position - root.Position).Magnitude < 25 then
                        if LastVictim ~= p.Name then
                            LastVictim = p.Name
                            Status.Text = "Teasing: " .. p.Name
                            Tease(p.Name)
                            task.wait(5) -- Prevents double-tease
                        end
                    end
                end
            end
        end)
    end
end)
