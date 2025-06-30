-- FULL FLY & GOD MODE GUI SCRIPT
repeat wait() until game:IsLoaded()

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI Setup
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "FlyGUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 280)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(50, 50, 50)

local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Fly & Godmode"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -60, 0.5, -12)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextScaled = true
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local flyButton = Instance.new("TextButton", mainFrame)
flyButton.Size = UDim2.new(0, 200, 0, 60)
flyButton.Position = UDim2.new(0.5, -100, 0, 70)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
flyButton.Text = "Fly Off"
flyButton.TextScaled = true
flyButton.Font = Enum.Font.GothamBold
flyButton.TextColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0, 8)

local godModeButton = Instance.new("TextButton", mainFrame)
godModeButton.Size = UDim2.new(0, 200, 0, 60)
godModeButton.Position = UDim2.new(0.5, -100, 0, 140)
godModeButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
godModeButton.Text = "God Mode Off"
godModeButton.TextScaled = true
godModeButton.Font = Enum.Font.GothamBold
godModeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", godModeButton).CornerRadius = UDim.new(0, 8)

local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Size = UDim2.new(0, 200, 0, 25)
speedLabel.Position = UDim2.new(0.5, -100, 0, 210)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Fly Speed: 30"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextScaled = true

local speedBox = Instance.new("TextBox", mainFrame)
speedBox.Size = UDim2.new(0, 200, 0, 25)
speedBox.Position = UDim2.new(0.5, -100, 0, 240)
speedBox.PlaceholderText = "Set Speed"
speedBox.Text = ""
speedBox.Font = Enum.Font.Gotham
speedBox.TextScaled = true
speedBox.TextColor3 = Color3.new(0, 0, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)

-- Fly & GodMode Logic
local character = player.Character or player.CharacterAdded:Wait()
local flying = false
local flySpeed = 30
local moveVec = Vector3.zero
local flyConn, godConn

local function startFly()
	local root = character:WaitForChild("HumanoidRootPart")
	flyConn = RunService.RenderStepped:Connect(function(dt)
		local cam = workspace.CurrentCamera
		local move = cam.CFrame.LookVector * moveVec.Z + cam.CFrame.RightVector * moveVec.X + Vector3.new(0, moveVec.Y, 0)
		root.Velocity = move.Magnitude > 0 and move.Unit * flySpeed or Vector3.zero
	end)
end

local function stopFly()
	if flyConn then flyConn:Disconnect() flyConn = nil end
	local root = character:FindFirstChild("HumanoidRootPart")
	if root then root.Velocity = Vector3.zero end
end

flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		startFly()
		flyButton.Text = "Fly On"
	else
		stopFly()
		flyButton.Text = "Fly Off"
	end
end)

speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val and val > 0 then
		flySpeed = val
		speedLabel.Text = "Fly Speed: " .. tostring(val)
	end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or not flying then return end
	local map = {
		W = Vector3.new(0, 0, 1), S = Vector3.new(0, 0, -1),
		A = Vector3.new(-1, 0, 0), D = Vector3.new(1, 0, 0),
		Space = Vector3.new(0, 1, 0), LeftControl = Vector3.new(0, -1, 0)
	}
	if map[input.KeyCode.Name] then moveVec += map[input.KeyCode.Name] end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
	if gpe or not flying then return end
	local map = {
		W = Vector3.new(0, 0, 1), S = Vector3.new(0, 0, -1),
		A = Vector3.new(-1, 0, 0), D = Vector3.new(1, 0, 0),
		Space = Vector3.new(0, 1, 0), LeftControl = Vector3.new(0, -1, 0)
	}
	if map[input.KeyCode.Name] then moveVec -= map[input.KeyCode.Name] end
end)

local function godMode(enable)
	local h = character and character:FindFirstChildOfClass("Humanoid")
	if not h then return end
	if enable then
		h.MaxHealth = math.huge
		h.Health = h.MaxHealth
		godConn = h.HealthChanged:Connect(function()
			if h.Health < h.MaxHealth then h.Health = h.MaxHealth end
		end)
	else
		if godConn then godConn:Disconnect() end
		h.MaxHealth = 100
		h.Health = math.min(h.Health, 100)
	end
end

godModeButton.MouseButton1Click:Connect(function()
	godModeOn = not godModeOn
	godMode(godModeOn)
	godModeButton.Text = godModeOn and "God Mode On" or "God Mode Off"
end)

player.CharacterAdded:Connect(function(char)
	character = char
	if flying then task.wait(1) startFly() end
	if godModeOn then task.wait(1) godMode(true) end
end)

-- GUI Controls
minimizeBtn.MouseButton1Click:Connect(function()
	local min = mainFrame.Size.Y.Offset > 100
	local newSize = min and UDim2.new(0, 300, 0, 35) or UDim2.new(0, 300, 0, 280)
	TweenService:Create(mainFrame, TweenInfo.new(0.25), {Size = newSize}):Play()
	minimizeBtn.Text = min and "+" or "-"
	flyButton.Visible = not min
	godModeButton.Visible = not min
	speedLabel.Visible = not min
	speedBox.Visible = not min
end)

closeBtn.MouseButton1Click:Connect(function()
	stopFly()
	if godConn then godConn:Disconnect() end
	screenGui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F then
		flying = not flying
		if flying then
			startFly()
			flyButton.Text = "Fly On"
		else
			stopFly()
			flyButton.Text = "Fly Off"
		end
	end
end)
