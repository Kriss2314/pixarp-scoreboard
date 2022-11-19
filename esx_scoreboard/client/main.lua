local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local CurrentPlayers = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)




RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	local data = xPlayer
	local job = data.job

	if job.label == 'Unemployed' then
		SendNUIMessage({action = "updatePraca", praca = 'Bezrobotny'})
	else
SendNUIMessage({action = "updatePraca", praca = job.label.." - "..job.grade_label})
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
		if job.label == 'Unemployed' then
			SendNUIMessage({action = "updatePraca", praca = 'Bezrobotny'})
		else
	SendNUIMessage({action = "updatePraca", praca = job.label.." - "..job.grade_label})
		end
end)





RegisterNetEvent('esx_scoreboard:updateConnectedPlayers')
AddEventHandler('esx_scoreboard:updateConnectedPlayers', function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
	CurrentPlayers = connectedPlayers
end)


RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
  SendNUIMessage({action = "updateStatus", infos = status})
end)

RegisterNetEvent('esx_status:onTick')
AddEventHandler('esx_status:onTick', function(status)
  SendNUIMessage({action = "updateStatus", infos = status})
end)

RegisterNetEvent('esx_status:update')
AddEventHandler('esx_status:update', function(status)
	SendNUIMessage({action = "updateStatus", infos = status})
end)



RegisterNetEvent('uptime:tick')
AddEventHandler('uptime:tick', function(uptime)
	ajdik = GetPlayerServerId(PlayerId())
	if ajdik == nil or ajdik == '' then
		ajdik = GetPlayerServerId(PlayerId())
	end
	SendNUIMessage({
		action = 'updateServerInfo',
		uptime = ajdik
	})
end)







function GetJobCount(job)
	local count = 0
	for k,v in pairs(CurrentPlayers) do
		if v.job == job then
			count = count + 1
		end
	end
	return count
end

function UpdatePlayerTable(connectedPlayers)
	CurrentPlayers = connectedPlayers
	local formattedPlayerList, num = {}, 1
	local ems, police, taxi, mechanic, dmv, govm, estate, fire, safj,graczy, players = 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0
	CurrentPlayers = connectedPlayers
	for k,v in pairs(connectedPlayers) do
		table.insert(formattedPlayerList, ('<tr><td>%s</td><td>%s</td><td>%s</td>'):format(v.name, v.id, v.ping))
		players = players + 1

		if v.job == 'ambulance' then
			ems = ems + 1
		elseif v.job == 'police' then
			police = police + 1
		elseif v.job == 'pdm' then
			fire = fire + 1
		elseif v.job == 'mechanic' then
			mechanic = mechanic + 1
		elseif v.job == 'dmv' then
			dmv = dmv + 1
		elseif v.job == 'taxi' then
			estate = estate + 1
		end
	
	end

	if police <= 4 then
	SendNUIMessage({
		action = 'updatePlayerJobs',
		jobs   = {ems = ems, police = police, taxi = taxi, mechanic = mechanic, dmv = dmv, fire = fire, estate = estate, player_count = players}
	})
	elseif police > 4 then
		SendNUIMessage({
		action = 'updatePlayerJobs',
		jobs   = {ems = ems, police = '4+', taxi = taxi, mechanic = mechanic, dmv = dmv, fire = fire, estate = estate, player_count = players}
	})
	end



end


local voiceId = 'CURRENT_VOICE_ID'
RegisterKeyMapping('+scoreboard', 'HUD~', 'keyboard', 'Z')
RegisterCommand("+scoreboard",function()
	TabelaOtwarta = not TabelaOtwarta
	if TabelaOtwarta then
		SendNUIMessage({
			action = 'open'
		})
	else
		SendNUIMessage({
			action = 'close'
		})
		exports['mythic_notify']:PersistentAlert('end', voiceId)
	end

	while TabelaOtwarta do
		ReadStatus()
		Wait(500)
	end
	
end)

RegisterCommand("scoreboard", function ()
	print('otwarto zetke i chuj')
end)

function ReadStatus()
	TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
		TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
				SendNUIMessage({
					action = "updateStatus",
					hunger = hunger.getPercent(),
	  
				})
				  SendNUIMessage({action = "updateGtaStat", name = 'hunger', stat = hunger.getPercent()})
				  SendNUIMessage({action = "updateGtaStat", name = 'thirst', stat = thirst.getPercent()})
		end)
	end)
	local playerPed = PlayerPedId()
	playerCurrentHealth = GetEntityHealth(playerPed)
	Armour = GetPedArmour(playerPed)
	ajdik = GetPlayerServerId(PlayerId())
	Dive = GetPlayerUnderwaterTimeRemaining(PlayerId())
	Air = math.floor(Dive*10)
	Sprint = math.floor(100 - GetPlayerSprintStaminaRemaining(PlayerId()))
	if Dive < 0.0 then
	  Air = 0.0
	end
	Health = math.floor(playerCurrentHealth-100)
	SendNUIMessage({action = "updateGtaStat", name = 'health', stat = Health})
	SendNUIMessage({action = "updateGtaStat", name = 'armour', stat = Armour})
	SendNUIMessage({
	  action = 'updateServerInfo',
	  maxPlayers = GetConvarInt('sv_maxclients', 80),
	  uptime = ajdik,
  })

end


function ToggleScoreBoard()
	SendNUIMessage({
		action = 'toggle'
	})
end
