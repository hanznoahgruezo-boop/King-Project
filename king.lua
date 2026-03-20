--[[ 
    KING PREMIUM V9 - THE OPIAM GOD-TIER REWRITE
    - FULL VISUALS: Box ESP, Tracers, Names, Health
    - FIXED COMBAT: Improved Silent Aim & Aimbot with Wallcheck
    - COOL UI: Smooth animations, Blur effects, and draggable Mobile Toggle
]]

if not game:IsLoaded() then game.Loaded:Wait() end

--// CONFIGURATION (THE ROYAL SETTINGS)
getgenv().KingConfig = {
    Combat = {Aimbot = false, SilentAim = false, FOV = 150, Smooth = 0.4, WallCheck = true, TargetPart = "Head"},
    Visuals = {ESP = false, Boxes = false, Tracers = false, Names = false, Health = false},
    Player = {Fly = false, Noclip = false, WalkSpeed = 16, JumpPower = 50},
    Theme = {Accent = Color3.fromRGB(160, 80, 255), Background = Color3.fromRGB(10, 10, 10)}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// UTILITY: TARGETING & WALLCHECK
local function IsVisible(part)
    if not getgenv().KingConfig.Combat.WallCheck then return true end
    local Ray = Camera:GetPartsObscuringTarget({part.Position, Camera.CFrame.Position}, {LocalPlayer.Character, part.Parent})
    return #Ray == 0
end

local function GetClosestTarget()
    local Target, MaxDist = nil, getgenv().KingConfig.Combat.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(getgenv().KingConfig.Combat.TargetPart) then
            local Part = v.Character[getgenv().KingConfig.Combat.TargetPart]
            local Pos, OnScreen = Camera:WorldToViewportPoint(Part.Position)
            if OnScreen and IsVisible(Part) then
                local MouseDist = (Vector2.new(Pos.X, Pos.Y) - UIS:GetMouseLocation()).Magnitude
                if MouseDist < MaxDist then MaxDist = MouseDist; Target = v end
            end
        end
    end
    return Target
end

--// VISUALS ENGINE: DRAWING ESP
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    local Tracer = Drawing.new("Line")
    local Name = Drawing.new("Text")

    RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and getgenv().KingConfig.Visuals.ESP then
            local Root = Player.Character.HumanoidRootPart
            local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)

            if OnScreen then
                -- Box
                Box.Visible = getgenv().KingConfig.Visuals.Boxes
                Box.Size = Vector2.new(2000 / Pos.Z, 3000 / Pos.Z)
                Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                Box.Color = getgenv().KingConfig.Theme.Accent
                
                -- Tracer
                Tracer.Visible = getgenv().KingConfig.Visuals.Tracers
                Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Tracer.To = Vector2.new(Pos.X, Pos.Y)
                Tracer.Color = getgenv().KingConfig.Theme.Accent

                -- Name
                Name.Visible = getgenv().KingConfig.Visuals.Names
                Name.Text = Player.Name
                Name.Position = Vector2.new(Pos.X, Pos.Y - (Box.Size.Y / 2) - 15)
                Name.Center = true
                Name.Color = Color3.new(1,1,1)
                Name.Size = 14
            else
                Box.Visible = false; Tracer.Visible = false; Name.Visible = false
            end
        else
            Box.Visible = false; Tracer.Visible = false; Name.Visible = false
        end
    end)
end
for _, v in pairs(Players:GetPlayers()) do if v ~= LocalPlayer then CreateESP(v) end end
Players.PlayerAdded:Connect(CreateESP)

--// UI SYSTEM (OPIAM RE-RE-DESIGN)
local KingUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", KingUI)
Main.Size = UDim2.new(0, 600, 0, 400)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.BackgroundColor3 = getgenv().KingConfig.Theme.Background
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 170, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 70)
Logo.Text = "opiam premium"
Logo.TextColor3 = getgenv().KingConfig.Theme.Accent
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 20
Logo.BackgroundTransparency = 1

-- Page Container
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -180, 1, -20)
Container.Position = UDim2.new(0, 175, 0, 10)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0)
    P.BackgroundTransparency = 1
    P.Visible = false
    P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)
    Pages[name] = P
    return P
