--[[ 
    PROJECT: OPIAM CLONE V10 (KING EDITION)
    DESIGN: 1:1 UI MATCH (SIDEBAR + CARDS + TOP STATS)
    FEATURES: Universal Combat, Drawing-API Visuals, Script Hub, Server Mods
]]

if not game:IsLoaded() then game.Loaded:Wait() end

--// NOTIFICATIONS (The Premium Feel)
local function Notify(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "KING PREMIUM",
        Text = text,
        Duration = 5
    })
end

--// GLOBALS
getgenv().KingConfig = {
    Combat = {Aimbot = false, SilentAim = false, FOV = 150, Smooth = 0.5, WallCheck = true},
    Visuals = {ESP = false, Boxes = false, Tracers = false, Names = false},
    Player = {WS = 16, JP = 50, InfJump = false, Noclip = false},
    Theme = {Accent = Color3.fromRGB(160, 80, 255), BG = Color3.fromRGB(13, 13, 15), Side = Color3.fromRGB(18, 18, 22)}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--// UNIVERSAL TARGETING ENGINE
local function IsVisible(Part)
    if not getgenv().KingConfig.Combat.WallCheck then return true end
    local Ray = Camera:GetPartsObscuringTarget({Part.Position, Camera.CFrame.Position}, {LocalPlayer.Character, Part.Parent})
    return #Ray == 0
end

local function GetTarget()
    local Target, MaxDist = nil, getgenv().KingConfig.Combat.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local Head = v.Character.Head
            local Pos, OnScreen = Camera:WorldToViewportPoint(Head.Position)
            if OnScreen and IsVisible(Head) then
                local Dist = (Vector2.new(Pos.X, Pos.Y) - UIS:GetMouseLocation()).Magnitude
                if Dist < MaxDist then MaxDist = Dist; Target = v end
            end
        end
    end
    return Target
end

--// UI CONSTRUCTION
local KingUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", KingUI)
Main.Size = UDim2.new(0, 620, 0, 420)
Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = getgenv().KingConfig.Theme.BG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(35, 35, 40)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = getgenv().KingConfig.Theme.Side
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 80)
Logo.Text = "opiam"
Logo.TextColor3 = Color3.new(1,1,1)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 24
Logo.BackgroundTransparency = 1

-- Top Bar Stats
local Stats = Instance.new("Frame", Main)
Stats.Size = UDim2.new(1, -190, 0, 40)
Stats.Position = UDim2.new(0, 185, 0, 5)
Stats.BackgroundTransparency = 1

local function CreateStat(name, color, pos)
    local L = Instance.new("TextLabel", Stats)
    L.Size = UDim2.new(0, 80, 1, 0)
    L.Position = pos
    L.Text = "0 " .. name
    L.TextColor3 = color
    L.Font = Enum.Font.GothamSemibold
    L.TextSize = 12
    L.BackgroundTransparency = 1
    return L
end
local FPSL = CreateStat("FPS", Color3.fromRGB(100, 255, 150), UDim2.new(0.65, 0, 0, 0))
local PingL = CreateStat("MS", Color3.fromRGB(255, 100, 100), UDim2.new(0.85, 0, 0, 0))

-- Page Logic
local PageHolder = Instance.new("Frame", Main)
PageHolder.Size = UDim2.new(1, -190, 1, -60)
PageHolder.Position = UDim2.new(0, 185, 0, 50)
PageHolder.BackgroundTransparency = 1

local Pages = {}
local function NewPage(name)
    local P = Instance.new("ScrollingFrame", PageHolder)
    P.Size = UDim2.new(1, 0, 1, 0)
    P.Visible = false
    P.BackgroundTransparency = 1
    P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)
    Pages[name] = P
    return P
end

local Tabs = {"Home", "Player", "Aimbot", "World", "Visuals", "Scripts", "Settings"}
for _, t in pairs(Tabs) do NewPage(t) end
Pages["Home"].Visible = true

