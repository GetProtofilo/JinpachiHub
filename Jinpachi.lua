-- [[ 1. HUB CORE: DETECTION & PLACEMENT ]]
local Games = {
    [2041312730]  = "MM2",
    [10449761463] = "TSB",
    [1153255416]  = "SlapBattles",
    [17021312891] = "StealBrainrot"
}

local PlaceId, lp = game.PlaceId, game.Players.LocalPlayer
local GameName = Games[PlaceId] or "Universal"

-- [[ 2. TITAN UI ENGINE ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 280, 0, 520), UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3, Main.BorderSizePixel = Color3.fromRGB(12, 0, 0), 2
Main.BorderColor3 = Color3.new(1, 0, 0)
Main.Active, Main.Draggable = true, true

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 45), "🔱 APEX TITAN: " .. GameName
Title.TextColor3, Title.BackgroundColor3 = Color3.new(1, 1, 1), Color3.fromRGB(50, 0, 0)
Title.Font = Enum.Font.GothamBold

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size, Scroll.Position = UDim2.new(1, -10, 1, -55), UDim2.new(0, 5, 0, 50)
Scroll.BackgroundTransparency, Scroll.CanvasSize = 1, UDim2.new(0, 0, 18, 0)
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 8)

local function AddBtn(name, desc, callback)
    local b = Instance.new("TextButton", Scroll)
    b.Size, b.Text = UDim2.new(1, 0, 0, 55), "<b>" .. name .. "</b>\n<font size='10'>" .. desc .. "</font>"
    b.RichText, b.BackgroundColor3, b.TextColor3 = true, Color3.fromRGB(20, 20, 20), Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code; b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(callback)
end

-- [[ 3. MODULE: MURDER MYSTERY 2 🟢 ]]
if GameName == "MM2" then
    AddBtn("METATABLE SILENT AIM", "Intercepts network to hit 100% of shots", function()
        local Meta = getrawmetatable(game); setreadonly(Meta, false); local Old = Meta.__namecall
        Meta.__namecall = newcclosure(function(self, ...)
            local Method, Args = getnamecallmethod(), {...}
            if (Method == "FireServer" and (self.Name == "ThrowKnife" or self.Name == "ShootGun")) then
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= lp and v.Character then Args[1] = v.Character.HumanoidRootPart.Position end
                end
            end
            return Old(self, unpack(Args))
        end)
    end)
    AddBtn("EVENT TOKEN FARM", "Instant TP to coins and 2025 tokens", function()
        task.spawn(function()
            while task.wait(0.2) do
                for _,v in pairs(workspace:GetDescendants()) do
                    if v.Name == "CoinContainer" or v.Name:find("Token") then
                        lp.Character.HumanoidRootPart.CFrame = v:FindFirstChildOfClass("Part").CFrame
                    end
                end
            end
        end)
    end)
    AddBtn("ROLE X-RAY", "Reveals Murderer/Sheriff through walls", function()
        while task.wait(1) do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                    if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then h.FillColor = Color3.new(1,0,0)
                    elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then h.FillColor = Color3.new(0,0,1)
                    else h.FillColor = Color3.new(0,1,0) end
                end
            end
        end
    end)

-- [[ 4. MODULE: THE STRONGEST BATTLEGROUNDS 🟢 ]]
elseif GameName == "TSB" then
    AddBtn("COMBAT RESET (M1 TILT)", "Removes knockback from 4th hit", function()
        local c = 0
        game:GetService("UserInputService").InputBegan:Connect(function(i,p)
            if not p and i.UserInputType == Enum.UserInputType.MouseButton1 then
                c = (c + 1) % 4
                if c == 0 then lp.Character.HumanoidRootPart.CFrame *= CFrame.new(0,0,1.5) end
            end
        end)
    end)
    AddBtn("COUNTER PREDICTOR", "Alerts you if enemy Garou/Atomic is countering", function()
        task.spawn(function()
            while task.wait() do
                for _,v in pairs(game.Players:GetPlayers()) do
                    if v ~= lp and v.Character then
                        for _,a in pairs(v.Character.Humanoid:GetPlayingAnimationTracks()) do
                            if a.Animation.AnimationId:find("12510170988") then
                                print("ALERT: COUNTER DETECTED")
                            end
                        end
                    end
                end
            end
        end)
    end)

-- [[ 5. MODULE: SLAP BATTLES 🟢 ]]
elseif GameName == "SlapBattles" then
    AddBtn("360 RAGE AURA", "Slaps everyone in 20 stud radius", function()
        while task.wait() do
            for _,v in pairs(game.Players:GetPlayers()) do
                if v ~= lp and v.Character and (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude < 20 then
                    game:GetService("ReplicatedStorage").SlapEvent:FireServer(v.Character.HumanoidRootPart)
                end
            end
        end
    end)
    AddBtn("PHYSICS ANCHOR", "Anti-Ragdoll and Velocity Override", function()
        game:GetService("RunService").Stepped:Connect(function()
            lp.Character.Humanoid.PlatformStand = false
            if lp.Character.Humanoid.FloorMaterial == Enum.Material.Air then
                lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end)
    end)

-- [[ 6. MODULE: STEAL A BRAINROT 🟢 ]]
elseif GameName == "StealBrainrot" then
    AddBtn("LEGENDARY SNIPER", "Auto-snatches best items from conveyor", function()
        task.spawn(function()
            while task.wait(0.1) do
                for _, v in pairs(workspace.Conveyor:GetDescendants()) do
                    if v:IsA("ClickDetector") and (v.Parent.Name:find("Legendary") or v.Parent.Name:find("Secret")) then
                        lp.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                        fireclickdetector(v)
                    end
                end
            end
        end)
    end)
    AddBtn("SHIELD BYPASS", "Steal Brainrots even if base is shielded", function()
        -- Logic: Temporarily disables collision on the shield parts
        for _, v in pairs(workspace.Bases:GetDescendants()) do
            if v.Name == "Shield" then v.CanCollide = false; v.Transparency = 0.8 end
        end
    end)
    AddBtn("NO SLOWDOWN", "Removes speed penalty when carrying item", function()
        task.spawn(function()
            while task.wait() do if lp.Character.Humanoid.WalkSpeed < 16 then lp.Character.Humanoid.WalkSpeed = 70 end end
        end)
    end)

-- [[ 7. UNIVERSAL TOOLS ]]
else
    AddBtn("TITAN FLY/SPEED", "100 Speed & Infinite Jump", function()
        lp.Character.Humanoid.WalkSpeed = 100
        game:GetService("UserInputService").JumpRequest:Connect(function() lp.Character.Humanoid:ChangeState("Jumping") end)
    end)
end
