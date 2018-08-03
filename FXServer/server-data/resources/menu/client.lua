local leoSkins = {
	"S_M_Y_COP_01",
	"S_F_Y_COP_01",
    "s_m_m_ciasec_01",
    "s_m_y_hwaycop_01",
    "s_m_y_hwaycop_01_p",
	"s_m_m_ciasec_01",
	"s_m_y_marineyoung_01",
    "s_m_y_marine_01",
    "s_m_y_marine_02",
    "s_m_y_marine_03",
    "s_m_y_sheriff_01",
    "s_m_y_swat_01",
	"s_f_y_ranger_01",
	"s_m_y_ranger_01",
}

local fdSkins = {
    "s_m_y_fireman_01",
	"s_m_m_paramedic_01"
}

Citizen.CreateThread(function()

	ped = GetPlayerPed(-1)

	while true do
		Citizen.Wait(0)
		if IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then
			isCuffed = true
		elseif isCuffed then
			TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
			DisableControlAction(1, 24, true)
			DisableControlAction(1, 25, true)
			DisableControlAction(1, 59, true)
			DisableControlAction(1, 63, true)
			DisableControlAction(1, 64, true)
			DisableControlAction(1, 123, true)
			DisableControlAction(1, 124, true)
			DisableControlAction(1, 125, true)
			DisableControlAction(1, 133, true)
			DisableControlAction(1, 134, true)
			SetPedCurrentWeaponVisible(GetPlayerPed(-1), false, true, false, false)
			
		end
	end
end)

