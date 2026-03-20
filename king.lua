--[[ 
    KING PREMIUM V11 - COMPACT OPIAM EDITION
    - Size: 480x300 (Mobile Optimized)
    - Fixes: Silent Aim (RaycastParams Hook), Aimbot (Health Check)
    - UI: Active Tab Highlighting, HD Crown Toggle
]]

if not game:IsLoaded() then game.Loaded:Wait() end

--// SETTINGS
getgenv().KingConfig = {
    Combat = {Aimbot = false, SilentAim = false, FOV = 120, WallCheck = true},
    Visuals = {ESP = false, Boxes = false, Names = false},
    Player = {WS = 16, JP = 50, InfJump = false},
    Accent = Color3.fromRGB(160, 80, 255)
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// ROBUST TARGETING
local function GetClosest()
    local Target, MaxDist = nil, getgenv().KingConfig.Combat.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") then
            if v.Character.Humanoid.Health > 0 then
                local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if OnScreen then
                    local Dist = (Vector2.new(Pos.X, Pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if Dist < MaxDist then
                        -- Wallcheck logic
                        if getgenv().KingConfig.Combat.WallCheck then
                            local Parts = Camera:GetPartsObscuringTarget({v.Character.Head.Position, Camera.CFrame.Position}, {LocalPlayer.Character, v.Character})
                            if #Parts == 0 then MaxDist = Dist; Target = v end
                        else
                            MaxDist = Dist; Target = v
                        end
                    end
                end
            end
        end
    end
    return Target
end

--// UI CORE (COMPACT & CLEAN)
local KingUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", KingUI)
Main.Size = UDim2.new(0, 480, 0, 300) -- Smaller, Mobile Friendly
Main.Position = UDim2.new(0.5, -240, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(40, 40, 45)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

-- Page System
local PageHolder = Instance.new("Frame", Main)
PageHolder.Size = UDim2.new(1, -150, 1, -10)
PageHolder.Position = UDim2.new(0, 145, 0, 5)
PageHolder.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local P = Instance.new("ScrollingFrame", PageHolder)
    P.Size = UDim2.new(1, 0, 1, 0)
    P.Visible = false
    P.BackgroundTransparency = 1
    P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 5)
    Pages[name] = P
    return P
end

local CombatP = CreatePage("Combat")
local PlayerP = CreatePage("Player")
local ScriptsP = CreatePage("Scripts")
CombatP.Visible = true

--// COMPONENT: THE OPIAM BUTTON
local function AddButton(parent, text, callback)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, -5, 0, 40)
    B.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    B.Text = "  " .. text
    B.TextColor3 = Color3.fromRGB(200, 200, 200)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 12
    B.TextXAlignment = 0
    Instance.new("UICorner", B)

    local state = false
    B.MouseButton1Click:Connect(function()
        state = not state
        B.BackgroundColor3 = state and getgenv().KingConfig.Accent or Color3.fromRGB(25, 25, 28)
        B.TextColor3 = state and Color3.new(0,0,0) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

--// NAVIGATION (WITH LIGHT-UP TABS)
local function AddTab(name)
    local T = Instance.new("TextButton", Sidebar)
    T.Size = UDim2.new(1, 0, 0, 40)
    T.Position = UDim2.new(0, 0, 0, 60 + (#Sidebar:GetChildren()-1)*42)
    T.BackgroundTransparency = 1
    T.Text = name
    T.TextColor3 = Color3.fromRGB(150, 150, 150)
    T.Font = Enum.Font.GothamBold
    T.TextSize = 13

    T.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end
        end
        T.TextColor3 = getgenv().KingConfig.Accent
    end)
end

AddTab("Combat"); AddTab("Player"); AddTab("Scripts")

--// CONTENT
AddButton(CombatP, "Aimbot", function(v) getgenv().KingConfig.Combat.Aimbot = v end)
AddButton(CombatP, "Silent Aim (Universal)", function(v) getgenv().KingConfig.Combat.SilentAim = v end)
AddButton(PlayerP, "Infinite Jump", function(v) getgenv().KingConfig.Player.InfJump = v end)
AddButton(ScriptsP, "Infinite Yield", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

--// THE "COOL" TOGGLE (KING CROWN)
local Toggle = Instance.new("ImageButton", KingUI)
Toggle.Size = UDim2.new(0, 45, 0, 45)
Toggle.Position = UDim2.new(0, 10, 0.2, 0)
Toggle.Image = "rbxassetid://10747373176" -- HD CROWN
Toggle.BackgroundTransparency = 1
Toggle.Draggable = true
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

--// FUNCTIONAL HOOKS
local OldNC; OldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if not checkcaller() and getgenv().KingConfig.Combat.SilentAim and (Method == "Raycast" or Method == "FindPartOnRay") then
        local T = GetClosest()
        if T then
            if Method == "Raycast" then Args[2] = (T.Character.Head.Position - Args[1]).Unit * 1000
            else Args[1] = Ray.new(Camera.CFrame.Position, (T.Character.Head.Position - Camera.CFrame.Position).Unit * 1000) end
            return OldNC(self, unpack(Args))
        end
    end
    return OldNC(self, ...)
end))

RunService.RenderStepped:Connect(function()
    if getgenv().KingConfig.Combat.Aimbot then
        local T = GetClosest()
        if T then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, T.Character.Head.Position), 1 - getgenv().KingConfig.Combat.Smooth) end
    end
end)

UIS.JumpRequest:Connect(function() if getgenv().KingConfig.Player.InfJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)

print("KING PREMIUM V11: MOBILE OPTIMIZED")
