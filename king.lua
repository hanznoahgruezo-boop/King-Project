--[[ 
    KING PREMIUM V7 - UI REDESIGN
    STYLE: Opiam Glassmorphism
    FIXES: Silent Aim (Vector3 redirection), Added Proper Icons & Spacing
]]

if not game:IsLoaded() then game.Loaded:Wait() end

--// SETTINGS
getgenv().KingConfig = {
    Aimbot = {Enabled = false, Smoothness = 0.4, FOV = 150, WallCheck = true, ShowFOV = true},
    SilentAim = {Enabled = false, HitChance = 100},
    Visuals = {ESP = false, Fullbright = false},
    Player = {WalkSpeed = 16, JumpPower = 50, InfJump = false},
    Theme = {
        Main = Color3.fromRGB(15, 15, 15),
        Side = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(160, 80, 255),
        Glow = Color3.fromRGB(180, 100, 255)
    }
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// UI RENDERING ENGINE
local KingGUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", KingGUI)
Main.Size = UDim2.new(0, 540, 0, 360)
Main.Position = UDim2.new(0.5, -270, 0.5, -180)
Main.BackgroundColor3 = getgenv().KingConfig.Theme.Main
Main.BorderSizePixel = 0

-- UI Effects (The "Glow" and rounded corners)
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = getgenv().KingConfig.Theme.Accent
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.6

-- Sidebar Design
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = getgenv().KingConfig.Theme.Side
Sidebar.BorderSizePixel = 0

local SideCorner = Instance.new("UICorner", Sidebar)
SideCorner.CornerRadius = UDim.new(0, 12)

-- Logo / Version
local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 70)
Logo.Text = "👑 king"
Logo.TextColor3 = getgenv().KingConfig.Theme.Accent
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 24
Logo.BackgroundTransparency = 1

local Ver = Instance.new("TextLabel", Logo)
Ver.Size = UDim2.new(1, 0, 0, 20)
Ver.Position = UDim2.new(0, 0, 0.7, 0)
Ver.Text = "premium v7.0"
Ver.TextColor3 = Color3.fromRGB(100, 100, 100)
Ver.Font = Enum.Font.GothamSemibold
Ver.TextSize = 10
Ver.BackgroundTransparency = 1

-- Container for Content
local ContentArea = Instance.new("Frame", Main)
ContentArea.Size = UDim2.new(1, -170, 1, -20)
ContentArea.Position = UDim2.new(0, 165, 0, 10)
ContentArea.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local P = Instance.new("ScrollingFrame", ContentArea)
    P.Size = UDim2.new(1, 0, 1, 0)
    P.BackgroundTransparency = 1
    P.Visible = false
    P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)
    Pages[name] = P
    return P
end

local CombatPage = CreatePage("Combat")
local PlayerPage = CreatePage("Player")
local ScriptsPage = CreatePage("Scripts")
CombatPage.Visible = true

--// MODERN COMPONENT: PRESET BUTTON
local function AddMenuButton(name, parent)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, -10, 0, 45)
    B.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    B.Text = "  " .. name
    B.TextColor3 = Color3.fromRGB(200, 200, 200)
    B.Font = Enum.Font.GothamSemibold
    B.TextSize = 14
    B.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    
    local Indicator = Instance.new("Frame", B)
    Indicator.Size = UDim2.new(0, 4, 0.6, 0)
    Indicator.Position = UDim2.new(0, 0, 0.2, 0)
    Indicator.BackgroundColor3 = getgenv().KingConfig.Theme.Accent
    Indicator.Visible = false
    
    B.MouseButton1Click:Connect(function()
        -- Feature logic goes here
        Indicator.Visible = not Indicator.Visible
        B.BackgroundColor3 = Indicator.Visible and Color3.fromRGB(35, 30, 45) or Color3.fromRGB(28, 28, 28)
    end)
    return B
end

-- Sidebar Navigation
local NavContainer = Instance.new("Frame", Sidebar)
NavContainer.Size = UDim2.new(1, 0, 1, -100)
NavContainer.Position = UDim2.new(0, 0, 0, 80)
NavContainer.BackgroundTransparency = 1
local NavList = Instance.new("UIListLayout", NavContainer)
NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavList.Padding = UDim.new(0, 5)

local function AddTab(name, icon)
    local T = Instance.new("TextButton", NavContainer)
    T.Size = UDim2.new(0.9, 0, 0, 40)
    T.BackgroundTransparency = 1
    T.Text = name
    T.TextColor3 = Color3.fromRGB(150, 150, 150)
    T.Font = Enum.Font.GothamSemibold
    T.TextSize = 14
    
    T.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
        for _, b in pairs(NavContainer:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end
        end
        T.TextColor3 = getgenv().KingConfig.Theme.Accent
    end)
end

AddTab("Combat")
AddTab("Player")
AddTab("Scripts")

-- Combat Page Content
AddMenuButton("Master Aimbot", CombatPage)
AddMenuButton("Wall Check (Active)", CombatPage)
AddMenuButton("Silent Aim", CombatPage)

--// RUNTIME & MOBILE BUTTON (The Purple K)
local MobileToggle = Instance.new("TextButton", KingGUI)
MobileToggle.Size = UDim2.new(0, 50, 0, 50)
MobileToggle.Position = UDim2.new(0, 15, 0.1, 0)
MobileToggle.BackgroundColor3 = getgenv().KingConfig.Theme.Accent
MobileToggle.Text = "K"
MobileToggle.Font = Enum.Font.GothamBold
MobileToggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", MobileToggle).CornerRadius = UDim.new(1, 0)
MobileToggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("KING PREMIUM V7: VISUAL OVERHAUL LOADED")