Citizen.CreateThread(function()
    local windows = { "Front Right Window","Front Left Window", "Back Right Window", "Back Left Window" }
    local doors = {"Front Left", "Front Right", "Back Left", "Back Right", "Hood", "Trunk", "Back", "Back2"}
    local currentDoorIndex = 1
    local selectedDoorIndex = 1
    local currentWindowIndex = 1
    local selectedWindowIndex = 1
    local Engine = true
    local DoorsLocked = false
	local KeepClean = false

	--Main
    WarMenu.CreateMenu('csrMenu', 'Roleplay Menu')
    WarMenu.CreateSubMenu('emoteMenu', 'csrMenu', 'Emotes')
    WarMenu.CreateSubMenu('vehMenu', 'csrMenu', 'Vehicle Options')
	--CIV
    WarMenu.CreateSubMenu('civMenu', 'csrMenu', 'Civilian Toolbox')
    WarMenu.CreateSubMenu('civActions', 'civMenu', 'Civilian Actions')
    WarMenu.CreateSubMenu('advertMenu', 'civMenu', 'Adverts')
	--LE
    WarMenu.CreateSubMenu('leMenu', 'csrMenu', 'Police Toolbox')
    WarMenu.CreateSubMenu('leActions', 'leMenu', 'Police Actions')
    WarMenu.CreateSubMenu('Objectspawner', 'leMenu', 'Object Spawner')
	WarMenu.CreateSubMenu('barrierMenu', 'Objectspawner', 'Barriers')
	WarMenu.CreateSubMenu('coneMenu', 'Objectspawner', 'Cones')
	WarMenu.CreateSubMenu('leEmoteMenu', 'leMenu', 'Police Emotes')
	WarMenu.CreateSubMenu('leOutfits', 'leMenu', 'Police Outfits')
	WarMenu.CreateSubMenu('leLoadouts', 'leMenu', 'Police Loadouts')
	--FD
    WarMenu.CreateSubMenu('fdMenu', 'csrMenu', 'FD Toolbox')
	WarMenu.CreateSubMenu('fdLoadouts', 'fdMenu', 'FD Loadouts')
	WarMenu.CreateSubMenu('fdActions', 'fdMenu', 'FD Actions')
	WarMenu.CreateSubMenu('fdEmoteMenu', 'fdMenu', 'FD Emotes')
	WarMenu.CreateSubMenu('fdOutfits', 'fdMenu', 'FD Outfits')

    while true do
        if WarMenu.IsMenuOpened('csrMenu') then
			if WarMenu.MenuButton('Police Toolbox', 'leMenu') then
			elseif WarMenu.MenuButton('Fire/Medical Toolbox', 'fdMenu') then
            elseif WarMenu.MenuButton('Civilian Toolbox', 'civMenu') then
			elseif WarMenu.MenuButton('Vehicle Toolbox', 'vehMenu') then
			elseif WarMenu.MenuButton('Emotes', 'emoteMenu') then
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('emoteMenu') then
			if WarMenu.Button('List of Emotes') then
				displayEmotes()
			elseif WarMenu.Button('Cancel Emote') then
				ClearPedTasksImmediately(PlayerPedId())
			elseif WarMenu.MenuButton('←←← Back','csrMenu') then
			end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('vehMenu') then
            if WarMenu.ComboBox('Door', doors, currentDoorIndex, selectedDoorIndex, function(currentIndex, selectedIndex)
                currentDoorIndex = currentIndex
                selectedDoorIndex = selectedIndex
            end) then
            elseif WarMenu.ComboBox('Window', windows, currentWindowIndex, selectedWindowIndex, function(currentIndex, selectedIndex)
                currentWindowIndex = currentIndex
                selectedWindowIndex = selectedIndex
            end) then
            elseif WarMenu.Button('Open/Close selected door') then
                OpenDoor(selectedDoorIndex - 1)
				drawNotification("You have Open/Closed the selected door.")
			elseif WarMenu.Button("Open/Close all doors") then
				for i=0,6 do
					OpenDoor(i)
					drawNotification("You have Open/Closed all doors.")
				end
            elseif WarMenu.Button('Open/Close selected window') then
                OpenWindow(selectedWindowIndex - 1)
			elseif WarMenu.Button("Open/Close all windows") then
				for i=0,6 do
					OpenWindow(i)
					drawNotification("You have Open/Closed all windows.")
				end
            elseif WarMenu.CheckBox('Engine', Engine, function(checked)
                Engine = checked
            end) then
            elseif WarMenu.CheckBox('Lock Doors', DoorsLocked, function(checked)
                DoorsLocked = checked

                local LastVeh = GetPlayersLastVehicle()
                if DoorsLocked then
                    SetVehicleDoorsLockedForAllPlayers(LastVeh, true)
                else
                    SetVehicleDoorsLockedForAllPlayers(LastVeh, false)
                end
            end) then
			elseif WarMenu.Button("~r~Delete Vehicle") then
				local vehicle = GetVehiclePedIsUsing(PlayerPedId())
				SetEntityAsMissionEntity(vehicle, 1, 1)
				SetEntityAsNoLongerNeeded(vehicle)
				DeleteEntity(vehicle)
				if not DoesEntityExist(vehicle) then
					drawNotification("~g~You have successfully deleted your vehicle.")
				else
					drawNotification("~r~Your vehicle could not be deleted.")
				end
            elseif WarMenu.MenuButton('←←← Back','csrMenu') then
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('civMenu') then
            if WarMenu.MenuButton('Actions', "civActions") then
            elseif WarMenu.MenuButton('Adverts', 'advertMenu') then
			elseif WarMenu.Button('Show ID') then
				TriggerServerEvent("showideee", KeyboardInput("Enter your Character's FIRST Name", "", 25), KeyboardInput("Enter your Character's LAST Name", "", 25), KeyboardInput("Enter your Character's Age", "", 2))
            elseif WarMenu.MenuButton('←←← Back','csrMenu') then
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('civActions') then
            if WarMenu.Button('Drop current weapon') then
                DropWeapon()
            elseif WarMenu.Button('Place your Hands up') then
                HandsyUpsy()
            elseif WarMenu.Button('Kneel with hands up') then
				drawNotification("You are kneeling with your hands up.")
                KneelHU()
			elseif WarMenu.Button('Crouch') then
				crouch()
            elseif WarMenu.Button('Set Blood Alcohol Level (0.08%+ = Illegal)') then
                TriggerServerEvent("setBac", KeyboardInput("Enter BAC", "", 100))
            elseif WarMenu.MenuButton('←←← Back','civMenu') then
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('advertMenu') then
            if WarMenu.Button('24/7') then
                TriggerEvent( 'ad1' )
            elseif WarMenu.Button('Ammunation') then
                TriggerEvent( 'ad2' )
            elseif WarMenu.Button('Weazel News') then
                TriggerEvent( 'ad3' )
            elseif WarMenu.Button('Vanilla Unicorn') then
                TriggerEvent( 'ad4' )
            elseif WarMenu.Button('Downtown Cab Co') then
                TriggerEvent( 'ad5' )
            elseif WarMenu.Button('Los Santos Traffic Info') then
                TriggerEvent( 'ad6' )
            elseif WarMenu.Button('Los Santos Customs') then
                TriggerEvent( 'ad7' )
            elseif WarMenu.Button('Liquor Ace') then
                TriggerEvent( 'ad8' )
            elseif WarMenu.Button('Limited Gasoline') then
                TriggerEvent( 'ad9' )
            elseif WarMenu.Button('GoPostal') then
                TriggerEvent( 'ad10' )
            elseif WarMenu.Button('Hayes Auto') then
                TriggerEvent( 'ad11' )
            elseif WarMenu.Button('Vangelico') then
                TriggerEvent( 'ad12' )
            elseif WarMenu.Button('Cluckin\' Bell') then
                TriggerEvent( 'ad13' )
            elseif WarMenu.Button('Bugstars') then
                TriggerEvent( 'ad14' )
            elseif WarMenu.Button('Fleeca Bank') then
                TriggerEvent( 'ad15' )
            elseif WarMenu.Button('Echo Sechs') then
                TriggerEvent( 'ad16' )
            elseif WarMenu.Button('Mors Mutual Insurance') then
                TriggerEvent( 'ad17' )
            elseif WarMenu.Button('PostOP') then
                TriggerEvent( 'ad18' )
            elseif WarMenu.Button('Auto Exotic') then
                TriggerEvent( 'ad19' )
            elseif WarMenu.Button('Los Santos Water and Power') then
                TriggerEvent( 'ad20' )
            elseif WarMenu.Button('Dynasty 8') then
                TriggerEvent( 'ad21' )
            elseif WarMenu.MenuButton('←←← Back','csrMenu') then
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('leMenu') then
			if WarMenu.MenuButton('Emotes', 'leEmoteMenu') then
			elseif WarMenu.MenuButton('Actions', "leActions") then
			elseif WarMenu.MenuButton('Object Spawner', "Objectspawner") then
            elseif WarMenu.MenuButton('Outfits', 'leOutfits') then
			elseif WarMenu.MenuButton('Loadouts', 'leLoadouts') then
            elseif WarMenu.Button('Radar') then
                drawNotification("~y~Press 'Delete' when in a emergency vehicle!")
            elseif WarMenu.MenuButton('←←← Back','csrMenu') then
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('Objectspawner') then
			if WarMenu.Button('Spikes') then
				drawNotification("~y~Coming Soon.")
			elseif WarMenu.MenuButton('Barriers', "barrierMenu") then
			elseif WarMenu.MenuButton('Cones', "coneMenu") then
            elseif WarMenu.MenuButton('←←← Back','leMenu') then
            end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('barrierMenu') then
            if WarMenu.Button("Red Barrier") then
                SBarrier("spawn")
            elseif WarMenu.Button("Delete Previous") then
                SBarrier("delete")
            elseif WarMenu.Button("Do Not Cross") then
                Barrier("spawn")
            elseif WarMenu.Button("Delete Previous") then
                Barrier("delete")
            elseif WarMenu.Button("Traffic Barracde") then
                Barrier3("spawn")
            elseif WarMenu.Button("Delete Previous") then
                Barrier3("delete")
            elseif WarMenu.Button("Road works ahead") then
                consign1("spawn")
            elseif WarMenu.Button("Delete Previous") then
                consign1("delete")
			elseif WarMenu.MenuButton('←←← Back','Objectspawner') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('coneMenu') then
            if WarMenu.Button("Spawn Cone") then
                Cone("spawn")
            elseif WarMenu.Button("Delete previous cone") then
                Cone("delete")
            elseif WarMenu.Button("Delete all cones") then
                Cone("deleteall")
			elseif WarMenu.MenuButton('←←← Back','Objectspawner') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('leLoadouts') then
			if WarMenu.Button('Equip Loadout') then
				TriggerEvent("CIVLoadout")
			elseif WarMenu.Button('Toggle Carbine') then
				TriggerEvent("togglecarbine")
			elseif WarMenu.Button('Toggle Shotgun') then
				TriggerEvent("toggleshotgun")
			elseif WarMenu.MenuButton('←←← Back','leMenu') then
			end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('leActions') then
            if WarMenu.Button('Cuff') then
                TriggerEvent('cuff')
            elseif WarMenu.Button("Grab") then
                DragPlayer()
			elseif WarMenu.Button("Beathalyze") then
                TriggerEvent('breathNearby')
            elseif WarMenu.Button("Place in vehicle") then
                TriggerEvent('Cuff_close:getSeatedVehicle')
            elseif WarMenu.Button("Remove from vehicle") then
                TriggerEvent('Cuff_close:getUnseatVehicle')
				Citizen.Wait(500)
		        DragPlayer()
			elseif WarMenu.Button('Crouch') then
				crouch()
            elseif WarMenu.MenuButton('←←← Back','leMenu') then
            end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('leEmoteMenu') then
			if WarMenu.Button('Traffic Control') then
				drawNotification("You are playing Emote: Traffic Control")
				DoTraffic()
			elseif WarMenu.Button('Clipboard') then
				Note()
				drawNotification("You are playing Emote: Clipboard")
			elseif WarMenu.Button('Notepad') then
				Note2()
				drawNotification("You are playing Emote: Notepad")
			elseif WarMenu.Button('Stance/idol') then
				StandBy()
				drawNotification("You are playing Emote: Stance/idol")
			elseif WarMenu.Button('Crowd Control') then
				Crowd()
				drawNotification("You are playing Emote: Crowd Control")
			elseif WarMenu.Button('Investigate') then
				Investigate()
				drawNotification("You are playing Emote: Investigate")
			elseif WarMenu.Button('Cancel Emote') then
				ClearPedTasksImmediately(PlayerPedId())
			elseif WarMenu.MenuButton('←←← Back','leMenu') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('leOutfits') then
			if WarMenu.Button('DPD Uniform') then
				lspdskin()
				drawNotification("You have changed your clothing to: PD")
			elseif WarMenu.Button('WCSO Uniform') then
				bcsoskin()
				drawNotification("You have changed your clothing to: WCSO")
			elseif WarMenu.Button('CSP Uniform') then
				sahpskin()
				drawNotification("You have changed your clothing to: CSP")
			elseif WarMenu.MenuButton('←←← Back','leMenu') then
			end


			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('fdMenu') then
			if WarMenu.MenuButton('Actions', "fdActions") then
			elseif WarMenu.MenuButton('Emotes', 'fdEmoteMenu') then
			elseif WarMenu.MenuButton('Outfits', 'fdOutfits') then
			elseif WarMenu.MenuButton('Loadouts', 'fdLoadouts') then
			elseif WarMenu.MenuButton('←←← Back','csrMenu') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('fdActions') then
			if WarMenu.Button("Carry on stretcher") then
				DragPlayer()
			elseif WarMenu.Button("Seat player in ambulance") then
				TriggerEvent('Cuff_close:getSeatedVehicle')
			elseif WarMenu.Button("Take out of vehicle") then
				TriggerEvent('savefromcar')
			elseif WarMenu.Button('Crouch') then
				crouch()
			elseif WarMenu.MenuButton('←←← Back','fdMenu') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('fdLoadouts') then
			if WarMenu.Button("Equip Loadout (Denver Fire)") then
				drawNotification("You have equiped your DFD loadout.")
				TriggerEvent("FDLoadout")
			elseif WarMenu.Button("Equip Loadout (Denver EMS)") then
				TriggerEvent("EMSLoadout")
				drawNotification("You have equiped your EMT loadout.")
			elseif WarMenu.MenuButton('←←← Back','fdMenu') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('fdOutfits') then
			if WarMenu.Button('Firefighter Uniform') then
				lafdskin()
			elseif WarMenu.Button('Firemedic Uniform') then
				lafdskin2()
			elseif WarMenu.Button('Medic gloves') then
				TriggerEvent( 'gloveson' )
			elseif WarMenu.Button('Headwear') then
				TriggerEvent( 'haton' )
			elseif WarMenu.Button('Glasses') then
				TriggerEvent( 'sgon' )
			elseif WarMenu.MenuButton('←←← Back','leMenu') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('fdEmoteMenu') then
			if WarMenu.Button("Tend to Patient") then
				Tendto()
				drawNotification("You are playing Emote: Tend to Patient")
			elseif WarMenu.Button("Clipboard") then
				Note()
				drawNotification("You are playing Emote: Clipboard")
			elseif WarMenu.Button("Weld") then
				Weld()
				drawNotification("You are playing Emote: Weld")
			elseif WarMenu.Button("Cancel Emote") then
				ClearPedTasksImmediately(PlayerPedId())
			elseif WarMenu.MenuButton('←←← Back','fdMenu') then
			end



            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'csrMenu') then
            end

            WarMenu.Display()
        elseif IsControlJustReleased(0, 244) and GetLastInputMethod( 0 ) then  --M by default
            WarMenu.OpenMenu('csrMenu')
        end

        if not Engine then
            SetVehicleEngineOn(GetVehiclePedIsUsing(PlayerPedId()), false, false, 0)
        end

		if WarMenu.IsMenuOpened('leMenu') and not IsAllowedPed("leo") then
			WarMenu.OpenMenu("csrMenu")
			drawNotification("~r~You are not authorised to access the LE menu.")
		elseif WarMenu.IsMenuOpened('fdMenu') and not IsAllowedPed("fd") then
			WarMenu.OpenMenu("csrMenu")
			drawNotification("~r~You are not authorised to access the DFD menu.")
		end

        Citizen.Wait(0)
    end
