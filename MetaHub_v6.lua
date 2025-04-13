local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Wer0000/System-hub-V3/refs/heads/main/Themes/Black%20Theme"))()

local FileSupport = isfile and isfolder and writefile and readfile and makefolder

if FileSupport then
    if not isfolder("System-Hub-V3") then
        makefolder("System-Hub-V3")
    end
    if not isfile("System-Hub-V3/Settings.txt") then
        writefile("System-Hub-V3/Settings.txt", "false")
    end
end

local function readAutoExecuteState()
    if FileSupport and isfile("System-Hub-V3/Settings.txt") then
        return readfile("System-Hub-V3/Settings.txt") == "true"
    end
    return false
end

local function saveAutoExecuteState(state)
    if FileSupport then
        writefile("System-Hub-V3/Settings.txt", tostring(state))
    end
end

local AutoExecute = readAutoExecuteState()

local Window = OrionLib:MakeWindow({
    Name = "MetaHub v5",
    IntroText = "loading...",
    SaveConfig = true,
    ConfigFolder = "System-Hub-V3/Settings"
})

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
local VU = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Tabs
local tabs = {
    Main = Window:MakeTab({Name = "Main", Icon = "rbxassetid://6026568227", PremiumOnly = false}),
    Player = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998", PremiumOnly = false}),
    LocalPlayer = Window:MakeTab({Name = "LocalPlayer", Icon = "rbxassetid://4483345998", PremiumOnly = false}),
    Combat = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://6031075933", PremiumOnly = false}),
    Teleport = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://6031094665", PremiumOnly = false}),
    ESP = Window:MakeTab({Name = "ESP", Icon = "rbxassetid://7736168172", PremiumOnly = false}),
    Visuals = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://6034837799", PremiumOnly = false}),
    Animations = Window:MakeTab({Name = "Animations", Icon = "rbxassetid://6031094678", PremiumOnly = false}),
    Bypass = Window:MakeTab({Name = "Bypass", Icon = "rbxassetid://11604639954", PremiumOnly = false}),
    Meta = Window:MakeTab({Name = "Meta", Icon = "rbxassetid://6023891164", PremiumOnly = false}),
    Server = Window:MakeTab({Name = "Server", Icon = "rbxassetid://6031079151", PremiumOnly = false}),
    Camera = Window:MakeTab({Name = "Camera", Icon = "rbxassetid://6034837799", PremiumOnly = false})
}

-- Main Tab
tabs.Main:AddToggle({
    Name = "Auto Execute",
    Default = AutoExecute,
    Callback = function(state)
        saveAutoExecuteState(state)
        if state then
            local function NACaller(pp)
                local s, err = pcall(pp)
                if not s then warn("NA script error: " .. err) end
            end
            local loader = [[]]
            local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or (fluxus and fluxus.queue_on_teleport) or function() end
            local teleportedServers = false
            NACaller(function()
                local teleportConnection = LP.OnTeleport:Connect(function(State)
                    if not teleportedServers then
                        teleportedServers = true
                        queueteleport(loader)
                    end
                end)
            end)
            if not DONE then
                DONE = true
                local qot = ""
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    qot = "task.spawn(function() end) repeat wait() until game and game:IsLoaded() local lp = game.Players.LocalPlayer local char = lp.Character or lp.CharacterAdded:Wait() repeat char:WaitForChild('HumanoidRootPart').CFrame = CFrame.new(" .. tostring(hrp.CFrame) .. ") wait() until (Vector3.new(" .. tostring(hrp.Position) .. ") - char:WaitForChild('HumanoidRootPart').Position).Magnitude < 10"
                end
                queueteleport(qot)
            end
        end
    end
})

-- Player Tab
local selectedPlayer = nil
local playerDropdown = nil -- Ссылка на Dropdown

-- Инициализация Dropdown при запуске
local function initializePlayerDropdown()
    local activePlayers = {}
    for _, player in pairs(Players:GetPlayers()) do
        table.insert(activePlayers, player.Name)
    end
    playerDropdown = tabs.Player:AddDropdown({
        Name = "Player List",
        Options = activePlayers,
        Default = selectedPlayer,
        Callback = function(chosenPlayer)
            selectedPlayer = chosenPlayer
        end
    })
end

initializePlayerDropdown() -- Первоначальная инициализация

-- Обновление списка игроков каждые 5 секунд
spawn(function()
    while task.wait(5) do
        local activePlayers = {}
        for _, player in pairs(Players:GetPlayers()) do
            table.insert(activePlayers, player.Name)
        end
        if playerDropdown then
            playerDropdown:Set({
                Name = "Player List",
                Options = activePlayers,
                Default = selectedPlayer,
                Callback = function(chosenPlayer)
                    selectedPlayer = chosenPlayer
                end
            })
        end
    end
end)

tabs.Player:AddButton({
    Name = "Teleport to Player",
    Callback = function()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character then
                LP.Character:PivotTo(target.Character.HumanoidRootPart.CFrame)
            end
        end
    end
})

tabs.Player:AddButton({
    Name = "Kill Player",
    Callback = function()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character then
                target.Character:BreakJoints()
            end
        end
    end
})

tabs.Player:AddSlider({
    Name = "Set Health",
    Min = 0,
    Max = 100,
    Default = 100,
    Increment = 1,
    Callback = function(value)
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                target.Character.Humanoid.Health = value
            end
        end
    end
})

tabs.Player:AddButton({
    Name = "Spectate",
    Callback = function()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character then
                workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
            end
        end
    end
})

tabs.Player:AddButton({
    Name = "Fling Player",
    Callback = function()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local localChar = LP.Character
                if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                    local originalCFrame = localChar.HumanoidRootPart.CFrame
                    local targetCFrame = target.Character.HumanoidRootPart.CFrame
                    localChar:PivotTo(targetCFrame)
                    task.wait(0.1)
                    target.Character.HumanoidRootPart.Velocity = Vector3.new(0, 10000, 0)
                    task.wait(0.1)
                    localChar:PivotTo(originalCFrame)
                end
            end
        end
    end
})

tabs.Player:AddButton({
    Name = "Freeze Player",
    Callback = function()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                target.Character.HumanoidRootPart.Anchored = not target.Character.HumanoidRootPart.Anchored
            end
        end
    end
})

tabs.Player:AddButton({
    Name = "Kick Player (Client Side)",
    Callback = function()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target == LP then
                LP:Kick("Kicked (client-side only)")
            end
        end
    end
})

local followPlayerEnabled = false
local trackPlayerEnabled = false
local followDistance = 5
local followHeight = 0
local followLateral = 0

tabs.Player:AddToggle({
    Name = "Follow Player",
    Default = false,
    Callback = function(value)
        followPlayerEnabled = value
        trackPlayerEnabled = false
        if not value then
            followDistance = 5
            followHeight = 0
            followLateral = 0
        end
    end
})

tabs.Player:AddSlider({
    Name = "Follow Distance",
    Min = -20,
    Max = 20,
    Default = 5,
    Increment = 1,
    Callback = function(value)
        followDistance = value
    end
})

tabs.Player:AddSlider({
    Name = "Follow Height",
    Min = -10,
    Max = 10,
    Default = 0,
    Increment = 1,
    Callback = function(value)
        followHeight = value
    end
})

tabs.Player:AddSlider({
    Name = "Follow Lateral",
    Min = -10,
    Max = 10,
    Default = 0,
    Increment = 1,
    Callback = function(value)
        followLateral = value
    end
})

tabs.Player:AddToggle({
    Name = "Track Player (Camera)",
    Default = false,
    Callback = function(value)
        trackPlayerEnabled = value
        followPlayerEnabled = false
        if not value then
            workspace.CurrentCamera.CameraSubject = LP.Character and LP.Character:FindFirstChild("Humanoid")
        end
    end
})

spawn(function()
    while task.wait() do
        if followPlayerEnabled and selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = target.Character.HumanoidRootPart
                local localChar = LP.Character
                if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                    local offset = CFrame.new(followLateral, followHeight, followDistance)
                    local targetCFrame = targetRoot.CFrame * offset
                    localChar:PivotTo(targetCFrame * CFrame.Angles(0, math.rad(targetRoot.Orientation.Y), 0))
                end
            end
        elseif trackPlayerEnabled and selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
            end
        end
    end
end)

