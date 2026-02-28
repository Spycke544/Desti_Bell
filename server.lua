-- ============================================================
--  desti_bell — Serveur
--  Reçoit les notifications clients et envoie une alerte
--  Discord via webhook.
-- ============================================================

-- Cooldown par joueur (source → timestamp de la dernière alerte).
local lastNotified = {}

-- ---------------------------------------------------------------
-- Construit et envoie l'embed Discord via PerformHttpRequest.
-- ---------------------------------------------------------------
local function SendDiscordAlert(playerName, playerId, identifier)
    local timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')

    local embed = {
        {
            title       = '🔔 Joueur dans le salon vocal',
            description = string.format(
                '**%s** vient de rejoindre **%s**.',
                playerName,
                Config.VoiceChannelName
            ),
            color       = Config.EmbedColor,
            fields      = {
                { name = '👤 Joueur',     value = playerName,             inline = true  },
                { name = '🪪 ID Serveur', value = tostring(playerId),     inline = true  },
                { name = '🔑 Identifiant', value = identifier or 'N/A',   inline = false },
            },
            footer      = { text = 'desti_bell • ' .. timestamp },
            timestamp   = timestamp,
        }
    }

    local payload = json.encode({
        username   = Config.BotName,
        avatar_url = Config.BotAvatar,
        embeds     = embed,
    })

    PerformHttpRequest(Config.WebhookURL, function(statusCode, _, _headers)
        if Config.EnableConsoleLogs then
            if statusCode == 204 then
                print(string.format('[desti_bell] Alerte envoyée pour %s (id: %d)', playerName, playerId))
            else
                print(string.format('[desti_bell] Échec de l\'envoi du webhook (HTTP %d)', statusCode))
            end
        end
    end, 'POST', payload, { ['Content-Type'] = 'application/json' })
end

-- ---------------------------------------------------------------
-- Récupère le premier identifiant disponible (license > steam > …).
-- ---------------------------------------------------------------
local function GetPlayerIdentifier(source)
    local priority = { 'license', 'steam', 'xbl', 'live', 'discord', 'fivem' }
    for _, idType in ipairs(priority) do
        local id = GetPlayerIdentifierByType(source, idType)
        if id then return id end
    end
    return 'unknown'
end

-- ---------------------------------------------------------------
-- Événement réseau déclenché par le client.
-- ---------------------------------------------------------------
RegisterNetEvent('desti_bell:playerEnteredVoice', function()
    local source     = source
    local now        = GetGameTimer()

    -- Anti-spam : on ignore si la dernière alerte date de moins de Config.CooldownMs.
    if lastNotified[source] and (now - lastNotified[source]) < Config.CooldownMs then
        return
    end
    lastNotified[source] = now

    local playerName = GetPlayerName(source) or ('Joueur #' .. source)
    local identifier = GetPlayerIdentifier(source)

    if Config.EnableConsoleLogs then
        print(string.format('[desti_bell] %s (%s) a rejoint %s', playerName, identifier, Config.VoiceChannelName))
    end

    SendDiscordAlert(playerName, source, identifier)
end)

-- ---------------------------------------------------------------
-- Nettoyage de la table de cooldowns quand un joueur se déconnecte.
-- ---------------------------------------------------------------
AddEventHandler('playerDropped', function()
    lastNotified[source] = nil
end)