end)

function GetVehicleInfrontOfEntity(entity)
	local coords = GetOffsetFromEntityInWorldCoords(entity,0.0,1.0,0.3)
	local coords2 = GetOffsetFromEntityInWorldCoords(entity, 0.0, 8.0,0.0)
	local rayhandle = CastRayPointToPoint(coords, coords2, 10, entity, 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit > 0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

local blip = nil

RegisterNetEvent("SetTrackerPos")
AddEventHandler("SetTrackerPos", function(serverId, x, y, z)
	if blip ~= nil then
		RemoveBlip(blip)
	end
	blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, 432)
	SetBlipColour(blip, 59)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Tracker")
    EndTextCommandSetBlipName(blip)
end)

function BeginTrackerUpdates(vehicle, playerId)
	while true do
		Citizen.Wait(5000)
		local x,y,z = table.unpack(GetEntityCoords(vehicle))
		TriggerServerEvent("UpdateTracker", PlayerId, x, y, z)
	end
end

local drag = false
local officerDrag = -1

function DragPlayer()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:dragRequest", GetPlayerServerId(t))
	else
		drawNotification("There is no player nearby to drag!")
	end
end

RegisterNetEvent('police:toggleDrag')
AddEventHandler('police:toggleDrag', function(t)
	drag = not drag
	officerDrag = t
end)

Citizen.CreateThread(function()
  while true do  
	Wait(0)
		if drag then
			local ped = GetPlayerPed(GetPlayerFromServerId(officerDrag))
			local myped = PlayerPedId()
			AttachEntityToEntity(myped, ped, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			playerStillDragged = true
		else
			if(playerStillDragged) then
				DetachEntity(PlayerPedId(), true, false)
				playerStillDragged = false
			end
		end	
  end
end)

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end


local crouched = false

function crouch()
	local ped = GetPlayerPed( -1 )
	RequestAnimSet( "move_ped_crouched" )
	    if ( crouched == true ) then 
            ResetPedMovementClipset( ped, 0 )
            crouched = false 
        elseif ( crouched == false ) then
            SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
            crouched = true 
        end 
end

RegisterNetEvent('ShootTracker')
AddEventHandler('ShootTracker', function()
	local PoliceVehicle = GetVehiclePedIsUsing(PlayerPedId())
	local ShotVehicle = GetVehicleInfrontOfEntity(PoliceVehicle)
	local PoliceOffset = GetOffsetFromEntityInWorldCoords(PoliceVehicle, 0.0, 8.0, 0.0)
	ShootSingleBulletBetweenCoords(GetEntityCoords(PoliceVehicle), PoliceOffset, 0.0, 0, GetHashKey("WEAPON_STUNGUN"), PlayerPedId(), true, false, 1.0)
	if ShotVehicle ~= nil and IsPedAPlayer(GetPedInVehicleSeat(ShotVehicle, -1)) then
		local PlayerPed = GetPedInVehicleSeat(ShotVehicle, -1)
		local PlayerId = NetworkGetPlayerIndexFromPed(PlayerPed)
		print("Gotcha bitch!")
		local x,y,z = table.unpack(GetEntityCoords(ShotVehicle))
		TriggerServerEvent("AddTracker", PlayerId, x, y, z)
		BeginTrackerUpdates(ShotVehicle, playerId)
	end
end)

function IsAllowedPed(class)
	success = false
	if class == "leo" then
		for i=1,#leoSkins do
			if GetEntityModel(PlayerPedId()) == GetHashKey(leoSkins[i]) then
				success = true
			end
		end
	elseif class == "fd" then
		for i=1,#fdSkins do
			if GetEntityModel(PlayerPedId()) == GetHashKey(fdSkins[i]) then
				success = true
			end
		end
	end

	return success
end

function DoTraffic()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false)
    end)
end

function VehMechanic()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_VEHICLE_MECHANIC", 0, false)
    end)
end

function Note()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, false)
    end)
end

function Note2()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, 1)
    end)
end

function StandBy()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_COP_IDLES", 0, true)
    end)
end

function Crowd()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_POLICE_CROWD_CONTROL", 0, 1)
    end)
end

function Investigate()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_POLICE_INVESTIGATE", 0, 1)
    end)
end

function Kneel()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_KNEEL", 0, 1)
    end)
end

function Tendto()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, 1)
    end)
end

function Weld()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, 1)
    end)
end

function DropWeapon()
    currentWeapon = GetSelectedPedWeapon(PlayerPedId())
    SetPedDropsInventoryWeapon(PlayerPedId(), currentWeapon, -2.0, 0.0, 0.5, 30)
    drawNotification("Dropped weapon")
