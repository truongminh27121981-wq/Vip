-- KHỞI TẠO SCREEN_GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "ChoHauSidaMenu_" .. tostring(math.random(100000, 999999))
ScreenGui.ResetOnSpawn = false

-- DỊCH VỤ CẦN THIẾT
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- BIẾN CẤU HÌNH
local CustomSpeed = 16
local MaxSpeedLimit = 40

local HitboxEnabled = false
local HitboxSize = 2
local MaxHitboxLimit = 50

-- MỚI: Jump (độ nhảy)
local CustomJump = 50
local MaxJumpLimit = 70

-- HÀM KÉO THẢ GIAO DIỆN (MƯỢT MÀ MOBILE & PC)
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- 1. NÚT ICON BẬT/TẮT MENU CHÍNH
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "MenuIcon"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleButton.Position = UDim2.new(0, 15, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.fromRGB(255, 69, 0)
ToggleButton.TextSize = 24
MakeDraggable(ToggleButton)

local ToggleCorner = Instance.new("UICorner", ToggleButton)
ToggleCorner.CornerRadius = UDim.new(0, 12)

local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(255, 69, 0)

-- 2. BẢNG MENU CHÍNH ("chó hậu sida")
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainPanel"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -95)
MainFrame.Size = UDim2.new(0, 250, 0, 360)
MainFrame.Active = true
MainFrame.Visible = true
MakeDraggable(MainFrame)

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(50, 50, 50)

-- TIÊU ĐỀ MENU
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "chó hậu sida 🐕🦠"
TitleLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16

-- NÚT X (ẨN BẢNG)
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.Position = UDim2.new(0.88, 0, 0.05, 0)
CloseButton.Size = UDim2.new(0, 18, 0, 18)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

-- CONTAINER CHỨC NĂNG
local Container = Instance.new("Frame")
Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 40)
Container.Size = UDim2.new(1, -20, 1, -50)
Container.BackgroundTransparency = 1

----------------------------------------------------
-- CHỨC NĂNG 1: THANH TRƯỢT TỐC ĐỘ (SLIDER 1-40) + ANTI-LAG/ANTI-CHEAT BACK
----------------------------------------------------
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = Container
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 5)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Tốc độ chạy: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpeedSlider = Instance.new("TextButton")
SpeedSlider.Parent = Container
SpeedSlider.Size = UDim2.new(1, 0, 0, 14)
SpeedSlider.Position = UDim2.new(0, 0, 0, 28)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedSlider.Text = ""
Instance.new("UICorner", SpeedSlider).CornerRadius = UDim.new(0, 7)

local SpeedFill = Instance.new("Frame")
SpeedFill.Parent = SpeedSlider
SpeedFill.Size = UDim2.new((16 - 1) / (MaxSpeedLimit - 1), 0, 1, 0)
SpeedFill.BackgroundColor3 = Color3.fromRGB(255, 69, 0)
Instance.new("UICorner", SpeedFill).CornerRadius = UDim.new(0, 7)

local SlidingSpeed = false

local function UpdateSpeedSlider(input)
    local mousePos = input.Position.X
    local sliderPos = SpeedSlider.AbsolutePosition.X
    local sliderWidth = SpeedSlider.AbsoluteSize.X
    if sliderWidth <= 0 then return end
    
    local percentage = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
    SpeedFill.Size = UDim2.new(percentage, 0, 1, 0)
    
    CustomSpeed = math.floor(1 + (percentage * (MaxSpeedLimit - 1)))
    SpeedLabel.Text = "Tốc độ chạy: " .. tostring(CustomSpeed)
end

SpeedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        SlidingSpeed = true
        UpdateSpeedSlider(input)
    end
end)

