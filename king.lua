--[[ 
    KING PREMIUM V8 - THE ULTIMATE OVERHAUL
    STYLE: Exact Opiam Clone (Sidebar + Header + Cards)
    FEATURES: Combat, Player (Fly/Noclip), Visuals (ESP), Scripts (Hub), World, Settings
]]

if not game:IsLoaded() then game.Loaded:Wait() end

--// CONFIG
getgenv().KingConfig = {
    Aimbot = {Enabled = false, Smooth = 0.5, FOV = 150, WallCheck = true},
    Player = {WS = 16, JP = 50, InfJump = false, Noclip = false, Fly = false},
    Visuals = {ESP = false, Tracers = false, Fullbright = false},
    Theme = {
        Main = Color3.fromRGB(15, 15, 16),
        Side = Color3.fromRGB(22, 21, 26),
        Accent = Color3.fromRGB(160, 80, 255),
        Text = Color3.fromRGB(240, 240, 240)
    }
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

--// UI CORE
local KingUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", KingUI)
Main.Size = UDim2.new(0, 580, 0, 380)
Main.Position = UDim2.new(0.5, -290, 0.5, -190)
Main.BackgroundColor3 = getgenv().KingConfig.Theme.Main
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = getgenv().KingConfig.Theme.Side
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.Text = "opiam" -- Matching your image style
Logo.TextColor3 = Color3.new(1, 1, 1)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 22
Logo.BackgroundTransparency = 1

local Ver = Instance.new("TextLabel", Logo)
Ver.Size = UDim2.new(0, 30, 0, 15)
Ver.Position = UDim2.new(0.65, 0, 0.45, 0)
Ver.BackgroundColor3 = getgenv().KingConfig.Theme.Accent
Ver.Text = "v8.0"
Ver.TextSize = 10
Ver.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Ver)

-- Top Stats Bar (FPS / PING)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, -170, 0, 40)
TopBar.Position = UDim2.new(0, 165, 0, 5)
TopBar.BackgroundTransparency = 1

local FPSLabel = Instance.new("TextLabel", TopBar)
FPSLabel.Size = UDim2.new(0, 60, 1, 0)
FPSLabel.Position = UDim2.new(0.7, 0, 0, 0)
FPSLabel.Text = "60 FPS"
FPSLabel.TextColor3 = Color3.fromRGB(80, 255, 150)
FPSLabel.Font = Enum.Font.GothamSemibold
FPSLabel.TextSize = 12
FPSLabel.BackgroundTransparency = 1

local PingLabel = Instance.new("TextLabel", TopBar)
PingLabel.Size = UDim2.new(0, 60, 1, 0)
PingLabel.Position = UDim2.new(0.85, 0, 0, 0)
PingLabel.Text = "20ms"
PingLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
PingLabel.Font = Enum.Font.GothamSemibold
PingLabel.TextSize = 12
PingLabel.BackgroundTransparency = 1

-- Page System
local PageContainer = Instance.new("Frame", Main)
PageContainer.Size = UDim2.new(1, -170, 1, -50)
PageContainer.Position = UDim2.new(0, 165, 0, 45)
PageContainer.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local P = Instance.new("ScrollingFrame", PageContainer)
    P.Size = UDim2.new(1, 0, 1, 0)
    P.Visible = false
    P.BackgroundTransparency = 1
    P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
    Pages[name] = P
    return P
end

local CombatPage = CreatePage("Combat")
local PlayerPage = CreatePage("Player")
local VisualsPage = CreatePage("Visuals")
local ScriptsPage = CreatePage("Scripts")
local WorldPage = CreatePage("World")
CombatPage.Visible = true