end

--[[ Cuff Player ]]--
RegisterNetEvent("cuff1")
AddEventHandler("cuff1", function()
	ped = GetPlayerPed(-1)
	if (DoesEntityExist(ped)) then
		Citizen.CreateThread(function()
		RequestAnimDict("mp_arresting")
			while not HasAnimDictLoaded("mp_arresting") do
				Citizen.Wait(0)
			end
			if isCuffed then
				ClearPedSecondaryTask(ped)
				StopAnimTask(ped, "mp_arresting", "idle", 3)
				SetEnableHandcuffs(ped, false)
				isCuffed = false
			else
				TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
				SetEnableHandcuffs(ped, true)
				Citizen.Trace("cuffed")
				isCuffed = true
			end
			
			
		end)
	end
end)


AddEventHandler("core:ShowNotification", function(text)
	SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true)
end)

RegisterNetEvent("cuff")
AddEventHandler("cuff", function()
	local ped = GetPlayerPed(-1)
	local nearestPlayer = GetNearestPlayerToEntity(ped)
	local entityType = GetEntityType(ped)
	
	shortestDistance = 2
	closestId = 0
	
	for id = 0, 32 do
        if NetworkIsPlayerActive( id ) and GetPlayerPed(id) ~= GetPlayerPed(-1) then
			ped1 = GetPlayerPed( id )
			local x,y,z = table.unpack(GetEntityCoords(ped))
                if (GetDistanceBetweenCoords(GetEntityCoords(ped1), x,y,z) <  shortestDistance) then
					
					shortestDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), x,y,z)
					closestId = GetPlayerServerId(id)		
					
				end
				
        end		
	end
		
		TriggerServerEvent("cuffNear", closestId)
	
end)

RegisterNetEvent('Cuff_close:getUnseatVehicle')
AddEventHandler('Cuff_close:getUnseatVehicle', function()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("Cuff_close:getUnseatServer", GetPlayerServerId(t))
	else
	drawNotification("There is no player nearby to unseat from your car.")
	end
end)

RegisterNetEvent('savefromcar')
AddEventHandler('savefromcar', function()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("Cuff_close:getUnseatServer", GetPlayerServerId(t))
	else
	drawNotification("There is no player nearby to save from a car.")
	end
end)

RegisterNetEvent('Cuff_close:getSeatedVehicle')
AddEventHandler('Cuff_close:getSeatedVehicle', function()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		local v = GetVehiclePedIsIn(PlayerPedId(), true)
		TriggerServerEvent("Cuff_close:getSeatedServer", GetPlayerServerId(t), v)
	else
	drawNotification("There is no player nearby to seat into your car.")
	end
end)

function lspdskin()
    Citizen.CreateThread(function()
        local copModel = GetHashKey("s_m_y_cop_01")
        RequestModel(copModel)
        while not HasModelLoaded(copModel) do
            Wait(0)
        end
        if HasModelLoaded(copModel) then
	   drawNotification("You have put on you LSPD uniform.")
            SetPlayerModel(PlayerId(), copModel)
        else
	   drawNotification("The model could not load - if you see this contact development.")
        end
    end)
end

function bcsoskin()
    Citizen.CreateThread(function()
        local copModel = GetHashKey("s_m_y_sheriff_01")
        RequestModel(copModel)
        while not HasModelLoaded(copModel) do
            Wait(0)
        end
        if HasModelLoaded(copModel) then
	   drawNotification("You have put on you BCSO uniform.")
            SetPlayerModel(PlayerId(), copModel)
        else
	   drawNotification("The model could not load - if you see this contact development.")
        end
    end)
end

function sahpskin()
    Citizen.CreateThread(function()
        local copModel = GetHashKey("s_m_y_hwaycop_01")
        RequestModel(copModel)
        while not HasModelLoaded(copModel) do
            Wait(0)
        end
        if HasModelLoaded(copModel) then
	   drawNotification("You have put on you SAHP uniform.")
            SetPlayerModel(PlayerId(), copModel)
        else
	   drawNotification("The model could not load - if you see this contact development.")
        end
    end)
end

function lafdskin()
    Citizen.CreateThread(function()
        local copModel = GetHashKey("s_m_y_fireman_01")
        RequestModel(copModel)
        while not HasModelLoaded(copModel) do
            Wait(0)
        end
        if HasModelLoaded(copModel) then
	   drawNotification("You have put on your Fire Department FireFighter uniform.")
            SetPlayerModel(PlayerId(), copModel)
        else
	   drawNotification("The model could not load - if you see this contact development.")
        end
    end)
end

function lafdskin2()
    Citizen.CreateThread(function()
        local copModel = GetHashKey("s_m_m_paramedic_01")
        RequestModel(copModel)
        while not HasModelLoaded(copModel) do
            Wait(0)
        end
        if HasModelLoaded(copModel) then
	   drawNotification("You have put on your Fire Department Medic unifor.")
            SetPlayerModel(PlayerId(), copModel)
        else
	   drawNotification("The model could not load - if you see this contact development.")
        end
    end)
end

local hwaycop = GetHashKey("s_m_y_hwaycop_01")
local cop = GetHashKey("s_m_y_cop_01")
local sheriff = GetHashKey("s_m_y_sheriff_01")
local fireman = GetHashKey("s_m_y_fireman_01")
local medic = GetHashKey("s_m_m_paramedic_01")


hat = false

  RegisterNetEvent( 'haton' )
AddEventHandler( 'haton', function()
	hat = not hat
	if(GetEntityModel(PlayerPedId()) == hwaycop) then
		if hat then
			SetPedPropIndex(PlayerPedId(), 0, 01, 0, 2)
			drawNotification("Your headwear has been equipped.")
		else
			ClearPedProp(PlayerPedId(), 0)
			drawNotification("Your headwear has been unequipped.")
		end
	elseif(GetEntityModel(PlayerPedId()) == cop) then
		if hat then
			SetPedPropIndex(PlayerPedId(), 0, 0, 0, 2)
			drawNotification("Your headwear has been equipped.")
		else
			ClearPedProp(PlayerPedId(), 0)
			drawNotification("Your headwear has been unequipped.")
		end
	elseif(GetEntityModel(PlayerPedId()) == sheriff) then
		if hat then
			SetPedPropIndex(PlayerPedId(), 0, 0, 0, 2)
			drawNotification("Your headwear has been equipped.")
		else
			ClearPedProp(PlayerPedId(), 0)
			drawNotification("Your headwear has been unequipped.")
		end
	elseif (GetEntityModel(PlayerPedId()) == fireman) then
		if hat then
			SetPedPropIndex(PlayerPedId(), 0, 0, 0, 2)
			drawNotification("Your headwear has been equipped.")
		else
			ClearPedProp(PlayerPedId(), 0)
			drawNotification("Your headwear has been unequipped.")
		end
	elseif (GetEntityModel(PlayerPedId()) == medic) then
		if hat then
			SetPedPropIndex(PlayerPedId(), 0, 0, 0, 2)
			drawNotification("Your headwear has been equipped.")
		else
			ClearPedProp(PlayerPedId(), 0)
			drawNotification("Your headwear has been unequipped.")
		end
	end
end)

vest = false
	RegisterNetEvent('veston')
