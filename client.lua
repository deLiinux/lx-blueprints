local QBCore = exports['qbx-core']:GetCoreObject()

local vehicleRepairProgress = {} -- Table storing progress per vehicle

local function deleteVehicle(entity)
    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        DeleteVehicle(entity)
    end
end

local function RotToDirection(rotation)
    local z = math.rad(rotation.z)
    local x = math.rad(rotation.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

local function getPlacementCoords()
    local playerPed = PlayerPedId()
    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)

    local direction = RotToDirection(camRot)
    local targetCoords = camCoords + direction * 20.0

    local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, -1, playerPed, 7)
    local _, hit, hitCoords, _, _ = GetShapeTestResult(rayHandle)

    if hit == 1 then
        local groundZ = 0.0
        local foundGround, z = GetGroundZFor_3dCoord(hitCoords.x, hitCoords.y, hitCoords.z + 50.0, false)
        groundZ = foundGround and z or hitCoords.z
        return vector3(hitCoords.x, hitCoords.y, groundZ)
    else
        return targetCoords
    end
end

local vehicleKeys = {}
for modelName, _ in pairs(QBCore.Shared.Vehicles) do
    table.insert(vehicleKeys, modelName)
end

local function startVehiclePlacement(model)

    lib.showTextUI('ENTER - Place Vehicle  \n SCROLL - Rotate Vehicle  \n BACKSPACE - Cancel Placement', {position = 'left-center'})
    if isPlacingVehicle then
        TriggerEvent('ox_lib:notify', { type = 'error', description = 'You are already placing a vehicle.' })
        return
    end

    local modelHash = GetHashKey(model)
    RequestModel(modelHash)
    local timeout = 5000
    while not HasModelLoaded(modelHash) and timeout > 0 do
        Wait(10)
        timeout = timeout - 10
    end

    if not HasModelLoaded(modelHash) then
        TriggerEvent('ox_lib:notify', { type = 'error', description = 'Failed to load vehicle model.' })
        return
    end

    isPlacingVehicle = true
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    placedVehicle = CreateVehicle(modelHash, pos.x, pos.y, pos.z, 0.0, false, false)

    SetEntityAlpha(placedVehicle, 150, false)
    SetEntityCollision(placedVehicle, false, false)
    FreezeEntityPosition(placedVehicle, true)
    SetVehicleDoorsLocked(placedVehicle, 2)

    local placing = true
    local rotation = GetEntityHeading(playerPed)

    CreateThread(function()
        while placing do
            Wait(0)

            local coords = getPlacementCoords()
            SetEntityCoordsNoOffset(placedVehicle, coords.x, coords.y, coords.z, true, true, true)
            SetEntityHeading(placedVehicle, rotation)
            SetVehicleOnGroundProperly(placedVehicle)

            if IsControlPressed(0, 14) then
                rotation = (rotation - 5.0) % 360
            elseif IsControlPressed(0, 15) then
                rotation = (rotation + 5.0) % 360
            end

            if IsControlJustPressed(0, 201) then -- Confirm placement
                placing = false
                deleteVehicle(placedVehicle)
                placedVehicle = nil
                isPlacingVehicle = false

                TriggerServerEvent('lx-vehicleblueprint:placeStrippedVehicle', model, coords, rotation)

                lib.hideTextUI()

            elseif IsControlJustPressed(0, 202) then -- Cancel
                placing = false
                deleteVehicle(placedVehicle)
                placedVehicle = nil
                isPlacingVehicle = false

                lib.hideTextUI()

                TriggerEvent('ox_lib:notify', { type = 'info', description = 'Vehicle placement cancelled.' })
            end
        end
    end)
end

local function BlueprintEvent(eventName, model)
    RegisterNetEvent(eventName, function(item)
        startVehiclePlacement(model)
    end)
end

