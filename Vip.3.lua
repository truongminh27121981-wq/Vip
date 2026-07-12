-- SCRIPT AUTO EVADE TỐC ĐỘ 40 - CHỈ KÍCH HOẠT KHI CHẠM SÁT NGƯỜI (ĐÚNG 1 STUD)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local IsEvadeActive = false
local EvadeLoop = nil
local LockedTarget = nil 

local ActivationDistance = 1 -- Đã sửa đổi: Đúng 1 stud mới kích hoạt bay

-- 1. TẠO MENU NÚT BẤM GỌN GÀNG (LÀM SẠCH BIẾN)
local ScreenGui = CoreGui:FindFirstChild("LockEvadeMenu")
if ScreenGui then ScreenGui:Destroy() end

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LockEvadeMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ToggleButton.Name = "Toggle"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69) -- Đỏ (Tắt)
ToggleButton.Position = UDim2.new(0.05, 0, 0.75, 0)
ToggleButton.Size = UDim2.new(0, 130, 0, 40)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "LOCK EVADE: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = ToggleButton

-- Hàm quét tìm đối thủ trong tầm sát sạt người (1 stud)
local function FindEnemyInZone()
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end

    local closestEnemy = nil
    local shortestDistance = ActivationDistance 

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local enemyChar = player.Character
            local enemyHrp = enemyChar and enemyChar:FindFirstChild("HumanoidRootPart")
            local enemyHumanoid = enemyChar and enemyChar:FindFirstChildOfClass("Humanoid")

            if enemyHrp and enemyHumanoid and enemyHumanoid.Health > 0 then
                local distance = (myHrp.Position - enemyHrp.Position).Magnitude
                -- Trong Roblox, kích hoạt ở tầm 1-2 studs là khoảng cách khi 2 cơ thể chạm hẳn vào nhau
                if distance <= (ActivationDistance + 2) then 
                    shortestDistance = distance
                    closestEnemy = enemyHrp
                end
            end
        end
    end
    return closestEnemy
end

-- 2. CƠ CHẾ BÁM ĐUÔI VÀ LƯỚT TOÁN HỌC KHÔNG BUÔNG
local function StartSpeedEvade()
    EvadeLoop = RunService.Heartbeat:Connect(function(deltaTime)
        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
        
        if not myHrp or not myHumanoid or not IsEvadeActive then return end

        -- NẾU CHƯA KHÓA AI: Quét xem có ai chạm sát người dưới 1 stud không
        if not LockedTarget then
            LockedTarget = FindEnemyInZone()
        end

        -- NẾU MỤC TIÊU ĐÃ BỊ KHÓA: Hủy khóa nếu họ chết hoặc thoát game
        if LockedTarget and (not LockedTarget.Parent or not LockedTarget.Parent:FindFirstChildOfClass("Humanoid") or LockedTarget.Parent:FindFirstChildOfClass("Humanoid").Health <= 0) then
            LockedTarget = nil
        end

        -- TIẾN HÀNH BAY ĐUỔI THEO MÃI MÃI KHI ĐÃ KHÓA ĐƯỢC MỤC TIÊU
        if LockedTarget then
            local targetPosition = LockedTarget.Position + Vector3.new(0, 8, 0) -- Bay trên đầu đúng 8 studs
            local currentPosition = myHrp.Position
            local distanceVector = targetPosition - currentPosition
            local distance = distanceVector.Magnitude

            if distance > 0.1 then
                -- Lướt toán học đuổi theo sát nút với tốc độ 40 studs/giây
                local step = 40 * deltaTime
                local direction = distanceVector.Unit
                
                if step >= distance then
                    myHrp.CFrame = CFrame.new(targetPosition, LockedTarget.Position)
                else
                    local nextPosition = currentPosition + (direction * step)
                    myHrp.CFrame = CFrame.new(nextPosition, LockedTarget.Position)
                end
            end
            
            -- Chống giật lùi vị trí (Bypass Anti-Cheat)
            myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function StopSpeedEvade()
    if EvadeLoop then
        EvadeLoop:Disconnect()
        EvadeLoop = nil
    end
    LockedTarget = nil 
end

-- 3. XỬ LÝ SỰ KIỆN BẬT / TẮT KHI BẤM NÚT
ToggleButton.MouseButton1Click:Connect(function()
    IsEvadeActive = not IsEvadeActive
    if IsEvadeActive then
        ToggleButton.Text = "LOCK EVADE: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 167, 69) -- Xanh
        StartSpeedEvade()
    else
        ToggleButton.Text = "LOCK EVADE: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69) -- Đỏ
        StopSpeedEvade()
    end
end)

-- Tự động dọn dẹp khi nhân vật của bạn bị chết
LocalPlayer.CharacterAdded:Connect(function()
    StopSpeedEvade()
    IsEvadeActive = false
    ToggleButton.Text = "LOCK EVADE: OFF"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
end)