-- LocalPlayer Tab
local noclipEnabled = false
local flyEnabled = false
local flySpeed = 50
local flyV2Enabled = false
local flyV2Speed = 50
local freezeEnabled = false
local airJumpEnabled = false
local platformEnabled = false
local infinityJumpEnabled = false
local godModeEnabled = false
local flashbackEnabled = false
local unlockCameraEnabled = false
local currentPlatform = nil
local CanInvis = true
local Keybind = "E"
local flashbackKey = "E"
local flashbackLength = 60
local flashbackSpeed = 1
local frames = {}
local flashback = {lastinput = false, canrevert = true}
local cameraDistance = 10
local maxCameraDistance = 999
local minCameraDistance = 5
local cameraStep = 5

tabs.LocalPlayer:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 1000,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        local humanoid = LP.Character and LP.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = value end
    end
})

tabs.LocalPlayer:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 1000,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        local humanoid = LP.Character and LP.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.JumpPower = value end
    end
})

tabs.LocalPlayer:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(value)
        flyEnabled = value
        local char = LP.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChild("Humanoid")
        if not rootPart or not humanoid then
            OrionLib:MakeNotification({Name = "Fly Error", Content = "Character not ready!", Time = 2})
            flyEnabled = false
            return
        end
        
        if value then
            humanoid.PlatformStand = true -- Поза "смирно"
            local bv = Instance.new("BodyVelocity")
            local bg = Instance.new("BodyGyro")
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.P = 9e4
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = rootPart
            bg.Parent = rootPart
            
            spawn(function()
                while flyEnabled and rootPart and humanoid do
                    local cam = workspace.CurrentCamera
                    bg.CFrame = cam.CFrame
                    local moveDir = Vector3.new()
                    local speed = flySpeed
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                    
                    if moveDir.Magnitude > 0 then
                        bv.Velocity = moveDir.Unit * speed
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end
                    
                    VU:CaptureController()
                    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if v:IsA("RemoteEvent") and v.Name:lower():match("move") then
                            pcall(function() v:FireServer(rootPart.Position, tick()) end)
                            break
                        end
                    end
                    
                    task.wait()
                end
                humanoid.PlatformStand = false
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
                if rootPart then rootPart.Velocity = Vector3.new(0, 0, 0) end
            end)
        end
    end
})

tabs.LocalPlayer:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        flySpeed = value
    end
})

tabs.LocalPlayer:AddToggle({
    Name = "Fly v2 (Bypass)",
    Default = false,
    Callback = function(value)
        flyV2Enabled = value
        local char = LP.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChild("Humanoid")
        if not rootPart or not humanoid then
            OrionLib:MakeNotification({Name = "Fly v2 Error", Content = "Character not ready!", Time = 2})
            flyV2Enabled = false
            return
        end
        
        if value then
            humanoid.PlatformStand = true -- Поза "смирно"
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = rootPart
            
            spawn(function()
                while flyV2Enabled and rootPart and humanoid do
                    local cam = workspace.CurrentCamera
                    local moveDir = Vector3.new()
                    local speed = flyV2Speed
                    -- Ориентация движения по камере
                    local forward = cam.CFrame.LookVector
                    local right = cam.CFrame.RightVector
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + forward end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - forward end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - right end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + right end
                    if UIS:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                    
                    if moveDir.Magnitude > 0 then
                        bv.Velocity = moveDir.Unit * speed
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end
                    
                    VU:CaptureController()
                    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if v:IsA("RemoteEvent") and v.Name:lower():match("move") then
                            pcall(function() v:FireServer(rootPart.Position, tick()) end)
                            break
                        end
                    end
                    
                    task.wait()
                end
                humanoid.PlatformStand = false
                if bv then bv:Destroy() end
                if rootPart then rootPart.Velocity = Vector3.new(0, 0, 0) end
            end)
        end
    end
})

tabs.LocalPlayer:AddSlider({
    Name = "Fly v2 Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        flyV2Speed = value
    end
})

tabs.LocalPlayer:AddToggle({
    Name = "No Clip",
    Default = false,
    Callback = function(value)
        noclipEnabled = value
    end
})

tabs.LocalPlayer:AddToggle({
    Name = "Air Jump",
    Default = false,
    Callback = function(value)
        airJumpEnabled = value
    end
})

tabs.LocalPlayer:AddToggle({
    Name = "Platform",
    Default = false,
    Callback = function(value)
        platformEnabled = value
        local char = LP.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        if not value and currentPlatform then
            currentPlatform:Destroy()
            currentPlatform = nil
        end
    end
})

tabs.LocalPlayer:AddToggle({
    Name = "Infinity Jump",
    Default = false,
    Callback = function(value)
        infinityJumpEnabled = value
    end
})

tabs.LocalPlayer:AddButton({
    Name = "Toggle Flashback",
    Callback = function()
        flashbackEnabled = not flashbackEnabled
        if not flashbackEnabled then frames = {} end
        OrionLib:MakeNotification({Name = "Flashback", Content = flashbackEnabled and "Enabled" or "Disabled", Time = 2})
    end
})

tabs.LocalPlayer:AddToggle({
    Name = "Freeze",
    Default = false,
    Callback = function(value)
        freezeEnabled = value
        local char = LP.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        rootPart.Anchored = value
    end
})

tabs.LocalPlayer:AddToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(value)
        godModeEnabled = value
        local humanoid = LP.Character and LP.Character:FindFirstChild("Humanoid")
        if humanoid then
            if value then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            else
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end
})

