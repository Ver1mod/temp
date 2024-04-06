-- Global Variables
local Player = game.Players.LocalPlayer
local spawn = game.ReplicatedStorage.Remotes.Spawn
local ping = {0, 0}
-- local connection
-- connection = game:GetService("RunService").Heartbeat:Connect(function()
--     if is_end == then
--         print(ping[1]/ping[2])
--         connection:Disconnect
--     end
--     ping[1] += game.Players.LocalPlayer:GetNetworkPing() * 1000
-- end)
--Functions

local function prepare()
    local Folder = Instance.new("Folder")
    Folder.Parent = workspace
    Folder.Name = "SomethingInteresting"

    local part = Instance.new("Part")
    part.Anchored = true 
    part.CFrame = CFrame.new(38.05671310424805, 19, 205.06903076171875)
    part.Name = "Part0"
    part.Parent = Folder
    part.Size = Vector3.new(50, 1, 50)

    local part0 = Instance.new("Part")
    part0.Name = "Part1"
    part0.CFrame =  CFrame.new(121.98226165771484, 96.61053466796875, 171.84950256347656)
    part0.Anchored = true
    part0.Size = Vector3.new(50, 2, 50)
    part0.Parent = Folder

    local part1 = Instance.new("Part")
    part1.Name = "Part2"
    part1.CFrame =  CFrame.new(46.06599807739258, 85, 17.795419692993164)
    part1.Anchored = true
    part1.Size = Vector3.new(50, 2, 50)
    part1.Parent = Folder
end
if not workspace:FindFirstChild("SomethingInteresting") then
    prepare()
end

local respawn_time = {0, 0}
local getting_credits_time = {0, 0}
local function respawn()
    -- Become SD
    spawn:InvokeServer({[1] = "Security Department"})
    -- Become CD
    spawn:InvokeServer({[1] = "Class - D"})

    local target = "New quests are now available."
    local gui = Player.PlayerGui.Notification

    local startTime = os.clock()
    while task.wait() do
        if gui:WaitForChild("Notification").Description.Text == target then
            gui.Notification:Destroy()
            break
        else
            gui.Notification:Destroy()
        end
    end
    local stopTime = os.clock()
    respawn_time[1] += (stopTime-startTime)
    respawn_time[2] += 1
end

local function escape()
    local Character = workspace:WaitForChild(Player.Name)
    Character:WaitForChild("HumanoidRootPart")
    Character:WaitForChild("Humanoid")
    local list = {
        CFrame.new(38.05671310424805, 23.95866584777832, 205.06903076171875),
        CFrame.new(121.98226165771484, 100.61051177978516, 171.84950256347656),
        CFrame.new(40.904762268066406, 88.9999771118164, 16.930776596069336),
    }
    for i, v in list do
        Character.HumanoidRootPart.CFrame = v
        if i == 2 then
            local Timer = 5
            while Timer > 0 do
                Character.HumanoidRootPart.CFrame = v
                local WaitTime = task.wait()
                Timer -= WaitTime
            end
        end
    end
    while Character.Humanoid.Health > 0 do
        if Player.Backpack:FindFirstChild("Scar - H") then
            local gui = game:GetService("Players").LocalPlayer.PlayerGui.Notification.Feedback.Top
            local startTime = os.clock()
            while Character.Humanoid.Health > 0 do
                if gui:FindFirstChild("6Icon") then
                    break
                end
                task.wait()
            end
            local stopTime = os.clock()
            getting_credits_time[1] += (stopTime-startTime)
            getting_credits_time[2] += 1
            respawn()
            break
        end
        task.wait()
    end
    return true
end

local target = "Escape into the Chaos Insurgency spawn as a Class - D."
local function compare_quests()
    -- Variables
    local gui = Player.PlayerGui.Utility.QuestsInfo
    local quest1 = gui.Quest1.Back.ContentText
    local quest2 = gui.Quest2.Back.ContentText
    local quest3 = gui.Quest3.Back.ContentText
    -- Action
    local compare = quest1 == target or quest2 == target or quest3 == target
    return compare
end

-- The main loop
local startTime = os.clock()
local num_of_credits = game.Players.LocalPlayer.PlayerGui.Utility.Credits.Credits.ContentText
local amount_of_errors = 0
print("Started at " .. tostring(startTime))
for i = 1, 10 do
    -- Variables
    local num_of_credits = game.Players.LocalPlayer.PlayerGui.Utility.Credits.Credits.ContentText
    -- Compare quests and target
    while task.wait() do
        local compare = compare_quests()
       -- Reload quests
        if not compare then
            respawn()
        -- Break the loop if compare == target
        else
            break
        end
    end
    -- Actions
    if pcall(escape) ~= true then
        amount_of_errors += 1
    end

    -- Compare credits before the script and after
    local test_of_credits = game.Players.LocalPlayer.PlayerGui.Utility.Credits.Credits.ContentText
    if num_of_credits == test_of_credits then
        print("There was an error.")
    end
    print("Step", i, "is done")
end

local test_of_credits = game.Players.LocalPlayer.PlayerGui.Utility.Credits.Credits.ContentText
local result = test_of_credits - num_of_credits
local stopTime = os.clock()
print("Got " .. tostring(result) .. " Credits!")
print("Time: " .. tostring(math.floor(startTime-stopTime+0.5)))
print("Credits per second: " .. tostring(result/math.floor(stopTime-startTime+0.5)))
print("Amount of errors:", amount_of_errors)

print("Amount of respawns:", respawn_time[2])
print("Respawn time:", respawn_time[1])
print("Medium respawn time:", respawn_time[1]/respawn_time[2])

print("Getting credits time:", getting_credits_time[1])
print("Medium getting credits time:", getting_credits_time[1]/getting_credits_time[2])
-- End of the script
print("The script has been ended!")
