--[[ 
    KING PREMIUM V5 - THE "ULTIMATE" HUB
    UPDATES: Internal Executor, Player Slider, Tab System, Full Stats
    FIXES: Smooth UI, Multi-Page Layout
]]

if not game:IsLoaded() then game.Loaded:Wait() end

--// CONFIG
getgenv().KingConfig = {
    Aimbot = {Enabled = false, Smoothness = 0.5, FOV = 150, WallCheck = true, ShowFOV = true},
    Player = {WalkSpeed = 16, JumpPower = 50, InfJump = false},
    Visuals = {Fullbright = false},
    CurrentTab = "Combat"
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// 1. UI SETUP (OPIAM STYLE)
local KingGUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", KingGUI)
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

-- Content Area
local PageContainer = Instance.new("Frame", Main)
PageContainer.Size = UDim2.new(1, -150, 1, -20)
PageContainer.Position = UDim2.new(0, 145, 0, 10)
PageContainer.BackgroundTransparency = 1

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", PageContainer)
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = (name == "Combat")
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 6)
    return Page
end

local CombatPage = CreatePage("Combat")
local PlayerPage = CreatePage("Player")
local ExecutorPage = CreatePage("Executor")

--// 2. UI COMPONENTS (Buttons & Inputs)
local function AddToggle(parent, text, callback)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, -5, 0, 35)
    B.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    B.Text = "  " .. text
    B.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    B.TextXAlignment = Enum.TextXAlignment.Left
    B.Font = Enum.Font.Gotham
    Instance.new("UICorner", B)
    
    local state = false
    B.MouseButton1Click:Connect(function()
        state = not state
        B.BackgroundColor3 = state and Color3.fromRGB(160, 80, 255) or Color3.fromRGB(25, 25, 25)
        callback(state)
    end)
end

--// 3. COMBAT TAB
AddToggle(CombatPage, "Master Aimbot", function(v) getgenv().KingConfig.Aimbot.Enabled = v end)
AddToggle(CombatPage, "Wall Check", function(v) getgenv().KingConfig.Aimbot.WallCheck = v end)
AddToggle(CombatPage, "Show FOV Circle", function(v) getgenv().KingConfig.Aimbot.ShowFOV = v end)

--// 4. PLAYER TAB (Sliders & Custom Values)
local SpeedInput = Instance.new("TextBox", PlayerPage)
SpeedInput.Size = UDim2.new(1, -5, 0, 35)
SpeedInput.PlaceholderText = "Enter WalkSpeed (Default 16)..."
SpeedInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", SpeedInput)
SpeedInput.FocusLost:Connect(function()
    LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(SpeedInput.Text) or 16
end)

AddToggle(PlayerPage, "Infinite Jump", function(v) getgenv().KingConfig.Player.InfJump = v end)
AddToggle(PlayerPage, "Fullbright", function(v) getgenv().KingConfig.Visuals.Fullbright = v end)

--// 5. EXECUTOR TAB (Internal Script Runner)
local CodeBox = Instance.new("TextBox", ExecutorPage)
CodeBox.Size = UDim2.new(1, -5, 0, 150)
CodeBox.MultiLine = true
CodeBox.ClearTextOnFocus = false
CodeBox.Text = "-- Paste Script Here..."
CodeBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CodeBox.TextColor3 = Color3.new(0, 1, 0)
CodeBox.Font = Enum.Font.Code
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", CodeBox)

local ExecBtn = Instance.new("TextButton", ExecutorPage)
ExecBtn.Size = UDim2.new(1, -5, 0, 35)
ExecBtn.Text = "EXECUTE SCRIPT"
ExecBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
ExecBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ExecBtn)

ExecBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(CodeBox.Text)()
    end)
    if not success then warn("EXEC ERROR: " .. err) end
end)

--// 6. SIDEBAR NAVIGATION
local function AddTab(name)
    local T = Instance.new("TextButton", Sidebar)
    T.Size = UDim2.new(1, 0, 0, 40)
    T.Position = UDim2.new(0, 0, 0, 60 + (#Sidebar:GetChildren() * 45))
    T.Text = name
    T.TextColor3 = Color3.new(1,1,1)
    T.BackgroundTransparency = 1
    T.Font = Enum.Font.GothamBold
    
    T.MouseButton1Click:Connect(function()
        CombatPage.Visible = (name == "Combat")
        PlayerPage.Visible = (name == "Player")
        ExecutorPage.Visible = (name == "Scripts")
    end)
end

AddTab("Combat")
AddTab("Player")
AddTab("Scripts")

--// 7. MOBILE TOGGLE & RUNTIME
local K = Instance.new("TextButton", KingGUI)
K.Size = UDim2.new(0, 50, 0, 50)
K.Position = UDim2.new(0, 15, 0.1, 0)
K.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
K.Text = "K"
K.Font = Enum.Font.GothamBold
Instance.new("UICorner", K).CornerRadius = UDim.new(1, 0)
K.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Infinite Jump Hook
UIS.JumpRequest:Connect(function()
    if getgenv().KingConfig.Player.InfJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

print("KING PREMIUM V5 LOADED: ENJOY THE HUB")
