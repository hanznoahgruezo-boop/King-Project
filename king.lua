--[[ 
    PROJECT: KING PREMIUM V6 (OPIAM STYLE)
    FEATURES: Aimbot (Wallcheck), Silent Aim (FIXED), Visuals, Player Mods, Script Hub
    FIXES: Silent Aim redirection fixed, Wallcheck added.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

--// CONFIGURATION
getgenv().KingConfig = {
    Aimbot = {Enabled = false, Smoothness = 0.5, FOV = 150, WallCheck = true, ShowFOV = true},
    SilentAim = {Enabled = false, TargetPart = "Head", HitChance = 100},
    Visuals = {ESP = false, Fullbright = false},
    Player = {WalkSpeed = 16, JumpPower = 50, InfJump = false},
    Theme = {Main = Color3.fromRGB(15, 15, 15), Side = Color3.fromRGB(22, 22, 22), Accent = Color3.fromRGB(160, 80, 255)}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// UTILITIES
local function IsVisible(part)
    if not getgenv().KingConfig.Aimbot.WallCheck then return true end
    local Ignore = {LocalPlayer.Character, part.Parent}
    local Ray = Camera:GetPartsObscuringTarget({part.Position, Camera.CFrame.Position}, Ignore)
    return #Ray == 0
end

local function GetTarget()
    local Target, MaxDist = nil, getgenv().KingConfig.Aimbot.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if OnScreen and IsVisible(v.Character.Head) then
                local Dist = (Vector2.new(Pos.X, Pos.Y) - UIS:GetMouseLocation()).Magnitude
                if Dist < MaxDist then MaxDist = Dist; Target = v end
            end
        end
    end
    return Target
end

--// UI CONSTRUCTION (PICTURE ACCURATE)
local KingGUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", KingGUI)
Main.Size = UDim2.new(0, 520, 0, 340)
Main.Position = UDim2.new(0.5, -260, 0.5, -170)
Main.BackgroundColor3 = getgenv().KingConfig.Theme.Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Left Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = getgenv().KingConfig.Theme.Side
Instance.new("UICorner", Sidebar)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.Text = "👑 king"
Logo.TextColor3 = getgenv().KingConfig.Theme.Accent
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 22
Logo.BackgroundTransparency = 1

local Nav = Instance.new("Frame", Sidebar)
Nav.Size = UDim2.new(1, 0, 1, -70)
Nav.Position = UDim2.new(0, 0, 0, 65)
Nav.BackgroundTransparency = 1
local NavList = Instance.new("UIListLayout", Nav)

-- Pages
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -165, 1, -20)
Container.Position = UDim2.new(0, 160, 0, 10)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0)
    P.BackgroundTransparency = 1
    P.Visible = false
    P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 5)
    Pages[name] = P
    return P
end

local CombatPage = CreatePage("Combat")
local PlayerPage = CreatePage("Player")
local VisualsPage = CreatePage("Visuals")
local ScriptsPage = CreatePage("Scripts")
CombatPage.Visible = true

--// UI BUILDER FUNCTIONS
local function AddTab(name)
    local B = Instance.new("TextButton", Nav)
    B.Size = UDim2.new(1, 0, 0, 40)
    B.BackgroundTransparency = 1
    B.Text = "  " .. name
    B.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    B.Font = Enum.Font.GothamSemibold
    B.TextXAlignment = Enum.TextXAlignment.Left
    
    B.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
    end)
end

local function AddToggle(parent, text, configPath, configKey)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, 0, 0, 35)
    B.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    B.Text = "  " .. text
    B.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    B.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", B)
    
    B.MouseButton1Click:Connect(function()
        getgenv().KingConfig[configPath][configKey] = not getgenv().KingConfig[configPath][configKey]
        B.BackgroundColor3 = getgenv().KingConfig[configPath][configKey] and getgenv().KingConfig.Theme.Accent or Color3.fromRGB(25, 25, 25)
    end)
end

--// TABS & CONTENT
AddTab("Combat")
AddTab("Player")
AddTab("Visuals")
AddTab("Scripts")

-- Combat
AddToggle(CombatPage, "Enable Aimbot", "Aimbot", "Enabled")
AddToggle(CombatPage, "Wall Check (Active)", "Aimbot", "WallCheck")
AddToggle(CombatPage, "Enable Silent Aim", "SilentAim", "Enabled")

-- Player
AddToggle(PlayerPage, "Infinite Jump", "Player", "InfJump")
local SpeedInp = Instance.new("TextBox", PlayerPage)
SpeedInp.Size = UDim2.new(1,0,0,35); SpeedInp.PlaceholderText = "Speed Value..."
SpeedInp.FocusLost:Connect(function() LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(SpeedInp.Text) or 16 end)

-- Scripts (Internal Executor)
local ExecBox = Instance.new("TextBox", ScriptsPage)
ExecBox.Size = UDim2.new(1,0,0,100); ExecBox.MultiLine = true; ExecBox.BackgroundColor3 = Color3.new(0,0,0); ExecBox.TextColor3 = Color3.new(1,1,1)
local RunBtn = Instance.new("TextButton", ScriptsPage)
RunBtn.Size = UDim2.new(1,0,0,30); RunBtn.Text = "Execute"; RunBtn.MouseButton1Click:Connect(function() loadstring(ExecBox.Text)() end)

--// FIX: SILENT AIM METHOD
local OldNC; OldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if not checkcaller() and getgenv().KingConfig.SilentAim.Enabled and (Method == "FindPartOnRayWithIgnoreList" or Method == "Raycast") then
        local T = GetTarget()
        if T then
            if Method == "Raycast" then Args[2] = (T.Character.Head.Position - Args[1]).Unit * 1000
            else Args[1] = Ray.new(Camera.CFrame.Position, (T.Character.Head.Position - Camera.CFrame.Position).Unit * 1000) end
            return OldNC(self, unpack(Args))
        end
    end
    return OldNC(self, ...)
end))

--// RUNTIME
RunService.RenderStepped:Connect(function()
    if getgenv().KingConfig.Aimbot.Enabled then
        local T = GetTarget()
        if T then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), 1 - getgenv().KingConfig.Aimbot.Smoothness) end
    end
end)

UIS.JumpRequest:Connect(function() if getgenv().KingConfig.Player.InfJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)

print("KING PREMIUM V6 LOADED - OPIAM STYLE")
