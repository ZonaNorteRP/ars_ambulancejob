local DoScreenFadeOut              = DoScreenFadeOut
local IsScreenFadedOut             = IsScreenFadedOut
local NetworkResurrectLocalPlayer  = NetworkResurrectLocalPlayer
local ShakeGameplayCam             = ShakeGameplayCam
local AnimpostfxPlay               = AnimpostfxPlay
local CreateThread                 = CreateThread
local Wait                         = Wait
local SetEntityCoords              = SetEntityCoords
local TaskPlayAnim                 = TaskPlayAnim
local FreezeEntityPosition         = FreezeEntityPosition
local ClearPedTasks                = ClearPedTasks
local SetEntityHealth              = SetEntityHealth
local SetEntityInvincible          = SetEntityInvincible
local SetEveryoneIgnorePlayer      = SetEveryoneIgnorePlayer
local GetGameTimer                 = GetGameTimer
local IsControlJustPressed         = IsControlJustPressed
local TriggerServerEvent           = TriggerServerEvent
local AddEventHandler              = AddEventHandler
local SetEntityHeading             = SetEntityHeading
local DoScreenFadeIn               = DoScreenFadeIn
local PlayerPedId                  = PlayerPedId
local NetworkGetPlayerIndexFromPed = NetworkGetPlayerIndexFromPed
local IsPedAPlayer                 = IsPedAPlayer
local IsPedDeadOrDying             = IsPedDeadOrDying
local IsPedFatallyInjured          = IsPedFatallyInjured

local animations                   = lib.load("config").animations
local mumbleDisable                 = lib.load("config").mumbleDisable
local disableEMSCalls               = lib.load("config").disableEMSCalls
local disableRespawnAnimation       = lib.load("config").disableRespawnAnimation
local ejectDeadFromVehicle          = lib.load("config").ejectDeadFromVehicle

function stopPlayerDeath()
    player.isDead = false
    -- player.injuries = {}

    local playerPed = cache.ped or PlayerPedId()
    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
        Wait(50)
    end

    local coords = cache.coords or GetEntityCoords(playerPed)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.w, false, false)

    local deathStatus = { isDead = false }
    TriggerServerEvent('ars_ambulancejob:updateDeathStatus', deathStatus)

    playerPed = PlayerPedId()

    if cache.vehicle then
        SetPedIntoVehicle(cache.ped, cache.vehicle, cache.seat)
    end

    ClearPedBloodDamage(playerPed)
    SetEntityInvincible(playerPed, false)
    SetEveryoneIgnorePlayer(cache.playerId, false)
    ClearPedTasks(playerPed)
    AnimpostfxStopAll()

    DoScreenFadeIn(700)
    if not disableRespawnAnimation then
        TaskPlayAnim(playerPed, animations["get_up"].dict, animations["get_up"].clip, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
    end

    -- LocalPlayer.state:set("injuries", {}, true)
    LocalPlayer.state:set("dead", false, true)
    LocalPlayer.state:set("isDead", false, true)
    if mumbleDisable then
        MumbleSetActive(true)
    end
    exports["pma-voice"]:overrideProximityRange(3.0, false)

    player.distressCallTime = nil
    Framework.playerSpawned()
    healPlayer()
end

function healPlayer()
    local playerPed = cache.ped or PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)

    SetEntityHealth(playerPed, maxHealth)
    Framework.healStatus()
end

-- Compatibilidade com qb
RegisterNetEvent("hospital:client:Revive", function()
    local data = {
        revive = true,
    }
    TriggerEvent("ars_ambulancejob:healPlayer", data)
end)

-- Compatibilidade com qbx
RegisterNetEvent("qbx_medical:client:playerRevived", function()
    local data = {
        revive = true,
    }
    TriggerEvent("ars_ambulancejob:healPlayer", data)
end)

RegisterNetEvent("ars_ambulancejob:healPlayer", function(data)
    if data.revive then
        stopPlayerDeath()
    elseif data.injury then
        treatInjury(data.bone)
    elseif data.heal then
        healPlayer()
    end
end)