tabs.LocalPlayer:AddSlider({
    Name = "FOV",
    Min = 70,
    Max = 120,
    Default = 70,
    Increment = 1,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

tabs.LocalPlayer:AddSlider({
    Name = "Gravity",
    Min = 0,
    Max = 196.2,
    Default = 196.2,
    Increment = 1,
    Callback = function(value)
        workspace.Gravity = value
    end
})

tabs.LocalPlayer:AddButton({
    Name = "Respawn",
    Callback = function()
        local char = LP.Character
        if char then char:BreakJoints() end
    end
})

-- Unlock Camera+ с плавным отдалением
tabs.LocalPlayer:AddToggle({
    Name = "Unlock Camera+",
    Default = false,
    Callback = function(value)
        unlockCameraEnabled = value
        local camera = workspace.CurrentCamera
        if not value then
            cameraDistance = 10
            camera.CameraType = Enum.CameraType.Custom
            LP.CameraMaxZoomDistance = 128
        else
            camera.CameraType = Enum.CameraType.Custom
            LP.CameraMaxZoomDistance = maxCameraDistance
        end
    end
})

-- LocalPlayer Logic
RS.Stepped:Connect(function()
    if noclipEnabled then
        local char = LP.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

LP.CharacterAdded:Connect(function(char)
    if noclipEnabled then
        task.wait(0.1)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    if godModeEnabled then
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)

UIS.InputBegan:Connect(function(input)
    if airJumpEnabled and input.KeyCode == Enum.KeyCode.Space then
        local humanoid = LP.Character and LP.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

spawn(function()
    while task.wait() do
        if infinityJumpEnabled then
            local humanoid = LP.Character and LP.Character:FindFirstChild("Humanoid")
            if humanoid and UIS:IsKeyDown(Enum.KeyCode.Space) then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.1)
            end
        end
    end
end)

spawn(function()
    while task.wait(0.05) do
        if platformEnabled then
            local char = LP.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local position = rootPart.Position - Vector3.new(0, 3, 0)
                if not currentPlatform or (currentPlatform.Position - position).Magnitude > 5 then
                    if currentPlatform then currentPlatform:Destroy() end
                    currentPlatform = Instance.new("Part")
                    currentPlatform.Size = Vector3.new(40, 0, 40)
                    currentPlatform.Position = Vector3.new(position.X, position.Y, position.Z)
                    currentPlatform.Anchored = true
                    currentPlatform.Transparency = 1
                    currentPlatform.CanCollide = true
                    currentPlatform.Parent = workspace
                end
            end
        end
    end
end)

local function getChar()
    if not LP.Character then LP.CharacterAdded:Wait() end
    return LP.Character
end

local function getHrp(c)
    if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChildWhichIsA("BasePart")
end

function flashback:Advance(char, hrp, hum, allowinput)
    if not char or not hrp or not hum then return end
    if #frames > flashbackLength * 60 then table.remove(frames, 1) end
    if allowinput and not self.canrevert then self.canrevert = true end
    if self.lastinput then hum.PlatformStand = false self.lastinput = false end
    table.insert(frames, {hrp.CFrame, hrp.Velocity, hum:GetState(), hum.PlatformStand, char:FindFirstChildOfClass("Tool")})
end

function flashback:Revert(char, hrp, hum)
    if not char or not hrp or not hum then return end
    local num = #frames
    if num == 0 or not self.canrevert then self.canrevert = false self:Advance(char, hrp, hum) return end
    for i = 1, flashbackSpeed do
        if num > 0 then table.remove(frames, num) num = num - 1 end
    end
    if num <= 0 then return end
    self.lastinput = true
    local lastframe = frames[num]
    table.remove(frames, num)
    hrp.CFrame = lastframe[1]
    hrp.Velocity = -lastframe[2]
    hum:ChangeState(lastframe[3])
    hum.PlatformStand = lastframe[4]
    local currenttool = char:FindFirstChildOfClass("Tool")
    if lastframe[5] then if not currenttool then hum:EquipTool(lastframe[5]) end else hum:UnequipTools() end
end

spawn(function()
    while task.wait(0.05) do
        if not flashbackEnabled then continue end
        local char = getChar()
        if not char then continue end
        local hrp = getHrp(char)
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hrp or not hum then continue end
        if UIS:IsKeyDown(Enum.KeyCode[flashbackKey]) then flashback:Revert(char, hrp, hum)
        else flashback:Advance(char, hrp, hum, true) end
    end
end)

UIS.InputChanged:Connect(function(input)
    if unlockCameraEnabled and input.UserInputType == Enum.UserInputType.MouseWheel then
        local delta = input.Position.Z
        cameraDistance = math.clamp(cameraDistance - delta * cameraStep, minCameraDistance, maxCameraDistance)
        LP.CameraMaxZoomDistance = cameraDistance
    end
end)

RS.RenderStepped:Connect(function()
    if unlockCameraEnabled then
        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = LP.Character and LP.Character:FindFirstChild("Humanoid")
    end
end)

-- Combat Tab
local aimbotEnabled = false
local aimActive = false -- Отслеживание состояния аимбота
local aimKey = Enum.KeyCode.E
local aimPart = "Head"
local aimSmoothness = 0.1

tabs.Combat:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(value)
        aimbotEnabled = value
        if not value then aimActive = false end -- Отключаем аимбот при выключении тоггла
    end
})

tabs.Combat:AddDropdown({
    Name = "Aim Key",
    Options = {"Q", "E", "R", "T", "F"},
    Default = "E",
    Callback = function(value)
        aimKey = Enum.KeyCode[value]
    end
})

tabs.Combat:AddDropdown({
    Name = "Aim Part",
    Options = {"Head", "Torso"},
    Default = "Head",
    Callback = function(value)
        aimPart = value
    end
})

tabs.Combat:AddSlider({
    Name = "Aimbot Smoothness",
    Min = 0.05,
    Max = 0.5,
    Default = 0.1,
    Increment = 0.05,
    Callback = function(value)
        aimSmoothness = value
    end
})

-- Включение/выключение аимбота по нажатию клавиши
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == aimKey and aimbotEnabled then
        aimActive = not aimActive
        OrionLib:MakeNotification({
            Name = "Aimbot",
            Content = aimActive and "Aimbot activated" or "Aimbot deactivated",
            Time = 2
        })
    end
end)

