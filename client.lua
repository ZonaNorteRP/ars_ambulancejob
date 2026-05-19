local DoesEntityExist = DoesEntityExist
local DeletePed       = DeletePed
local CreateThread    = CreateThread

player                = {}
player.injuries       = {}

local hospitals       = lib.load("data.hospitals")
local emsJobs         = lib.load("config").emsJobs
local clothingScript  = lib.load("config").clothingScript
local debug           = lib.load("config").debug
local function createZones()
    for index, hospital in pairs(hospitals) do
        local cfg = hospital

        if cfg.blip.enable then
            utils.createBlip(cfg.blip)
        end

        lib.zones.box({
            name = 'ars_hospital:' .. index,
            coords = cfg.zone.pos,
            size = cfg.zone.size,
            clothes = clothingScript and cfg.clothes,
            debug = debug,
            rotation = 0.0,
            onEnter = function(self)
                initGarage(cfg.garage, emsJobs)

                if self.clothes and self.clothes.enable then
                    initClothes(self.clothes, emsJobs)
                end

                initParamedic()
            end,
            onExit = function(self)
                for k, v in pairs(peds) do
                    if DoesEntityExist(v) then
                        DeletePed(v)
                    end
                end

                unloadGarage()
            end
        })
    end
end


CreateThread(createZones)


exports('bandage', function(data, slot)
    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)
    local health = GetEntityHealth(playerPed)

    if health < maxHealth then
        exports.ox_inventory:useItem(data, function(data)
            if data then
                lib.progressBar({
                    duration = 5000,
                    position = 'bottom',
                    label = 'Fazendo curativo...',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = false,
                        combat = true
                    },
                    anim = {
                        bone = 28422,
                        dict = 'missheistdockssetup1clipboard@idle_a',
                        clip = 'idle_a', flag = 49
                    },
                    prop = {
                        model = 'prop_ld_health_pack',
                        pos = vec3(-0.1, -0.05, -0.1),
                        rot = vec3(0.0, 0.0, 0.0)
                    },
                })
                SetEntityHealth(playerPed, math.min(maxHealth, math.floor(health + maxHealth / 16)))
                lib.notify({description = 'Você se sente melhor...'})
            end
        end)
    else
        lib.notify({type = 'error', description = 'Você não precisa de um curativo agora.'})
        return false
    end
end)

exports('analgesic', function(data, slot)
    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)
    local health = GetEntityHealth(playerPed)

    if health < maxHealth then
        exports.ox_inventory:useItem(data, function(data)
            if data then
                lib.progressBar({
                    duration = 4000,
                    position = 'bottom',
                    label = 'Tomando analgésico...',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = false,
                        combat = true
                    },
                    anim = {
                        dict = 'mp_player_intdrink',
                        clip = 'loop_bottle', flag = 49
                    },
                    prop = {
                        model = 'prop_cs_pills',
                        pos = vec3(0.15, 0.04, 0.01),
                        rot = vec3(-90.0, 0.0, 0.0),
                        bone = 18905
                    },
                })
                SetEntityHealth(playerPed, math.min(maxHealth, math.floor(health + maxHealth / 20)))
                lib.notify({description = 'A dor diminuiu...'})
            end
        end)
    else
        lib.notify({type = 'error', description = 'Você não precisa de um analgésico agora.'})
        return false
    end
end)

-- Registra o uso do item de adrenalina com o target system
CreateThread(function()
    Wait(1000) -- Aguarda o sistema carregar

    -- Tenta usar ox_target diretamente
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:addGlobalPlayer({
            {
                name = 'use_adrenaline',
                label = 'Usar Adrenalina',
                icon = 'fa-solid fa-syringe',
                distance = 3.0,
                canInteract = function(entity, distance, coords, name, bone)
                    local count = exports.ox_inventory:Search('count', 'adrenaline', 1)
                    if not count or count <= 0 then return false end

                    local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                    if targetServerId == 0 then return false end

                    return IsPedDeadOrDying(entity, true) or Player(targetServerId).state.isDead
                end,
                onSelect = function(data)
                    local targetPlayerId = GetPlayerServerId(NetworkGetEntityOwner(data.entity))
                    print("^2[ADRENALINA]^7 Tentando usar em player: " .. tostring(targetPlayerId))

                    if targetPlayerId == 0 then
                        lib.notify({ title = 'Erro', description = 'Player não encontrado.', type = 'error' })
                        return
                    end

                    -- Verifica se está morto antes de usar
                    local targetData = lib.callback.await('ars_ambulancejob:getData', false, targetPlayerId)
                    if not targetData or not targetData.status or not targetData.status.isDead then
                        lib.notify({
                            title = 'Adrenalina',
                            description = 'Este player não está morto.',
                            type = 'error'
                        })
                        return
                    end

                    local success = lib.progressBar({
                        duration = 5000,
                        label = 'Aplicando adrenalina...',
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                            combat = true
                        },
                        anim = { dict = 'amb@medic@standing@tendtodead@base', clip = 'base' },
                    })

                    if success then
                        TriggerServerEvent('ars_ambulancejob:reviveWithAdrenaline', targetPlayerId)
                    else
                        lib.notify({ title = 'Adrenalina', description = 'Aplicação cancelada.', type = 'error' })
                    end
                end
            }
        })
        print("^2[ADRENALINA]^7 Ox_target registrado com sucesso!")
    -- Tenta usar qb-target
    elseif GetResourceState('qb-target') == 'started' then
        exports['qb-target']:AddGlobalPlayer({
            options = {
                {
                    type = "client",
                    event = "ars_ambulancejob:useAdrenalineTarget",
                    icon = "fa-solid fa-syringe",
                    label = "Usar Adrenalina",
                    canInteract = function(entity)
                        local count = exports.ox_inventory:Search('count', 'adrenaline', 1)
                        if count <= 0 then return false end

                        local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                        if targetServerId == 0 then return false end

                        return IsPedDeadOrDying(entity, true) or Player(targetServerId).state.isDead
                    end,
                }
            },
            distance = 3.0
        })
        print("^2[ADRENALINA]^7 QB-target registrado com sucesso!")
    -- Usa o sistema Target se disponível
    elseif Target and Target.addGlobalPlayer then
        Target.addGlobalPlayer({
            {
                label = 'Usar Adrenalina',
                icon = 'fa-solid fa-syringe',
                groups = false,
                cn = function(entity, distance, coords, name, bone)
                    local count = exports.ox_inventory:Search('count', 'adrenaline', 1)
                    if count <= 0 then return false end

                    local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                    if targetServerId == 0 then return false end

                    return IsPedDeadOrDying(entity, true) or Player(targetServerId).state.isDead
                end,
                fn = function(data)
                    local targetPlayerId = GetPlayerServerId(NetworkGetEntityOwner(data.entity))
                    if targetPlayerId == 0 then
                        lib.notify({ title = 'Erro', description = 'Player não encontrado.', type = 'error' })
                        return
                    end

                    local success = lib.progressBar({
                        duration = 5000,
                        label = 'Aplicando adrenalina...',
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                            combat = true
                        },
                        anim = { dict = 'amb@medic@standing@tendtodead@base', clip = 'base' },
                    })

                    if success then
                        TriggerServerEvent('ars_ambulancejob:reviveWithAdrenaline', targetPlayerId)
                    else
                        lib.notify({ title = 'Adrenalina', description = 'Aplicação cancelada.', type = 'error' })
                    end
                end
            }
        })
        print("^2[ADRENALINA]^7 Target system registrado com sucesso!")
    else
        print("^3[AVISO]^7 Nenhum sistema de target encontrado. Use a adrenalina diretamente do inventário.")
    end
