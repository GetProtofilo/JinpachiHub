-- [[ 1. EMERGENCY BOOTSTRAP ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ 2. PURE UI ENGINE (Mobile Optimized) ]]
-- We are not using Rayfield or Orion here to ensure it actually executes.
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Gemini Hub V10"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- [[ 3. GLOBAL STATE ]]
_G.Settings = {
    Webhook = "",
    Fruits = {["Kitsune-Kitsune"] = true, ["Dragon-Dragon"] = true, ["Dough-Dough"] = true},
    AutoHop = false,
    ChestFarm = false,
    AutoElite = false
}

-- [[ 4. FUNCTIONAL BUTTONS ]]
local function CreateToggleButton(name, pos, setting)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)

    btn.MouseButton1Click:Connect(function()
        _G.Settings[setting] = not _G.Settings[setting]
        btn.Text = name .. ": " .. (_G.Settings[setting] and "ON" or "OFF")
        btn.BackgroundColor3 = _G.Settings[setting] and Color3.fromRGB(0, 70, 0) or Color3.fromRGB(70, 0, 0)
    end)
end

CreateToggleButton("Fruit Sniper", 40, "AutoHop")
CreateToggleButton("Chest Farm", 85, "ChestFarm")
CreateToggleButton("Elite Hunter", 130, "AutoElite")

-- [[ 5. MOVEMENT ENGINE ]]
local function MoveTo(targetCFrame)
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = targetCFrame
        end
    end)
end

-- [[ 6. THE CORE LOOP ]]
task.spawn(function()
    while task.wait(3) do
        local taskDone = false
        
        -- CHEST LOGIC
        if _G.Settings.ChestFarm then
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") then
                    taskDone = true; MoveTo(v.CFrame); task.wait(0.2)
                end
            end
        end

        -- FRUIT LOGIC
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and _G.Settings.Fruits[v.Name] then
                taskDone = true; MoveTo(v.Handle.CFrame); task.wait(0.5)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
            end
        end

        -- ELITE LOGIC
        if _G.Settings.AutoElite then
            pcall(function()
                for _, boss in pairs(game.Workspace.Enemies:GetChildren()) do
                    if boss.Name == "Deandre" or boss.Name == "Diablo" or boss.Name == "Urban" then
                        taskDone = true; MoveTo(boss.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                    end
                end
            end)
        end

        -- AUTO HOP
        if _G.Settings.AutoHop and not taskDone then
            local srv = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, s in pairs(srv.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    break
                end
            end
        end
    end
end)

print("Gemini Hub V10: Successfully Loaded.")
