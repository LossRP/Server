--[[
Copyright © Julie Manlet // State of San Andreas

All rights reserved. 


No part of this script may be reproduced, distributed, or transmitted in any form or by any means. 
These include, but are not limited to: uploading, privately sharing, or other electronic methods without the prior written permission of the owner.
Please understand that there will be no exceptions, no matter the case.
If you have any questions, concerns or suggestions - please contact the SOSA Development Department.

v1.0

]]--



RegisterNetEvent('manlet:allowRespawn')
RegisterNetEvent('manlet:allowRevive') 

local reviveWaitPeriod = 0
local RPDeathEnabled = true  


AddEventHandler('onClientMapStart', function()
	exports.spawnmanager:spawnPlayer()
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
end)


local allowRespawn = false
local allowRevive = false
local diedTime = nil


AddEventHandler('manlet:allowRespawn', function(from)
	allowRespawn = true	
end)


AddEventHandler('manlet:allowRevive', function(from)
	
	if(not IsEntityDead(GetPlayerPed(-1)))then
		return
	end
	
	if(IsEntityDead(GetPlayerPed(-1)))then
	allowRevive = true	
	end
	
end)


Citizen.CreateThread(function()
	local respawnCount = 0
	local spawnPoints = {}
	local playerIndex = NetworkGetPlayerIndex(-1) or 0


	math.randomseed(playerIndex)

	function createSpawnPoint(x1,x2,y1,y2,z,heading)
		local xValue = math.random(x1,x2) + 0.0001
		local yValue = math.random(y1,y2) + 0.0001

		local newObject = {
			x = xValue,
			y = yValue,
			z = z + 0.0001,
			heading = heading + 0.0001
		}
		table.insert(spawnPoints,newObject)
	end

	createSpawnPoint(372, 375, -596, -594, 30.0, 0)   -- Pillbox Hill
	createSpawnPoint(335, 340, -1400, -1390, 34.0, 0) -- Central Los Santos
	createSpawnPoint(1850, 1854, 3700, 3704, 35.0, 0) -- Sandy Shores
	createSpawnPoint(-247, -245, 6328, 6332, 33.5, 0) -- Paleto

	while true do
		Wait(0)
		local ped = GetPlayerPed(-1)
		
		if (RPDeathEnabled) then

			if (IsEntityDead(ped)) then
				if(diedTime == nil)then
					diedTime = GetGameTimer()
				end

				SetPlayerInvincible(ped, true)
				SetEntityHealth(ped, 1)
				
				if (allowRespawn) then 
					local coords = spawnPoints[math.random(1,#spawnPoints)]

					respawnPed(ped, coords)

			  		allowRespawn = false
			  		diedTime = nil
					respawnCount = respawnCount + 1
					math.randomseed( playerIndex * respawnCount )

				elseif (allowRevive) then
					revivePed(ped)

					allowRevive = false	
		  			diedTime = nil
					Wait(0)
				else
		  			Wait(0)
				end
			else
		  		allowRespawn = false
		  		allowRevive = false	
		  		diedTime = nil		
				Wait(0)
			end


		else 

		end
	
	end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)		
		local ped = GetPlayerPed(-1)

		
		if IsControlJustPressed(1, 86) and IsEntityDead(ped) then
        	TriggerEvent('manlet:allowRevive')
			drawNotification("You have ~g~revived~s~ yourself.")

        end
		
		if IsControlJustPressed(1, 45) and IsEntityDead(ped) then
        	TriggerEvent('manlet:allowRespawn')
			drawNotification("You have ~g~respawned~s~ yourself.")
		end
		
   end
end)

Citizen.CreateThread(function()
    while true do
        Wait(500)     
		local ped = GetPlayerPed(-1)
		if IsEntityDead(ped) then
		drawNotificationPic("~r~You have died!~s~ ~n~~h~Press ~g~E~s~ to Revive! ~n~Press ~g~R~s~ to Respawn!")		
		else
		
		end
		
   end
end)



-- Commands
RegisterCommand("die", function(source, args, raw)
	local ped = PlayerPedId()
	local noHealth = 0
    SetEntityHealth(ped, noHealth)
	drawNotification("You have ~r~killed~s~ yourself.")
end, false)


-- Functions
function revivePed(ped)
	local playerPos = GetEntityCoords(ped, true)

	NetworkResurrectLocalPlayer(playerPos, true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
end


function respawnPed(ped,coords)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false) 

	SetPlayerInvincible(ped, false) 

	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
	ClearPedBloodDamage(ped)
end

function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function drawBlinkNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
end

function drawNotificationPic(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Roleplay Death", "")
	DrawNotification(false, false)
end


--[[
Copyright © Julie Manlet // State of San Andreas

All rights reserved. 


No part of this script may be reproduced, distributed, or transmitted in any form or by any means. 
These include, but are not limited to: uploading, privately sharing, or other electronic methods without the prior written permission of the owner.
Please understand that there will be no exceptions, no matter the case.
If you have any questions, concerns or suggestions - please contact the SOSA Development Department.

v1.0

]]--