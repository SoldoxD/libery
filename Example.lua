-- ════════════════════════════════════════════════════════════════════
-- COMPREHENSIVE EXAMPLE — tests every feature of GuiLibrary
-- ════════════════════════════════════════════════════════════════════
local GuiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/SoldoxD/libery/refs/heads/main/main"))() -- replace with your loadstring URL
-- OR if loaded locally:
-- local GuiLibrary = require(path.to.GuiLibrary)

-- GuiLibrary.debugPrints = true  -- uncomment to enable verbose output

local Players      = game:GetService("Players")
local LocalPlayer  = Players.LocalPlayer
local Character    = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid     = Character:WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid  = c:WaitForChild("Humanoid")
end)

-- Create the main window — third arg is an optional icon (asset id)
local window = GuiLibrary:CreateWindow("Comprehensive Demo", UDim2.new(0, 620, 0, 420), 132382392)

-- You can also change the icon at runtime:
-- window.SetIcon(132382392)
-- window.SetIcon("rbxassetid://132382392")
-- window.SetIcon(nil)            -- removes the icon
-- window.SetTitle("Renamed!")    -- updates the window title

-- ════════════════════════════════════════════════════════════════════
-- TAB 1 — Player
-- ════════════════════════════════════════════════════════════════════
local playerTab = GuiLibrary:CreateTab(window, "Player")

GuiLibrary:CreateSection(playerTab, "Movement")

local walkSpeedSlider = GuiLibrary:CreateSlider(playerTab, "Walk Speed", 1, 200, 16, function(value)
    if Humanoid then Humanoid.WalkSpeed = value end
end)

local jumpPowerSlider = GuiLibrary:CreateSlider(playerTab, "Jump Power", 1, 500, 50, function(value)
    if Humanoid then Humanoid.JumpPower = value end
end)

local hipHeightSlider = GuiLibrary:CreateSlider(playerTab, "Hip Height", 0, 10, 2, function(value)
    if Humanoid then Humanoid.HipHeight = value end
end)

GuiLibrary:CreateSection(playerTab, "Abilities")

GuiLibrary:CreateToggle(playerTab, "God Mode", false, function(state)
    if Humanoid then
        Humanoid.MaxHealth = state and math.huge or 100
        Humanoid.Health    = Humanoid.MaxHealth
    end
    GuiLibrary:CreateNotification("God Mode", state and "Enabled" or "Disabled", 2,
        state and "success" or "info")
end)

GuiLibrary:CreateToggle(playerTab, "Infinite Jump", false, function(state)
    GuiLibrary:CreateNotification("Infinite Jump", state and "Enabled" or "Disabled", 2,
        state and "success" or "info")
end)

GuiLibrary:CreateToggle(playerTab, "Auto Reload", false, function(state)
    print("Auto reload:", state)
end)

GuiLibrary:CreateButton(playerTab, "Reset Character", function()
    if Humanoid then Humanoid.Health = 0 end
end)

-- ════════════════════════════════════════════════════════════════════
-- TAB 2 — Visual
-- ════════════════════════════════════════════════════════════════════
local visualTab = GuiLibrary:CreateTab(window, "Visual")

GuiLibrary:CreateSection(visualTab, "ESP")

GuiLibrary:CreateToggle(visualTab, "Player ESP", false, function(state)
    GuiLibrary:CreateNotification("ESP", state and "Enabled" or "Disabled", 2,
        state and "success" or "info")
end)

GuiLibrary:CreateToggle(visualTab, "Chams", false, function(state)
    print("Chams:", state)
end)

GuiLibrary:CreateToggle(visualTab, "Tracers", false, function(state)
    print("Tracers:", state)
end)

GuiLibrary:CreateToggle(visualTab, "Names", true, function(state)
    print("Names:", state)
end)

GuiLibrary:CreateSection(visualTab, "Color")

GuiLibrary:CreateColorPicker(visualTab, "ESP Color", Color3.fromRGB(255, 80, 80), function(color)
    print("ESP color:", color)
end)
GuiLibrary:CreateColorPicker(visualTab, "Chams Color", Color3.fromRGB(80, 220, 255), function(color)
    print("Chams color:", color)
end)
GuiLibrary:CreateColorPicker(visualTab, "Tracer Color", Color3.fromRGB(180, 80, 255), function(color)
    print("Tracer color:", color)
end)

GuiLibrary:CreateSection(visualTab, "Camera")

GuiLibrary:CreateSlider(visualTab, "FOV", 70, 120, 90, function(value)
    print("FOV:", value)
end)

GuiLibrary:CreateSlider(visualTab, "Distance", 50, 1000, 250, function(value)
    print("Distance:", value)
end)

-- ════════════════════════════════════════════════════════════════════
-- TAB 3 — Combat
-- ════════════════════════════════════════════════════════════════════
local combatTab = GuiLibrary:CreateTab(window, "Combat")

