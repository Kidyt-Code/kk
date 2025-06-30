pcall(function()
    repeat task.wait() until game:IsLoaded()

    -- Services
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local ProximityPromptService = game:GetService("ProximityPromptService")

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Protect GUI for Xeno
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NoclipGUI"
    screenGui.ResetOnSpawn = false
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    end
    screenGui.Parent = playerGui

    -- Anti-AFK
    pcall(function()
        local vu = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            vu:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
        end)
    end)

    -- GUI Setup
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 300, 0, 210)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -105)
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
    title.Text = "Noclip & Godmode"
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

    local godModeButton = Instance.new("TextButton", mainFrame)
    godModeButton.Size = UDim2.new(0, 200, 0, 60)
    godModeButton.Position = UDim2.new(0.5, -100, 0, 140)
    godModeButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    godModeButton.Text = "God Mode Off"
    godModeButton.TextScaled = true
    godModeButton.Font = Enum.Font.GothamBold
    godModeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    godModeButton.BorderSizePixel = 0
    Instance.new("UICorner", godModeButton).CornerRadius = UDim.new(0, 8)
    local godButtonStroke = Instance.new("UIStroke", godModeButton)
    godButtonStroke.Color = Color3.fromRGB(170, 140, 0)
    godButtonStroke.Thickness = 3

    -- Core Logic
    local character = player.Character or player.CharacterAdded:Wait()
    local noclipOn = false
    local godModeOn = false
    local moveVec = Vector3.zero
    local speed = 50
    local noclipConnection
    local godModeConnection

    local function setPartsNoCollide()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    local function startNoclip()
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function(_, dt)
            if not character or not character.Parent then return end
            setPartsNoCollide()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                humanoid.PlatformStand = true
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
            if rootPart then
                rootPart.Anchored = true
                rootPart.AssemblyLinearVelocity = Vector3.zero
                rootPart.AssemblyAngularVelocity = Vector3.zero
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
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        if rootPart then
            rootPart.Anchored = false
        end
        moveVec = Vector3.zero
    end

    local function enableGodMode(enable)
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if enable then
            humanoid.MaxHealth = math.huge
            humanoid.Health = humanoid.MaxHealth
            if not godModeConnection then
                godModeConnection = humanoid.HealthChanged:Connect(function()
                    if godModeOn and humanoid.Health < humanoid.MaxHealth then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end)
            end
        else
            humanoid.MaxHealth = 100
            humanoid.Health = math.min(humanoid.Health, 100)
            if godModeConnection then
                godModeConnection:Disconnect()
                godModeConnection = nil
            end
        end
    end

    -- GUI Actions
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

    godModeButton.MouseButton1Click:Connect(function()
        godModeOn = not godModeOn
        enableGodMode(godModeOn)
        if godModeOn then
            godModeButton.Text = "God Mode On"
            godModeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
        else
            godModeButton.Text = "God Mode Off"
            godModeButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe or not noclipOn then return end
        if input.KeyCode == Enum.KeyCode.W then moveVec += Vector3.new(0, 0, 1)
        elseif input.KeyCode == Enum.KeyCode.S then moveVec += Vector3.new(0, 0, -1)
        elseif input.KeyCode == Enum.KeyCode.A then moveVec += Vector3.new(-1, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.D then moveVec += Vector3.new(1, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.Space then moveVec += Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then moveVec += Vector3.new(0, -1, 0)
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gpe)
        if gpe or not noclipOn then return end
        if input.KeyCode == Enum.KeyCode.W then moveVec -= Vector3.new(0, 0, 1)
        elseif input.KeyCode == Enum.KeyCode.S then moveVec -= Vector3.new(0, 0, -1)
        elseif input.KeyCode == Enum.KeyCode.A then moveVec -= Vector3.new(-1, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.D then moveVec -= Vector3.new(1, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.Space then moveVec -= Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then moveVec -= Vector3.new(0, -1, 0)
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not noclipOn then return end
        if moveVec.Magnitude < 0.01 then
            moveVec = Vector3.zero
        end
    end)

    player.CharacterAdded:Connect(function(char)
        character = char
        if noclipOn then startNoclip() end
        if godModeOn then enableGodMode(true) end
    end)

    -- Minimize & Close
    local originalSize = mainFrame.Size
    local minimizedSize = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 35)
    local minimized = false

    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and minimizedSize or originalSize
        TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = targetSize
        }):Play()
        minimizeBtn.Text = minimized and "+" or "-"
        button.Visible = not minimized
        godModeButton.Visible = not minimized
    end)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        stopNoclip()
        godModeOn = false
        enableGodMode(false)
    end)

    TweenService:Create(button, TweenInfo.new(0.5), {
        BackgroundTransparency = 0,
        TextTransparency = 0,
    }):Play()

    TweenService:Create(godModeButton, TweenInfo.new(0.5), {
        BackgroundTransparency = 0,
        TextTransparency = 0,
    }):Play()
end)