BlueprintEvent('lx-vehicleblueprint:dominator4Blueprint'    ,   'dominator4')
BlueprintEvent('lx-vehicleblueprint:zr380Blueprint'         ,   'zr380')
BlueprintEvent('lx-vehicleblueprint:ratloaderBlueprint'     ,   'ratloader')
BlueprintEvent('lx-vehicleblueprint:slamvan3Blueprint'      ,   'slamvan3')
BlueprintEvent('lx-vehicleblueprint:rustonBlueprint'        ,   'ruston')
BlueprintEvent('lx-vehicleblueprint:dukesBlueprint'         ,   'dukes')
BlueprintEvent('lx-vehicleblueprint:ruinerBlueprint'        ,   'ruiner')
BlueprintEvent('lx-vehicleblueprint:blista2Blueprint'       ,   'blista2')
BlueprintEvent('lx-vehicleblueprint:phoenixBlueprint'       ,   'phoenix')
BlueprintEvent('lx-vehicleblueprint:gauntletBlueprint'      ,   'gauntlet')
BlueprintEvent('lx-vehicleblueprint:buccaneerBlueprint'     ,   'buccaneer')
BlueprintEvent('lx-vehicleblueprint:wastelanderBlueprint'   ,   'wastelander')
BlueprintEvent('lx-vehicleblueprint:duneBlueprint'          ,   'dune')
BlueprintEvent('lx-vehicleblueprint:dune3Blueprint'         ,   'dune3')
BlueprintEvent('lx-vehicleblueprint:dune4Blueprint'         ,   'dune4')
BlueprintEvent('lx-vehicleblueprint:brickadeBlueprint'      ,   'brickade')
BlueprintEvent('lx-vehicleblueprint:brickade2Blueprint'     ,   'brickade2')
BlueprintEvent('lx-vehicleblueprint:manchez3Blueprint'      ,   'manchez3')
BlueprintEvent('lx-vehicleblueprint:ratbikeBlueprint'       ,   'ratbike')
BlueprintEvent('lx-vehicleblueprint:technicalBlueprint'     ,   'technical')
BlueprintEvent('lx-vehicleblueprint:boxville5Blueprint'     ,   'boxville5')


-- RegisterNetEvent('lx-vehicleblueprint:supervolitoBlueprint', function()
--     startVehiclePlacement('supervolito')
-- end)

RegisterNetEvent('lx-vehicleblueprint:spawnStrippedVehicle', function(modelName, coords, heading)
    local modelHash = GetHashKey(modelName)

    RequestModel(modelHash)
    local timeout = 5000
    while not HasModelLoaded(modelHash) and timeout > 0 do
        Citizen.Wait(10)
        timeout = timeout - 10
    end

    if not HasModelLoaded(modelHash) then
        print("Failed to load model for stripped vehicle: " .. modelName)
        return
    end

    local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, heading, true, false)

    -- Strip it
    SetVehicleDirtLevel(vehicle, 15.0)
    SetVehicleEngineHealth(vehicle, 500.0)
    SetVehicleEngineOn(vehicle, false, true, true)
    SetVehicleUndriveable(vehicle, true)
    SetVehicleDoorsLocked(vehicle, 2)
    SetEntityAlpha(vehicle, 150, false)

    for door = 0, 7 do
        SetVehicleDoorBroken(vehicle, door, true)
    end

    for wheel = 0, 7 do
        SetVehicleTyreBurst(vehicle, wheel, true, 1000.0)
        BreakOffVehicleWheel(vehicle, wheel, true, true, true, false)
    end

    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
    FreezeEntityPosition(vehicle, true)
    SetModelAsNoLongerNeeded(modelHash)
    

    -- ox_target interaction opens menu
    exports.ox_target:addLocalEntity(vehicle, {
        {
            label = 'Build Blueprint',
            icon = 'fa-solid fa-wrench',
            onSelect = function()
                TriggerEvent('lx-vehicleblueprint:showRepairMenu', vehicle)
            end
        }
    })
    isPlacingVehicle = false
end)

