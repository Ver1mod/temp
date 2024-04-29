-- v10 Super (Minimalist)
-- Global Variables

-- Improved perfomance and added some features
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

	local Animation_speed = 60
	example:AddBox("Animation Speed", function(object, focus)
		if focus then
			Animation_speed = 60
			pcall(function()
				Animation_speed = tonumber(object.Text)
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
	local my_gun
	example:AddButton("Set main gun", function(state)
		if Player.Character:FindFirstChildOfClass("Tool"):GetAttribute("Ammo") ~= nil then
			my_gun = Player.Character:FindFirstChildOfClass("Tool")
			local gun = my_gun
			if gun:FindFirstChild("AntiDetection") then
				gun.AntiDetection:Destroy()
				gun.Grip = CFrame.new(gun.Grip.Position - gun.Grip.UpVector*30) * gun.Grip.Rotation
			end
			--Instance.new("StringValue", _G.my_gun.Parent).Name = "MyGun"
			for _, v in Player.Backpack:GetChildren() do
				if v.ClassName == "Tool" and v:GetAttribute("Ammo") ~= nil and not v:FindFirstChild("AntiDetection") then
					Instance.new("StringValue", v).Name = "AntiDetection"
					v.Grip = CFrame.new(v.Grip.Position + v.Grip.UpVector*30) * v.Grip.Rotation
				end
			end
		end
	end)

	local function auto_equip()
		for _, v in Player.Backpack:GetChildren() do
			if v:GetAttribute("Ammo") ~= nil then
				v.Parent = Player.Character
			end
		end
	end

	local time_test = false
	local animation
	local animloader
	local function shot_animation()
		if time_test == false then
			time_test = true

			pcall(function()
				if animloader == nil or animation.Parent ~= my_gun then
					animation = my_gun.ShootAnim
					animloader = my_gun.Parent.Humanoid:LoadAnimation(animation)
				end

				animloader:Play()
				wait(1/(my_gun:GetAttribute("RPM")/Animation_speed))
			end)

			time_test = false
		end
	end

	local function shot(weapon, enemy)
		if weapon:GetAttribute("Ammo") ~= nil then
			if Player:DistanceFromCharacter(enemy.Position) < weapon:GetAttribute("Range")*Range then
				weapon.Main:FireServer("MUZZLE", weapon.Handle.Barrel)
				weapon.Main:FireServer("DAMAGE", {[1]=enemy,[2] = enemy.Position,[3]=100})
				weapon.Main:FireServer("AMMO")
				coroutine.wrap(shot_animation)()
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

	-- Auto mod detection
	local connection
	local function scan_players()
		local names = ""
		local list = {
			"Homboor", 
			"Rynhex", 
			"yuji071", 
			"xXDrqgon", 
			"deaconwtx", 
			"Red_intern", 
			"TrueShadowSpear", 
			"GoszuGamer", 
			"luckyluke1281mia",
			"AntePavelicPoglavnik",
			"happysully07",
			"perciless",
			"Steven_XP23",
			"Chaosys",
			"hack_tested"
		}
		local mod = 0
		local iter = 0
		for _, player in game.Players:GetChildren() do --Get the table of players
			local name = player.Name --Nick of the loop's player
			for _, n in list do
				iter += 1
				if name == n then
					if names ~= "" then
						names = names .. ", " .. name
					else
						names = name
					end
					print(n)
					mod += 1
				end
			end
		end
		print("Number of iterations:", iter)
		if mod == 0 then
			game:GetService("CoreGui").UILibrary:FindFirstChildOfClass("Frame").Name = "0 mods"
			game:GetService("CoreGui").UILibrary:FindFirstChildOfClass("Frame").Window.Text = "0 mods"
			-- print("The server hasn't any moderators")
		else
			game:GetService("CoreGui").UILibrary:FindFirstChildOfClass("Frame").Name = "DISCONNECT RIGHT NOW!!!"
			game:GetService("CoreGui").UILibrary:FindFirstChildOfClass("Frame").Window.Text = "DISCONNECT RIGHT NOW!!!"
			print("The server has", mod, "moderators")
		end
	end
	scan_players()
	example:AddToggle("Auto Disconnect", function(state)
		_G.auto_disconnect = state
		connection = game.Players.PlayerAdded:Connect(function(player)
			if _G.auto_disconnect == false then
				connection:Disconnect()
			elseif _G.auto_disconnect == true then
				scan_players()
			end
		end)
	end)
end)()
