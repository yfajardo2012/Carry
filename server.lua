local QBX = exports.qbx_core
local carryingStates = {}

-- Server event to start carrying
RegisterNetEvent('qbx_carry:server:startCarry', function(targetId)
    local src = source
    local player = QBX.Functions.GetPlayer(src)
    local targetPlayer = QBX.Functions.GetPlayer(targetId)

    if not player or not targetPlayer then return end

    -- Check if target is already being carried
    if carryingStates[targetId] then
        TriggerClientEvent('QBX:Notify', src, 'That player is already being carried!', 'error')
        return
    end

    -- Check distance (server-side validation)
    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetId)
    if #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed)) > 3.0 then
        TriggerClientEvent('QBX:Notify', src, 'You are too far away!', 'error')
        return
    end

    -- Set carrying states
    carryingStates[src] = targetId
    carryingStates[targetId] = src

    -- Notify players
    TriggerClientEvent('QBX:Notify', src, 'You are now carrying ' .. targetPlayer.PlayerData.charinfo.firstname .. '!', 'success')
    TriggerClientEvent('QBX:Notify', targetId, 'You are being carried!', 'primary')

    -- Trigger client events
    TriggerClientEvent('qbx_carry:client:startCarry', targetId, src)
    TriggerClientEvent('qbx_carry:client:startCarry', src, targetId) -- For carrier animation if needed
end)

-- Server event to stop carrying
RegisterNetEvent('qbx_carry:server:stopCarry', function(targetId)
    local src = source
    local player = QBX.Functions.GetPlayer(src)

    if not player then return end

    if not carryingStates[src] then
        TriggerClientEvent('QBX:Notify', src, 'You are not carrying anyone!', 'error')
        return
    end

    local targetSrc = carryingStates[src]
    local targetPlayer = QBX.Functions.GetPlayer(targetSrc)

    if not targetPlayer then return end

    -- Clear carrying states
    carryingStates[src] = nil
    carryingStates[targetSrc] = nil

    -- Notify players
    TriggerClientEvent('QBX:Notify', src, 'You stopped carrying ' .. targetPlayer.PlayerData.charinfo.firstname .. '!', 'success')
    TriggerClientEvent('QBX:Notify', targetSrc, 'You are no longer being carried!', 'primary')

    -- Trigger client events
    TriggerClientEvent('qbx_carry:client:stopCarry', src)
    TriggerClientEvent('qbx_carry:client:stopCarry', targetSrc)
end)

-- Cleanup on player disconnect
AddEventHandler('playerDropped', function()
    local src = source
    if carryingStates[src] then
        local carriedSrc = carryingStates[src]
        carryingStates[src] = nil
        if carriedSrc and GetPlayerName(carriedSrc) ~= nil then
            TriggerClientEvent('qbx_carry:client:stopCarry', carriedSrc)
        end
    end
    for carrier, carried in pairs(carryingStates) do
        if carried == src then
            carryingStates[carrier] = nil
            if GetPlayerName(carrier) ~= nil then
                TriggerClientEvent('qbx_carry:client:stopCarry', carrier)
            end
            break
        end
    end
end)