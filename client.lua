-- ============================================================
--  desti_bell — Client
--  Détecte quand le joueur local entre dans le salon vocal
--  et en informe le serveur.
-- ============================================================

local inVoiceChannel = false

-- Envoie l'événement au serveur quand le joueur rejoint le salon vocal.
local function OnVoiceChannelEntered()
    if inVoiceChannel then return end
    inVoiceChannel = true
    TriggerServerEvent('desti_bell:playerEnteredVoice')
end

-- Réinitialise l'état quand le joueur quitte le salon vocal.
local function OnVoiceChannelLeft()
    inVoiceChannel = false
end

-- Événements déclenchés par d'autres ressources (ex. pma-voice, mumble-voip).
AddEventHandler('desti_bell:enterVoiceChannel', OnVoiceChannelEntered)
AddEventHandler('desti_bell:leaveVoiceChannel', OnVoiceChannelLeft)

-- ============================================================
--  Export public : permet à d'autres ressources d'appeler
--  directement exports['desti_bell']:EnterVoiceChannel()
-- ============================================================
exports('EnterVoiceChannel', OnVoiceChannelEntered)
exports('LeaveVoiceChannel', OnVoiceChannelLeft)
