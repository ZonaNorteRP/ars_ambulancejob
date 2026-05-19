local Config = {}

Config.debug = false

Config.useOxInventory = GetResourceState('ox_inventory'):find('start')

Config.clothingScript = 'illenium-appearance' -- 'illenium-appearance', 'fivem-appearance', 'core' or false -- to disable
Config.emsJobs = { "ambulance", "ems", "bombeiro", "medico" }
Config.respawnTime = 5                        -- in minutes
Config.waitTimeForNewCall = 5                 -- minutes

Config.reviveCommand = "revive"
Config.reviveAreaCommand = "revivearea"
Config.healCommand = "heal"
Config.healAreaCommand = "healarea"
Config.reviveAllCommand = "reviveall"

Config.adminGroup = {"admin", "mod", "support"}

Config.mumbleDisable = false -- true >> desativar o mumble ao morrer
Config.healthRegen = true -- true >> desativar a recuperação de vida automática do GTA

Config.medicBagProp = "xm_prop_x17_bag_med_01a"
Config.medicBagItem = "medicalbag"

Config.tabletItem = "emstablet"

Config.helpCommand = "911"
Config.disableEMSCalls = false -- true >> desativar as chamadas de emergência
Config.removeItemsOnRespawn = true
Config.disableRespawnAnimation = false -- true >> desativar a animação de respawn
Config.keepItemsOnRespawn = {} --{ "money", "WEAPON_PISTOL" } -- items that will not be removed when respawed (works only when Config.RemoveItemsOnRespawn is true)

Config.baseInjuryReward = 150
Config.reviveReward = 700

Config.paramedicTreatmentPrice = 4000
Config.allowAlways = false             -- false if you want it to work only when there are only medics online

Config.ambulanceStretchers = 2        -- how many stretchers should an ambulance have
Config.consumeItemPerUse = 10         -- every time you use an item it gets used by 10%

Config.npcReviveCommand = "socorro" -- this will work only when there are no medics online
Config.timeToWaitForCommand = 2       -- when player dies he needs to wait 2 minutes to do the ambulance command
Config.minimumOnServiceForNPC = 3      -- mínimo de médicos online para desabilitar o comando de socorro da ambulância NPC <- Se for 0, quando tiver 1 ou mais médicos online, o comando será desabilitado

Config.usePedToDepositVehicle = false -- if false the vehicle will instantly despawns
Config.extraEffects = true            -- false >> disables the screen shake and the black and white screen

Config.ejectDeadFromVehicle = true   -- OPÇÃO ZAP: true >> ejects the dead player from the vehicle they are in

Config.emsVehicles = {                -- vehicles that have access to the props (cones and ecc..)
	ambulance = true,
	ambulance2 = true,
	firetruk = true,
}

Config.animations = {
	["death_car"] = {
		dict = "veh@low@front_ps@idle_duck",
		clip = "sit"
	},
	["death_normal"] = {
		dict = "dead",
		clip = "dead_a"
	},
	["get_up"] = {
		dict = "get_up@directional@movement@from_knees@action",
		clip = "getup_r_0"
	}
}

Config.Discord = {
    Settings = {
        Webhook = 'https://discord.com/api/webhooks/1458861934278344736/xOlg6jzNZIkB12xCzXlxDADFOOk2QT9ZzTbnvpQJDgou-fIuUDe11b-4I_JXllz_aOYt',
        Name = 'Zona Norte - Deathlog',
        Images = 'https://i.imgur.com/QjLjjYZ.png'
    },
}

function Config.sendDistressCall(msg)
	-- [--] -- Quasar

	-- TriggerServerEvent('qs-smartphone:server:sendJobAlert', {message = msg, location = GetEntityCoords(PlayerPedId())}, "ambulance")


	-- [--] -- GKS
	-- local myPos = GetEntityCoords(PlayerPedId())
	-- local GPS = 'GPS: ' .. myPos.x .. ', ' .. myPos.y

	-- ESX.TriggerServerCallback('gksphone:namenumber', function(Races)
	--   local name = Races[2].firstname .. ' ' .. Races[2].lastname

	--   TriggerServerEvent('gksphone:jbmessage', name, Races[1].phone_number, msg, '', GPS, "ambulance")
	-- end)
end

function Config.giveVehicleKeys(vehicle, plate)
	-- exaple usage
	-- exports['youscript']:name(vehicle, plate)
	exports.mri_Qcarkeys:GiveKeyItem(plate, vehicle)
end

function Config.removeVehicleKeys(vehicle, plate)
	-- exaple usage
	-- exports['youscript']:name(vehicle, plate)
	exports.mri_Qcarkeys:RemoveKeyItem(plate, vehicle)
end

return Config