local removeItemsOnRespawn = lib.load("config").removeItemsOnRespawn
local function respawnPlayer()
    local playerPed = cache.ped or PlayerPedId()

    if removeItemsOnRespawn then
        TriggerServerEvent("ars_ambulancejob:removeInventory")
    end

    TriggerEvent('ND_Police:uncuffPed')

    local hospital = utils.getClosestHospital()
    local bed = nil

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(1) end

    for i = 1, #hospital.respawn do
        local _bed = hospital.respawn[i]
        local isBedOccupied = utils.isBedOccupied(_bed.bedPoint)
        if not isBedOccupied then
            bed = _bed
            break
        end
    end

    if not bed then bed = hospital.respawn[1] end

    player.respawning = true

    if not disableRespawnAnimation then
        lib.requestAnimDict("anim@gangops@morgue@table@")
        lib.requestAnimDict("switch@franklin@bed")

        SetEntityCoords(playerPed, bed.bedPoint)
        SetEntityHeading(playerPed, bed.bedPoint.w)
        TaskPlayAnim(playerPed, "anim@gangops@morgue@table@", "body_search", 2.0, 2.0, -1, 1, 0, false, false, false)
        FreezeEntityPosition(playerPed, true)
        DoScreenFadeIn(300)
        Wait(5000)
        SetEntityCoords(playerPed, vector3(bed.bedPoint.x, bed.bedPoint.y, bed.bedPoint.z) + vector3(0.0, 0.0, -1.0))
        FreezeEntityPosition(playerPed, false)
        SetEntityHeading(cache.ped, bed.bedPoint.w + 90.0)
        TaskPlayAnim(playerPed, "switch@franklin@bed", "sleep_getup_rubeyes", 1.0, 1.0, -1, 8, -1, 0, 0, 0)

        Wait(5000)
    end

    stopPlayerDeath()
    ClearPedTasks(playerPed)
    SetEntityCoords(playerPed, bed.spawnPoint)
    player.respawning = false
end

local function showScaleform(title, sec)
	function Initialize(scaleform)
		local scaleform = RequestScaleformMovie(scaleform)

		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		PushScaleformMovieFunctionParameterString(title)
		-- PushScaleformMovieFunctionParameterString(desc)
		PopScaleformMovieFunctionVoid()
		return scaleform
	end
	scaleform = Initialize("mp_big_message_freemode")

    PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)

	while sec > 0 do
		sec = sec - 0.02
		Citizen.Wait(0)
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
	end
	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

local useExtraEffects = lib.load("config").extraEffects
local respawnTime = lib.load("config").respawnTime
local function initPlayerDeath(logged_dead)
    if ejectDeadFromVehicle and IsPedInAnyVehicle(cache.ped, false) then
        local vehicle = GetVehiclePedIsIn(cache.ped, false)

        TaskLeaveVehicle(cache.ped, vehicle, 4160)
        Wait(250)

        local vehCoords = GetEntityCoords(vehicle)
        local forward = GetEntityForwardVector(vehicle)
        local ejectPos = vec3(
            vehCoords.x + forward.x * 2.0,
            vehCoords.y + forward.y * 2.0,
            vehCoords.z + 0.5
        )

        ClearPedTasksImmediately(cache.ped)
        SetEntityCoordsNoOffset(cache.ped, ejectPos.x, ejectPos.y, ejectPos.z, false, false, false)
        Wait(100)
        SetPedToRagdoll(cache.ped, 5000, 5000, 0, true, true, false)
    end

    if player.isDead then return end

    player.isDead = true
    LocalPlayer.state:set("isDead", true, true)
    if mumbleDisable then
        MumbleSetActive(false)
    end
    exports["pma-voice"]:overrideProximityRange(0.0, false)

    startCommandTimer()

    for _, anim in pairs(animations) do
        lib.requestAnimDict(anim.dict)
    end

    if logged_dead then goto logged_dead end

    if useExtraEffects then
        ShakeGameplayCam('DEATH_FAIL_IN_EFFECT_SHAKE', 1.0)
        AnimpostfxPlay('DeathFailOut', 0, true)
        -- showScaleform("~r~se fodeu", 20) -- Tela de morte removida

        Wait(4000)

        DoScreenFadeOut(200)
        Wait(800)
        DoScreenFadeIn(400)
    end
    if not player.isDead then return end

    ::logged_dead::
    local playerPed = cache.ped or PlayerPedId()

    CreateThread(function()
        while player.isDead do
            DisableFirstPersonCamThisFrame()
            Wait(0)
        end
    end)

    local coords = cache.coords or GetEntityCoords(playerPed)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(playerPed), false, false)
    playerPed = PlayerPedId()

    if cache.vehicle then
        SetPedIntoVehicle(cache.ped, cache.vehicle, cache.seat)
    end

    -- SetEntityInvincible(cache.ped, true) -- Testando
    -- SetEntityHealth(cache.ped, 100)
    SetEveryoneIgnorePlayer(cache.playerId, true)

    local time = 60000 * respawnTime
    local deathTime = GetGameTimer()

    CreateThread(function()
        while player.isDead do
            local sleep = 1500

            if not player.gettingRevived and not player.respawning then
                sleep = 0
                local anim = cache.vehicle and animations["death_car"] or animations["death_normal"]

                if not IsEntityPlayingAnim(playerPed, anim.dict, anim.clip, 3) then
                    TaskPlayAnim(playerPed, anim.dict, anim.clip, 50.0, 8.0, -1, 1, 1.0, false, false, false)
                end

                local elapsedSeconds = math.floor((GetGameTimer() - deathTime) / 1000)

                if not disableEMSCalls then
                    utils.drawTextFrame({
                    x = 0.5,
                        y = 0.9,
                        msg = locale("death_screen_call_medic")
                    })
                end

                if IsControlJustPressed(0, 38) and not disableEMSCalls then
                    createDistressCall()
                end

                utils.drawTextFrame({
                    x = 0.5,
                    y = 0.86,
                    msg = "Pressione ~y~Y~w~ para solicitar ~y~/socorro NPC"
                })

                if IsControlJustPressed(0, 246) then -- Tecla Y
                    ExecuteCommand("socorro")
                end

                if GetGameTimer() - deathTime >= time then
                    EnableControlAction(0, 47, true)

                    utils.drawTextFrame({
                        x = 0.5,
                        y = 0.82,
                        msg = locale("death_screen_respawn")
                    })

                    if IsControlJustPressed(0, 47) then
                        local confirmation = lib.alertDialog({
                            header = locale("death_screen_confirm_respawn_header"),
                            content = locale("death_screen_confirm_respawn_content"),
                            centered = true,
                            cancel = true
                        })

                        if confirmation == "confirm" then
                            respawnPlayer()
                        end
                    end
                else
                    utils.drawTextFrame({
                        x = 0.5,
                        y = 0.82,
                        msg = (locale("death_screen_respawn_timer")):format(math.floor((time / 1000) - elapsedSeconds))
                    })
                end
            end

            Wait(sleep)
        end
    end)
