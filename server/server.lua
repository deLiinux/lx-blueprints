
local QBCore = exports['qbx-core']:GetCoreObject()

RegisterNetEvent('lx-vehicleblueprint:placeStrippedVehicle', function(modelName, coords, heading)
    TriggerClientEvent('lx-vehicleblueprint:spawnStrippedVehicle', -1, modelName, coords, heading)
end)

RegisterNetEvent('bp:server:giveKeys', function(netId)
    local src = source
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if vehicle and DoesEntityExist(vehicle) then
        local success = exports.qbx_vehiclekeys:GiveKeys(src, vehicle)
        if success then
            print("Keys given to player " .. src)
        else
            print("Failed to give keys to player " .. src)
        end
    else
        print("Invalid vehicle entity for keys")
    end
end)

RegisterNetEvent('bp:server:makeOwner', function(netId, modelName, mods)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end

    local citizenid = player.PlayerData.citizenid
    local license = player.PlayerData.license
    local vehicle = NetworkGetEntityFromNetworkId(netId)

    if not vehicle or not DoesEntityExist(vehicle) then
        print("Invalid vehicle entity for netId: " .. tostring(netId))
        return
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    if not plate or plate == '' then
        print("Vehicle has no plate")
        return
    end

    local hash = GetEntityModel(vehicle)

    local function GetModelNameFromHash(hash)
        for modelName, _ in pairs(QBCore.Shared.Vehicles) do
            local modelHash = GetHashKey(modelName)
            if modelHash == hash then
                print("Found model name:", modelName)
                return modelName
            end
        end
        return nil
    end
    
    

    local modelName = GetModelNameFromHash(hash) or "unknown"

    -- Insert into database if not already owned
    local existing = MySQL.query.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if existing and existing[1] then
        print("Vehicle already exists in database with plate: " .. plate)
    else
        MySQL.insert.await('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            license,
            citizenid,
            modelName,
            hash,
            json.encode(mods or {}),
            plate,
            0
        })
        print(("Inserted vehicle [%s] (%s) for %s"):format(plate, modelName, citizenid))
    end

    -- Now set vehicle ownership through qbx_vehicles
    local success = exports.qbx_vehicles:SetPlayerVehicleOwner(plate, citizenid)
    if success then
        print(("Vehicle [%s] is now owned by %s"):format(plate, citizenid))
    else
        print(("Failed to assign ownership for [%s] to %s"):format(plate, citizenid))
    end
end)




local function GiveBlueprintItem(source)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return false end

    local vehblueprints = {
        'dominator4_blueprint',
        'zr380_blueprint',
        'ratloader_blueprint',
        'slamvan3_blueprint',
        'ruston_blueprint',
        'dukes_blueprint',
        'ruiner_blueprint',
        'blista2_blueprint',
        'phoenix_blueprint',
        'gauntlet_blueprint',
        'buccaneer_blueprint',
        'wastelander_blueprint',
        'dune_blueprint',
        'dune3_blueprint',
        'dune4_blueprint',
        'brickade_blueprint',
        'brickade2_blueprint',
        'manchez3_blueprint',
        'ratbike_blueprint',
        'technical_blueprint',
        'boxville5_blueprint'
    }
    

    local selectedBlueprint = vehblueprints[math.random(#vehblueprints)]

    local added = exports.ox_inventory:AddItem(source, selectedBlueprint, 1)

    if added then
        local label = selectedBlueprint:gsub("_blueprint", "")
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'success',
            description = ('You found a blueprint for: %s'):format(label),
            duration = 5000
        })
        return true
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Could not give you a blueprint.',
            duration = 5000
        })
        return false
    end
end

RegisterCommand('giveblueprint', function(source)
    if source == 0 then
        print("This command must be run by a player.")
        return
    end
    GiveBlueprintItem(source)
end)