----------------------------------------------------
-- CHỨC NĂNG 2: THANH TRƯỢT HITBOX (SLIDER 1-50)
----------------------------------------------------
local HitboxLabel = Instance.new("TextLabel")
HitboxLabel.Parent = Container
HitboxLabel.Size = UDim2.new(1, 0, 0, 20)
HitboxLabel.Position = UDim2.new(0, 0, 0, 55)
HitboxLabel.BackgroundTransparency = 1
HitboxLabel.Text = "Kích thước Hitbox: 2 (TẮT)"
HitboxLabel.TextColor3 = Color3.fromRGB(230, 75, 75)
HitboxLabel.Font = Enum.Font.SourceSansBold
HitboxLabel.TextSize = 14
HitboxLabel.TextXAlignment = Enum.TextXAlignment.Left

local HitboxSlider = Instance.new("TextButton")
HitboxSlider.Parent = Container
HitboxSlider.Size = UDim2.new(1, 0, 0, 14)
HitboxSlider.Position = UDim2.new(0, 0, 0, 78)
HitboxSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HitboxSlider.Text = ""
Instance.new("UICorner", HitboxSlider).CornerRadius = UDim.new(0, 7)

local HitboxFill = Instance.new("Frame")
HitboxFill.Parent = HitboxSlider
HitboxFill.Size = UDim2.new((2 - 1) / (MaxHitboxLimit - 1), 0, 1, 0)
HitboxFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
Instance.new("UICorner", HitboxFill).CornerRadius = UDim.new(0, 7)

local SlidingHitbox = false

local function UpdateHitboxSlider(input)
    local mousePos = input.Position.X
    local sliderPos = HitboxSlider.AbsolutePosition.X
    local sliderWidth = HitboxSlider.AbsoluteSize.X
    if sliderWidth <= 0 then return end
    
    local percentage = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
    HitboxFill.Size = UDim2.new(percentage, 0, 1, 0)
    
    HitboxSize = math.floor(1 + (percentage * (MaxHitboxLimit - 1)))
    
    if HitboxSize > 2 then
        HitboxEnabled = true
        HitboxLabel.Text = "Kích thước Hitbox: " .. tostring(HitboxSize) .. " (BẬT)"
        HitboxLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    else
        HitboxEnabled = false
        HitboxLabel.Text = "Kích thước Hitbox: 2 (TẮT)"
        HitboxLabel.TextColor3 = Color3.fromRGB(230, 75, 75)
    end
end

HitboxSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        SlidingHitbox = true
        UpdateHitboxSlider(input)
    end
end)

----------------------------------------------------
-- MỚI: CHỨC NĂNG 3: THANH TRƯỢT ĐỘ NHẢY (SLIDER 1-70)
----------------------------------------------------
local JumpLabel = Instance.new("TextLabel")
JumpLabel.Parent = Container
JumpLabel.Size = UDim2.new(1, 0, 0, 20)
JumpLabel.Position = UDim2.new(0, 0, 0, 105)
JumpLabel.BackgroundTransparency = 1
JumpLabel.Text = "Độ nhảy: " .. tostring(CustomJump)
JumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpLabel.Font = Enum.Font.SourceSansBold
JumpLabel.TextSize = 14
JumpLabel.TextXAlignment = Enum.TextXAlignment.Left

local JumpSlider = Instance.new("TextButton")
JumpSlider.Parent = Container
JumpSlider.Size = UDim2.new(1, 0, 0, 14)
JumpSlider.Position = UDim2.new(0, 0, 0, 128)
JumpSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JumpSlider.Text = ""
Instance.new("UICorner", JumpSlider).CornerRadius = UDim.new(0, 7)

local JumpFill = Instance.new("Frame")
JumpFill.Parent = JumpSlider
JumpFill.Size = UDim2.new((CustomJump - 1) / (MaxJumpLimit - 1), 0, 1, 0)
JumpFill.BackgroundColor3 = Color3.fromRGB(100, 149, 237)
Instance.new("UICorner", JumpFill).CornerRadius = UDim.new(0, 7)

local SlidingJump = false

