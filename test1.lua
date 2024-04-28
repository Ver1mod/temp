-- v10 Super (Perfomance)
-- Global Variables

coroutine.wrap(function()
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
	example0:AddToggle("Strength Mixture", function(state)
		auto_strength = state
		while auto_strength do
			pcall(function()
				if Player.Character.Humanoid.Health ~= 0 then
					local ohString2 = "Strength Mixture"
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
		auto_strength = state
		while auto_strength do
			pcall(function()
				if Player.Character.Humanoid.Health ~= 0 then
					local ohString2 = "Absorb Mixture"
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
	-- Auto bring items
	example0:AddButton("Teleport Device", function(state)
		local ohString2 = "Teleport Device"
		Use_Storage:FireServer("WITHDRAW", ohString2)
		Player.Backpack:WaitForChild(ohString2).Parent = Player.Character
		Player.Character:WaitForChild(ohString2).Use:FireServer(Vector3.new(0,0,0))
	end)

	example0:AddButton("Smoke Grenade", function(state)
		local ohString2 = "Smoke Grenade"
		Use_Storage:FireServer("WITHDRAW", ohString2)
	end)

	example0:AddButton("Scan Grenade", function(state)
		local ohString2 = "Scan Grenade"
		Use_Storage:FireServer("WITHDRAW", ohString2)
	end)

	example0:AddButton("Aura Grenade", function(state)
		local ohString2 = "Aura Grenade"
		Use_Storage:FireServer("WITHDRAW", ohString2)
	end)

	example0:AddButton("Deposit", function(state)
		local tool = Player.Character:FindFirstChildOfClass("Tool")
		if tool:GetAttribute("FromStorage") == true then
			Use_Storage:FireServer("DEPOSIT", tool.Name)
		end
	end)

	example0:AddButton("Bulk scrap", function(state)
		Player.PlayerGui.BulkScrap.Enabled = true
	end)

	-- Aimbot settings
	local RPM = 0
	example:AddBox("RPM", function(object, focus)
		if focus then
			RPM = 0
			pcall(function()
				RPM = 1/tonumber(object.Text)*60
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
				weapon.Main:FireServer("DAMAGE", {[1]=enemy,[2] = enemy.Position,[3]=100})
				weapon.Main:FireServer("AMMO")
			end
		end
	end

	-- Aimbot modes
	local autofarm = false
	example:AddToggle("Auto Farm Mobs(Ex)", function(state)
		autofarm = state
		while autofarm do
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
				until v.Parent.Humanoid.Health == 0 or autofarm == false
			end)
		end
	end)
end)()