AddEventHandler('veston', function()
	vest = not vest
	if (GetEntityModel(PlayerPedId()) == hwaycop) then
		if vest then
			SetPedComponentVariation(PlayerPedId(), 8, 1, 1, 1)
			drawNotification("Your vest has been equipped.")
		else
			SetPedDefaultComponentVariation(PlayerPedId())
			drawNotification("Your vest has been unequipped.")
		end
	elseif (GetEntityModel(PlayerPedId()) == cop) then
		if vest then
			SetPedComponentVariation(PlayerPedId(), 9, 2, 0, 1)
			drawNotification("Your vest has been equipped.")
		else
			SetPedDefaultComponentVariation(PlayerPedId())
			drawNotification("Your vest has been unequipped.")
		end
	elseif (GetEntityModel(PlayerPedId()) == sheriff) then
		if vest then
			SetPedComponentVariation(PlayerPedId(), 9, 2, 0, 1)
			drawNotification("Your vest has been equipped.")
		else
			SetPedDefaultComponentVariation(PlayerPedId())
			drawNotification("Your vest has been unequipped.")
		end
	end
end)

mask = false

  RegisterNetEvent( 'maskon' )
AddEventHandler( 'maskon', function()
	    if (GetEntityModel(PlayerPedId()) == fireman) then
		mask = not mask
		if mask then
			SetPedComponentVariation(PlayerPedId(), 8, 1, 1, 1)
			SetPlayerInvincible(PlayerPedId(), true)
			drawNotification("Your oxygen supply has been activated.")
		else
			SetPedDefaultComponentVariation(PlayerPedId())
			SetPlayerInvincible(PlayerPedId(), false)
			drawNotification("Your oxygen supply has been deactivated.")
		end
	end
end)

gloves = false

  RegisterNetEvent( 'gloveson')
AddEventHandler( 'gloveson', function()
	if (GetEntityModel(PlayerPedId()) == medic) then
		gloves = not gloves
		if gloves then
			SetPedComponentVariation(PlayerPedId(), 5, 1, 0, 1)
			drawNotification("Your medical latex gloves have been equipped.")
		else
			SetPedDefaultComponentVariation(PlayerPedId())
			drawNotification("Your medical latex gloves have been unequipped.")
		end
	end
end)

sg = false

  RegisterNetEvent( 'sgon' )
AddEventHandler( 'sgon', function()
	sg = not sg
	if(GetEntityModel(PlayerPedId()) == hwaycop) then
		if sg then
			SetPedPropIndex(PlayerPedId(), 1, 0, 1, 2)
			drawNotification("Your glasses have been equipped.")
		else
			ClearPedProp(PlayerPedId(), 1)
			drawNotification("Your glasses have been unequipped.")
		end
	elseif(GetEntityModel(PlayerPedId()) == cop) then
		if sg then
			SetPedPropIndex(PlayerPedId(), 1, 0, 0, 2)
			drawNotification("Your glasses have been equipped.")
		else
			ClearPedProp(PlayerPedId(), 1)
			drawNotification("Your glasses have been unquipped.")
		end
	elseif(GetEntityModel(PlayerPedId()) == sheriff) then
		if sg then
			SetPedPropIndex(PlayerPedId(), 1, 1, 0, 2)
			drawNotification("Your glasses have been equipped.")
		else
			ClearPedProp(PlayerPedId(), 1)
			drawNotification("Your glasses have been unequipped.")
		end
	elseif(GetEntityModel(PlayerPedId()) == medic) then
		if sg then
			SetPedPropIndex(PlayerPedId(), 1, 0, 0, 2)
			drawNotification("Your glasses have been equipped.")
		else
			ClearPedProp(PlayerPedId(), 1)
			drawNotification("Your glasses have been unequipped.")
		end
	end
end)

-- Idfk prolly civ
RegisterNetEvent("CIVLoadout")
AddEventHandler("CIVLoadout", function()
    local ped = PlayerPedId()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_COMBATPISTOL"), 1000, false)
	GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), 1000, false)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 1000, false)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), 1000, false)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FIREEXTINGUISHER"), 1000, false)
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'gun_reload', 0.1)
end)
-- end

-- loadout fd
RegisterNetEvent("FDLoadout")
AddEventHandler("FDLoadout", function()
    local ped = PlayerPedId()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 1000, false)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), 1000, false)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FIREEXTINGUISHER"), 1000, false)
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'gun_reload', 0.1)
end)
-- end

-- loadout ems
RegisterNetEvent("EMSLoadout")
AddEventHandler("EMSLoadout", function()
    local ped = PlayerPedId()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 1000, false)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), 1000, false)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FIREEXTINGUISHER"), 1000, false)
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'gun_reload', 0.1)
end)



carbineEquipped = false
shotgunEquipped = false

Citizen.CreateThread(function()

		ped = PlayerPedId()

	while true do
		Wait(0)

		ped = PlayerPedId()
		veh = GetVehiclePedIsIn(ped)
		currentWeapon = GetSelectedPedWeapon(ped)


		if nearPickup then
			drawNotification("Near pickup.")
		end

		if carbineEquipped == false then
			RemoveWeaponFromPed(ped, "WEAPON_CARBINERIFLE")

		end

		if shotgunEquipped == false then
			RemoveWeaponFromPed(ped, "WEAPON_PUMPSHOTGUN")

		end

		if carbineEquipped then
			if (tostring(currentWeapon) ~= "-2084633992") and veh == nil then
				drawNotification("Must put away your carbine.")
			end
			SetCurrentPedWeapon(ped, "WEAPON_CARBINERIFLE", true)
		end

		if shotgunEquipped then
			if tostring(currentWeapon) ~= "487013001" and veh == ni then
				drawNotification("Must put away your shotgun.")
			end
			SetCurrentPedWeapon(ped, "WEAPON_PUMPSHOTGUN", true)
		end
	end

end)

RegisterNetEvent("togglecarbine")
AddEventHandler("togglecarbine", function()

	print((GetVehicleClass(veh) == 18))

	if (GetVehicleClass(veh) == 18) then
		carbineEquipped = not carbineEquipped
		shotgunEquipped = false
		if carbineEquipped then
			drawNotification("Carbine equipped.")
			GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_CARBINERIFLE"), 1000, false, false)
			GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_SPECIALCARBINE_CLIP_02"))
			GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH"))
			GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))
			GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"))
			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'gun_reload', 0.1)
		else
			drawNotification("Carbine unequipped.")
		end
	elseif (GetVehicleClass(veh) ~= 18) then
		drawNotification("Must be in a police car to grab your carbine.")
	end


end)

RegisterNetEvent("toggleshotgun")
AddEventHandler("toggleshotgun", function()

	if (GetVehicleClass(veh) == 18) then
		shotgunEquipped = not shotgunEquipped
		carbineEquipped = false
		if shotgunEquipped then
			drawNotification("Shotgun equipped.")
			GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), 1000, false, false)
			GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), GetHashKey("COMPONENT_AT_AR_FLSH"))
			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'gun_reload', 0.1)
		else
			drawNotification("Shotgun unequipped.")
		end
	elseif (GetVehicleClass(veh) ~= 18) then
		drawNotification("Must be in a police car to grab your shotgun.")
	end
end)

RegisterNetEvent('Cuff_close:forcedEnteringVeh')
AddEventHandler('Cuff_close:forcedEnteringVeh', function(veh)
		local pos = GetEntityCoords(PlayerPedId())
		local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)

		if vehicleHandle ~= nil then
			SetPedIntoVehicle(PlayerPedId(), vehicleHandle, 1)
		end
end)


RegisterNetEvent('Cuff_close:unseatme')
AddEventHandler('Cuff_close:unseatme', function(t)
	local ped = GetPlayerPed(t)
	ClearPedTasksImmediately(ped)
	plyPos = GetEntityCoords(PlayerPedId(),  true)
	local xnew = plyPos.x-0
	local ynew = plyPos.y-0

	SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z)
