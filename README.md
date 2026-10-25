
-- Scripts Hub | Egg Finder
-- LocalScript para Roblox Studio

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local eggs = {
    {name = "Common Egg", rarity = "Común", value = 100},
    {name = "Rare Egg", rarity = "Raro", value = 500},
    {name = "Epic Egg", rarity = "Épico", value = 2500},
    {name = "Legendary Egg", rarity = "Legendario", value = 10000},
    {name = "Mythic Egg", rarity = "Mítico", value = 50000},
}

local gui = Instance.new("ScreenGui")
gui.Name = "ScriptsHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 410)
main.Position = UDim2.new(0.5, -180, 0.5, -205)
main.BackgroundColor3 = Color3.fromRGB(22, 20, 34)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius =
    UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 45)
title.Position = UDim2.new(0, 12, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🥚 Scripts Hub"
title.TextColor3 = Color3.fromRGB(190, 130, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -42, 0, 8)
close.Text = "X"
close.TextSize = 18
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(130, 45, 65)
close.Parent = main

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -24, 0, 36)
search.Position = UDim2.new(0, 12, 0, 55)
search.PlaceholderText = "Buscar huevo..."
search.Text = ""
search.TextSize = 15
search.Font = Enum.Font.Gotham
search.TextColor3 = Color3.new(1, 1, 1)
search.PlaceholderColor3 = Color3.fromRGB(160, 155, 175)
search.BackgroundColor3 = Color3.fromRGB(39, 35, 55)
search.ClearTextOnFocus = false
search.Parent = main

Instance.new("UICorner", search).CornerRadius =
    UDim.new(0, 8)

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -24, 0, 245)
list.Position = UDim2.new(0, 12, 0, 101)
list.BackgroundColor3 = Color3.fromRGB(29, 26, 43)
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -24, 0, 42)
status.Position = UDim2.new(0, 12, 1, -50)
status.BackgroundTransparency = 1
status.Text = "Buscador de huevos"
status.TextColor3 = Color3.fromRGB(210, 205, 225)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextWrapped = true
status.Parent = main

local function renderEggs()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local query = string.lower(search.Text)
    local count = 0

    for _, egg in ipairs(eggs) do
        if string.find(string.lower(egg.name), query, 1, true)
        or string.find(string.lower(egg.rarity), query, 1, true) then

            count += 1

            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -10, 0, 65)
            row.BackgroundColor3 = Color3.fromRGB(43, 37, 61)
            row.BorderSizePixel = 0
            row.LayoutOrder = -egg.value
            row.Parent = list

            Instance.new("UICorner", row).CornerRadius =
                UDim.new(0, 8)

            local info = Instance.new("TextLabel")
            info.Size = UDim2.new(0.65, 0, 1, 0)
            info.Position = UDim2.new(0, 10, 0, 0)
            info.BackgroundTransparency = 1
            info.Text = egg.name .. "\n" ..
                egg.rarity .. " | Valor: " .. egg.value
            info.TextColor3 = Color3.new(1, 1, 1)
            info.TextSize = 13
            info.TextWrapped = true
            info.Font = Enum.Font.Gotham
            info.TextXAlignment = Enum.TextXAlignment.Left
            info.Parent = row

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 90, 0, 32)
            button.Position = UDim2.new(1, -98, 0.5, -16)
            button.BackgroundColor3 =
                Color3.fromRGB(125, 75, 210)
            button.Text = "Buscar"
            button.TextColor3 = Color3.new(1, 1, 1)
            button.TextSize = 13
            button.Font = Enum.Font.GothamBold
            button.Parent = row

            Instance.new("UICorner", button).CornerRadius =
                UDim.new(0, 7)

            button.MouseButton1Click:Connect(function()
                status.Text = "Huevo seleccionado: " ..
                    egg.name ..
                    ". Conecta una fuente de datos para localizarlo."
            end)
        end
    end

    list.CanvasSize = UDim2.new(0, 0, 0, count * 72)
    status.Text = count .. " huevos encontrados en la lista."
end

search:GetPropertyChangedSignal("Text"):Connect(renderEggs)

renderEggs()
