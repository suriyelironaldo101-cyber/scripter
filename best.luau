--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

--// ORION
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "Leg Reach",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "LegReachCFG"
})

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

--// CONFIG
local LocalPlayer = Players.LocalPlayer
local REACH = 3
local ReachConnection

--// GET LEG
local function GetLeg(char, hum, foot)
    if hum.RigType == Enum.HumanoidRigType.R6 then
        return foot == 1 and char:FindFirstChild("Right Leg") or char:FindFirstChild("Left Leg")
    else
        return foot == 1 and char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("LeftLowerLeg")
    end
end

--// MAIN REACH FUNCTION
local function Tick()
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    local sys = workspace:FindFirstChild("TPSSystem")
    local ball = sys and sys:FindFirstChild("TPS")
    if not ball then return end

    local lf = Lighting:FindFirstChild(LocalPlayer.Name)
    local pf = lf and lf:FindFirstChild("PreferredFoot")
    if not pf then return end

    local leg = GetLeg(char, hum, pf.Value)
    if not leg then return end

    if (hrp.Position - ball.Position).Magnitude <= REACH then
        firetouchinterest(leg, ball, 0)
        firetouchinterest(leg, ball, 1)
    end
end

--// UI
Tab:AddToggle({
    Name = "Enable Leg Reach",
    Default = false,
    Callback = function(Value)
        if Value then
            ReachConnection = RunService.RenderStepped:Connect(Tick) -- 🔥 FIX
        else
            if ReachConnection then
                ReachConnection:Disconnect()
                ReachConnection = nil
            end
        end
    end
})

Tab:AddSlider({
    Name = "Reach Distance",
    Min = 1,
    Max = 10,
    Default = 3,
    Increment = 0.1,
    Callback = function(Value)
        REACH = Value
    end
})

OrionLib:Init()
