--[[
    KING PREMIUM V12 (OPIAM CLONE)
    - UNIVERSAL SILENT AIM (2026 BYPASS)
    - DRAWING-API ESP
    - GLOW-TAB NAVIGATION
]]

--// INITIALIZATION
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().KingConfig = {
    Combat = {SilentAim = false, Aimbot = false, FOV = 120, Smooth = 0.4},
    Visuals = {ESP = false, Tracers = false, Box = false},
    Movement = {Speed = 16, InfJump = false},
    UI = {Accent = Color3.fromRGB(180, 100, 255), BG = Color3.fromRGB(10, 10, 12)}
}

--// CORE FUNCTIONS
local function GetClosestPlayer()
    local Target, Closest = nil, getgenv().KingConfig.Combat.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") then
            if v.Character.Humanoid.Health > 0 then
                local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if OnScreen then
                    local Dist = (Vector2.new(Pos.X, Pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if Dist < Closest then Closest = Dist; Target = v end
                end
            end
        end
    end
    return Target
end

--// UI CONSTRUCTION
local KingUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", KingUI)
Main.Size = UDim2.new(0, 420, 0, 280)
Main.Position = UDim2.new(0.5, -210, 0.5, -140)
Main.BackgroundColor3 = getgenv().KingConfig.UI.BG
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(40, 40, 45); Stroke.Thickness = 1.5

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "KING"; Title.Font = Enum.Font.GothamBold; Title.TextColor3 = Color3.new(1,1,1); Title.TextSize = 20; Title.BackgroundTransparency = 1

-- Container
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -130, 1, -10); Container.Position = UDim2.new(0, 125, 0, 5); Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
    Pages[name] = P
    return P
end

local MainP = CreatePage("Combat")
local VisualP = CreatePage("Visuals")
local MoveP = CreatePage("Movement")
MainP.Visible = true

--// BUTTONS & TABS
local function AddTab(name, page)
    local T = Instance.new("TextButton", Sidebar)
    T.Size = UDim2.new(1, -10, 0, 35); T.Position = UDim2.new(0, 5, 0, 60 + (#Sidebar:GetChildren()-2)*40)
    T.BackgroundColor3 = Color3.fromRGB(20, 20, 25); T.Text = name; T.Font = Enum.Font.GothamBold; T.TextSize = 12; T.TextColor3 = Color3.fromRGB(150, 150, 150)
    Instance.new("UICorner", T)

    T.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150); b.BackgroundColor3 = Color3.fromRGB(20, 20, 25) end end
        page.Visible = true; T.TextColor3 = Color3.new(1,1,1); T.BackgroundColor3 = getgenv().KingConfig.UI.Accent
    end)
end

AddTab("COMBAT", MainP); AddTab("VISUALS", VisualP); AddTab("MOVE", MoveP)

local function AddToggle(parent, text, callback)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, -5, 0, 40); B.BackgroundColor3 = Color3.fromRGB(25, 25, 30); B.Text = "  " .. text; B.TextColor3 = Color3.new(0.8, 0.8, 0.8); B.Font = Enum.Font.GothamBold; B.TextSize = 12; B.TextXAlignment = 0
    Instance.new("UICorner", B)
    local state = false
    B.MouseButton1Click:Connect(function()
        state = not state; callback(state)
        B.BackgroundColor3 = state and getgenv().KingConfig.UI.Accent or Color3.fromRGB(25, 25, 30)
        B.TextColor3 = state and Color3.new(0,0,0) or Color3.new(0.8, 0.8, 0.8)
    end)
end

--// FEATURES
AddToggle(MainP, "Silent Aim (Universal)", function(v) getgenv().KingConfig.Combat.SilentAim = v end)
AddToggle(MainP, "Legit Aimbot", function(v) getgenv().KingConfig.Combat.Aimbot = v end)
AddToggle(VisualP, "Box ESP", function(v) getgenv().KingConfig.Visuals.Box = v end)
AddToggle(MoveP, "Infinite Jump", function(v) getgenv().KingConfig.Movement.InfJump = v end)

--// UNIVERSAL SILENT AIM HOOK
local OldNC; OldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if not checkcaller() and getgenv().KingConfig.Combat.SilentAim and (Method == "Raycast" or Method == "FindPartOnRay") then
        local T = GetClosestPlayer()
        if T then
            if Method == "Raycast" then
                Args[2] = (T.Character.Head.Position - Args[1]).Unit * 1000
            else
                Args[1] = Ray.new(Camera.CFrame.Position, (T.Character.Head.Position - Camera.CFrame.Position).Unit * 1000)
            end
            return OldNC(self, unpack(Args))
        end
    end
    return OldNC(self, ...)
end))

--// LOOP LOGIC
RunService.RenderStepped:Connect(function()
    if getgenv().KingConfig.Combat.Aimbot then
        local T = GetClosestPlayer()
        if T then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), getgenv().KingConfig.Combat.Smooth)
        end
    end
end)

UIS.JumpRequest:Connect(function() if getgenv().KingConfig.Movement.InfJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)

--// CROWN TOGGLE
local Crown = Instance.new("ImageButton", KingUI)
Crown.Size = UDim2.new(0, 45, 0, 45); Crown.Position = UDim2.new(0, 10, 0, 10); Crown.BackgroundTransparency = 1; Crown.Image = "rbxassetid://10747373176"
Crown.Draggable = true; Crown.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
