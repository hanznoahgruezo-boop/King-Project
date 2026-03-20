--[[ 
    PROJECT: KING_GUI_PREMIUM_FINAL
    BUILD: 3.0.5 (RETAIL)
    FEATURES: Aimbot, ESP, Silent Aim, Server Hop, Anti-AFK, Panic Key
]]

if not game:IsLoaded() then game.Loaded:Wait() end

--// SETTINGS & GLOBALS
getgenv().KingConfig = {
    Aimbot = {Enabled = false, Smoothness = 0.4, FOV = 150, TargetPart = "Head"},
    ESP = {Enabled = false, Boxes = true, Names = true, Color = Color3.fromRGB(212, 175, 55)},
    SilentAim = {Enabled = false, HitChance = 100},
    AntiAFK = true,
    PanicKey = Enum.KeyCode.RightControl
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// FEATURE: ANTI-AFK (Internal)
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if getgenv().KingConfig.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

--// CORE FUNCTIONS
local function GetClosestPlayer()
    local Target, MaxDist = nil, getgenv().KingConfig.Aimbot.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if OnScreen then
                local MouseDist = (Vector2.new(Pos.X, Pos.Y) - UIS:GetMouseLocation()).Magnitude
                if MouseDist < MaxDist then MaxDist = MouseDist; Target = v end
            end
        end
    end
    return Target
end

--// KING UI INITIALIZATION
local KingGUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", KingGUI)
Main.Size = UDim2.new(0, 250, 0, 400)
Main.Position = UDim2.new(0.5, -125, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "KING PREMIUM V3"
Title.TextColor3 = Color3.fromRGB(212, 175, 55)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 8)

--// UI COMPONENT TOOLKIT
local function CreateToggle(text, callback)
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 13
    Instance.new("UICorner", Btn)

    local toggled = false
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Btn.TextColor3 = toggled and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(200, 200, 200)
        callback(toggled)
    end)
end

--// FEATURE SETUP
CreateToggle("Master Aimbot", function(v) getgenv().KingConfig.Aimbot.Enabled = v end)
CreateToggle("Royal ESP", function(v) getgenv().KingConfig.ESP.Enabled = v end)
CreateToggle("Silent Aim", function(v) getgenv().KingConfig.SilentAim.Enabled = v end)
CreateToggle("Anti-AFK (On)", function(v) getgenv().KingConfig.AntiAFK = v end)

CreateToggle("Server Hop", function()
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
    for _, s in pairs(Servers.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end)

--// MOBILE TOGGLE CROWN
local Crown = Instance.new("TextButton", KingGUI)
Crown.Size = UDim2.new(0, 50, 0, 50)
Crown.Position = UDim2.new(0, 10, 0.2, 0)
Crown.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
Crown.Text = "K"
Crown.Font = Enum.Font.GothamBold
Crown.TextSize = 24
Instance.new("UICorner", Crown).CornerRadius = UDim.new(1, 0)
Crown.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

--// PANIC KEY SCRIPT
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == getgenv().KingConfig.PanicKey then KingGUI:Destroy() end
end)

--// RUNTIME LOOP (Aimbot Logic)
RunService.RenderStepped:Connect(function()
    if getgenv().KingConfig.Aimbot.Enabled then
        local T = GetClosestPlayer()
        if T and T.Character then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character[getgenv().KingConfig.Aimbot.TargetPart].Position), 1 - getgenv().KingConfig.Aimbot.Smoothness)
        end
    end
end)

print("KING PREMIUM LOADED SUCCESSFULLY")
