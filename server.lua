local webhookURL = "YOURWEBHOOKURLHERE"

function sendToDiscord(name, message, color)
    local embeds = {
        {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
                ["text"] = os.date("%X") -- Pridá aktuálny čas
            }
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds }), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("snt-tdismoke:SyncStartParticles")
AddEventHandler("snt-tdismoke:SyncStartParticles", function(carid)
    TriggerClientEvent("snt-tdismoke:StartParticles", -1, carid)
    
    local playerName = GetPlayerName(source)
    sendToDiscord("TDI snt-tdismoke", playerName .. " používa auto snt-tdismoke.", 65280) -- Zelená farba
end)

RegisterServerEvent("snt-tdismoke:SyncStopParticles")
AddEventHandler("snt-tdismoke:SyncStopParticles", function(carid)
    TriggerClientEvent("snt-tdismoke:StopParticles", -1, carid)
    
    local playerName = GetPlayerName(source)
    sendToDiscord("TDI snt-tdismoke", playerName .. " prestal používať auto snt-tdismoke.", 16711680) -- Červená farba
end)
