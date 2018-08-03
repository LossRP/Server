RegisterCommand("fix", function(source, args, rawCommand)
    TriggerEvent('fix')
end, false)

RegisterNetEvent("fix")
AddEventHandler("fix", function()
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed)
		FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), true)
		    Notification("~g~The mechanic's working on your car. It should take around 15 seconds to complete.")
			Citizen.Wait(15000)
		FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
		SetVehicleEngineHealth(vehicle, 9999)
		SetVehiclePetrolTankHealth(vehicle, 9999)
		SetVehicleFixed(vehicle)
		    Notification("~g~Your vehicle has been fixed.")
	else
		Notification("~g~You are not in a vehicle.")
	end
end)

function Notification(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(false, false)
end
