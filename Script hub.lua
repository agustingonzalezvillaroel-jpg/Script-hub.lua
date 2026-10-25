
-- Scripts Hub | Server Finder
-- Place ID: Steal An Egg

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PLACE_ID = 107778070777162

local gui = Instance.new("ScreenGui")
gui.Name = "ServerFinder"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 400)
main.Position = UDim2.new(0.5, -170, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(25, 22, 38)
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🥚 Scripts Hub | Servers"
title.TextColor3 = Color3.fromRGB(200, 155, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = main

local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(1, -20, 0, 38)
searchBtn.Position = UDim2.new(0, 10, 0, 48)
searchBtn.Text = "Buscar servidores"
searchBtn.TextColor3 = Color3.new(1, 1, 1)
searchBtn.BackgroundColor3 = Color3.fromRGB(115, 70, 195)
searchBtn.Font = Enum.Font.GothamBold
searchBtn.TextSize = 14
searchBtn.Parent = main
Instance.new("UICorner", searchBtn).CornerRadius = UDim.new(0, 8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 88)
status.BackgroundTransparency = 1
status.Text = "Pulsa buscar para cargar servidores"
status.TextColor3 = Color3.new(1, 1, 1)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.Parent = main

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 0, 260)
list.Position = UDim2.new(0, 10, 0, 122)
list.BackgroundColor3 = Color3.fromRGB(35, 31, 49)
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.new()
list.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

local function clearList()
    for _, obj in ipairs(list:GetChildren()) do
        if obj:IsA("Frame") then
            obj:Destroy()
        end
    end
end

local function addServer(server, index)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 58)
    row.BackgroundColor3 = Color3.fromRGB(50, 43, 68)
    row.LayoutOrder = index
    row.Parent = list
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(0.62, 0, 1, 0)
    info.Position = UDim2.new(0, 8, 0, 0)
    info.BackgroundTransparency = 1
    info.Text = string.format(
        "%d jugadores\nMáximo: %d",
        server.playing or 0,
        server.maxPlayers or 0
    )
    info.TextColor3 = Color3.new(1, 1, 1)
    info.TextSize = 12
    info.Font = Enum.Font.Gotham
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.Parent = row

    local join = Instance.new("TextButton")
    join.Size = UDim2.new(0, 100, 0, 32)
    join.Position = UDim2.new(1, -108, 0.5, -16)
    join.Text = "Unirse"
    join.TextColor3 = Color3.new(1, 1, 1)
    join.BackgroundColor3 = Color3.fromRGB(105, 65, 175)
    join.Font = Enum.Font.GothamBold
    join.TextSize = 12
    join.Parent = row
    Instance.new("UICorner", join).CornerRadius = UDim.new(0, 7)

    join.MouseButton1Click:Connect(function()
        if server.id then
            status.Text = "Intentando entrar al servidor..."
            local ok, err = pcall(function()
                TeleportService:TeleportToPlaceInstance(
                    PLACE_ID, server.id, player
                )
            end)
            if not ok then
                status.Text = "No se pudo iniciar: " .. tostring(err)
            end
        end
    end)
end

local function fetchServers()
    clearList()
    status.Text = "Consultando servidores..."

    -- Requiere que el entorno permita solicitudes HTTP.
    if not (syn and syn.request) and not
        (http and http.request) and not
        (request) then
        status.Text = "Este executor no expone una función HTTP compatible."
        return
    end

    local req = (syn and syn.request)
        or (http and http.request)
        or request

    local url = "https://games.roblox.com/v1/games/"
        .. PLACE_ID .. "/servers/Public?sortOrder=Asc&limit=100"

    local ok, response = pcall(function()
        return req({Url = url, Method = "GET"})
    end)

    if not ok or not response or
        (response.StatusCode and response.StatusCode ~= 200) then
        status.Text = "Error consultando la API pública de Roblox."
        return
    end

    local decodedOk, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not decodedOk or type(data.data) ~= "table" then
        status.Text = "Respuesta no válida de la API."
        return
    end

    table.sort(data.data, function(a, b)
        return (a.playing or 0) < (b.playing or 0)
    end)

    local count = 0
    for index, server in ipairs(data.data) do
        if (server.playing or 0) < (server.maxPlayers or 0) then
            count += 1
            addServer(server, count)
        end
    end

    status.Text = count .. " servidores disponibles (ordenados por jugadores)."
end

searchBtn.MouseButton1Click:Connect(fetchServers)
