--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

--// WIND UI
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Reach Hub",
    Icon = "rbxassetid://4483345998",
    Author = "Converted",
    Folder = "ReachHub",
    Size = UDim2.fromOffset(520, 420),
    Theme = "Dark"
})

local ReachTab = Window:CreateTab("Reach", "square")

--// ================== COMMON ==================
local function GetCharacter()
    return LocalPlayer.Character
end

local function GetBall()
    local sys = workspace:FindFirstChild("TPSSystem")
    return sys and sys:FindFirstChild("TPS")
end

local function GetLeg(char, hum, foot)
    if hum.RigType == Enum.HumanoidRigType.R6 then
        return foot == 1 and char:FindFirstChild("Right Leg") or char:FindFirstChild("Left Leg")
    else
        return foot == 1 and char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("LeftLowerLeg")
    end
end

--// ================== LEG REACH ==================
local LEG_REACH = 3
local LegConn

local function StartLegReach()
    if LegConn then LegConn:Disconnect() end
    LegConn = RunService.RenderStepped:Connect(function()
        local char = GetCharacter()
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        local ball = GetBall()
        if not ball then return end

        local lf = Lighting:FindFirstChild(LocalPlayer.Name)
        local pf = lf and lf:FindFirstChild("PreferredFoot")
        if not pf then return end

        local leg = GetLeg(char, hum, pf.Value)
        if not leg then return end

        if (hrp.Position - ball.Position).Magnitude <= LEG_REACH then
            firetouchinterest(leg, ball, 0)
            firetouchinterest(leg, ball, 1)
        end
    end)
end

ReachTab:CreateToggle({
    Name = "Enable Leg Reach",
    Callback = function(state)
        if state then
            StartLegReach()
        else
            if LegConn then LegConn:Disconnect() LegConn = nil end
        end
    end
})

ReachTab:CreateSlider({
    Name = "Leg Reach Distance",
    Min = 1,
    Max = 20,
    Default = 3,
    Callback = function(v)
        LEG_REACH = v
    end
})

--// ================== BALL REACH ==================
local BALL_REACH = 5
local BallConn

local function StartBallReach()
    if BallConn then BallConn:Disconnect() end
    BallConn = RunService.RenderStepped:Connect(function()
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local ball = GetBall()
        if not hrp or not ball then return end

        if (hrp.Position - ball.Position).Magnitude <= BALL_REACH then
            firetouchinterest(ball, hrp, 0)
            firetouchinterest(ball, hrp, 1)
        end
    end)
end

ReachTab:CreateToggle({
    Name = "Enable Ball Reach",
    Callback = function(state)
        if state then
            StartBallReach()
        else
            if BallConn then BallConn:Disconnect() BallConn = nil end
        end
    end
})

ReachTab:CreateSlider({
    Name = "Ball Reach Distance",
    Min = 1,
    Max = 20,
    Default = 5,
    Callback = function(v)
        BALL_REACH = v
    end
})

--// ================== HEAD REACH ==================
local HEAD_REACH = 4
local HeadConn

local function StartHeadReach()
    if HeadConn then HeadConn:Disconnect() end
    HeadConn = RunService.RenderStepped:Connect(function()
        local char = GetCharacter()
        local head = char and char:FindFirstChild("Head")
        local ball = GetBall()
        if not head or not ball then return end

        if (head.Position - ball.Position).Magnitude <= HEAD_REACH then
            firetouchinterest(head, ball, 0)
            firetouchinterest(head, ball, 1)
        end
    end)
end

ReachTab:CreateToggle({
    Name = "Enable Head Reach",
    Callback = function(state)
        if state then
            StartHeadReach()
        else
            if HeadConn then HeadConn:Disconnect() HeadConn = nil end
        end
    end
})

ReachTab:CreateSlider({
    Name = "Head Reach Distance",
    Min = 1,
    Max = 20,
    Default = 4,
    Callback = function(v)
        HEAD_REACH = v
    end
})

--// ================== RESPAWN FIX ==================
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if LegConn then StartLegReach() end
    if BallConn then StartBallReach() end
    if HeadConn then StartHeadReach() end
end)
