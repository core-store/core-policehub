local QBCore = exports['qb-core']:GetCoreObject()
CreateThread(function()
    while true do
        Wait(2000)
        TriggerServerEvent("core-policehub:refresh")
    end
end)
RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobInfo)
    if Enabled then
        xPlayer = QBCore.Functions.GetPlayerData()
        if xPlayer.job.name ~= "police" then
            SendNUIMessage({ ['action'] = "close" })
        end
    end

    TriggerServerEvent("core-policehub:refresh")
end)
AddEventHandler("QBCore:Client:OnPlayerUnload", function()
    SendNUIMessage({ ['action'] = 'close' })
end)
RegisterNUICallback("setcallsign", function(calls)
    TriggerServerEvent('core-policehub:callSign', calls)
end)
RegisterNUICallback("Close", function()
    SetNuiFocus(false, false)
end)
RegisterNetEvent("core-policehub:officers:open")
AddEventHandler("core-policehub:officers:open", function(type)
    if type == 'toggle' then
        if Enabled then
            Enabled = false
            SendNUIMessage({ ['action'] = 'close' })
            print("close")
        else
            Enabled = true
            SendNUIMessage({ ['action'] = 'open' })
            print("open")
        end
    elseif type == 'drag' then
        SetNuiFocus(true, true)
        SendNUIMessage({ ['action'] = 'drag' })
    end
end)
RegisterNetEvent("core-policehub:officers:refresh")
AddEventHandler("core-policehub:officers:refresh", function(data)
    SendNUIMessage({ ['action'] = 'refresh', ['data'] = data })
end)