local function UpdateJumpSlider(input)
    local mousePos = input.Position.X
    local sliderPos = JumpSlider.AbsolutePosition.X
    local sliderWidth = JumpSlider.AbsoluteSize.X
    if sliderWidth <= 0 then return end

    local percentage = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
    JumpFill.Size = UDim2.new(percentage, 0, 1, 0)

    CustomJump = math.floor(1 + (percentage * (MaxJumpLimit - 1)))
    JumpLabel.Text = "Độ nhảy: " .. tostring(CustomJump)
end

JumpSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        SlidingJump = true
        UpdateJumpSlider(input)
    end
end)

----------------------------------------------------
-- NÚT COPY CODE
----------------------------------------------------
local CopyButton = Instance.new("TextButton")
CopyButton.Parent = Container
CopyButton.Size = UDim2.new(1, 0, 0, 28)
CopyButton.Position = UDim2.new(0, 0, 0, 205)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
CopyButton.Text = "Copy Code"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 14
Instance.new("UICorner", CopyButton).CornerRadius = UDim.new(0, 7)

CopyButton.MouseButton1Click:Connect(function()
    local scriptCode = [[-- SCRIPT SIÊU KHỎE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local CustomSpeed = 16
local CustomJump = 50
local CustomFlySpeed = 1
local FlyEnabled = false
local FlyBodyVelocity = nil
local FlyCamera = workspace.CurrentCamera

-- BẬT/TẮT FLY
local function StopFly()
    FlyEnabled = false
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end
end

local function StartFly()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    FlyEnabled = true
    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyBodyVelocity.Parent = hrp
end

-- CHẠY NHANH & NHẢY CAO
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and hrp and humanoid.Health > 0 then
            humanoid.WalkSpeed = CustomSpeed
            pcall(function()
                humanoid.UseJumpPower = true
                humanoid.JumpPower = CustomJump
            end)
        end
    end
end)

-- ĐIỀU KHIỂN BAY
RunService.RenderStepped:Connect(function()
    if FlyEnabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and FlyBodyVelocity then
            local camera = FlyCamera
            local moveDir = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
            FlyBodyVelocity.Velocity = FlyBodyVelocity.Velocity:Lerp(moveDir * CustomFlySpeed, 0.2)
        end
    end
end)

-- BẬT/TẮT FLY VỚI PHÍM
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F then
        if FlyEnabled then
            StopFly()
        else
            StartFly()
        end
    end
end)

-- DỪNG KHI CHẾT
Players.LocalPlayer.CharacterAdded:Connect(function()
    StopFly()
end)

-- ĐIỀU CHỈNH TỐC ĐỘ
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == Enum.KeyCode.E then CustomFlySpeed = math.min(CustomFlySpeed + 5, 50) end
        if input.KeyCode == Enum.KeyCode.Q then CustomFlySpeed = math.max(CustomFlySpeed - 5, 1) end
    end
end)
]]
    
    setclipboard(scriptCode)
    CopyButton.Text = "✓ Đã Copy!"
    CopyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    
    task.wait(2)
    CopyButton.Text = "Copy Code"
    CopyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
end)

-- GỘP SỰ KIỆN ĐIỀU HƯỚNG INPUT TRƯỢT ĐỂ TRÁNH XUNG ĐỘT
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if SlidingSpeed then UpdateSpeedSlider(input) end
        if SlidingHitbox then UpdateHitboxSlider(input) end
        if SlidingJump then UpdateJumpSlider(input) end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        SlidingSpeed = false
        SlidingHitbox = false
        SlidingJump = false
    end
end)

