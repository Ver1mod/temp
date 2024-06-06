local create = {}
local Player = game.Players.LocalPlayer
create.__index = create

function create.Invoke(ohString1, ohString2, ohCFrame3, ohInstance4)
	Player.Character.F3X.SyncAPI.ServerEndpoint:InvokeServer(ohString1, ohString2, ohCFrame3, ohInstance4)
end

function create:CreatePart()
	self.Invoke("CreatePart", "Normal", CFrame.new(0,10,0), workspace)
end

--create:CreatePart()

function create:SyncColor()
	local ohTable2 = self:GetProperties({"Color"})
	self.Invoke("SyncColor", ohTable2)
end

function create:SyncResize()
	local ohTable2 = self:GetProperties({"CFrame", "Size"})
	self.Invoke("SyncResize", ohTable2)
end

function create:SyncCollision()
	local ohTable2 = self:GetProperties({"CanCollide"})
	self.Invoke("SyncCollision", ohTable2)
end

function create:SyncMaterial()
	local ohTable2 = self:GetProperties({"Transparency", "Reflectance", "Material"})
	self.Invoke("SyncMaterial", ohTable2)
end

--Create mesh
function create:CreateMeshes()
	local ohTable2 = self:GetProperties({})
	self.Invoke("CreateMeshes", ohTable2)
end

function create:SyncMesh()
	local ohTable2 = self:GetProperties({"MeshType", "MeshId", "TextureId"})
	for _, v in ohTable2 do
		if v.MeshType then
			self.Invoke("SyncMesh", ohTable2)
		end
	end
end

--Create decal
function create:CreateTextures(i)
	local ohTable2 = self:GetProperties({"Face", "TextureType"})
	self.Invoke("CreateTextures", create:SetList(ohTable2))
end

--function create:SyncTexture(i)
--	local ohTable2 = {
--		[1] = {
--			["Part"] = self.part,
--			["Face"] = self.texture_face[i],
--			["TextureType"] = self.texture_type[i],
--			["Texture"] = self.texture_id[i]
--		}
--	}
--	self.Invoke("SyncTexture", ohTable2)
--end

--function create:SyncTexture(i)
--	local ohTable2 = self:GetProperties({"Face", "TextureType", "Texture"})
--	self.Invoke("SyncTexture", ohTable2)
--end

-- test
function create:SetPath(Id, Position)
	self.path = game:GetObjects(Id)[1]
	self.path.Parent = workspace
	self.path.Name = "test_structure"
	self.path:MoveTo(Position)
end

function create:SetParts2Load()
	local function size_of_f3x()
		local test = 0
		for i, v in workspace.F3XBuilt:GetChildren() do
			v.Name = i
			test += 1
		end
		return test
	end
	self.Parts2Load = {}
	local i = 1
	local size_of_f3x = size_of_f3x()
	for _, v in self.path:GetDescendants() do
		if v:IsA("BasePart") then
			local target = workspace.F3XBuilt[tostring(i)]
			self.Parts2Load[i] = {
				["Part"] = target,
				["CFrame"] = v.CFrame,
				["Size"] = v.Size,
				["Color"] = v.Color,
				["CanCollide"] = v.CanCollide,
				["Transparency"] = v.Transparency,
				["Material"] = v.Material,
				["Reflectance"] = v.Reflectance
			}
			local mesh = v:FindFirstChildOfClass("DataModelMesh")
			if mesh then
				self.Parts2Load[i].MeshType = mesh.MeshType
				if mesh.MeshId then
					self.Parts2Load[i].MeshId = mesh.MeshId
				end
				if mesh.TextureId then
					self.Parts2Load[i].TextureId = mesh.TextureId
				end
			end
			i += 1
			if size_of_f3x < i then
				break
			end
		end
	end
end

function create:GetProperties(required)
	local ohTable = {}
	for i, v in self.Parts2Load do
		ohTable[i] = {}
		ohTable[i].Part = v.Part
		for i0, v0 in required do
			ohTable[i][v0] = v[v0]
		end
	end
	return ohTable
end

function create:SyncPart()
	self:SetParts2Load()

	self:SyncColor()
	self:SyncResize()
	self:SyncCollision()
	self:SyncMaterial()


	self:CreateMeshes()
	self:SyncMesh()
end

function create:Activate()
	self.nparts = 0
	self.loaded_parts = 0
	for _, v in self.path:GetDescendants() do
		if v.ClassName == "Part" then
			coroutine.wrap(function()
				create:CreatePart()
			end)()
			self.nparts += 1
		end
	end
	-- Check if a child was added to self.path
	--self.path.ChildAdded:Connect(function(child)
	--	self.loaded_parts += 1
	--	if self.loaded_parts >= self.nparts then
	--		print("Almost done")
	--		create:SyncPart()
	--	end
	--end)
end

if not workspace.test_structure then
	create:SetPath("rbxassetid://984809285", Vector3.new(0,10,0))
else
	create.path = workspace.test_structure
end

create:Activate()
print("Done")

workspace.test_structure:Destroy()