end)



function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)

	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function drawNotification(text)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, true)
end

RegisterNetEvent("showNotification")
Citizen.CreateThread(function()
	AddEventHandler("showNotification", function(text)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(text)
		DrawNotification(0,1)
	end)
end)


RegisterNetEvent("DrawAdvert")
AddEventHandler("DrawAdvert",function(text, notifParams)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
    SetNotificationMessage(notifParams.picName1, notifParams.picName2, true, notifParams.iconType, notifParams.sender, "")
	DrawNotification(false, true)
end)

RegisterCommand("hu", function(source,args,rawCommand)
    HandsyUpsy()
end, false)

RegisterCommand("huk", function(source,args,rawCommand)
    KneelHU()
end, false)

function KneelHU()
    local ped = PlayerPedId()
    if (DoesEntityExist(ped) and not IsEntityDead(ped)) and not handCuffed then
        loadAnimDict("random@arrests")
        loadAnimDict("random@arrests@busted")
        if (IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3)) then
            TaskPlayAnim(ped, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait (3000)
            TaskPlayAnim(ped, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0)
			drawNotification("You have gotten back on your feet.")
        else
            TaskPlayAnim(ped, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait (4000)
            TaskPlayAnim(ped, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait (500)
            TaskPlayAnim(ped, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait (1000)
            TaskPlayAnim(ped, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)
			drawNotification("You have gotten on your knees with your hands up!")
        end
    end
end

function HandsyUpsy()
    ped = PlayerPedId()
    if DoesEntityExist(ped) and not handCuffed then
		Citizen.CreateThread(function()
			loadAnimDict("random@mugging3")

			if IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3) or handCuffed then
				ClearPedSecondaryTask(ped)
				SetEnableHandcuffs(ped, false)
				drawNotification("Your hands are down.")
			elseif not IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3) or not handCuffed then
				TaskPlayAnim(ped, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
				SetEnableHandcuffs(ped, true)
				drawNotification("Your hands are up.")
			end
		end)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests@busted", "idle_a", 3) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(0,21,true)
        end
    end
end)

function OpenDoor(door)
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if GetVehicleDoorAngleRatio(veh, door) > 0 then
        SetVehicleDoorShut(veh, door, false)
    else
        SetVehicleDoorOpen(veh, door, false, false)
    end
end

local OpenedWindows = {}

function OpenWindow(window)
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    local WindowFound = false
    for i=1,#OpenedWindows do
        if OpenedWindows[i] == window and not WindowFound then
            RollUpWindow(veh, window)
            table.remove(OpenedWindows, i)
            WindowFound = true
        end
    end
    if not WindowFound then
        RollDownWindow(veh, window)
        table.insert(OpenedWindows, window)
    end
end

--breath
AddEventHandler("Breath", function(results)

	local dots = ". . . ."
	local timer = 0

	for timer=0,5,1 do
		SetNotificationTextEntry("STRING")
		AddTextComponentString("~b~~h~Breathalyzing~h~~n~~c~"..dots)
		local notify = DrawNotification(false, false)
		Citizen.Wait(1000)
		RemoveNotification(notify)
		dots = dots.." . . . ."
	end

	if (results < "0.08") then
		SetNotificationTextEntry("STRING")
		AddTextComponentString("~b~~h~BAC Results:~h~~n~~g~ "..results.."%")
		local notify = DrawNotification(false, false)
	elseif (results >= "0.08") then
		SetNotificationTextEntry("STRING")
		AddTextComponentString("~b~~h~BAC Results:~h~~n~~r~"..results.."%")
		local notify = DrawNotification(false, false)
	elseif (results == nil) then
		SetNotificationTextEntry("STRING")
		AddTextComponentString("~b~~h~BAC Results:~h~~n~~g~ 0.000%")
		local notify = DrawNotification(false, false)
	end


end)

	-- Allows for server to client calls --

RegisterNetEvent("Breath")
RegisterNetEvent("NoResults")
RegisterNetEvent("Bac")
RegisterNetEvent("breathNearby")

	-- Chat Message for setting BAC --


AddEventHandler("Bac", function()
	SetNotificationTextEntry("STRING")
	AddTextComponentString("~g~Blood Alcohol Level has been set!")
	DrawNotification(false, false)
end)

AddEventHandler("breathNearby", function()
local ped = PlayerPedId()
	local nearestPlayer = GetNearestPlayerToEntity(ped)
	local entityType = GetEntityType(ped)

	shortestDistance = 2
	closestId = 0

	for id = 0, 32 do
        if NetworkIsPlayerActive( id ) and GetPlayerPed(id) ~= PlayerPedId() then
			ped1 = GetPlayerPed( id )
			local x,y,z = table.unpack(GetEntityCoords(ped))
                if (GetDistanceBetweenCoords(GetEntityCoords(ped1), x,y,z) <  shortestDistance) then

					shortestDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), x,y,z)
					closestId = GetPlayerServerId(id)


				end

        end
	end
	TriggerServerEvent("returnData", closestId)
end)

Citizen.CreateThread( function()
	SetNuiFocus( false )

	while true do
		if (IsControlPressed( 1, 36 ) and IsControlJustPressed( 1, 140 ) ) then
            drawNotification("Successfully opened the radar menu. Proceed with CTRL + R to close this menu.")
	        TriggerEvent("toggleMenu")
		end
		Citizen.Wait( 0 )
	end
end )

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local ped = GetPlayerPed(-1)

		if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
			local engineWasRunning = GetIsVehicleEngineRunning(GetVehiclePedIsIn(ped, true))
			Citizen.Wait(1000)
			if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and not IsPauseMenuActive() then
				local veh = GetVehiclePedIsIn(ped, true)
				if (engineWasRunning) then
					SetVehicleEngineOn(veh, true, true, true)
				end
			end
		end
	end
end)

-- EMOTES Menu

-- more emotes available at https://pastebin.com/6mrYTdQv
local emotes = {
    ['smoke'] = "WORLD_HUMAN_SMOKING",
    ['cop'] = "WORLD_HUMAN_COP_IDLES",
    ['lean'] = "WORLD_HUMAN_LEANING",
    ['sit'] = "WORLD_HUMAN_PICNIC",
    ['stupor'] = "WORLD_HUMAN_STUPOR",
    ['sunbathe2'] = "WORLD_HUMAN_SUNBATHE_BACK",
    ['sunbathe'] = "WORLD_HUMAN_SUNBATHE",
    ['medic'] = "CODE_HUMAN_MEDIC_TEND_TO_DEAD",
    ['clipboard'] = "WORLD_HUMAN_CLIPBOARD",
    ['party'] = "WORLD_HUMAN_PARTYING",
    ['kneel'] = "CODE_HUMAN_MEDIC_KNEEL",
    ['notepad'] = "CODE_HUMAN_MEDIC_TIME_OF_DEATH",
    ['weed'] = "WORLD_HUMAN_SMOKING_POT",
    ['impatient'] = "WORLD_HUMAN_STAND_IMPATIENT",
    ['fish'] = "WORLD_HUMAN_STAND_FISHING",
    ['weld'] = "WORLD_HUMAN_WELDING",
    ['photography'] = "WORLD_HUMAN_PAPARAZZI",
    ['film'] = "WORLD_HUMAN_MOBILE_FILM_SHOCKING",
    ['cheer'] = "WORLD_HUMAN_CHEERING",
    ['binoculars'] = "WORLD_HUMAN_BINOCULARS",
    ['flex'] = "WORLD_HUMAN_MUSCLE_FLEX",
    ['weights'] = "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS",
    ['yoga'] = "WORLD_HUMAN_YOGA"
}


