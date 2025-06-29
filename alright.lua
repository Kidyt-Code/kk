repeat wait() until game:IsLoaded()

local success, err = pcall(function()
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local PhysicsService = game:GetService("PhysicsService")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- GUI
    local screenGui = Instance.new("ScreenGui", playerGui)
    screenGui.Name = "NoclipGUI"
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 300, 0, 150)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.Active = true
    mainFrame.Draggable = true

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    local frameStroke = Instance.new("UIStroke", mainFrame)
    frameStroke.Thickness = 2
    frameStroke.Color = Color3.fromRGB(50, 50, 50)

    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)
    header.ClipsDescendants = true

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -70, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "K's Noclip"
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

    local button = Instance.new("TextButton", mainFrame)
    button.Size = UDim2.new(0, 200, 0, 60)
    button.Position = UDim2.new(0.5, -100, 0, 70)
    button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    button.Text = "Noclip Off"
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.TextColor3 = Color3.fromRGB(0, 0, 0)
    button.BorderSizePixel = 0
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    local buttonStroke = Instance.new("UIStroke", button)
    buttonStroke.Color = Color3.fromRGB(0, 50, 100)
    buttonStroke.Thickness = 3
    buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Noclip logic
    local character = player.Character or player.CharacterAdded:Wait()
    local noclipConnection
    local noclipOn = false
    local speed = 50
    local moveVec = Vector3.zero
    local flying = false

    local function setCollisions(state)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = state
                part.Anchored = false
                pcall(function()
                    part.CollisionGroup = noclipOn and "NoCollide" or "Default"
                end)
            end
        end
    end

    local function startNoclip()
        if noclipConnection then noclipConnection:Disconnect() end
        flying = true
        noclipConnection = RunService.Stepped:Connect(function(_, dt)
            if not character or not character.Parent then return end
            setCollisions(false)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                humanoid.PlatformStand = true
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
            if rootPart then
                rootPart.AssemblyLinearVelocity = Vector3.zero
                local cam = workspace.CurrentCamera
                local move = Vector3.zero
                move += cam.CFrame.LookVector * moveVec.Z
                move += cam.CFrame.RightVector * moveVec.X
                move += Vector3.new(0, moveVec.Y, 0)
                if move.Magnitude > 0 then
                    rootPart.CFrame = rootPart.CFrame + move.Unit * speed * dt
                end
            end
        end)
    end

    local function stopNoclip()
        if noclipConnection then noclipConnection:Disconnect() end
        flying = false
        setCollisions(true)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
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

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp or not noclipOn then return end
        if input.KeyCode == Enum.KeyCode.W then moveVec += Vector3.new(0,0,1)
        elseif input.KeyCode == Enum.KeyCode.S then moveVec += Vector3.new(0,0,-1)
        elseif input.KeyCode == Enum.KeyCode.A then moveVec += Vector3.new(-1,0,0)
        elseif input.KeyCode == Enum.KeyCode.D then moveVec += Vector3.new(1,0,0)
        elseif input.KeyCode == Enum.KeyCode.Space then moveVec += Vector3.new(0,1,0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then moveVec += Vector3.new(0,-1,0)
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gp)
        if gp or not noclipOn then return end
        if input.KeyCode == Enum.KeyCode.W then moveVec -= Vector3.new(0,0,1)
        elseif input.KeyCode == Enum.KeyCode.S then moveVec -= Vector3.new(0,0,-1)
        elseif input.KeyCode == Enum.KeyCode.A then moveVec -= Vector3.new(-1,0,0)
        elseif input.KeyCode == Enum.KeyCode.D then moveVec -= Vector3.new(1,0,0)
        elseif input.KeyCode == Enum.KeyCode.Space then moveVec -= Vector3.new(0,1,0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then moveVec -= Vector3.new(0,-1,0)
        end
    end)

    player.CharacterAdded:Connect(function(char)
        character = char
        if noclipOn then startNoclip() end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        stopNoclip()
    end)

    minimizeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        minimizeBtn.Text = mainFrame.Visible and "-" or "+"
    end)

    TweenService:Create(button, TweenInfo.new(0.3), {
        BackgroundTransparency = 0,
        TextTransparency = 0,
    }):Play()
end)

if not success then
    warn("[Noclip Error] -", err)
end
