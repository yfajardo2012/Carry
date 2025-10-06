local QBX = exports.qbx_core
local PlayerData = {}
local isCarrying = false
local carryingPlayerId = nil
local carryAnimDict = 'nm'
local carryAnimName = 'firemans_carry'
local carriedAnimDict = 'nm'
local carriedAnimName = 'fireman_carry'

-- Load animations
RequestAnimDict(carryAnimDict)
while not HasAnimDictLoaded(carryAnimDict) do
    Wait(100)
end
RequestAnimDict(carriedAnimDict)
while not HasAnimDictLoaded(carriedAnimDict) do
    Wait(100)
end

-- Function to start carrying
local function StartCarrying(targetId)
    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(targetId)

    if isCarrying then
        QBX:Notify('You are already carrying someone!', 'error')
        return
    end

    if #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed)) > 2.0 then
        QBX:Notify('You are too far away!', 'error')
        return
    end

    TriggerServerEvent('qbx_carry:server:startCarry', targetId)
end

-- Function to stop carrying
local function StopCarrying()
    if not isCarrying then return end

    TriggerServerEvent('qbx_carry:server:stopCarry', carryingPlayerId)
end

-- Client event to handle being carried
RegisterNetEvent('qbx_carry:client:startCarry', function(carryId)
    local playerPed = PlayerPedId()
    carryingPlayerId = carryId

    -- Attach player to carrier
    local carrierPed = GetPlayerPed(carryId)
    AttachEntityToEntity(
        playerPed,
        carrierPed,
        0,
        0.27, 0.15, 0.0,
        0.0, 90.0, 0.0,
        false, false, false, false, 2, true
    )

    -- Play carried animation
    TaskPlayAnim(playerPed, carriedAnimDict, carriedAnimName, 8.0, -8.0, -1, 49, 0, false, false, false)
    isCarrying = true
end)

-- Client event to handle stopping carry
RegisterNetEvent('qbx_carry:client:stopCarry', function()
    if not isCarrying then return end

    local playerPed = PlayerPedId()
    carryingPlayerId = nil

    -- Detach and clear animations
    DetachEntity(playerPed, true, false)
    ClearPedTasks(playerPed)
    isCarrying = false
end)

-- ox_target integration
exports.ox_target:addGlobalPlayer({
    {
        name = 'carry',
        icon = 'fas fa-hand-paper',
        label = 'Carry',
        distance = 2.0,
        onSelect = function(data)
            StartCarrying(data.entity)
        end,
        canInteract = function()
            return not isCarrying
        end
    }
})

-- Handle key press to stop carrying (e.g., E key)
CreateThread(function()
    while true do
        Wait(0)
        if isCarrying and IsControlJustPressed(0, 38) then -- E key
            StopCarrying()
        end
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if isCarrying then
            StopCarrying()
        end
    end
end)