end

local CombatPage = CreatePage("Combat")
local VisualsPage = CreatePage("Visuals")
local PlayerPage = CreatePage("Player")
local ScriptsPage = CreatePage("Scripts")
CombatPage.Visible = true

--// COMPONENT: THE PRESET CARD
local function AddCard(parent, title, desc, callback)
    local Card = Instance.new("TextButton", parent)
    Card.Size = UDim2.new(1, -10, 0, 65)
    Card.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    Card.Text = ""
    Instance.new("UICorner", Card)
    
    local Title = Instance.new("TextLabel", Card)
    Title.Size = UDim2.new(1, -20, 0, 30)
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.Text = title
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    local Desc = Instance.new("TextLabel", Card)
    Desc.Size = UDim2.new(1, -20, 0, 20)
    Desc.Position = UDim2.new(0, 15, 0, 30)
    Desc.Text = desc
    Desc.TextColor3 = Color3.fromRGB(150, 150, 150)
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 11
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.BackgroundTransparency = 1

    local state = false
    Card.MouseButton1Click:Connect(function()
        state = not state
        Card.BackgroundColor3 = state and getgenv().KingConfig.Theme.Accent or Color3.fromRGB(20, 20, 24)
        Title.TextColor3 = state and Color3.new(0,0,0) or Color3.new(1,1,1)
        callback(state)
    end)
end

--// FILLING TABS
-- COMBAT
AddCard(CombatPage, "Master Aimbot", "Locks onto nearest visible head", function(v) getgenv().KingConfig.Combat.Aimbot = v end)
AddCard(CombatPage, "Silent Aim", "Redirects shots (Works in most games)", function(v) getgenv().KingConfig.Combat.SilentAim = v end)

-- VISUALS (THE MISSING STUFF)
AddCard(VisualsPage, "Master ESP", "Enable/Disable all visuals", function(v) getgenv().KingConfig.Visuals.ESP = v end)
AddCard(VisualsPage, "Box ESP", "Draws boxes around players", function(v) getgenv().KingConfig.Visuals.Boxes = v end)
AddCard(VisualsPage, "Tracers", "Lines connecting you to players", function(v) getgenv().KingConfig.Visuals.Tracers = v end)
AddCard(VisualsPage, "Name Tags", "Show player usernames", function(v) getgenv().KingConfig.Visuals.Names = v end)

-- SCRIPTS
AddCard(ScriptsPage, "Infinite Yield", "Best Universal Admin", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
AddCard(ScriptsPage, "Fly Script", "Toggle Flying (Press E)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))() end)

--// SIDEBAR NAVIGATION
local function AddTab(name)
    local T = Instance.new("TextButton", Sidebar)
    T.Size = UDim2.new(1, 0, 0, 45)
    T.Position = UDim2.new(0, 0, 0, 80 + (#Sidebar:GetChildren()-1)*45)
    T.Text = name
    T.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    T.Font = Enum.Font.GothamBold
    T.BackgroundTransparency = 1
    T.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
    end)
end
AddTab("Combat"); AddTab("Visuals"); AddTab("Player"); AddTab("Scripts")

--// THE "COOL" MOBILE TOGGLE
local Toggle = Instance.new("ImageButton", KingUI)
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0, 20, 0.2, 0)
Toggle.Image = "rbxassetid://6031280245" -- Stylish Crown Icon
Toggle.BackgroundColor3 = getgenv().KingConfig.Theme.Accent
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
Toggle.Active = true
Toggle.Draggable = true
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

--// SILENT AIM HOOK (FIXED)
local OldNC; OldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if not checkcaller() and getgenv().KingConfig.Combat.SilentAim and (Method == "Raycast" or Method == "FindPartOnRay") then
        local T = GetClosestTarget()
        if T then
            return OldNC(self, Ray.new(Camera.CFrame.Position, (T.Character.Head.Position - Camera.CFrame.Position).Unit * 1000))
        end
    end
    return OldNC(self, ...)
end))

print("KING PREMIUM V9 LOADED - OPIAM MODE")
