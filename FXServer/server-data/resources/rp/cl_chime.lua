Citizen.CreateThread(function()
	while true do
		local ped_l = GetPlayerPed(-1)

			if(DoesEntityExist(ped_l)) and (not IsEntityDead(ped_l)) then

				if(IsPedInAnyVehicle(ped_l,false)) and (IsThisModelACar(GetEntityModel(GetVehiclePedIsUsing(ped_l)))) then
					if(GetIsTaskActive(ped_l,2))then
						local veh = GetLastDrivenVehicle() or GetVehiclePedIsUsing(ped_l)
						TriggerServerEvent('InteractSound_SV:PlayOnSource', 'door_ring', 0.1)
						Wait(500)
					end
				end

					if (GetIsTaskActive(ped_l,160)) then
						local veh = GetVehiclePedIsUsing(ped_l)

							if (IsPedInAnyVehicle(ped_l,false)) and (IsThisModelACar(GetEntityModel(veh))) then
								TriggerServerEvent('InteractSound_SV:PlayOnSource', 'door_ring', 0.1)
								Wait(500)
							end
					end
			end
Wait(0)
end
end)
