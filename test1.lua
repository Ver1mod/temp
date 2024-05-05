-- v10 Super (Perfomance)
-- Global Variables

local Player = game.Players.LocalPlayer
local BulletReplication = game:GetService("ReplicatedStorage").BulletReplication.ReplicateClient
local Use_Storage = game:GetService("ReplicatedStorage").Remotes.UseStorage
local NPCs = game.Workspace.NPCs

local function merge_tables(arg, value0)
	local value = arg
	for i, v in value0 do
		table.insert(value, v)
	end
	return value
end

-- The start
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ver1mod/NewGui/main/UI_Library.lua", true))()
local example = library:CreateWindow({
	text = "SCP: The Red Lake"
})
local example0 = library:CreateWindow({
	text = "Items"
})

-- Auto potions
local auto_strength = false
local auto_absorb = false
local auto_mixture = false
example0:AddToggle("Strength Mixture", function(state)
	auto_strength = state
	local ohString2 = "Strength Mixture"
	while auto_strength do
		pcall(function()
			if Player.Character.Humanoid.Health ~= 0 then
				if not Player.Backpack:FindFirstChild("Strength Mixture") and not Player.Character:FindFirstChild("Strength Mixture") then
					Use_Storage:FireServer("WITHDRAW", ohString2)
				end
				Player.Backpack:WaitForChild("Strength Mixture").Parent = Player.Character
				Player.Character:WaitForChild("Strength Mixture").Use:FireServer(Vector3.new(0,0,0))
				wait(16)
			end
		end)
		task.wait()
	end
end)
example0:AddToggle("Absorb Mixture", function(state)
	auto_absorb = state
	local ohString2 = "Absorb Mixture"
	while auto_absorb do
		pcall(function()
			if Player.Character.Humanoid.Health ~= 0 then
				if not Player.Backpack:FindFirstChild("Absorb Mixture") and not Player.Character:FindFirstChild("Strength Mixture") then
					Use_Storage:FireServer("WITHDRAW", ohString2)
					Player.Backpack:WaitForChild("Absorb Mixture").Parent = Player.Character
				elseif Player.Backpack:FindFirstChild("Absorb Mixture") then
					Player.Backpack["Absorb Mixture"].Parent = Player.Character
				end
				Player.Character["Absorb Mixture"].Use:FireServer(Vector3.new(0,0,0))
				wait(31)
			end
		end)
		task.wait()
	end
end)
example0:AddToggle("Mixture", function(state)
	auto_mixture = state
	while auto_mixture do
		pcall(function()
			if Player.Character.Humanoid.Health ~= 0 then
				if not Player.Backpack:FindFirstChild("Mixture") and not Player.Character:FindFirstChild("Mixture") then
					game:GetService("ReplicatedStorage").Remotes.BuyWeapon:FireServer("Mixture")
					Player.Backpack:WaitForChild("Mixture").Parent = Player.Character
				elseif Player.Backpack:FindFirstChild("Mixture") then
					Player.Backpack.Mixture.Parent = Player.Character
				end
				Player.Character:WaitForChild("Mixture").Use:FireServer(Vector3.new(0,0,0))
				task.wait(2.6)
			end
		end)
		task.wait()
	end
end)

-- Auto bring items
example0:AddButton("Teleport Device", function()
	local ohString2 = "Teleport Device"
	Use_Storage:FireServer("WITHDRAW", ohString2)
	Player.Backpack:WaitForChild(ohString2).Parent = Player.Character
	Player.Character:WaitForChild(ohString2).Use:FireServer(Vector3.new(0,0,0))
end)

example0:AddButton("Smoke Grenade", function()
	local ohString2 = "Smoke Grenade"
	Use_Storage:FireServer("WITHDRAW", ohString2)
end)

example0:AddButton("Scan Grenade", function()
	local ohString2 = "Scan Grenade"
	Use_Storage:FireServer("WITHDRAW", ohString2)
end)

example0:AddButton("Aura Grenade", function()
	local ohString2 = "Aura Grenade"
	Use_Storage:FireServer("WITHDRAW", ohString2)
end)

example0:AddButton("Deposit", function()
	local tool = Player.Character:FindFirstChildOfClass("Tool")
	if tool:GetAttribute("FromStorage") == true then
		Use_Storage:FireServer("DEPOSIT", tool.Name)
	end
end)

example0:AddButton("Bulk scrap", function()
	Player.PlayerGui.BulkScrap.Enabled = true
end)

-- Aimbot settings
local RPM = 0
example:AddBox("Delay", function(object, focus)
	if focus then
		RPM = 0
		pcall(function()
			RPM = tonumber(object.Text)
		end)
	end
end)

local Range = 2
example:AddBox("Range", function(object, focus)
	if focus then
		Range = 2
		pcall(function()
			Range = tonumber(object.Text)
		end)
	end
end)

local Hardness = 5
example:AddBox("Hardness", function(object, focus)
	if focus then
		Hardness = 5
		pcall(function()
			Hardness = tonumber(object.Text)
		end)
	end
end)

-- Backpack hack
local backpack_hack = false
example:AddToggle("Enable backpack bag", function(state)
	backpack_hack = state
	while backpack_hack do
		pcall(function()
			fireproximityprompt(Player.Character.BackpackBag.Handle.Template)
		end)
		task.wait(1)
	end
end)

-- Aimbot modules
local function auto_equip()
	for _, v in Player.Backpack:GetChildren() do
		if v:GetAttribute("Ammo") ~= nil then
			v.Parent = Player.Character
		end
	end
end