----------------------------------------------------
-- VÒNG LẶP QUÉT VÀ THỰC THI HITBOX BIẾN THIÊN (1-50)
----------------------------------------------------
task.spawn(function()
    while task.wait(0.3) do
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                
                if hrp and humanoid and humanoid.Health > 0 then
                    if HitboxEnabled then
                        hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                        hrp.Transparency = 0.7
                        hrp.Color = Color3.fromRGB(255, 0, 0)
                        hrp.Material = Enum.Material.Neon
                        hrp.CanCollide = false
                    else
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.Color = Color3.fromRGB(163, 162, 165)
                        hrp.Material = Enum.Material.Plastic
                        hrp.CanCollide = false
                    end
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoid and hrp and humanoid.Health > 0 then
            if CustomSpeed > 16 then
                humanoid.WalkSpeed = CustomSpeed
                if humanoid.MoveDirection.Magnitude > 0 then
                    hrp.Velocity = humanoid.MoveDirection * CustomSpeed + Vector3.new(0, hrp.Velocity.Y, 0)
                end
            else
                humanoid.WalkSpeed = 16
            end

            if humanoid:IsA("Humanoid") then
                pcall(function()
                    humanoid.UseJumpPower = true
                end)
                pcall(function()
                    humanoid.JumpPower = CustomJump
                end)
            end
        end
    end
end)

local function ToggleMenu()
    MainFrame.Visible = not MainFrame.Visible
end

ToggleButton.MouseButton1Click:Connect(ToggleMenu)
CloseButton.MouseButton1Click:Connect(ToggleMenu)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and (input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.Insert) then
        ToggleMenu()
    end
end)

-- FAR-RANGE DODGE: configuration and integration into main menu
local DodgeDistance = 24    -- Khoảng cách bắt đầu phát hiện đối thủ (studs)
local DodgeSpeed = 155      -- Lực lướt mạnh để dạt ra thật xa
local DodgeCooldown = 0.45  -- Thời gian chờ để nhân vật lướt hết tầm
local IsDoggling = false
local DodgeEnabled = false

-- Add a button labeled "Né" into the main menu (Container)
local DodgeButton = Instance.new("TextButton")
DodgeButton.Parent = Container
DodgeButton.Size = UDim2.new(1, 0, 0, 28)
DodgeButton.Position = UDim2.new(0, 0, 0, 240)
DodgeButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
DodgeButton.Text = "Né: OFF"
DodgeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DodgeButton.Font = Enum.Font.SourceSansBold
DodgeButton.TextSize = 14
Instance.new("UICorner", DodgeButton).CornerRadius = UDim.new(0, 7)

DodgeButton.MouseButton1Click:Connect(function()
    DodgeEnabled = not DodgeEnabled
    if DodgeEnabled then
        DodgeButton.Text = "Né: ON"
        DodgeButton.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
    else
        DodgeButton.Text = "Né: OFF"
        DodgeButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
        IsDoggling = false
    end
end)

-- Dodge logic uses existing Players/RunService/LocalPlayer; only runs when DodgeEnabled
RunService.Heartbeat:Connect(function()
    if not DodgeEnabled or IsDoggling or not LocalPlayer.Character then return end

    local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myHumanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not myHrp or not myHumanoid or myHumanoid.Health <= 0 then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local enemyHrp = player.Character:FindFirstChild("HumanoidRootPart")
            local enemyHumanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if enemyHrp and enemyHumanoid and enemyHumanoid.Health > 0 then
                local distance = (myHrp.Position - enemyHrp.Position).Magnitude

                if distance <= DodgeDistance then
                    IsDoggling = true

                    local sideDirection = (math.random(1, 2) == 1) and myHrp.CFrame.RightVector or -myHrp.CFrame.RightVector

                    myHrp.AssemblyLinearVelocity = Vector3.new(
                        sideDirection.X * DodgeSpeed,
                        myHrp.AssemblyLinearVelocity.Y,
                        sideDirection.Z * DodgeSpeed
                    )

                    task.wait(DodgeCooldown)
                    IsDoggling = false
                    break
                end
            end
        end
    end
end)

print("Chế độ tự động né dạt ra xa đã được tích hợp vào menu (bấm 'Né' để bật/tắt).")