end

function onPlayerLoaded()
    exports.spawnmanager:setAutoSpawn(false) -- for qbcore

    local data = lib.callback.await('ars_ambulancejob:getDeathStatus', false)

    if data and data.isDead then
        initPlayerDeath(true)
        utils.showNotification(locale("logged_dead"))
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if LocalPlayer.state.isLoggedIn then
            onPlayerLoaded()
        end
    end
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event ~= 'CEventNetworkEntityDamage' then return end

    local victim, attacker, victimDied, weapon = data[1], data[2], data[4], data[7]
    utils.debug(weapon)


    if not IsPedAPlayer(victim) then return end

    local playerPed = cache.playerId or PlayerId()

    if NetworkGetPlayerIndexFromPed(victim) ~= playerPed then return end

    local victimDiedAndPlayer = victimDied and NetworkGetPlayerIndexFromPed(victim) == playerPed and (IsPedDeadOrDying(victim, true) or IsPedFatallyInjured(victim))

    if victimDiedAndPlayer then
        local deathData = {}

        deathData.isDead = true
        deathData.weapon = weapon

        if weapon and weapon ~= 0 then
            LocalPlayer.state:set("deathweapon", weapon, true)
            utils.debug("^2Deathlog^7: Arma capturada do evento - Hash: " .. tostring(weapon))
        else
            utils.debug("^3Deathlog^7: Hash da arma não disponível no evento")
        end

        local killerServerId = nil
        local isNPCKill = false

        if attacker and attacker ~= 0 then
            if IsEntityAVehicle(attacker) then
                local driver = GetPedInVehicleSeat(attacker, -1)
                if driver and driver ~= 0 then
                    if IsPedAPlayer(driver) then
                        killerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(driver))
                        LocalPlayer.state:set("deathKillerServerId", killerServerId, true)
                        LocalPlayer.state:set("deathIsVehicleKill", true, true)
                        utils.debug("^2Deathlog^7: Assassino capturado do evento (veículo) - Server ID: " .. tostring(killerServerId))
                    else
                        isNPCKill = true
                        LocalPlayer.state:set("deathIsNPCKill", true, true)
                        utils.debug("^2Deathlog^7: Morte por NPC (veículo)")
                    end
                end
            elseif IsEntityAPed(attacker) then
                if IsPedAPlayer(attacker) then
                    killerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(attacker))
                    LocalPlayer.state:set("deathKillerServerId", killerServerId, true)
                    LocalPlayer.state:set("deathIsVehicleKill", false, true)
                    utils.debug("^2Deathlog^7: Assassino capturado do evento - Server ID: " .. tostring(killerServerId))
                else
                    isNPCKill = true
                    LocalPlayer.state:set("deathIsNPCKill", true, true)
                    utils.debug("^2Deathlog^7: Morte por NPC")
                end
            end
        end

        if not killerServerId and not isNPCKill then
            LocalPlayer.state:set("deathKillerServerId", nil, true)
            LocalPlayer.state:set("deathIsVehicleKill", nil, true)
            LocalPlayer.state:set("deathIsNPCKill", nil, true)
        end

        TriggerServerEvent('ars_ambulancejob:updateDeathStatus', deathData)
        LocalPlayer.state:set("dead", true, true)
        initPlayerDeath()

        exports["ars_ambulancejob"]:DeathLog()
    end

    updateInjuries(victim, weapon)

    utils.debug(LocalPlayer.state.injuries)
end)


exports("isDead", function()
    return player.isDead
end)