-- Draws a simple notification
function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Registering all of the events called by the server
RegisterNetEvent("emote:invoke")
RegisterNetEvent("emote:cancelnow")
RegisterNetEvent("emote:display")

local emotePlaying = IsPedActiveInScenario(GetPlayerPed(-1)) -- Registering whether or not the player is in an active scenario


function cancelEmote() -- Cancels the emote slowly
    ClearPedTasks(GetPlayerPed(-1))
    emotePlaying = false
end
function cancelEmoteNow() -- Cancels the emote immediately
    ClearPedTasksImmediately(GetPlayerPed(-1))
    emotePlaying = false
end

function displayEmotes()
    local index = 0 -- Current index
    local display = "^7" -- Text to display

    for name, value in pairs(emotes) do -- Adding the emote names to the display var
        index = index + 1
        if index == 1 then
            display = display..name
        else
            display = display..", "..name
        end
    end

    TriggerEvent("chatMessage", "^1CSR | Emotes", {255,0,0}, "USAGE - /emote [emote]") -- Saying "EMOTES:" in red
    TriggerEvent("chatMessage", "", {0,0,0}, display) -- Displaying the emotes in white
end
function playEmote(emoteDic) -- Plays an emote from the given name dictionary
    if not DoesEntityExist(GetPlayerPed(-1)) then -- Return of the ped doesn't exist
        return false
    end

    if IsPedInAnyVehicle(GetPlayerPed(-1)) then -- Returns if the player is in any vehicle
        drawNotification("~r~You must leave the vehicle first")
        return false
    end

    local pedHoldingWeapon = IsPedArmed(GetPlayerPed(-1), 7)
    if pedHoldingWeapon then -- If the player is holding weapon, remove it
        SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263, true)
        drawNotification("Please put away your weapon first next time!")
    end

    TaskStartScenarioInPlace(GetPlayerPed(-1), emoteDic, 0, true) -- Start the scenario
    emotePlaying = true
    return true
end

AddEventHandler("emote:invoke", function(name)
    if emotes[name] ~= nil then -- Checking if the name is in the dictionary
        if playEmote(emotes[name]) then -- Playing the emote from the dictionary
            drawNotification("Playing the emote \""..name.."\"")
        end
    else
        TriggerEvent("chatMessage", "^1CSR | Emotes", {255,0,0}, "Invalid emote name") -- Saying if the name wasn't in the dictionary
    end
end)
AddEventHandler("emote:display", function()
    displayEmotes() -- Displays all of the emotes
end)
AddEventHandler("emote:cancelnow", function()
    cancelEmoteNow() -- Cancels the emote immediately
end)

Citizen.CreateThread(function()
    while true do

        if emotePlaying then
            if (IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35)) then
                cancelEmote() -- Cancels the emote if the player is moving
            end
        end

        Citizen.Wait(0)
    end
end)

local PlacedCones = {}

function Cone(option)
    if option == "delete" then
        local lastPlaced = PlacedCones[#PlacedCones]
        SetEntityAsMissionEntity(lastPlaced, 0, 0)
        DeleteEntity(lastPlaced)
        table.remove(PlacedCones, #PlacedCones)
    elseif option == "deleteall" then
		for i=#PlacedCones, 1, -1 do
            SetEntityAsMissionEntity(PlacedCones[i], 0, 0)
            DeleteEntity(PlacedCones[i])
            table.remove(PlacedCones, i)
        end
	elseif option == "spawn" then
        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0))
        local obj = CreateObject(GetHashKey("prop_mp_cone_01"), x, y, z-1.0, true, 0, false)
        SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
        table.insert(PlacedCones, obj)
    end
end

local PlacedSpikes = {}

function Spikes(option)
    if option == "delete" then
        local lastPlaced = PlacedSpikes[#PlacedSpikes]
        SetEntityAsMissionEntity(lastPlaced, 0, 0)
        DeleteEntity(lastPlaced)
        table.remove(PlacedSpikes, #PlacedSpikes)
    elseif option == "deleteall" then
		for i=#PlacedSpikes, 1, -1 do
            SetEntityAsMissionEntity(PlacedSpikes[i], 0, 0)
            DeleteEntity(PlacedSpikes[i])
            table.remove(PlacedSpikes, i)
        end
	elseif option == "spawn" then
        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0))
        local obj = CreateObject(GetHashKey("P_ld_stinger_s"), x, y, z-1.0, true, 0, false)
        SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
        table.insert(PlacedSpikes, obj)
    end
end

local PlacedBarrier3 = {}

function Barrier3(option)
    if option == "delete" then
        local lastPlaced = PlacedBarrier3[#PlacedBarrier3]
        SetEntityAsMissionEntity(lastPlaced, 0, 0)
        DeleteEntity(lastPlaced)
        table.remove(PlacedBarrier3, #PlacedBarrier3)
    elseif option == "deleteall" then
		for i=#PlacedBarrier3, 1, -1 do
            SetEntityAsMissionEntity(PlacedBarrier3[i], 0, 0)
            DeleteEntity(PlacedBarrier3[i])
            table.remove(PlacedBarrier3, i)
        end
	elseif option == "spawn" then
        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0))
        local obj = CreateObject(GetHashKey("prop_barrier_work06a"), x, y, z-1.0, true, 0, false)
        SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
        table.insert(PlacedBarrier3, obj)
    end
end

local PlacedSBarrier = {}

function SBarrier(option)
    if option == "delete" then
        local lastPlaced = PlacedSBarrier[#PlacedSBarrier]
        SetEntityAsMissionEntity(lastPlaced, 0, 0)
        DeleteEntity(lastPlaced)
        table.remove(PlacedSBarrier, #PlacedSBarrier)
    elseif option == "deleteall" then
		for i=#PlacedSBarrier, 1, -1 do
            SetEntityAsMissionEntity(PlacedSBarrier[i], 0, 0)
            DeleteEntity(PlacedSBarrier[i])
            table.remove(PlacedSBarrier, i)
        end
	elseif option == "spawn" then
        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0))
        local obj = CreateObject(GetHashKey("prop_mp_barrier_02b"), x, y, z-1.0, true, 0, false)
        SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
        table.insert(PlacedSBarrier, obj)
    end
end

local PlacedBarrier = {}

function Barrier(option)
    if option == "delete" then
        local lastPlaced = PlacedBarrier[#PlacedBarrier]
        SetEntityAsMissionEntity(lastPlaced, 0, 0)
        DeleteEntity(lastPlaced)
        table.remove(PlacedBarrier, #PlacedBarrier)
    elseif option == "deleteall" then
		for i=#PlacedBarrier, 1, -1 do
            SetEntityAsMissionEntity(PlacedBarrier[i], 0, 0)
            DeleteEntity(PlacedBarrier[i])
            table.remove(PlacedBarrier, i)
        end
	elseif option == "spawn" then
        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0))
        local obj = CreateObject(GetHashKey("prop_barrier_work05"), x, y, z-1.0, true, 0, false)
        SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
        table.insert(PlacedBarrier, obj)
    end
end

local Placedconsign1 = {}