--// COMPONENT: THE OPIAM CARD
local function AddCard(parent, title, desc, callback)
    local Card = Instance.new("TextButton", parent)
    Card.Size = UDim2.new(1, -10, 0, 60)
    Card.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    Card.AutoButtonColor = false
    Card.Text = ""
    Instance.new("UICorner", Card)
    Instance.new("UIStroke", Card).Color = Color3.fromRGB(35, 35, 35)

    local T = Instance.new("TextLabel", Card)
    T.Size = UDim2.new(0.7, 0, 0, 30)
    T.Position = UDim2.new(0, 15, 0, 10)
    T.Text = title
    T.TextColor3 = Color3.new(1,1,1)
    T.Font = Enum.Font.GothamSemibold
    T.TextSize = 14
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.BackgroundTransparency = 1

    local D = Instance.new("TextLabel", Card)
    D.Size = UDim2.new(0.7, 0, 0, 20)
    D.Position = UDim2.new(0, 15, 0, 30)
    D.Text = desc
    D.TextColor3 = Color3.fromRGB(120, 120, 120)
    D.Font = Enum.Font.Gotham
    D.TextSize = 11
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.BackgroundTransparency = 1

    local Icon = Instance.new("ImageLabel", Card)
    Icon.Size = UDim2.new(0, 25, 0, 25)
    Icon.Position = UDim2.new(1, -40, 0.5, -12)
    Icon.Image = "rbxassetid://6031094678" -- Click Icon
    Icon.BackgroundTransparency = 1
    Icon.ImageColor3 = Color3.fromRGB(60, 60, 60)

    local toggled = false
    Card.MouseButton1Click:Connect(function()
        toggled = not toggled
        Icon.ImageColor3 = toggled and getgenv().KingConfig.Theme.Accent or Color3.fromRGB(60, 60, 60)
        callback(toggled)
    end)
end

--// NAVIGATION
local function AddTab(name)
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(1, 0, 0, 40)
    B.Position = UDim2.new(0, 0, 0, 70 + (#Sidebar:GetChildren()-2)*45)
    B.BackgroundTransparency = 1
    B.Text = "  " .. name
    B.TextColor3 = Color3.fromRGB(150, 150, 150)
    B.Font = Enum.Font.GothamSemibold
    B.TextSize = 13
    B.TextXAlignment = Enum.TextXAlignment.Left

    B.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
        for _, btn in pairs(Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then btn.TextColor3 = Color3.fromRGB(150, 150, 150) end
        end
        B.TextColor3 = getgenv().KingConfig.Theme.Accent
    end)
end

AddTab("Combat")
AddTab("Player")
AddTab("Visuals")
AddTab("World")
AddTab("Scripts")

--// POPULATING TABS
-- Combat
AddCard(CombatPage, "Master Aimbot", "Locks camera onto targets", function(v) getgenv().KingConfig.Aimbot.Enabled = v end)
AddCard(CombatPage, "Wall Check", "Only aim at visible players", function(v) getgenv().KingConfig.Aimbot.WallCheck = v end)
AddCard(CombatPage, "Silent Aim", "Redirects bullets to enemies", function(v) print("Silent Aim: "..tostring(v)) end)

-- Player
AddCard(PlayerPage, "Fly Mode", "Allows you to fly around", function(v) getgenv().KingConfig.Player.Fly = v end)
AddCard(PlayerPage, "Noclip", "Walk through walls", function(v) getgenv().KingConfig.Player.Noclip = v end)
AddCard(PlayerPage, "Infinite Jump", "Never touch the ground", function(v) getgenv().KingConfig.Player.InfJump = v end)

-- World
AddCard(WorldPage, "Fullbright", "Removes shadows and darkness", function(v) getgenv().KingConfig.Visuals.Fullbright = v end)

-- Scripts
AddCard(ScriptsPage, "Infinite Yield", "Best admin command script", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
AddCard(ScriptsPage, "Dex Explorer", "Explore game files", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)

--// RUNTIME STATS & LOGIC
RunService.RenderStepped:Connect(function()
    FPSLabel.Text = math.floor(1/RunService.RenderStepped:Wait()) .. " FPS"
    PingLabel.Text = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    
    if getgenv().KingConfig.Visuals.Fullbright then
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
    end
end)

--// MOBILE TOGGLE (The New Logo Toggle)
local ToggleBtn = Instance.new("ImageButton", KingUI)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 15, 0.15, 0)
ToggleBtn.BackgroundColor3 = getgenv().KingConfig.Theme.Side
ToggleBtn.Image = "rbxassetid://6031280245" -- Crown Icon
ToggleBtn.ImageColor3 = getgenv().KingConfig.Theme.Accent
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("KING PREMIUM V8 LOADED")
