local cooldowns = {}

-- ---------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------

local function getIdentifiers(src)
    local ids = {}
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if id then
            ids[#ids + 1] = id
        end
    end
    return table.concat(ids, "\n")
end

--- Returns true (and records the timestamp) the first time a player joins
--- a given channel; returns false while still within the cooldown window.
local function isOnCooldown(src, channelName)
    if Config.CooldownSeconds <= 0 then return false end
    local key = tostring(src) .. ":" .. channelName
    local now = os.time()
    if cooldowns[key] and (now - cooldowns[key]) < Config.CooldownSeconds then
        return true
    end
    cooldowns[key] = now
    return false
end

local function sendDiscordWebhook(playerName, src, channelName, coords)
    if not Config.WebhookURL or Config.WebhookURL == "" then return end

    local description = string.format(
        "**%s** (ID: **%d**) a rejoint le channel vocal **%s**.",
        playerName, src, channelName
    )

    if Config.ShowCoords and coords then
        description = description .. string.format(
            "\n📍 Coords : `x: %.1f | y: %.1f | z: %.1f`",
            coords.x, coords.y, coords.z
        )
    end

    if Config.ShowIdentifiers then
        local ids = getIdentifiers(src)
        if ids ~= "" then
            description = description .. "\n🪪 Identifiants :\n```" .. ids .. "```"
        end
    end

    local payload = json.encode({
        username = Config.WebhookUsername,
        embeds = {
            {
                title = "🔔 Desti Bell — Channel Vocal",
                description = description,
                color = Config.WebhookColor,
                footer = { text = "Desti Bell • " .. os.date("%d/%m/%Y %H:%M:%S") },
            }
        }
    })

    PerformHttpRequest(Config.WebhookURL, function(code, _, headers)
        -- silent — webhook delivery is best-effort
    end, "POST", payload, { ["Content-Type"] = "application/json" })
end

local function notifyAdminsInGame(message)
    if not Config.InGameNotification then return end

    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local src = tonumber(playerId)
        if src then
            local isAdmin = false
            for _, group in ipairs(Config.AdminGroups) do
                if IsPlayerAceAllowed(src, group) then
                    isAdmin = true
                    break
                end
            end
            if isAdmin then
                TriggerClientEvent("chat:addMessage", src, {
                    color = { 255, 215, 0 },
                    multiline = true,
                    args = { Config.ChatPrefix, message },
                })
            end
        end
    end
end

-- ---------------------------------------------------------------
-- Main events
-- ---------------------------------------------------------------

-- Fired by clients that do not send coordinates (Config.ShowCoords = false)
RegisterNetEvent("desti_bell:playerJoinedVoiceChannel", function(channelName)
    local src = source
    if isOnCooldown(src, channelName) then return end

    local playerName = GetPlayerName(src) or "Inconnu"
    local msg = string.format("%s a rejoint le channel vocal « %s ».", playerName, channelName)

    notifyAdminsInGame(msg)
    sendDiscordWebhook(playerName, src, channelName, nil)
end)

-- Fired by clients that include player coordinates (Config.ShowCoords = true)
RegisterNetEvent("desti_bell:playerJoinedVoiceChannelWithCoords", function(channelName, coordsTable)
    local src = source
    if isOnCooldown(src, channelName) then return end

    local playerName = GetPlayerName(src) or "Inconnu"
    local coords = coordsTable and vector3(coordsTable.x, coordsTable.y, coordsTable.z) or nil
    local msg = string.format("%s a rejoint le channel vocal « %s ».", playerName, channelName)

    notifyAdminsInGame(msg)
    sendDiscordWebhook(playerName, src, channelName, coords)
end)

-- Clean up cooldown table when a player drops
AddEventHandler("playerDropped", function()
    local src = source
    local prefix = tostring(src) .. ":"
    for key in pairs(cooldowns) do
        if key:sub(1, #prefix) == prefix then
            cooldowns[key] = nil
        end
    end
end)