function consign1(option)
    if option == "delete" then
        local lastPlaced = Placedconsign1[#Placedconsign1]
        SetEntityAsMissionEntity(lastPlaced, 0, 0)
        DeleteEntity(lastPlaced)
        table.remove(Placedconsign1, #Placedconsign1)
    elseif option == "deleteall" then
		for i=#Placedconsign1, 1, -1 do
            SetEntityAsMissionEntity(Placedconsign1[i], 0, 0)
            DeleteEntity(Placedconsign1[i])
            table.remove(Placedconsign1, i)
        end
	elseif option == "spawn" then
        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0))
        local obj = CreateObject(GetHashKey("prop_consign_01a"), x, y, z-1.0, true, 0, false)
        SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
        table.insert(Placedconsign1, obj)
    end
end

function getEntity(player) --Function To Get Entity Player Is Aiming At
	local result, entity = GetEntityPlayerIsFreeAimingAt(player)
	return entity
end

RegisterNetEvent("ForceQuit")
AddEventHandler("ForceQuit", function()
	ForceSocialClubUpdate()
end)

local cruiseControl = false
local cruiseSpeed
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(ped, false)
		local speed = GetEntitySpeed(vehicle)
		DisableControlAction(0, 166, true)
		
		cruiseSpeed = speed

		if ped and vehicle and IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(vehicle, -1) == ped and speed*2.23694+0.5 > 20 and not IsPedInAnyBoat(ped) and not IsPedInAnyPlane(ped) and (IsDisabledControlJustPressed(0, 166) or (IsControlJustPressed(0, 27) and IsControlJustPressed(0, 99))) then

			if not cruiseControl then
				DisplayNotification("[CSR Cruise Control]: Activated at a speed of "..math.floor(speed*2.23694+0.5).."mph.")
				cruiseControl = true
				setSpeed()
			else
				DisplayNotification("[CSR Cruise Control]: Deactivated.")
				cruiseControl = false
			end
		end

		if cruiseControl and (not IsPedInAnyVehicle(ped, false) or not GetPedInVehicleSeat(vehicle, -1) == ped or not IsVehicleOnAllWheels(vehicle)) then
			DisplayNotification("[CSR Cruise Control]: Deactivated.")
			cruiseControl = false
		end

		if ped and vehicle and cruiseControl then

			if IsControlPressed(27, 71) then
				cruiseControl = false
				acceleratingToNewSpeed()
			end

			if IsControlPressed(27, 72) then
				DisplayNotification("[CSR Cruise Control]: Deactivated.")
				cruiseControl = false
			end
		end

		if cruiseControl and speed*2.23694+0.5 < 20 then
			DisplayNotification("[CSR Cruise Control]: Deactivated.")
			cruiseControl = false
		end
	end
end)

function setSpeed()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local ped = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn(ped, false)

			if ped and vehicle and cruiseControl and IsVehicleOnAllWheels(vehicle) then
				SetVehicleForwardSpeed(vehicle, cruiseSpeed)
			end
		end
	end)
end

function acceleratingToNewSpeed()
	Citizen.CreateThread(function()
		while IsControlPressed(27, 71) do
			Citizen.Wait(1)
		end

		cruiseControl = true
		setSpeed()
	end)
end

function DisplayNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end



-- ADVERTISMENTS
RegisterNetEvent("ad1")
AddEventHandler("ad1",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad1', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad1')
AddEventHandler('displayad1',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "247", true, 1, "~y~24/7~s~", "");
DrawNotification(false, true);

end)

--
RegisterNetEvent("ad2")
AddEventHandler("ad2",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad2', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad2')
AddEventHandler('displayad2',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_AMMUNATION", "CHAR_AMMUNATION", true, 1, "~y~Ammunation~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad3")
AddEventHandler("ad3",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad3', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad3')
AddEventHandler('displayad3',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "NEWS", true, 1, "~y~Weazel News~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad4")
AddEventHandler("ad4",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad4', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad4')
AddEventHandler('displayad4',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_MP_STRIPCLUB_PR", "CHAR_MP_STRIPCLUB_PR", true, 1, "~y~Vanilla Unicorn~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad5")
AddEventHandler("ad5",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad5', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad5')
AddEventHandler('displayad5',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_TAXI", "CHAR_TAXI", true, 1, "~y~Downtown Cab Co.~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad6")
AddEventHandler("ad6",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad6', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad6')
AddEventHandler('displayad6',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_LS_TOURIST_BOARD", "CHAR_LS_TOURIST_BOARD", true, 1, "~y~Los Santos Traffic Info~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad7")
AddEventHandler("ad7",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad7', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad7')
AddEventHandler('displayad7',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_LS_CUSTOMS", "CHAR_LS_CUSTOMS", true, 1, "~y~Los Santos Customs~s~", "");
DrawNotification(false, true);

end)

--
RegisterNetEvent("ad8")
AddEventHandler("ad8",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad8', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad8')
AddEventHandler('displayad8',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "ACE", true, 1, "~y~Liquor Ace~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad9")
AddEventHandler("ad9",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad9', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad9')
AddEventHandler('displayad9',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "LTD", true, 1, "~y~Limited Gasoline~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad10")
AddEventHandler("ad10",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad10', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad10')
AddEventHandler('displayad10',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "POSTAL", true, 1, "~y~GoPostal~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad11")
AddEventHandler("ad11",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad11', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad11')
AddEventHandler('displayad11',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "NA", true, 1, "~y~Hayes Auto~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad12")
AddEventHandler("ad12",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad12', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad12')
AddEventHandler('displayad12',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "VAN", true, 1, "~y~Vangelico~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad13")
AddEventHandler("ad13",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad13', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad13')
AddEventHandler('displayad13',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "BELL", true, 1, "~y~Cluckin' Bell~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad14")
AddEventHandler("ad14",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad14', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad14')
AddEventHandler('displayad14',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "BUG", true, 1, "~y~Bugstars~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad15")
AddEventHandler("ad15",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad15', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad15')
AddEventHandler('displayad15',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", true, 1, "~y~Fleeca Bank~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad16")
AddEventHandler("ad16",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad16', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad16')
AddEventHandler('displayad16',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "NA", true, 1, "~y~Echo Sechs~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad17")
AddEventHandler("ad17",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad17', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad17')
AddEventHandler('displayad17',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_MP_MORS_MUTUAL", "CHAR_MP_MORS_MUTUAL", true, 1, "~y~Mors Mutual Insurance~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad18")
AddEventHandler("ad18",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad18', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad18')
AddEventHandler('displayad18',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "OP", true, 1, "~y~PostOP~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad19")
AddEventHandler("ad19",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad19', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad19')
AddEventHandler('displayad19',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "EXOTIC", true, 1, "~y~Auto Exotic~s~", "");
DrawNotification(false, true);

end)
--
RegisterNetEvent("ad20")
AddEventHandler("ad20",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad20', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad20')
AddEventHandler('displayad20',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "LSWP", true, 1, "~y~Los Santos Water and Power~s~", "");
DrawNotification(false, true);

end)
--
--
RegisterNetEvent("ad21")
AddEventHandler("ad21",function()
		DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		local input = true
		Citizen.CreateThread(function()
		while input do
		if input == true then
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
		elseif UpdateOnscreenKeyboard() == 1 then
		local inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
		TriggerServerEvent('syncad21', inputText)
		input = false
		else
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		end
		end
		 Citizen.Wait(0)
		 end
		 
	
end)
end)

RegisterNetEvent('displayad21')
AddEventHandler('displayad21',function(inputText)

SetNotificationTextEntry("STRING");
AddTextComponentString(inputText);
SetNotificationMessage("CHAR_FLOYD", "D8", true, 1, "~y~Dynasty 8~s~", "");
DrawNotification(false, true);

end)

-- END OF ADVERTISMENTS