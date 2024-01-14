local QBCore = exports['qb-core']:GetCoreObject()
local html = ''
local CallSigns = {}
RegisterCommand("policehub", function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)

    if xPlayer.PlayerData.job.name == "police" then
        local type = "toggle"
        TriggerEvent("core-policehub:refresh:officers:refresh")

        if args[1] == "0" then
            type = "drag"
        end

        TriggerClientEvent("core-policehub:officers:open", src, type)
    end
end)



RegisterNetEvent('core-policehub:callSign', function(callsign)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if xPlayer and (xPlayer.PlayerData.job.name == 'police') and callsign then
        if callsign == 'none' then
            CallSigns[xPlayer.PlayerData.license] = "NO TAG"
            TriggerEvent("core-policehub:refresh")
            SaveResourceFile(GetCurrentResourceName(), "callsigns.json", json.encode(CallSigns))
            TriggerEvent("core-policehub:refresh")
            TriggerClientEvent('QBCore:Notify', source, "Restored Callsign", "success")
        else
            CallSigns[xPlayer.PlayerData.license] = callsign
            TriggerEvent("core-policehub:refresh")
            SaveResourceFile(GetCurrentResourceName(), "callsigns.json", json.encode(CallSigns))
            TriggerEvent("core-policehub:refresh")
            TriggerClientEvent('QBCore:Notify', source, "Updated Callsign: " .. callsign, "success")
        end
    end
end)


function GetName(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if xPlayer ~= nil and xPlayer.PlayerData.charinfo.firstname ~= nil and xPlayer.PlayerData.charinfo.lastname ~= nil then
        return xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    else
        return ""
    end
end

RegisterNetEvent('core-policehub:refresh', function(data)
    local new = ""
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local ply = QBCore.Functions.GetPlayer(v)
        if ply and ply.PlayerData.job.name == 'police' then
            local name = GetName(v)
            local dutyClass = ""
            local duty = ''

            if ply.PlayerData.job.onduty then
                dutyClass = 'duty'
                duty = 'background: linear-gradient(to right, #1d1d1d, #1d1d1d, #2f8125);'
            else
                dutyClass = 'offduty'
                duty = 'background: linear-gradient(to right, #1d1d1d, #1d1d1d, #ff00006f);'
            end
            local radioChannel = GetRadioChannel(v)
            local radioLabel = ""

            if radioChannel == 0 then
                radioLabel = "Not in Radio"
            else
                radioLabel = radioChannel .. ' hz'
            end
            local callSign = CallSigns[ply.PlayerData.license] ~= nil and CallSigns[ply.PlayerData.license] or
                "NO TAG"
            new = new ..
                '<div class="officer" style="' ..
                duty ..
                '"><span class="callsign-command">' ..
                callSign .. '</span><span></span> <span class="name">' ..
                name ..
                '</span>  <span class="grade">' ..
                ply.PlayerData.job.grade.name ..
                '</span> <span class="radio">' .. radioLabel .. '<span class="' .. dutyClass .. '"></span> </div>'
            html = new
            TriggerClientEvent("core-policehub:officers:refresh", -1, html)
        end
    end
end)
function GetRadioChannel(source)
    return Player(source).state['radioChannel']
end

CreateThread(function()
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "callsigns.json"))

    if result then
        CallSigns = result
    end
end)
