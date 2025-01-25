-- Place this script in StarterPlayerScripts
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local npcFolder = Workspace:WaitForChild("NPCs")

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local StartButton = Instance.new("TextButton")
local CancelButton = Instance.new("TextButton")
local ExitButton = Instance.new("TextButton")

ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")

Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

StartButton.Size = UDim2.new(0.4, 0, 0.3, 0)
StartButton.Position = UDim2.new(0.1, 0, 0.2, 0)
StartButton.Text = "Start"
StartButton.BackgroundColor3 = Color3.new(0, 0.8, 0)
StartButton.Parent = Frame

CancelButton.Size = UDim2.new(0.4, 0, 0.3, 0)
CancelButton.Position = UDim2.new(0.5, 0, 0.2, 0)
CancelButton.Text = "Cancel"
CancelButton.BackgroundColor3 = Color3.new(0.8, 0, 0)
CancelButton.Parent = Frame

ExitButton.Size = UDim2.new(0.8, 0, 0.3, 0)
ExitButton.Position = UDim2.new(0.1, 0, 0.6, 0)
ExitButton.Text = "Exit"
ExitButton.BackgroundColor3 = Color3.new(0.5, 0, 0.5)
ExitButton.Parent = Frame

-- Script Logic
local running = false
local function getRandomNPC()
    local npcs = npcFolder:GetChildren()
    for _, npc in ipairs(npcs) do
        local attributes = npc:FindFirstChild("Attributes")
        if attributes then
            local health = attributes:FindFirstChild("Health")
            local level = attributes:FindFirstChild("Level")
            if health and level and health:IsA("IntValue") and level:IsA("NumberValue") then
                if health.Value > 0 and level.Value > 50 then
                    return npc
                end
            end
        end
    end
    return nil
end

local function teleportToNPC()
    while running do
        local npc = getRandomNPC()
        if npc then
            local targetCFrame = npc.PrimaryPart.CFrame
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
            tween:Play()

            local attributes = npc:FindFirstChild("Attributes")
            local health = attributes:FindFirstChild("Health")

            -- Wait for NPC's health to reach 0
            while health.Value > -100 and running do
                task.wait(0.1)
            end
        else
            -- No valid NPCs found
        end
    end
end

StartButton.MouseButton1Click:Connect(function()
    if not running then
        running = true
        teleportToNPC()
    end
end)

CancelButton.MouseButton1Click:Connect(function()
    running = false
end)

ExitButton.MouseButton1Click:Connect(function()
    running = false
    ScreenGui:Destroy()
end)