end)

-- Evento para qb-target
RegisterNetEvent('ars_ambulancejob:useAdrenalineTarget')
AddEventHandler('ars_ambulancejob:useAdrenalineTarget', function(data)
    local targetPlayerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
    if targetPlayerId == 0 then
        lib.notify({ title = 'Erro', description = 'Player não encontrado.', type = 'error' })
        return
    end

    local success = lib.progressBar({
        duration = 5000,
        label = 'Aplicando adrenalina...',
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = { dict = 'amb@medic@standing@tendtodead@base', clip = 'base' },
    })

    if success then
        TriggerServerEvent('ars_ambulancejob:reviveWithAdrenaline', targetPlayerId)
    else
        lib.notify({ title = 'Adrenalina', description = 'Aplicação cancelada.', type = 'error' })
    end
end)

-- Export para usar adrenalina como item
exports('useAdrenaline', function(data, slot)
    -- Debug: testa diferentes formas de verificar o item
    local count1 = exports.ox_inventory:Search('count', 'adrenaline')
    local count2 = exports.ox_inventory:Search('count', 'adrenaline', 1)
    local hasItem = exports.ox_inventory:Search('slots', 'adrenaline')

    print("^3[DEBUG EXPORT ADRENALINA]^7 Count sem quantidade: " .. tostring(count1))
    print("^3[DEBUG EXPORT ADRENALINA]^7 Count com quantidade: " .. tostring(count2))
    print("^3[DEBUG EXPORT ADRENALINA]^7 HasItem slots: " .. tostring(hasItem and #hasItem or 0))

    -- Testa se tem o item de qualquer forma
    local hasAdrenaline = false
    if count1 and count1 > 0 then
        hasAdrenaline = true
    elseif count2 and count2 > 0 then
        hasAdrenaline = true
    elseif hasItem and #hasItem > 0 then
        hasAdrenaline = true
    end

    if not hasAdrenaline then
        lib.notify({
            type = 'error',
            description = 'Você não tem adrenalina no inventário.'
        })
        return false
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    -- Procura por players mortos próximos
    local closestPlayer = nil
    local closestDistance = 3.0

    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(coords - targetCoords)

            if distance < closestDistance then
                local targetServerId = GetPlayerServerId(playerId)
                -- Verifica se o player está morto de forma síncrona
                local isDead = IsPedDeadOrDying(targetPed, true) or Player(targetServerId).state.isDead
                if isDead then
                    closestPlayer = targetServerId
                    closestDistance = distance
                end
            end
        end
    end

    if closestPlayer then
        exports.ox_inventory:useItem(data, function(data)
            if data then
                local success = lib.progressBar({
                    duration = 5000,
                    label = 'Aplicando adrenalina...',
                    canCancel = true,
                    disable = {
                        car = true,
                        move = true,
                        combat = true
                    },
                    anim = { dict = 'amb@medic@standing@tendtodead@base', clip = 'base' },
                })

                if success then
                    TriggerServerEvent('ars_ambulancejob:reviveWithAdrenaline', closestPlayer)
                    lib.notify({
                        title = 'Adrenalina',
                        description = 'Adrenalina aplicada com sucesso!',
                        type = 'success'
                    })
                else
                    lib.notify({ title = 'Adrenalina', description = 'Aplicação cancelada.', type = 'error' })
                end
            end
        end)
    else
        lib.notify({
            type = 'error',
            description = 'Nenhum player morto encontrado próximo a você (máximo 3 metros). Tente usar o botão direito em um player morto.'
        })
        return false
    end
end)
