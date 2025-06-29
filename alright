local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoclipGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local frameStroke = Instance.new("UIStroke", mainFrame)
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(50, 50, 50)

-- Header bar
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)
header.ClipsDescendants = true

-- Title label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "K's Noclip"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -60, 0.5, -12)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextScaled = true
minimizeBtn.Parent = header
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Noclip toggle button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 60)
button.Position = UDim2.new(0.5, -100, 0, 70)
button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
button.Text = "Noclip Off"
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.TextColor3 = Color3.fromRGB(0, 0, 0)
button.BorderSizePixel = 0
button.Parent = mainFrame
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
local buttonStroke = Instance.new("UIStroke", button)
buttonStroke.Color = Color3.fromRGB(0, 50, 100)
buttonStroke.Thickness = 3
buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local PhysicsService = game:GetService("PhysicsService")

local character = player.Character or player.CharacterAdded:Wait()
local noclipConnection
local noclipOn = false

-- Variables for fly controls
local speed = 50
local moveVec = Vector3.zero
local flying = false

local function setCollisions(state)
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = state
			part.Anchored = false
			if noclipOn then
				pcall(function()
					part.CollisionGroup = "NoCollide"
				end)
			else
				pcall(function()
					part.CollisionGroup = "Default"
				end)
			end
		end
	end
end

local function startNoclip()
	if noclipConnection then noclipConnection:Disconnect() end
	flying = true
	noclipConnection = RunService.Stepped:Connect(function(_, delta)
		if not character or not character.Parent then return end
		setCollisions(false)

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local rootPart = character:FindFirstChild("HumanoidRootPart")

		if humanoid then
			humanoid.PlatformStand = true
			if humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
				humanoid:ChangeState(Enum.HumanoidStateType.Physics)
			end
		end

		if rootPart then
			-- Freeze velocity
			rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

			-- Move character according to inputs
			if flying then
				local camera = workspace.CurrentCamera
				local lookVector = camera.CFrame.LookVector
				local rightVector = camera.CFrame.RightVector

				local moveDirection = Vector3.new(0,0,0)
				moveDirection += moveVec.Z * lookVector
				moveDirection += moveVec.X * rightVector
				moveDirection = moveDirection.Unit * speed
				if moveVec.Magnitude == 0 then
					moveDirection = Vector3.new(0,0,0)
				end

				rootPart.CFrame = rootPart.CFrame + moveDirection * delta
			end
		end
	end)
end

local function stopNoclip()
	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end
	flying = false
	setCollisions(true)

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.PlatformStand = false
		if humanoid:GetState() == Enum.HumanoidStateType.Physics then
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end
end

button.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	if noclipOn then
		startNoclip()
		button.Text = "Noclip On"
		button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
	else
		stopNoclip()
		button.Text = "Noclip Off"
		button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
	end
end)

-- Input handling for flying
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if not noclipOn then return end

	if input.KeyCode == Enum.KeyCode.W then
		moveVec = moveVec + Vector3.new(0, 0, 1)
	elseif input.KeyCode == Enum.KeyCode.S then
		moveVec = moveVec + Vector3.new(0, 0, -1)
	elseif input.KeyCode == Enum.KeyCode.A then
		moveVec = moveVec + Vector3.new(-1, 0, 0)
	elseif input.KeyCode == Enum.KeyCode.D then
		moveVec = moveVec + Vector3.new(1, 0, 0)
	elseif input.KeyCode == Enum.KeyCode.Space then
		moveVec = moveVec + Vector3.new(0, 1, 0)
	elseif input.KeyCode == Enum.KeyCode.LeftControl then
		moveVec = moveVec + Vector3.new(0, -1, 0)
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if not noclipOn then return end

	if input.KeyCode == Enum.KeyCode.W then
		moveVec = moveVec - Vector3.new(0, 0, 1)
	elseif input.KeyCode == Enum.KeyCode.S then
		moveVec = moveVec - Vector3.new(0, 0, -1)
	elseif input.KeyCode == Enum.KeyCode.A then
		moveVec = moveVec - Vector3.new(-1, 0, 0)
	elseif input.KeyCode == Enum.KeyCode.D then
		moveVec = moveVec - Vector3.new(1, 0, 0)
	elseif input.KeyCode == Enum.KeyCode.Space then
		moveVec = moveVec - Vector3.new(0, 1, 0)
	elseif input.KeyCode == Enum.KeyCode.LeftControl then
		moveVec = moveVec - Vector3.new(0, -1, 0)
	end
end)

-- Reconnect on respawn
player.CharacterAdded:Connect(function(char)
	character = char
	if noclipOn then
		startNoclip()
	end
end)

local function fadeInButton()
	local tween = TweenService:Create(button, TweenInfo.new(0.3), {
		BackgroundTransparency = 0,
		TextTransparency = 0,
	})
	tween:Play()
end

task.wait(0.1)
fadeInButton()