GuiLibrary:CreateSection(combatTab, "Aimbot")

GuiLibrary:CreateToggle(combatTab, "Aimbot Enabled", false, function(s) print("aimbot:", s) end)
GuiLibrary:CreateSlider(combatTab, "Smoothness",  0, 1,  0.3, function(v) print("smooth:", v) end)
GuiLibrary:CreateSlider(combatTab, "FOV Radius", 10, 500, 90, function(v) print("fov radius:", v) end)

GuiLibrary:CreateDropdown(combatTab, "Target Part",
    {"Head","Torso","HumanoidRootPart","RightArm","LeftArm"},
    function(part) print("target part:", part) end)

GuiLibrary:CreateDropdown(combatTab, "Aim Mode",
    {"Closest","Lowest HP","Random","Most Visible"},
    function(mode) print("aim mode:", mode) end)

GuiLibrary:CreateKeybind(combatTab, "Aim Key", Enum.KeyCode.E, function()
    print("Aim key pressed")
end)

-- ════════════════════════════════════════════════════════════════════
-- TAB 4 — Players (live list)
-- ════════════════════════════════════════════════════════════════════
local playersTab = GuiLibrary:CreateTab(window, "Players")

GuiLibrary:CreateSection(playersTab, "Target")

local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    if #names == 0 then names = {"(no players)"} end
    return names
end

local targetDropdown = GuiLibrary:CreateDropdown(playersTab, "Target Player",
    getPlayerNames(), function(name) print("Target selected:", name) end)

GuiLibrary:CreateButton(playersTab, "Refresh Player List", function()
    targetDropdown.UpdateOptions(getPlayerNames(), true)
end)

Players.PlayerAdded:Connect(function()
    targetDropdown.UpdateOptions(getPlayerNames(), true)
end)
Players.PlayerRemoving:Connect(function()
    targetDropdown.UpdateOptions(getPlayerNames(), true)
end)

GuiLibrary:CreateSection(playersTab, "Actions")

GuiLibrary:CreateButton(playersTab, "Teleport To Target", function()
    local name = targetDropdown.GetValue()
    local target = Players:FindFirstChild(name)
    if target and target.Character then
        local root   = target.Character:FindFirstChild("HumanoidRootPart")
        local myRoot = Character and Character:FindFirstChild("HumanoidRootPart")
        if root and myRoot then
            myRoot.CFrame = root.CFrame + Vector3.new(3, 0, 0)
            GuiLibrary:CreateNotification("Teleport", "Teleported to " .. name, 2, "success")
        end
    else
        GuiLibrary:CreateNotification("Error", "Player not found", 2, "error")
    end
end)

GuiLibrary:CreateButton(playersTab, "Spectate Target", function()
    local name = targetDropdown.GetValue()
    GuiLibrary:CreateNotification("Spectate", "Spectating " .. name, 2, "info")
end)

-- ════════════════════════════════════════════════════════════════════
-- TAB 5 — Misc
-- ════════════════════════════════════════════════════════════════════
local miscTab = GuiLibrary:CreateTab(window, "Misc")

GuiLibrary:CreateSection(miscTab, "Chat")

local chatInput = GuiLibrary:CreateInput(miscTab, "Message to send...", function(text)
    print("Send:", text)
end)

GuiLibrary:CreateButton(miscTab, "Send", function()
    GuiLibrary:CreateNotification("Chat", "Sent: " .. (chatInput.GetValue() or ""), 2, "info")
end)

GuiLibrary:CreateSection(miscTab, "Teleport")

local placeInput = GuiLibrary:CreateInput(miscTab, "Place ID", function(id) print("place:", id) end)

GuiLibrary:CreateButton(miscTab, "Teleport", function()
    local id = tonumber(placeInput.TextBox.Text)
    if id then
        GuiLibrary:CreateNotification("Teleport", "Teleporting to " .. id, 3, "info")
    else
        GuiLibrary:CreateNotification("Error", "Enter a valid Place ID", 2, "error")
    end
end)

GuiLibrary:CreateSection(miscTab, "Server")

local serverDropdown = GuiLibrary:CreateDropdown(miscTab, "Region",
    {"Auto", "US East", "US West", "EU", "Asia"}, function(r) print("region:", r) end)

GuiLibrary:CreateButton(miscTab, "Rejoin", function()
    GuiLibrary:CreateNotification("Rejoin", "Rejoining server...", 2, "info")
end)

GuiLibrary:CreateButton(miscTab, "Server Hop", function()
    GuiLibrary:CreateNotification("Server Hop", "Looking for server...", 2, "info")
end)

-- ════════════════════════════════════════════════════════════════════
-- TAB 5b — Live Label Demo (auto-heist style counter)
-- ════════════════════════════════════════════════════════════════════
local heistTab = GuiLibrary:CreateTab(window, "Heist")