-- Функция поиска ближайшего игрока
local function getNearestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild(aimPart) then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (myRoot.Position - targetRoot.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Логика аимбота
spawn(function()
    while task.wait() do
        if aimbotEnabled and aimActive then
            local target = getNearestPlayer()
            if target and target.Character and target.Character:FindFirstChild(aimPart) then
                local camera = workspace.CurrentCamera
                local targetPos = target.Character[aimPart].Position
                local currentCFrame = camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
                
                -- Плавное отслеживание с учетом телепортации
                camera.CFrame = currentCFrame:Lerp(targetCFrame, aimSmoothness)
            end
        end
    end
end)

-- Teleport Tab
-- Teleport Tab
local selectedTeleportPlayer = nil
local teleportDropdown = nil -- Ссылка на Dropdown

-- Инициализация Dropdown при запуске
local function initializeTeleportDropdown()
    local activePlayers = {}
    for _, player in pairs(Players:GetPlayers()) do
        table.insert(activePlayers, player.Name)
    end
    teleportDropdown = tabs.Teleport:AddDropdown({
        Name = "Teleport to Player",
        Options = activePlayers,
        Default = selectedTeleportPlayer,
        Callback = function(chosenPlayer)
            selectedTeleportPlayer = chosenPlayer
        end
    })
end

initializeTeleportDropdown() -- Первоначальная инициализация

-- Обновление списка игроков каждые 5 секунд
spawn(function()
    while task.wait(5) do
        local activePlayers = {}
        for _, player in pairs(Players:GetPlayers()) do
            table.insert(activePlayers, player.Name)
        end
        if teleportDropdown then
            teleportDropdown:Set({
                Name = "Teleport to Player",
                Options = activePlayers,
                Default = selectedTeleportPlayer,
                Callback = function(chosenPlayer)
                    selectedTeleportPlayer = chosenPlayer
                end
            })
        end
    end
end)

tabs.Teleport:AddButton({
    Name = "Go",
    Callback = function()
        if selectedTeleportPlayer then
            local target = Players:FindFirstChild(selectedTeleportPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character:PivotTo(target.Character.HumanoidRootPart.CFrame)
            end
        end
    end
})

tabs.Teleport:AddTextbox({
    Name = "Teleport to Coordinates (X,Y,Z)",
    Default = "0,0,0",
    TextDisappear = true,
    Callback = function(value)
        local coords = {}
        for num in value:gmatch("[^,]+") do table.insert(coords, tonumber(num)) end
        if #coords == 3 then
            LP.Character:PivotTo(CFrame.new(coords[1], coords[2], coords[3]))
        end
    end
})

-- ESP tab
local espEnabled = false
local healthESPEnabled = false
local boxESPEnabled = false
local lineESPEnabled = false -- Новый тоггл для линий
local infoESPEnabled = false
local distanceESPEnabled = false
local boxDrawing = {}
local lineDrawing = {} -- Таблица для линий
local healthBillboards = {}
local infoBillboards = {}
local distanceBillboards = {}
local boxColor = Color3.fromRGB(0, 0, 255) -- Стандартный цвет боксов
local lineColor = Color3.fromRGB(255, 0, 0) -- Стандартный цвет линий
local HttpService = game:GetService("HttpService")

-- Тогглы и настройки в интерфейсе
tabs.ESP:AddToggle({
    Name = "Player ESP (Names)",
    Default = false,
    Callback = function(value)
        espEnabled = value
        if not value then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Head") then
                    local billboard = player.Character.Head:FindFirstChild("ESP_Name")
                    if billboard then billboard:Destroy() end
                end
            end
        end
    end
})

tabs.ESP:AddToggle({
    Name = "Health ESP",
    Default = false,
    Callback = function(value)
        healthESPEnabled = value
        if not value then
            for playerName, billboard in pairs(healthBillboards) do
                if billboard and billboard.Parent then billboard:Destroy() healthBillboards[playerName] = nil end
            end
        end
    end
})

tabs.ESP:AddToggle({
    Name = "Box ESP",
    Default = false,
    Callback = function(value)
        boxESPEnabled = value
        if not value then
            for playerName, drawing in pairs(boxDrawing) do
                if drawing then drawing:Remove() boxDrawing[playerName] = nil end
            end
        end
    end
})

tabs.ESP:AddToggle({
    Name = "Line ESP",
    Default = false,
    Callback = function(value)
        lineESPEnabled = value
        if not value then
            for playerName, line in pairs(lineDrawing) do
                if line then line:Remove() lineDrawing[playerName] = nil end
            end
        end
    end
})

tabs.ESP:AddToggle({
    Name = "Player Info ESP",
    Default = false,
    Callback = function(value)
        infoESPEnabled = value
        if not value then
            for playerName, billboard in pairs(infoBillboards) do
                if billboard and billboard.Parent then billboard:Destroy() infoBillboards[playerName] = nil end
            end
        end
    end
})

tabs.ESP:AddToggle({
    Name = "Distance ESP",
    Default = false,
    Callback = function(value)
        distanceESPEnabled = value
        if not value then
            for playerName, billboard in pairs(distanceBillboards) do
                if billboard and billboard.Parent then billboard:Destroy() distanceBillboards[playerName] = nil end
            end
        end
    end
})

-- Выбор цвета для Box
tabs.ESP:AddDropdown({
    Name = "Box Color",
    Options = {"Red", "Green", "Blue", "Yellow", "White"},
    Default = "Blue",
    Callback = function(value)
        if value == "Red" then boxColor = Color3.fromRGB(255, 0, 0)
        elseif value == "Green" then boxColor = Color3.fromRGB(0, 255, 0)
        elseif value == "Blue" then boxColor = Color3.fromRGB(0, 0, 255)
        elseif value == "Yellow" then boxColor = Color3.fromRGB(255, 255, 0)
        elseif value == "White" then boxColor = Color3.fromRGB(255, 255, 255) end
    end
})

-- Выбор цвета для Line
tabs.ESP:AddDropdown({
    Name = "Line Color",
    Options = {"Red", "Green", "Blue", "Yellow", "White"},
    Default = "Red",
    Callback = function(value)
        if value == "Red" then lineColor = Color3.fromRGB(255, 0, 0)
        elseif value == "Green" then lineColor = Color3.fromRGB(0, 255, 0)
        elseif value == "Blue" then lineColor = Color3.fromRGB(0, 0, 255)
        elseif value == "Yellow" then lineColor = Color3.fromRGB(255, 255, 0)
        elseif value == "White" then lineColor = Color3.fromRGB(255, 255, 255) end
    end
})

-- Функция для получения количества подписчиков через API
local function getFollowerCount(userId)
    local success, response = pcall(function()
        local url = "https://friends.roblox.com/v1/users/" .. userId .. "/followers/count"
        local data = HttpService:GetAsync(url)
        local decoded = HttpService:JSONDecode(data)
        return decoded.count or "N/A"
    end)
    return success and response or "N/A"
end

-- Основная логика ESP
spawn(function()
    while task.wait(0.01) do -- Минимальная задержка для плавности
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
                local head = player.Character.Head
                local rootPart = player.Character.HumanoidRootPart
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)

                -- Player ESP (Names)
                if espEnabled and humanoid and humanoid.Health > 0 then
                    local billboard = head:FindFirstChild("ESP_Name")
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESP_Name"
                        billboard.Size = UDim2.new(0, 100, 0, 20)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.Text = player.Name
                        text.TextColor3 = Color3.new(1, 0, 0)
                        text.TextScaled = true
                        text.Parent = billboard
                        billboard.Parent = head
                    end
                elseif head:FindFirstChild("ESP_Name") then
                    head:FindFirstChild("ESP_Name"):Destroy()
                end

                -- Health ESP
                if healthESPEnabled and humanoid and humanoid.Health > 0 then
                    local billboard = healthBillboards[player.Name]
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "Health_ESP"
                        billboard.Size = UDim2.new(0, 100, 0, 20)
                        billboard.StudsOffset = Vector3.new(0, 5, 0)
                        billboard.AlwaysOnTop = true
                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.new(0, 1, 0)
                        text.TextScaled = true
                        text.Parent = billboard
                        billboard.Parent = head
                        healthBillboards[player.Name] = billboard
                    end
                    billboard.TextLabel.Text = "Health: " .. math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth
                elseif healthBillboards[player.Name] then
                    healthBillboards[player.Name]:Destroy()
                    healthBillboards[player.Name] = nil
                end

                -- Box ESP
                if boxESPEnabled and humanoid and humanoid.Health > 0 then
                    local size = Vector3.new(1.5, 3, 1) -- Точный размер по телу
                    local topLeft = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position - size)
                    local bottomRight = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position + size)
                    local box = boxDrawing[player.Name]

                    if not box then
                        box = Drawing.new("Square")
                        box.Thickness = 1
                        box.Filled = false
                        boxDrawing[player.Name] = box
                    end

                    box.Color = boxColor
                    if onScreen then
                        box.Position = Vector2.new(topLeft.X, topLeft.Y)
                        box.Size = Vector2.new(bottomRight.X - topLeft.X, bottomRight.Y - topLeft.Y)
                        box.Visible = true
                    else
                        box.Visible = false
                    end
                elseif boxDrawing[player.Name] then
                    boxDrawing[player.Name]:Remove()
                    boxDrawing[player.Name] = nil
                end

                -- Line ESP
                if lineESPEnabled and humanoid and humanoid.Health > 0 then
                    local line = lineDrawing[player.Name]
                    if not line then
                        line = Drawing.new("Line")
                        line.Thickness = 1
                        lineDrawing[player.Name] = line
                    end

                    line.Color = lineColor
                    if onScreen then
                        local screenTopCenter = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 0) -- Центр верха экрана
                        line.From = screenTopCenter
                        line.To = Vector2.new(screenPos.X, screenPos.Y)
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                elseif lineDrawing[player.Name] then
                    lineDrawing[player.Name]:Remove()
                    lineDrawing[player.Name] = nil
                end

                -- Player Info ESP
                if infoESPEnabled and humanoid and humanoid.Health > 0 then
                    local billboard = infoBillboards[player.Name]
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "Info_ESP"
                        billboard.Size = UDim2.new(0, 250, 0, 120)
                        billboard.StudsOffset = Vector3.new(0, 7, 0)
                        billboard.AlwaysOnTop = true
                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.new(1, 1, 0)
                        text.TextScaled = true
                        text.TextWrapped = true
                        text.Parent = billboard
                        billboard.Parent = head
                        infoBillboards[player.Name] = billboard
                    end

                    local accountAge = player.AccountAge or 0
                    local displayName = player.DisplayName or player.Name
                    local team = player.Team and player.Team.Name or "No Team"
                    local membership = player.MembershipType == Enum.MembershipType.Premium and "Premium" or "None"
                    local followers = getFollowerCount(player.UserId) -- Реальные подписчики
                    local following = player.FollowUserId ~= 0 and tostring(player.FollowUserId) or "N/A"
                    local distance = "N/A"
                    if rootPart and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        distance = tostring(math.floor((rootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude))
                    end
                    local healthInfo = math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth

                    billboard.TextLabel.Text = string.format(
                        "Name: %s\nDisplay: %s\nUserId: %d\nAge: %d days\nTeam: %s\nMembership: %s\nFollowers: %s\nFollowing: %s\nDistance: %s studs\nHealth: %s",
                        player.Name or "Unknown", displayName, player.UserId or 0, accountAge, team, membership, followers, following, distance, healthInfo
                    )
                elseif infoBillboards[player.Name] then
                    infoBillboards[player.Name]:Destroy()
                    infoBillboards[player.Name] = nil
                end

                -- Distance ESP
                if distanceESPEnabled and humanoid and humanoid.Health > 0 then
                    local billboard = distanceBillboards[player.Name]
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "Distance_ESP"
                        billboard.Size = UDim2.new(0, 100, 0, 20)
                        billboard.StudsOffset = Vector3.new(0, 6, 0)
                        billboard.AlwaysOnTop = true
                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.new(0, 1, 1)
                        text.TextScaled = true
                        text.Parent = billboard
                        billboard.Parent = head
                        distanceBillboards[player.Name] = billboard
                    end
                    local distance = "N/A"
                    if rootPart and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        distance = math.floor((rootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude)
                    end
                    billboard.TextLabel.Text = "Distance: " .. distance .. " studs"
                elseif distanceBillboards[player.Name] then
                    distanceBillboards[player.Name]:Destroy()
                    distanceBillboards[player.Name] = nil
                end
            else
                -- Очистка при выходе/смерти игрока
                if boxDrawing[player.Name] then
                    boxDrawing[player.Name]:Remove()
                    boxDrawing[player.Name] = nil
                end
                if lineDrawing[player.Name] then
                    lineDrawing[player.Name]:Remove()
                    lineDrawing[player.Name] = nil
                end
                if healthBillboards[player.Name] then
                    healthBillboards[player.Name]:Destroy()
                    healthBillboards[player.Name] = nil
                end
                if infoBillboards[player.Name] then
                    infoBillboards[player.Name]:Destroy()
                    infoBillboards[player.Name] = nil
                end
                if distanceBillboards[player.Name] then
                    distanceBillboards[player.Name]:Destroy()
                    distanceBillboards[player.Name] = nil
                end
                if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("ESP_Name") then
                    player.Character.Head:FindFirstChild("ESP_Name"):Destroy()
                end
            end
        end
    end
end)

-- Visuals Tab
tabs.Visuals:AddToggle({
    Name = "Fullbright",
    Default = false,
    Callback = function(value)
        if value then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.FogEnd = 1000
        else
            game.Lighting.Brightness = 1
            game.Lighting.ClockTime = 12
            game.Lighting.FogEnd = 500
        end
    end
})

tabs.Visuals:AddSlider({
    Name = "Time of Day",
    Min = 0,
    Max = 24,
    Default = 12,
    Increment = 1,
    Callback = function(value)
        game.Lighting.ClockTime = value
    end
})

tabs.Visuals:AddButton({
    Name = "Remove Fog",
    Callback = function()
        game.Lighting.FogEnd = 100000
    end
})

-- Animations Tab
local animationIds = {
    Dance = "rbxassetid://507771019",
    Laugh = "rbxassetid://507770239",
    Wave = "rbxassetid://507770453",
    Point = "rbxassetid://507770818",
    Default = { idle1 = "http://www.roblox.com/asset/?id=507766666", idle2 = "http://www.roblox.com/asset/?id=507766951", walk = "http://www.roblox.com/asset/?id=507777826", run = "http://www.roblox.com/asset/?id=507767714", jump = "http://www.roblox.com/asset/?id=507765000", climb = "http://www.roblox.com/asset/?id=507765644", fall = "http://www.roblox.com/asset/?id=507767968" },
    Astronaut = { idle1 = "http://www.roblox.com/asset/?id=891621366", idle2 = "http://www.roblox.com/asset/?id=891633237", walk = "http://www.roblox.com/asset/?id=891667138", run = "http://www.roblox.com/asset/?id=891636393", jump = "http://www.roblox.com/asset/?id=891627522", climb = "http://www.roblox.com/asset/?id=891609353", fall = "http://www.roblox.com/asset/?id=891617961" },
    Vampire = { idle1 = "http://www.roblox.com/asset/?id=1083445855", idle2 = "http://www.roblox.com/asset/?id=1083450166", walk = "http://www.roblox.com/asset/?id=1083473930", run = "http://www.roblox.com/asset/?id=1083462077", jump = "http://www.roblox.com/asset/?id=1083455352", climb = "http://www.roblox.com/asset/?id=1083439238", fall = "http://www.roblox.com/asset/?id=1083464876" },
    Toy = { idle1 = "http://www.roblox.com/asset/?id=782841498", idle2 = "http://www.roblox.com/asset/?id=782843869", walk = "http://www.roblox.com/asset/?id=782843345", run = "http://www.roblox.com/asset/?id=782842708", jump = "http://www.roblox.com/asset/?id=782847020", climb = "http://www.roblox.com/asset/?id=782843735", fall = "http://www.roblox.com/asset/?id=782846423" },
    Werewolf = { idle1 = "http://www.roblox.com/asset/?id=1083195517", idle2 = "http://www.roblox.com/asset/?id=1083214717", walk = "http://www.roblox.com/asset/?id=1083178339", run = "http://www.roblox.com/asset/?id=1083216690", jump = "http://www.roblox.com/asset/?id=1083218792", climb = "http://www.roblox.com/asset/?id=1083182000", fall = "http://www.roblox.com/asset/?id=1083222527" },
    Cartoon = { idle1 = "http://www.roblox.com/asset/?id=742641138", idle2 = "http://www.roblox.com/asset/?id=742640026", walk = "http://www.roblox.com/asset/?id=742641808", run = "http://www.roblox.com/asset/?id=742641299", jump = "http://www.roblox.com/asset/?id=742639812", climb = "http://www.roblox.com/asset/?id=742636889", fall = "http://www.roblox.com/asset/?id=742637151" },
    Zombie = { idle1 = "http://www.roblox.com/asset/?id=616158929", idle2 = "http://www.roblox.com/asset/?id=616160636", walk = "http://www.roblox.com/asset/?id=616168032", run = "http://www.roblox.com/asset/?id=616163682", jump = "http://www.roblox.com/asset/?id=616161997", climb = "http://www.roblox.com/asset/?id=616156119", fall = "http://www.roblox.com/asset/?id=616157476" },
    Elder = { idle1 = "http://www.roblox.com/asset/?id=845397662", idle2 = "http://www.roblox.com/asset/?id=845400520", walk = "http://www.roblox.com/asset/?id=845403856", run = "http://www.roblox.com/asset/?id=845386501", jump = "http://www.roblox.com/asset/?id=845398858", climb = "http://www.roblox.com/asset/?id=845392038", fall = "http://www.roblox.com/asset/?id=845396002" },
    Ninja = { idle1 = "http://www.roblox.com/asset/?id=656117400", idle2 = "http://www.roblox.com/asset/?id=656118341", walk = "http://www.roblox.com/asset/?id=656121397", run = "http://www.roblox.com/asset/?id=656118852", jump = "http://www.roblox.com/asset/?id=656117878", climb = "http://www.roblox.com/asset/?id=656114359", fall = "http://www.roblox.com/asset/?id=656115606" },
    Robot = { idle1 = "http://www.roblox.com/asset/?id=616087089", idle2 = "http://www.roblox.com/asset/?id=616088211", walk = "http://www.roblox.com/asset/?id=616092152", run = "http://www.roblox.com/asset/?id=616090535", jump = "http://www.roblox.com/asset/?id=616091570", climb = "http://www.roblox.com/asset/?id=616084038", fall = "http://www.roblox.com/asset/?id=616086039" },
    Confident = { idle1 = "http://www.roblox.com/asset/?id=1069946257", idle2 = "http://www.roblox.com/asset/?id=1069977950", walk = "http://www.roblox.com/asset/?id=1069973677", run = "http://www.roblox.com/asset/?id=1069964870", jump = "http://www.roblox.com/asset/?id=1069987851", climb = "http://www.roblox.com/asset/?id=1069942040", fall = "http://www.roblox.com/asset/?id=1069952966" },
    Popstar = { idle1 = "http://www.roblox.com/asset/?id=1212900985", idle2 = "http://www.roblox.com/asset/?id=1212980338", walk = "http://www.roblox.com/asset/?id=1212980348", run = "http://www.roblox.com/asset/?id=1212954642", jump = "http://www.roblox.com/asset/?id=1212946684", climb = "http://www.roblox.com/asset/?id=1212900995", fall = "http://www.roblox.com/asset/?id=1213044953" },
    Princess = { idle1 = "http://www.roblox.com/asset/?id=941003647", idle2 = "http://www.roblox.com/asset/?id=941013098", walk = "http://www.roblox.com/asset/?id=941028902", run = "http://www.roblox.com/asset/?id=941015281", jump = "http://www.roblox.com/asset/?id=941008832", climb = "http://www.roblox.com/asset/?id=940996992", fall = "http://www.roblox.com/asset/?id=941010699" },
    Cowboy = { idle1 = "http://www.roblox.com/asset/?id=1014394116", idle2 = "http://www.roblox.com/asset/?id=1014429918", walk = "http://www.roblox.com/asset/?id=1014424200", run = "http://www.roblox.com/asset/?id=1014418435", jump = "http://www.roblox.com/asset/?id=1014398619", climb = "http://www.roblox.com/asset/?id=1014389378", fall = "http://www.roblox.com/asset/?id=1014403693" },
    Patrol = { idle1 = "http://www.roblox.com/asset/?id=1149612882", idle2 = "http://www.roblox.com/asset/?id=1150842221", walk = "http://www.roblox.com/asset/?id=1150967949", run = "http://www.roblox.com/asset/?id=1150944216", jump = "http://www.roblox.com/asset/?id=1148811837", climb = "http://www.roblox.com/asset/?id=1148815809", fall = "http://www.roblox.com/asset/?id=1148813266" },
    Skate = { idle1 = "http://www.roblox.com/asset/?id=1445738197", idle2 = "http://www.roblox.com/asset/?id=1445761322", walk = "http://www.roblox.com/asset/?id=1445771739", run = "http://www.roblox.com/asset/?id=1445759266", jump = "http://www.roblox.com/asset/?id=1445756428", climb = "http://www.roblox.com/asset/?id=1445733558", fall = "http://www.roblox.com/asset/?id=1445743288" },
    Mage = { idle1 = "http://www.roblox.com/asset/?id=707607567", idle2 = "http://www.roblox.com/asset/?id=707613378", walk = "http://www.roblox.com/asset/?id=707611933", run = "http://www.roblox.com/asset/?id=707609697", jump = "http://www.roblox.com/asset/?id=707604221", climb = "http://www.roblox.com/asset/?id=707598361", fall = "http://www.roblox.com/asset/?id=707616457" },
    Sneaky = { idle1 = "http://www.roblox.com/asset/?id=1138994778", idle2 = "http://www.roblox.com/asset/?id=1139002869", walk = "http://www.roblox.com/asset/?id=1139024190", run = "http://www.roblox.com/asset/?id=1139015006", jump = "http://www.roblox.com/asset/?id=1139008789", climb = "http://www.roblox.com/asset/?id=1138987475", fall = "http://www.roblox.com/asset/?id=1139011056" }
}
local currentAnims = {}
local animationOptions = {
    "Dance", "Laugh", "Wave", "Point", "Default", "Astronaut", "Vampire", "Toy", "Werewolf", 
    "Cartoon", "Zombie", "Elder", "Ninja", "Robot", "Confident", "Popstar", "Princess", 
    "Cowboy", "Patrol", "Skate", "Mage", "Sneaky"
}

tabs.Animations:AddDropdown({
    Name = "Play Animation Set",
    Options = animationOptions,
    Default = nil,
    Callback = function(value)
        local humanoid = LP.Character and LP.Character:FindFirstChild("Humanoid")
        local animate = LP.Character and LP.Character:FindFirstChild("Animate")
        if humanoid and animate then
            for _, anim in pairs(currentAnims) do anim:Stop() end
            currentAnims = {}
            if type(animationIds[value]) == "string" then
                local anim = Instance.new("Animation")
                anim.AnimationId = animationIds[value]
                currentAnims[value] = humanoid:LoadAnimation(anim)
                currentAnims[value]:Play()
            else
                animate.idle.Animation1.AnimationId = animationIds[value].idle1
                animate.idle.Animation2.AnimationId = animationIds[value].idle2
                animate.walk.WalkAnim.AnimationId = animationIds[value].walk
                animate.run.RunAnim.AnimationId = animationIds[value].run
                animate.jump.JumpAnim.AnimationId = animationIds[value].jump
                animate.climb.ClimbAnim.AnimationId = animationIds[value].climb or ""
                animate.fall.FallAnim.AnimationId = animationIds[value].fall
                humanoid.Jump = true
                task.wait(0.1)
                humanoid.Jump = false
            end
        end
    end
})

tabs.Animations:AddTextbox({
    Name = "Custom Animation ID",
    Default = "rbxassetid://",
    TextDisappear = true,
    Callback = function(value)
        local humanoid = LP.Character and LP.Character:FindFirstChild("Humanoid")
        if humanoid then
            for _, anim in pairs(currentAnims) do anim:Stop() end
            local anim = Instance.new("Animation")
            anim.AnimationId = value
            currentAnims[value] = humanoid:LoadAnimation(anim)
            currentAnims[value]:Play()
        end
    end
})

tabs.Animations:AddButton({
    Name = "Stop All Animations",
    Callback = function()
        for _, anim in pairs(currentAnims) do anim:Stop() end
        currentAnims = {}
    end
})

-- Bypass Tab
local antiAfkActive = false
tabs.Bypass:AddToggle({
    Name = "Anti-AFK",
    Default = false,
    Callback = function(value)
        antiAfkActive = value
        if value then
            spawn(function()
                while antiAfkActive and task.wait(math.random(30, 60)) do
                    VU:CaptureController()
                    VU:ClickButton1(Vector2.new(math.random(0, 100), math.random(0, 100)))
                    OrionLib:MakeNotification({Name = "Anti-AFK", Content = "Simulated activity", Time = 2})
                end
            end)
        end
    end
})

local function optimizeGraphics(settings)
    task.spawn(function()
        pcall(function()
            Lighting.GlobalShadows = settings.shadows
            Lighting.FogEnd = settings.fogEnd
            Lighting.Brightness = settings.brightness
            Lighting.ClockTime = settings.clockTime
        end)
        local descendants = Workspace:GetDescendants()
        local batchSize = 100
        for i = 1, #descendants, batchSize do
            for j = i, math.min(i + batchSize - 1, #descendants) do
                local obj = descendants[j]
                pcall(function()
                    if obj:IsA("BasePart") then
                        obj.Material = settings.material
                        obj.CastShadow = false
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Enabled = false
                    elseif obj:IsA("Decal") and settings.decalTransparency then
                        obj.Transparency = settings.decalTransparency
                    end
                end)
            end
            task.wait(0.01)
        end
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then pcall(function() effect.Enabled = false end) end
        end
    end)
end

tabs.Bypass:AddButton({
    Name = "Unlock FPS (PC)",
    Callback = function()
        if setfpscap then setfpscap(999) end
        local pcSettings = {shadows = false, fogEnd = 100000, brightness = 2, clockTime = 14, material = Enum.Material.SmoothPlastic, decalTransparency = nil}
        optimizeGraphics(pcSettings)
        task.spawn(function()
            Workspace.StreamingEnabled = false
            Workspace.Terrain.WaterWaveSize = 0
            Workspace.Terrain.WaterReflectance = 0
            RS:Set3dRenderingEnabled(true)
        end)
        OrionLib:MakeNotification({Name = "FPS Unlock", Content = "Optimized for PC", Time = 2})
    end
})

tabs.Bypass:AddButton({
    Name = "Unlock FPS (Mobile)",
    Callback = function()
        if setfpscap then setfpscap(999) end
        local mobileSettings = {shadows = false, fogEnd = 5000, brightness = 1.5, clockTime = 12, material = Enum.Material.Plastic, decalTransparency = 0.5}
        optimizeGraphics(mobileSettings)
        task.spawn(function()
            local camera = Workspace.CurrentCamera
            camera.FieldOfView = 70
            Workspace.StreamingEnabled = true
            Workspace.Terrain.WaterWaveSize = 0
            Workspace.Terrain.WaterReflectance = 0
        end)
        OrionLib:MakeNotification({Name = "FPS Unlock", Content = "Optimized for Mobile", Time = 2})
    end
})

local antiKickActive = false
tabs.Bypass:AddToggle({
    Name = "Anti-Kick",
    Default = false,
    Callback = function(value)
        antiKickActive = value
        if value then
            spawn(function()
                while antiKickActive and task.wait(math.random(5, 10)) do
                    VU:CaptureController()
                    for _, v in pairs(RS:GetDescendants()) do
                        if v:IsA("RemoteEvent") and v.Name:match("Input") then
                            v:FireServer("SimulatedMove", {Time = tick()})
                            break
                        end
                    end
                    OrionLib:MakeNotification({Name = "Anti-Kick", Content = "Preventing kick attempt", Time = 2})
                end
            end)
        end
    end
})

local antiDisplayActive = false
tabs.Bypass:AddToggle({
    Name = "Anti-Display (Hide Name)",
    Default = false,
    Callback = function(value)
        antiDisplayActive = value
        local char = LP.Character or LP.CharacterAdded:Wait()
        local humanoid = char:FindFirstChild("Humanoid")
        local head = char:FindFirstChild("Head")
        local function removeNameGui(targetHead)
            if targetHead then
                for _, gui in pairs(targetHead:GetChildren()) do
                    if gui:IsA("BillboardGui") then pcall(function() gui:Destroy() end) end
                end
            end
        end
        if value then
            pcall(function()
                humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                humanoid.NameDisplayDistance = 0
            end)
            removeNameGui(head)
            spawn(function()
                while antiDisplayActive do
                    if char and head and humanoid then
                        removeNameGui(head)
                        VU:CaptureController()
                        VU:ClickButton1(Vector2.new(math.random(0, 100), math.random(0, 100)))
                        for _, v in pairs(RS:GetDescendants()) do
                            if v:IsA("RemoteEvent") then
                                pcall(function()
                                    v:FireServer("UpdateName", "")
                                    v:FireServer("SetName", "")
                                    v:FireServer("PlayerData", {Name = ""})
                                    if char:FindFirstChild("HumanoidRootPart") then
                                        v:FireServer("UpdatePosition", char.HumanoidRootPart.Position)
                                    end
                                end)
                            end
                        end
                    else
                        char = LP.CharacterAdded:Wait()
                        head = char:WaitForChild("Head")
                        humanoid = char:WaitForChild("Humanoid")
                        pcall(function()
                            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                            humanoid.NameDisplayDistance = 0
                        end)
                        removeNameGui(head)
                    end
                    task.wait(0.2)
                end
            end)
            LP.CharacterAdded:Connect(function(newChar)
                if antiDisplayActive then
                    char = newChar
                    head = newChar:WaitForChild("Head")
                    humanoid = newChar:WaitForChild("Humanoid")
                    pcall(function()
                        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        humanoid.NameDisplayDistance = 0
                    end)
                    removeNameGui(head)
                end
            end)
        else
            if humanoid then
                pcall(function()
                    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                    humanoid.NameDisplayDistance = 100
                end)
            end
            if head then
                pcall(function()
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "NameTag"
                    billboard.Size = UDim2.new(0, 100, 0, 20)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.Parent = head
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Text = LP.Name
                    label.TextColor3 = Color3.new(1, 1, 1)
                    label.BackgroundTransparency = 1
                    label.Parent = billboard
                end)
            end
            for _, v in pairs(RS:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    pcall(function()
                        v:FireServer("UpdateName", LP.Name)
                        v:FireServer("SetName", LP.Name)
                        v:FireServer("PlayerData", {Name = LP.Name})
                    end)
                end
            end
        end
    end
})

local antiTeleportActive = false
tabs.Bypass:AddToggle({
    Name = "Anti-Teleport Reset",
    Default = false,
    Callback = function(value)
        antiTeleportActive = value
        local char = LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local lastPos = root.CFrame
            if value then
                spawn(function()
                    while antiTeleportActive and char and root and task.wait(0.1) do
                        if (root.CFrame.p - lastPos.p).Magnitude < 10 then
                            lastPos = root.CFrame
                        elseif (root.CFrame.p - lastPos.p).Magnitude > 10 then
                            root.CFrame = lastPos
                        end
                    end
                end)
            end
        end
    end
})

local serverSideMaskActive = false
tabs.Bypass:AddToggle({
    Name = "Server-Side Mask",
    Default = false,
    Callback = function(value)
        serverSideMaskActive = value
        if value then
            spawn(function()
                while serverSideMaskActive and task.wait(math.random(5, 10)) do
                    local char = LP.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local fakeData = {Action = "Move", Position = char.HumanoidRootPart.Position, Time = tick()}
                        for _, v in pairs(RS:GetDescendants()) do
                            if v:IsA("RemoteEvent") and v.Name:match("Update") then
                                v:FireServer("LegitUpdate", fakeData)
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
})

local clientSideMaskActive = false
tabs.Bypass:AddToggle({
    Name = "Client-Side Mask",
    Default = false,
    Callback = function(value)
        clientSideMaskActive = value
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            local humanoid = char.Humanoid
            if value then
                spawn(function()
                    while clientSideMaskActive and char and humanoid and task.wait(math.random(3, 7)) do
                        VU:CaptureController()
                        humanoid.WalkSpeed = humanoid.WalkSpeed
                    end
                end)
            end
        end
    end
})

local antiBanMaskActive = false
tabs.Bypass:AddToggle({
    Name = "Anti-Ban Mask",
    Default = false,
    Callback = function(value)
        antiBanMaskActive = value
        if value then
            spawn(function()
                while antiBanMaskActive and task.wait(math.random(10, 20)) do
                    VU:CaptureController()
                end
            end)
        end
    end
})

local antiHealthActive = false
tabs.Bypass:AddToggle({
    Name = "Anti-Health Drop",
    Default = false,
    Callback = function(value)
        antiHealthActive = value
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            local humanoid = char.Humanoid
            if value then
                local maxHealth = humanoid.MaxHealth
                humanoid.HealthChanged:Connect(function(health)
                    if antiHealthActive and health < maxHealth then humanoid.Health = maxHealth end
                end)
            end
        end
    end
})

local speedMaskActive = false
tabs.Bypass:AddToggle({
    Name = "Speed Mask",
    Default = false,
    Callback = function(value)
        speedMaskActive = value
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            local humanoid = char.Humanoid
            local root = char.HumanoidRootPart
            if value then
                humanoid.WalkSpeed = 16
                spawn(function()
                    while speedMaskActive and char and root and task.wait(0.01) do
                        local moveDir = humanoid.MoveDirection * 50
                        root.Velocity = Vector3.new(moveDir.X, root.Velocity.Y, moveDir.Z)
                    end
                end)
            else
                humanoid.WalkSpeed = 16
                root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
            end
        end
    end
})

local antiAdminActive = false
tabs.Bypass:AddToggle({
    Name = "Anti-Admin Detection",
    Default = false,
    Callback = function(value)
        antiAdminActive = value
        if value then
            spawn(function()
                while antiAdminActive and task.wait(math.random(5, 15)) do
                    VU:CaptureController()
                end
            end)
        end
    end
})

-- Meta Tab
tabs.Meta:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

tabs.Meta:AddButton({
    Name = "Solara Hub v3",
    Callback = function()
        loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Solara%20Hub%20v3.txt"))()
    end
})

tabs.Meta:AddButton({
    Name = "PShade Ultimate",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/randomstring0/pshade-ultimate/refs/heads/main/src/cd.lua'))()
    end
})

tabs.Meta:AddButton({
    Name = "Ghost Hub",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub'))()
    end
})

tabs.Meta:AddButton({
    Name = "GhostHub (src рабочий)",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/MyData3524/RobloxScripts/refs/heads/main/Ghost%20Hub'))()
    end
})

tabs.Meta:AddButton({
    Name = "Fling fe",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Wer0000/System-hub-V3/refs/heads/main/flings'))()
    end
})

tabs.Meta:AddButton({
    Name = "super-script-all-games (возможны вылеты)",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/FOGOTY/super-script-all-games-roblox/main/script'))()
    end
})

tabs.Meta:AddButton({
    Name = "invisible",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/dhVEWvWu'))()
    end
})

tabs.Meta:AddButton({
    Name = "hacker chat v5",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Wer0000/System-hub-V3/refs/heads/main/module.lua'))()
    end
})

-- Server Tab
local adminSpoofEnabled = false -- Флаг для перехвата прав админа
local serverDropdown = nil -- Дропдаун для списка серверов

-- Функция для получения и обновления списка серверов
local function updateServerList()
    local success, response = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    end)
    if not success or not response then
        if serverDropdown then
            serverDropdown:Set({
                Name = "Server List",
                Options = {"Failed to fetch servers!"},
                Callback = serverDropdown.Callback -- Сохраняем существующий Callback
            })
        end
        return {}
    end

    local servers = response
    if #servers == 0 then
        if serverDropdown then
            serverDropdown:Set({
                Name = "Server List",
                Options = {"No public servers found!"},
                Callback = serverDropdown.Callback
            })
        end
        return servers
    end

    -- Создаем список серверов
    local options = {}
    local serverList = {}
    for i, server in ipairs(servers) do
        local serverName = "Server " .. i .. " - " .. server.playing .. "/" .. server.maxPlayers .. " (ID: " .. server.id .. ")"
        table.insert(options, serverName)
        table.insert(serverList, {id = server.id, name = serverName})
    end

    -- Если дропдаун еще не существует, создаем его
    if not serverDropdown then
        serverDropdown = tabs.Server:AddDropdown({
            Name = "Server List",
            Options = options,
            Default = nil, -- Нет автоматического выбора
            Callback = function(selected)
                for _, server in pairs(serverList) do
                    if server.name == selected then
                        OrionLib:MakeNotification({
                            Name = "Join Server",
                            Content = "Joining " .. selected,
                            Time = 2
                        })
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LP)
                        break
                    end
                end
            end
        })
    else
        -- Обновляем существующий дропдаун
        serverDropdown:Set({
            Name = "Server List",
            Options = options,
            Callback = serverDropdown.Callback -- Сохраняем существующий Callback
        })
    end
    return servers
end

-- Запуск обновления каждые 10 секунд
spawn(function()
    updateServerList() -- Первоначальная загрузка
    while task.wait(10) do
        updateServerList()
    end
end)

-- Функция для проверки админа
local function checkForAdmin()
    for _, player in pairs(Players:GetPlayers()) do
        local success, rank = pcall(function()
            return player:GetRankInGroup(game.CreatorId)
        end)
        if (success and rank >= 240) or player.UserId == game.CreatorId then
            OrionLib:MakeNotification({
                Name = "Admin Detected",
                Content = "Admin " .. player.Name .. " (UserId: " .. player.UserId .. ") found!",
                Time = 5
            })
            if adminSpoofEnabled then
                spoofAdminRights(player.UserId)
            end
            return player
        end
    end
    OrionLib:MakeNotification({
        Name = "Admin Check",
        Content = "No admin found on the server.",
        Time = 5
    })
    return nil
end

-- Функция для подмены UserId и перехвата прав
local function spoofAdminRights(targetUserId)
    local originalUserId = LP.UserId
    local success, err = pcall(function()
        LP.UserId = targetUserId
        OrionLib:MakeNotification({
            Name = "Admin Spoof",
            Content = "Your UserId spoofed to " .. targetUserId .. " (Admin rights intercepted locally)",
            Time = 5
        })
    end)
    if not success then
        OrionLib:MakeNotification({
            Name = "Admin Spoof Error",
            Content = "Failed to spoof UserId: " .. err,
            Time = 5
        })
        LP.UserId = originalUserId
    end
end

-- Уведомление о входе админа (только если уже включён spoof)
Players.PlayerAdded:Connect(function(player)
    if adminSpoofEnabled then
        local success, rank = pcall(function()
            return player:GetRankInGroup(game.CreatorId)
        end)
        if (success and rank >= 240) or player.UserId == game.CreatorId then
            OrionLib:MakeNotification({
                Name = "Admin Detected",
                Content = "Admin " .. player.Name .. " (UserId: " .. player.UserId .. ") has joined!",
                Time = 5
            })
            spoofAdminRights(player.UserId)
        end
    end
end)

-- Кнопка для проверки админа
tabs.Server:AddButton({
    Name = "Check for Admin",
    Callback = function()
        checkForAdmin()
    end
})

tabs.Server:AddToggle({
    Name = "Spoof Admin Rights",
    Default = false,
    Callback = function(value)
        adminSpoofEnabled = value
        if value then
            OrionLib:MakeNotification({
                Name = "Admin Spoof",
                Content = "Spoof enabled. Press 'Check for Admin' or wait for an admin to join.",
                Time = 5
            })
        else
            LP.UserId = game.Players.LocalPlayer.UserId
            OrionLib:MakeNotification({
                Name = "Admin Spoof",
                Content = "Admin spoof disabled",
                Time = 2
            })
        end
    end
})

tabs.Server:AddButton({
    Name = "Server Hop",
    Callback = function()
        local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        local randomServer = servers[math.random(1, #servers)]
        if randomServer then
            OrionLib:MakeNotification({Name = "Server Hop", Content = "Hopping to server " .. randomServer.id, Time = 2})
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, randomServer.id)
        else
            OrionLib:MakeNotification({Name = "Server Hop", Content = "No servers found!", Time = 2})
        end
    end
})

tabs.Server:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        OrionLib:MakeNotification({Name = "Rejoin", Content = "Rejoining current server...", Time = 2})
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
    end
})

tabs.Server:AddButton({
    Name = "Server Reboot (Local)",
    Callback = function()
        OrionLib:MakeNotification({Name = "Server Reboot", Content = "Rebooting server locally...", Time = 2})
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                player.Character:BreakJoints()
            end
        end
        task.wait(1)
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
    end
})

tabs.Server:AddTextbox({
    Name = "Execute Server Script",
    Default = "-- Enter Lua code here",
    TextDisappear = true,
    Callback = function(value)
        local success, err = pcall(function()
            loadstring(value)()
        end)
        if success then
            OrionLib:MakeNotification({Name = "Server Script", Content = "Script executed successfully", Time = 2})
        else
            OrionLib:MakeNotification({Name = "Server Script", Content = "Error: " .. err, Time = 2})
        end
    end
})

tabs.Server:AddDropdown({
    Name = "Mass Action",
    Options = {"Kill All", "Kick All (Client)", "Freeze All", "Teleport All to Me"},
    Default = nil,
    Callback = function(value)
        if value == "Kill All" then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    player.Character:BreakJoints()
                end
            end
            OrionLib:MakeNotification({Name = "Mass Action", Content = "Killed all players", Time = 2})
        elseif value == "Kick All (Client)" then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LP then
                    player:Kick("Kicked by Meta Hub (client-side)")
                end
            end
            OrionLib:MakeNotification({Name = "Mass Action", Content = "Kicked all players (client-side)", Time = 2})
        elseif value == "Freeze All" then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.Anchored = true
                end
            end
            OrionLib:MakeNotification({Name = "Mass Action", Content = "Froze all players", Time = 2})
        elseif value == "Teleport All to Me" then
            local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character:PivotTo(myRoot.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5)))
                    end
                end
                OrionLib:MakeNotification({Name = "Mass Action", Content = "Teleported all to you", Time = 2})
            else
                OrionLib:MakeNotification({Name = "Mass Action", Content = "Your character not ready!", Time = 2})
            end
        end
    end
})