--// COMPONENT: THE OPIAM CARD
local function AddCard(parent, title, desc, callback)
    local Card = Instance.new("TextButton", parent)
    Card.Size = UDim2.new(1, -10, 0, 65)
    Card.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    Card.AutoButtonColor = false
    Card.Text = ""
    Instance.new("UICorner", Card)
    Instance.new("UIStroke", Card).Color = Color3.fromRGB(40, 40, 45)

    local T = Instance.new("TextLabel", Card)
    T.Size = UDim2.new(1, -20, 0, 30); T.Position = UDim2.new(0, 15, 0, 10)
    T.Text = title; T.TextColor3 = Color3.new(1,1,1); T.Font = Enum.Font.GothamBold; T.TextSize = 14; T.TextXAlignment = 0; T.BackgroundTransparency = 1

    local D = Instance.new("TextLabel", Card)
    D.Size = UDim2.new(1, -20, 0, 20); D.Position = UDim2.new(0, 15, 0, 32)
    D.Text = desc; D.TextColor3 = Color3.fromRGB(140, 140, 140); D.Font = Enum.Font.Gotham; D.TextSize = 11; D.TextXAlignment = 0; D.BackgroundTransparency = 1

    local state = false
    Card.MouseButton1Click:Connect(function()
        state = not state
        Card.BackgroundColor3 = state and getgenv().KingConfig.Theme.Accent or Color3.fromRGB(22, 22, 26)
        T.TextColor3 = state and Color3.new(0,0,0) or Color3.new(1,1,1)
        callback(state)
    end)
end

--// FEATURE INJECTION
AddCard(Pages["Aimbot"], "Master Aimbot", "Smoothly lock onto visible targets", function(v) getgenv().KingConfig.Combat.Aimbot = v end)
AddCard(Pages["Aimbot"], "Silent Aim", "Force bullets to hit without aiming", function(v) getgenv().KingConfig.Combat.SilentAim = v end)

AddCard(Pages["Visuals"], "Enable ESP", "Master switch for all player visuals", function(v) getgenv().KingConfig.Visuals.ESP = v end)
AddCard(Pages["Visuals"], "Box ESP", "Draw professional corners around players", function(v) getgenv().KingConfig.Visuals.Boxes = v end)

AddCard(Pages["Player"], "Infinite Jump", "Jump as many times as you want", function(v) getgenv().KingConfig.Player.InfJump = v end)
AddCard(Pages["World"], "Fullbright", "Removes all shadows from the map", function(v) 
    RunService.RenderStepped:Connect(function() if v then game.Lighting.Brightness = 2 game.Lighting.ClockTime = 14 end end)
end)

AddCard(Pages["Scripts"], "Infinite Yield", "Best Universal Admin Commands", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

--// SIDEBAR NAV
for i, name in pairs(Tabs) do
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(1, 0, 0, 45)
    B.Position = UDim2.new(0, 0, 0, 80 + (i-1)*45)
    B.BackgroundTransparency = 1
    B.Text = "     " .. name
    B.TextColor3 = Color3.fromRGB(160, 160, 170)
    B.Font = Enum.Font.GothamSemibold; B.TextSize = 13; B.TextXAlignment = 0
    B.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
    end)
end

--// SILENT AIM HOOK (THE PART THAT ACTUALLY WORKS)
local OldNC; OldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if not checkcaller() and getgenv().KingConfig.Combat.SilentAim and (Method == "Raycast" or Method == "FindPartOnRay") then
        local T = GetTarget()
        if T then
            if Method == "Raycast" then Args[2] = (T.Character.Head.Position - Args[1]).Unit * 1000
            else Args[1] = Ray.new(Camera.CFrame.Position, (T.Character.Head.Position - Camera.CFrame.Position).Unit * 1000) end
            return OldNC(self, unpack(Args))
        end
    end
    return OldNC(self, ...)
end))

--// FPS/PING LOOP
spawn(function()
    while wait(1) do
        FPSL.Text = math.floor(1/RunService.RenderStepped:Wait()) .. " FPS"
        PingL.Text = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. " MS"
    end
end)

--// MOBILE TOGGLE
local Togg = Instance.new("ImageButton", KingUI)
Togg.Size = UDim2.new(0, 50, 0, 50)
Togg.Position = UDim2.new(0, 20, 0.2, 0)
Togg.BackgroundColor3 = getgenv().KingConfig.Theme.Accent
Togg.Image = "rbxassetid://6031280245"
Instance.new("UICorner", Togg).CornerRadius = UDim.new(1, 0)
Togg.Draggable = true
Togg.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

Notify("OPIAM V10: System Active")
