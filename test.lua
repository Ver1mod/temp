-- v10 Super (Minimalist)
-- Global Variables
local Player = game.Players.LocalPlayer
local BulletReplication = game:GetService("ReplicatedStorage").BulletReplication.ReplicateClient
local Use_Storage = game:GetService("ReplicatedStorage").Remotes.UseStorage
local NPCs = game.Workspace.NPCs

function merge_tables(arg, value0)
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
example0:AddToggle("Strength Mixture", function(state)
	_G.auto_strength = state
	while _G.auto_strength do
		pcall(function()
			if Player.Character.Humanoid.Health ~= 0 then
				local ohString1 = "WITHDRAW"
				local ohString2 = "Strength Mixture"
				if not Player.Backpack:FindFirstChild("Strength Mixture") and not Player.Character:FindFirstChild("Strength Mixture") then
					Use_Storage:FireServer(ohString1, ohString2)
				end
				Player.Backpack:WaitForChild("Strength Mixture").Parent = Player.Character
				Player.Character:WaitForChild("Strength Mixture").Use:FireServer(Vector3.new(0,0,0))
				wait(15)
			end
		end)
		task.wait()
	end
end)

-- Auto bring items
example0:AddButton("Teleport Device", function(state)
	local ohString1 = "WITHDRAW"
	local ohString2 = "Teleport Device"
	Use_Storage:FireServer(ohString1, ohString2)
	Player.Backpack:WaitForChild(ohString2).Parent = Player.Character
	Player.Character:WaitForChild(ohString2).Use:FireServer(Vector3.new(0,0,0))
end)

example0:AddButton("Smoke Grenade", function(state)
	local ohString1 = "WITHDRAW"
	local ohString2 = "Smoke Grenade"
	Use_Storage:FireServer(ohString1, ohString2)
end)

example0:AddButton("Scan Grenade", function(state)
	local ohString1 = "WITHDRAW"
	local ohString2 = "Scan Grenade"
	Use_Storage:FireServer(ohString1, ohString2)
end)

example0:AddButton("Aura Grenade", function(state)
	local ohString1 = "WITHDRAW"
	local ohString2 = "Aura Grenade"
	Use_Storage:FireServer(ohString1, ohString2)
end)

-- Aimbot settings
example:AddBox("RPM", function(object, focus)
	if focus then
		_G.RPM = 0
		pcall(function()
			_G.RPM = 1/tonumber(object.Text)*60
		end)
	end
end)

example:AddBox("Range", function(object, focus)
	if focus then
		_G.Range = 3
		pcall(function()
			_G.Range = tonumber(object.Text)
		end)
	end
end)

-- Backpack hack
example:AddToggle("Enable backpack bag", function(state)
	_G.backpack_hack = state
	while _G.backpack_hack do
		pcall(function()
			fireproximityprompt(Player.Character.BackpackBag.Handle.Template)
		end)
		wait(1)
	end
end)

-- Aimbot modules
function shot(weapon, enemy)
	if weapon:GetAttribute("Ammo") ~= nil then
		if Player:DistanceFromCharacter(enemy.Position) < weapon:GetAttribute("Range")*_G.Range then
			weapon.Main:FireServer("MUZZLE", weapon.Handle.Barrel)
			weapon.Main:FireServer("DAMAGE", {[1]=enemy,[2] = enemy.Position,[3]=100})
			weapon.Main:FireServer("AMMO")
		end
	end
end

function auto_equip()
	for _, v in Player.Backpack:GetChildren() do
		local Ignored = v.Name == "Bloxy Cola" or v.Name == "Focus Potion"
		if v:GetAttribute("Ammo") ~= nil or Ignored then
			v.Parent = Player.Character
		end
	end
end

-- Aimbot modes
example:AddToggle("Auto Farm Mobs(Ex)", function(state)
	_G.autofarm = state
	while _G.autofarm do
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
					task.wait(_G.RPM)
				end
			end
		end)
		task.wait()
	end
end)

example:AddToggle("Auto Farm Mobs", function(state)
	_G.autofarm = state
	while _G.autofarm do
		wait()
		pcall(function()
			local enemy
			local distance = 9216

			local enemies = merge_tables(
				NPCs.Monsters:GetChildren(), 
				NPCs.Tango:GetChildren()
			)

			for i,v in enemies do
				if Player:DistanceFromCharacter(v.Head.Position) < distance then
					enemy = v
					distance = Player:DistanceFromCharacter(v.Head.Position)
				end
			end

			local v = enemy.Head
			repeat task.wait()
				auto_equip()
				for _, tool in Player.Character:GetChildren() do
					shot(tool, v)
				end
			until v.Parent.Humanoid.Health == 0 or _G.autofarm == false
		end)
	end
end)

function shot0(weapon, enemy)
	if weapon:GetAttribute("Ammo") ~= nil then
		if Player:DistanceFromCharacter(enemy.Position) < weapon:GetAttribute("Range")*_G.Range then
			weapon.Main:FireServer("MUZZLE", weapon.Handle.Barrel)
			for i = 1, 4 do
				weapon.Main:FireServer("DAMAGE", {[1]=enemy,[2] = enemy.Position,[3]=100})
			end
			weapon.Main:FireServer("AMMO")
		end
	end
end

example:AddToggle("Smart Fire", function(state)
	_G.autofarm = state
	while _G.autofarm do
		wait()
		pcall(function()
			local enemy
			local distance = 9216

			local enemies = merge_tables(
				NPCs.Monsters:GetChildren(), 
				NPCs.Tango:GetChildren()
			)

			for i,v in enemies do
				if Player:DistanceFromCharacter(v.Head.Position) < distance then
					enemy = v
					distance = Player:DistanceFromCharacter(v.Head.Position)
				end
			end

			local v = enemy.Head
			repeat task.wait()
				auto_equip()
				for _, tool in Player.Character:GetChildren() do
					shot0(tool, v)
				end
			until v.Parent.Humanoid.Health == 0 or _G.autofarm == false
		end)
	end
end)

-- Aimbot settings
example:AddBox("Shots", function(object, focus)
	if focus then
		_G.Shots = 0
		pcall(function()
			_G.Shots = tonumber(object.Text)
		end)
	end
end)

example:AddButton("Shoot", function()
	_G.autofarm = not _G.autofarm
	local enemy
	local distance = 9216

	local enemies = merge_tables(
		NPCs.Monsters:GetChildren(), 
		NPCs.Tango:GetChildren()
	)

	for i,v in enemies do
		if Player:DistanceFromCharacter(v.Head.Position) < distance then
			enemy = v
			distance = Player:DistanceFromCharacter(v.Head.Position)
		end
	end

	local v = enemy.Head
	for i = 1, _G.Shots do
		auto_equip()
		for _, tool in Player.Character:GetChildren() do
			shot0(tool, v)
		end
		if v.Parent.Humanoid.Health == 0 or _G.autofarm == false then
			break
		end
	end
end)