RegisterNetEvent('lx-vehicleblueprint:showRepairMenu', function(vehicle)
    local netId = VehToNet(vehicle)

    vehicleRepairProgress[netId] = vehicleRepairProgress[netId] or 0

    vehicleMaterialsProgress = vehicleMaterialsProgress or {}
    vehicleMaterialsProgress[netId] = vehicleMaterialsProgress[netId] or {
        vehicle_frame = 0,
        iron = 0,
        aluminium = 0,
        metalscrap = 0,
        car_parts = 0,
    }

    local wheelProgress = vehicleRepairProgress[netId]
    local materials = vehicleMaterialsProgress[netId]

    local requiredMaterials = {
        vehicle_frame = 1,
        iron = 58,
        aluminium = 100,
        metalscrap = 85,
        car_parts = 15,
    }

    -- Helper function to check if all materials are fully added
    local function allMaterialsDone()
        for k, v in pairs(requiredMaterials) do
            if materials[k] < v then
                return false
            end
        end
        return true
    end

    local options = {
        {
            title = ('Add Vehicle Frame (%d/%d)'):format(materials.vehicle_frame, requiredMaterials.vehicle_frame),
            icon = 'fa-solid fa-car',
            onSelect = function()
                local frameCount = exports.ox_inventory:Search('count', 'vehicle_frame') or 0
        
                if frameCount < 1 then
                    TriggerEvent('ox_lib:notify', {type='error', description='You need at least 1 vehicle frame to add it.'})
                    return
                end
        
                if materials.vehicle_frame >= requiredMaterials.vehicle_frame then
                    TriggerEvent('ox_lib:notify', {type='info', description='Vehicle frame already added.'})
                    TriggerEvent('lx-vehicleblueprint:showRepairMenu', vehicle)
                    return
                end
        
                local canAdd = requiredMaterials.vehicle_frame - materials.vehicle_frame
                local toAdd = math.min(frameCount, canAdd)
        
                TriggerServerEvent('ox_inventory:removeItem', 'vehicle_frame', toAdd)
        
                materials.vehicle_frame = materials.vehicle_frame + toAdd
                TriggerEvent('ox_lib:notify', {type='success', description=('Added %d vehicle frame(s)!'):format(toAdd)})
                ResetEntityAlpha(vehicle)
                TriggerEvent('lx-vehicleblueprint:showRepairMenu', vehicle)
            end
        },
        {
            title = ('Add Iron (%d/%d)'):format(materials.iron, requiredMaterials.iron),
            icon = 'fa-solid fa-ruler-horizontal',
            onSelect = function()
                -- Check how many iron items the player currently has
                local ironCount = exports.ox_inventory:Search('count', 'iron') or 0
                
                if ironCount < 1 then
                    TriggerEvent('ox_lib:notify', {type='error', description='You need at least 1 iron to add it.'})
                    return
                end
                
                if materials.iron >= requiredMaterials.iron then
                    TriggerEvent('ox_lib:notify', {type='info', description='Iron already fully added.'})
                    TriggerEvent('lx-vehicleblueprint:showRepairMenu', vehicle)
                    return
                end
                
                -- Calculate how many irons we can add without exceeding required amount
                local canAdd = requiredMaterials.iron - materials.iron
                local toAdd = math.min(ironCount, canAdd)
                
                -- Remove multiple irons at once from inventory
                TriggerServerEvent('ox_inventory:removeItem', 'iron', toAdd)
                
                materials.iron = materials.iron + toAdd
                TriggerEvent('ox_lib:notify', {type='success', description=('Added %d iron (%d/%d)'):format(toAdd, materials.iron, requiredMaterials.iron)})
                TriggerEvent('lx-vehicleblueprint:showRepairMenu', vehicle)
            end
        },
        {
            title = ('Add Aluminium (%d/%d)'):format(materials.aluminium, requiredMaterials.aluminium),
            icon = 'fa-solid fa-ruler',
            onSelect = function()
                -- Check how many aluminium the player has
                local aluminiumCount = exports.ox_inventory:Search('count', 'aluminium') or 0
        
                if aluminiumCount < 1 then
                    TriggerEvent('ox_lib:notify', {type='error', description='You need at least 1 aluminium to add it.'})
                    return
                end
        
                if materials.aluminium >= requiredMaterials.aluminium then
                    TriggerEvent('ox_lib:notify', {type='info', description='Aluminium already fully added.'})
                    TriggerEvent('lx-vehicleblueprint:showRepairMenu', vehicle)
                    return
                end
        
                local canAdd = requiredMaterials.aluminium - materials.aluminium
                local toAdd = math.min(aluminiumCount, canAdd)
        
                TriggerServerEvent('ox_inventory:removeItem', 'aluminium', toAdd)
        
                materials.aluminium = materials.aluminium + toAdd
                TriggerEvent('ox_lib:notify', {type='success', description=('Added %d aluminium (%d/%d)'):format(toAdd, materials.aluminium, requiredMaterials.aluminium)})
                TriggerEvent('lx-vehicleblueprint:showRepairMenu', vehicle)
            end
        },
        
        {
            title = ('Add Metal Scrap (%d/%d)'):format(materials.metalscrap, requiredMaterials.metalscrap),
            icon = 'fa-solid fa-wrench',
            onSelect = function()
                -- Check how many metalscrap the player has
                local metalCount = exports.ox_inventory:Search('count', 'metalscrap') or 0
        
                if metalCount < 1 then
                    TriggerEvent('ox_lib:notify', {type='error', description='You need at least 1 metal scrap to add it.'})
                    return
                end
        
                if materials.metalscrap >= requiredMaterials.metalscrap then
                    TriggerEvent('ox_lib:notify', {type='info', description='Metal scrap already fully added.'})
                    TriggerEvent('lx-vehicleblueprint:showRepairMenu', vehicle)
                    return
                end
        
                local canAdd = requiredMaterials.metalscrap - materials.metalscrap
                local toAdd = math.min(metalCount, canAdd)
        
                TriggerServerEvent('ox_inventory:removeItem', 'metalscrap', toAdd)
        
                materials.metalscrap = materials.metalscrap + toAdd
                TriggerEvent('ox_lib:notify', {type='success', description=('Added %d metal scrap (%d/%d)'):format(toAdd, materials.metalscrap, requiredMaterials.metalscrap)})
                TriggerEvent('lx-vehicleblueprint:showRepairMenu', vehicle)
            end
        },
        {
            title = ('Add Car Parts (%d/%d)'):format(materials.car_parts, requiredMaterials.car_parts),
            icon = 'fa-solid fa-cogs',
            onSelect = function()
                -- Check how many car parts the player has
                local partsCount = exports.ox_inventory:Search('count', 'car_parts') or 0
        
                if partsCount < 1 then
                    TriggerEvent('ox_lib:notify', {type='error', description='You need at least 1 car part to add it.'})
                    return
                end
        
                if materials.car_parts >= requiredMaterials.car_parts then
                    TriggerEvent('ox_lib:notify', {type='info', description='Car parts already fully added.'})
                    TriggerEvent('lx-vehicleblueprint:showRepairMenu', vehicle)
                    return
                end
        
                local canAdd = requiredMaterials.car_parts - materials.car_parts
                local toAdd = math.min(partsCount, canAdd)
        
                TriggerServerEvent('ox_inventory:removeItem', 'car_parts', toAdd)
        
                materials.car_parts = materials.car_parts + toAdd
                TriggerEvent('ox_lib:notify', {type='success', description=('Added %d car parts (%d/%d)'):format(toAdd, materials.car_parts, requiredMaterials.car_parts)})
                TriggerEvent('lx-vehicleblueprint:showRepairMenu', vehicle)
            end
        },
        
    }

    -- Finish button only enabled when all wheels & materials done

    if allMaterialsDone() then
        table.insert(options, {
            title = 'Finish Build',
            icon = 'fa-solid fa-check',
            onSelect = function()
                SetVehicleFixed(vehicle)
                SetVehicleEngineHealth(vehicle, 1000.0)
                SetVehicleDirtLevel(vehicle, 200.0)
                SetVehicleUndriveable(vehicle, false)
                FreezeEntityPosition(vehicle, false)
                ResetEntityAlpha(vehicle)
    
                SetVehicleFuelLevel(vehicle, 0.0)
    
                local netId = NetworkGetNetworkIdFromEntity(vehicle)
                SetNetworkIdCanMigrate(netId, true)
            
                TriggerServerEvent('bp:server:giveKeys', netId)
    
                local props = lib.getVehicleProperties(vehicle)
                local vehicle = NetworkGetEntityFromNetworkId(netId)
                local modelHash = GetEntityModel(vehicle)
                local modelName = GetDisplayNameFromVehicleModel(modelHash)
                
                TriggerServerEvent('bp:server:makeOwner', netId, modelName, props)

                exports.ox_target:removeLocalEntity(vehicle)

                TriggerEvent('ox_lib:notify', {type='success', description='Vehicle fully repaired and ready to go!'})
            end
        })
    else
        table.insert(options, {
            title = 'Finish Build (Incomplete)',
            icon = 'fa-solid fa-check',
            disabled = true,
        })
    end

    lib.registerContext({
        id = 'repair_vehicle_menu',
        title = 'Build Blueprint',
        options = options
    })

    lib.showContext('repair_vehicle_menu')
end)

QBCore.Functions = QBCore.Functions or {}

QBCore.Functions.GetVehicleProperties = function(vehicle)
    if not DoesEntityExist(vehicle) then return end

    local props = {}
    props.model = GetEntityModel(vehicle)
    props.plate = GetVehicleNumberPlateText(vehicle)
    props.bodyHealth = GetVehicleBodyHealth(vehicle)
    props.engineHealth = GetVehicleEngineHealth(vehicle)
    props.fuelLevel = GetVehicleFuelLevel(vehicle)
    props.dirtLevel = GetVehicleDirtLevel(vehicle)
    props.color1, props.color2 = GetVehicleColours(vehicle)
    props.pearlescentColor, props.wheelColor = GetVehicleExtraColours(vehicle)
    props.windowTint = GetVehicleWindowTint(vehicle)
    props.wheels = GetVehicleWheelType(vehicle)
    props.mods = {}

    for i = 0, 49 do
        props.mods[i] = GetVehicleMod(vehicle, i)
    end

    return props
end