local heistSection = GuiLibrary:CreateSection(heistTab, "Auto Heist")

-- Live-updating labels: returned table has SetText / GetText / SetColor / SetVisible
local bagLabel    = GuiLibrary:CreateLabel(heistTab, "Bag: $0 / $50,000")
local statusLabel = GuiLibrary:CreateLabel(heistTab, "Status: Idle")
local timerLabel  = GuiLibrary:CreateLabel(heistTab, "Time: 00:00")

-- A button whose label and callback can be swapped at runtime
local heistRunning = false
local heistBtn
heistBtn = GuiLibrary:CreateButton(heistTab, "Start Heist", function()
    heistRunning = not heistRunning
    if heistRunning then
        heistBtn.SetText("Stop Heist")
        statusLabel.SetText("Status: Running").SetColor(Color3.fromRGB(74, 222, 128))
        heistSection.SetText("Auto Heist (Active)")
    else
        heistBtn.SetText("Start Heist")
        statusLabel.SetText("Status: Idle").SetColor(Color3.fromRGB(120, 120, 150))
        heistSection.SetText("Auto Heist")
    end
end)

-- Background loop updates the live labels
task.spawn(function()
    local startTick = tick()
    local bag = 0
    while task.wait(0.5) do
        if bagLabel.Instance and bagLabel.Instance.Parent then
            if heistRunning then
                bag = math.min(bag + math.random(500, 1500), 50000)
                local mins = math.floor((tick() - startTick) / 60)
                local secs = math.floor((tick() - startTick) % 60)
                bagLabel.SetText(string.format("Bag: $%d / $50,000", bag))
                timerLabel.SetText(string.format("Time: %02d:%02d", mins, secs))
                if bag >= 50000 then
                    statusLabel.SetText("Status: Bag Full!").SetColor(Color3.fromRGB(255, 204, 0))
                end
            end
        else
            break
        end
    end
end)

GuiLibrary:CreateButton(heistTab, "Reset Bag", function()
    bagLabel.SetText("Bag: $0 / $50,000")
    timerLabel.SetText("Time: 00:00")
    statusLabel.SetText("Status: Idle").SetColor(Color3.fromRGB(120, 120, 150))
    GuiLibrary:CreateNotification("Heist", "Bag reset", 2, "info")
end)

-- ════════════════════════════════════════════════════════════════════
-- TAB 6 — Notification Tester (spam to verify stacking)
-- ════════════════════════════════════════════════════════════════════
local notifTab = GuiLibrary:CreateTab(window, "Notify")

GuiLibrary:CreateSection(notifTab, "Notifications")

GuiLibrary:CreateButton(notifTab, "Spawn Info", function()
    GuiLibrary:CreateNotification("Info", "An informational notification.", 4, "info")
end)
GuiLibrary:CreateButton(notifTab, "Spawn Success", function()
    GuiLibrary:CreateNotification("Success", "Operation finished successfully.", 4, "success")
end)
GuiLibrary:CreateButton(notifTab, "Spawn Warning", function()
    GuiLibrary:CreateNotification("Warning", "Watch out — something looks off.", 4, "warning")
end)
GuiLibrary:CreateButton(notifTab, "Spawn Error", function()
    GuiLibrary:CreateNotification("Error", "Something went wrong.", 4, "error")
end)
GuiLibrary:CreateButton(notifTab, "Spam x5 (test stacking)", function()
    for i = 1, 5 do
        GuiLibrary:CreateNotification("Notification "..i, "This is notification number "..i, 5, "info")
        task.wait(0.05)
    end
end)

-- ════════════════════════════════════════════════════════════════════
-- TAB 7 — Tab Overflow Test
-- (creates extra tabs so you can test horizontal tab scrolling)
-- ════════════════════════════════════════════════════════════════════
for i = 1, 6 do
    local extra = GuiLibrary:CreateTab(window, "Extra "..i)
    GuiLibrary:CreateSection(extra, "Tab "..i)
    GuiLibrary:CreateLabel(extra, "This is extra tab #"..i.." — try resizing the window smaller, then scroll the tab bar.")
    GuiLibrary:CreateToggle(extra, "Sample toggle "..i, false, function(s) print("tab",i,"toggle:",s) end)
    GuiLibrary:CreateSlider(extra, "Sample slider "..i, 0, 100, 50, function(v) print("tab",i,"slider:",v) end)
end

-- ════════════════════════════════════════════════════════════════════
-- Programmatic update demo (after 5 sec)
-- ════════════════════════════════════════════════════════════════════
task.delay(5, function()
    walkSpeedSlider.SetValue(32)
    jumpPowerSlider.SetValue(100)
    serverDropdown.UpdateOptions({"NA", "EU", "APAC"}, false)
    GuiLibrary:CreateNotification("Demo", "Programmatic update applied.", 3, "info")
end)
