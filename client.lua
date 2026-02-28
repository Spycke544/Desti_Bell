local currentChannel = nil

-- ---------------------------------------------------------------
-- Helper: fire server event with or without coords
-- ---------------------------------------------------------------
local function reportChannelJoin(channelName)
    if Config.ShowCoords then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        TriggerServerEvent("desti_bell:playerJoinedVoiceChannelWithCoords", channelName, {
            x = pos.x,
            y = pos.y,
            z = pos.z,
        })
    else
        TriggerServerEvent("desti_bell:playerJoinedVoiceChannel", channelName)
    end
end

-- ---------------------------------------------------------------
-- pma-voice / mumble-voip integration
-- These exports/events are fired by popular voice resources.
-- ---------------------------------------------------------------

-- pma-voice uses numeric channel IDs; -1 and 0 mean "no channel"
AddEventHandler("pma-voice:setVoiceChannel", function(channel)
    local channelName = tostring(channel)
    if channelName ~= tostring(currentChannel) then
        currentChannel = channel
        if channel ~= nil and channel ~= -1 and channel ~= 0 then
            reportChannelJoin(channelName)
        end
    end
end)

-- mumble-voip uses string channel names; empty string means "no channel"
AddEventHandler("mumble-voip:channelChanged", function(channel)
    local channelName = tostring(channel)
    if channelName ~= tostring(currentChannel) then
        currentChannel = channel
        if channel ~= nil and channel ~= "" then
            reportChannelJoin(channelName)
        end
    end
end)

-- ---------------------------------------------------------------
-- Generic export so other resources can trigger the bell manually
-- e.g.: exports["Desti_Bell"]:joinVoiceChannel("Staff")
-- ---------------------------------------------------------------
exports("joinVoiceChannel", function(channelName)
    if channelName and channelName ~= "" then
        currentChannel = channelName
        reportChannelJoin(tostring(channelName))
    end
end)