local function shot(weapon, enemy)
	if weapon:GetAttribute("Ammo") ~= nil then
		if Player:DistanceFromCharacter(enemy.Position) < weapon:GetAttribute("Range")*Range then
			weapon.Main:FireServer("MUZZLE", weapon.Handle.Barrel)
			weapon.Main:FireServer("DAMAGE", {[1]=enemy,[2] = enemy.Position,[3]=100, [4] = true})
			weapon.Main:FireServer("AMMO")
		end
	end
end

-- Aimbot modes
local autofarm = false
local autofarm_spread = false
local autofarm_experimental = false
local highlight_instance
example:AddToggle("Auto Farm Mobs(Ex)", function(state)
	autofarm_spread = state
	while autofarm_spread do
		pcall(function()
			auto_equip()
			local enemies = merge_tables(
				NPCs.Monsters:GetChildren(), 
				NPCs.Tango:GetChildren()
			)
			for _, enemy in enemies do
				local v = enemy.Head
				auto_equip()
				if v.Parent.Parent.Name ~= "Deceased" and v.Parent.Humanoid.Health > 0 then
					for _, tool in Player.Character:GetChildren() do
						shot(tool, v)
					end
					task.wait(RPM)
				end
			end
		end)
		task.wait()
	end
end)

example:AddToggle("Auto Farm Mobs", function(state)
	autofarm = state
	while autofarm do
		task.wait()
		pcall(function()
			local enemy = highlight_instance.Parent
			while enemy.Humanoid.Health > 0 and autofarm do
				auto_equip()
				for _, tool in Player.Character:GetChildren() do
					shot(tool, enemy.Head)
				end
				task.wait(RPM)
			end
		end)
	end
end)

example:AddToggle("Auto Farm Mobs(Hard)", function(state)
	autofarm_experimental = state
	local i0 = 1
	local tools = {}
	local enemies = merge_tables(
		NPCs.Monsters:GetChildren(), 
		NPCs.Tango:GetChildren()
	)
	local tools = {}
	for _, tool in Player.Character:GetChildren() do
		if tool:GetAttribute("Ammo") ~= nil then
			table.insert(tools, tool)
		end
	end

	local connections = {}
	local function set_tools(character)
		connections[5] = character.ChildAdded:Connect(function(tool)
			if tool:GetAttribute("Ammo") ~= nil then
				table.insert(tools, tool)
			end
		end)
		connections[6] = character.ChildRemoved:Connect(function(tool)
			if tool:GetAttribute("Ammo") ~= nil then
				local target = table.find(tools, tool)
				table.remove(tools, target)
			end
		end)
	end
	set_tools(Player.Character)
	connections[7] = Player.CharacterAdded:Connect(set_tools)
	connections[8] = Player.CharacterRemoving:Connect(function()
		connections[5]:Disconnect()
		connections[6]:Disconnect()
	end)

	connections[1] = NPCs.Monsters.ChildAdded:Connect(function(child)
		table.insert(enemies, child)
	end)
	connections[2] = NPCs.Tango.ChildAdded:Connect(function(child)
		table.insert(enemies, child)
	end)
	connections[3] = NPCs.Monsters.ChildRemoved:Connect(function(child)
		local target = table.find(enemies, child)
		table.remove(enemies, target)
	end)
	connections[4] = NPCs.Tango.ChildRemoved:Connect(function(child)
		local target = table.find(enemies, child)
		table.remove(enemies, target)
	end)

	local i = 1
	local i1 = 1
	while autofarm_experimental do
		auto_equip()
		if enemies[1] == nil or tools[1] == nil then
			task.wait()
			continue
		end
		if enemies[i] == nil then
			i = 1
		end
		if tools[i0] == nil then
			i0 = 1
		end
		local enemy = enemies[i]
		local weapon = tools[i0]
		if enemy.Parent.Name ~= "Deceased" and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("Head") and enemy.Humanoid.Health > 0 then
			shot(weapon, enemy.Head)
			i0 += 1
		end
		if i1 >= Hardness then
			i1 = 1
			task.wait()
		end
		i1 += 1
		i += 1
	end

	for _, v in connections do
		v:Disconnect()
	end
end)

example:AddButton("Select target", function()
	-- Player
	local mouse = Player:GetMouse()

	-- Detect part
	local UserInputService = game:GetService("UserInputService")
	local MAX_MOUSE_DISTANCE = 2400

	local function getPart()
		local mouseLocation = UserInputService:GetMouseLocation()

		-- Create a ray from the 2D mouseLocation
		local screenToWorldRay = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)

		-- The unit direction vector of the ray multiplied by a maximum distance
		local directionVector = screenToWorldRay.Direction * MAX_MOUSE_DISTANCE

		-- Raycast from the ray's origin towards its direction
		local raycastResult = workspace:Raycast(screenToWorldRay.Origin, directionVector)

		if raycastResult then
			return raycastResult.Instance
		end
	end

	local connection
	connection = mouse.Button1Down:Connect(function()
		local part = getPart()
		local target = part
		if part and part:IsDescendantOf(NPCs) then
			while target.Parent.Parent ~= NPCs do
				target = target.Parent
			end
			if highlight_instance then
				if highlight_instance.Parent ~= target then
					highlight_instance.Parent = target
				else
					highlight_instance:Destroy()
				end
			else
				highlight_instance = Instance.new("Highlight", target)
				highlight_instance.FillTransparency = 0.6
				highlight_instance.FillColor = Color3.fromRGB(8, 136, 255)
			end 
		end
		connection:Disconnect()
	end)
end)