tabs.Server:AddButton({
    Name = "Shutdown Server (Local)",
    Callback = function()
        OrionLib:MakeNotification({Name = "Server Shutdown", Content = "Shutting down locally...", Time = 2})
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP then
                player:Kick("Server shutdown by Meta Hub (client-side)")
            end
        end
        task.wait(1)
        LP:Kick("Server shutdown completed")
    end
})

tabs.Server:AddToggle({
    Name = "Lock Server (Prevent Joins)",
    Default = false,
    Callback = function(value)
        if value then
            game:GetService("TeleportService"):SetTeleportSetting("ReserveServer", true)
            OrionLib:MakeNotification({Name = "Server Lock", Content = "Server locked (new joins prevented)", Time = 2})
        else
            game:GetService("TeleportService"):SetTeleportSetting("ReserveServer", false)
            OrionLib:MakeNotification({Name = "Server Lock", Content = "Server unlocked", Time = 2})
        end
    end
})

-- Camera Tab
tabs.Camera:AddSlider({
    Name = "Camera Zoom",
    Min = 0,
    Max = 100,
    Default = 0,
    Increment = 1,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = 70 - value
    end
})

tabs.Camera:AddToggle({
    Name = "Lock Camera to Player",
    Default = false,
    Callback = function(value)
        if value then
            workspace.CurrentCamera.CameraSubject = LP.Character and LP.Character.Humanoid
        else
            workspace.CurrentCamera.CameraSubject = LP.Character
        end
    end
})

local playerDropdown = nil
local teleportDropdown = nil


local function updatePlayerLists()
    local activePlayers = {}
    for _, player in pairs(Players:GetPlayers()) do
        table.insert(activePlayers, player.Name)
    end
    

    if playerDropdown then
        playerDropdown:Destroy()
        playerDropdown = tabs.Player:AddDropdown({
            Name = "Player List",
            Options = activePlayers,
            Default = selectedPlayer,
            Callback = function(chosenPlayer)
                selectedPlayer = chosenPlayer
            end
        })
    end
    

    if teleportDropdown then
        teleportDropdown:Destroy()
        teleportDropdown = tabs.Teleport:AddDropdown({
            Name = "Teleport to Player",
            Options = activePlayers,
            Default = selectedTeleportPlayer,
            Callback = function(chosenPlayer)
                selectedTeleportPlayer = chosenPlayer
            end
        })
    end
end

Players.PlayerAdded:Connect(updatePlayerLists)
Players.PlayerRemoving:Connect(updatePlayerLists)
spawn(function()
    while task.wait(1) do
        updatePlayerLists()
    end
end)
updatePlayerLists()

OrionLib:Init()
