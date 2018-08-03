Citizen.CreateThread(function()	
    WarMenu.CreateMenu('csrRadar', 'Radar / ALPR')
	WarMenu.CreateSubMenu('alprOptions', 'csrRadar', 'ALPR Options')
	WarMenu.CreateSubMenu('radarOptions', 'csrRadar', 'Radar Options')
    while true do
        if WarMenu.IsMenuOpened('csrRadar') then
            if WarMenu.Button('~g~~h~Toggle ALPR & Radar') then
				toggleALPR()
				TriggerEvent( 'wk:toggleRadar' )
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('ALPR Options', 'alprOptions') then
            elseif WarMenu.MenuButton('Radar Options', 'radarOptions') then
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('alprOptions') then
			if WarMenu.Button('Reset ALPRs') then
				TriggerEvent("clearAlpr")
            elseif WarMenu.MenuButton('←←← Back', 'csrRadar') then
            end			
			
			
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('radarOptions') then
            if WarMenu.Button('Set Fast Speed') then
				Radar_SetLimit()
			elseif WarMenu.Button('Reset Front Antenna') then
				ResetFrontAntenna()
			elseif WarMenu.Button('Reset Rear Antenna') then
				ResetRearAntenna()
            elseif WarMenu.MenuButton('←←← Back', 'csrRadar') then
            end

            WarMenu.Display()
        elseif IsControlJustReleased(1, 178) and GetLastInputMethod( 0 ) and ( GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 18 )  then --M by default
            WarMenu.OpenMenu('csrRadar')
        end
		
        Citizen.Wait(0)
		
    end
end)



function drawNotification(text)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, true)
end

local radneg = 165.0

local toggled = false
local alpr_toggled = false
local radar_toggled = false
local alpr_lock = nil

local front_radar_model = ""
local front_radar_plate = ""
local front_plate_index = ""

local frontplate = "plate01"
local front_plate_red = 0
local front_plate_green = 0
local front_plate_blue = 0
local saved_fplate = ""								
 
local rear_radar_model = ""
local rear_radar_plate = ""
local rear_plate_index = ""

local rearplate = "plate01"
local rear_plate_red = 0
local rear_plate_green = 0
local rear_plate_blue = 0
local saved_rplate = ""

local radarDisplayOffset = 206

local isFrontStolen = ""
local isRearStolen = ""		

function toggleALPR()
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
	local class = GetVehicleClass(veh)
		
	if DoesEntityExist(GetVehiclePedIsIn(GetPlayerPed(-1))) then
		if ( toggled == true ) and ( class == 18 ) then
			PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			drawNotification("~b~ALPR's and Radar System have been toggled off!")
			toggled = false
			Wait(20)
			alpr_toggled = false
			radar_toggled = false
		elseif ( toggled == false ) and ( class == 18 ) then
			PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			drawNotification("~b~ALPR's and Radar System have been toggled on!")
			toggled = true
			Wait(20)
			alpr_toggled = true
			radar_toggled = true
		end
	end
end

RegisterNetEvent("clearAlpr")
AddEventHandler('clearAlpr', function()
	-- FRONT
	front_radar_plate = ""
	front_plate_index = ""
	frontplate = "plate01"
	front_plate_red = 0
	front_plate_green = 0
	front_plate_blue = 0
	fflag = "*NONE*"
	front_ro = "*NONE*"
	saved_fplate = ""								
	-- REAR
	rear_radar_plate = ""
	rear_plate_index = ""
	rearplate = "plate01"
	rear_plate_red = 0
	rear_plate_green = 0
	rear_plate_blue = 0
	rflag = "*NONE*"
	rear_ro = "*NONE*"
	saved_rplate = ""
end)

--------------------------------------------------------
local function GetNearestPlayer()
    local dist_closest = -1
    local s_dist_closest = -1
    local l_ped = GetPlayerPed(-1)
    local l_ped_x, l_ped_y, l_ped_z = table.unpack(GetEntityCoords(l_ped, false))
    for _, rt_value in ipairs(GetPlayers()) do
        local s_ped = GetPlayerPed(rt_value)
        if(s_ped ~= l_ped) then
            local s_ped_x, s_ped_y, s_ped_z = table.unpack(GetEntityCoords(s_ped, false))
            local l_dist = Vdist(l_ped_x, l_ped_y, l_ped_z, s_ped_x, s_ped_y, s_ped_z)
            if(dist_closest == -1 or dist_closest > l_dist) then
                s_dist_closest = rt_value
                dist_closest = l_dist
            end
        end
    end
    return s_dist_closest, dist_closest
end
-----------------------------------------------------------------------------
function hudZoom()
	SetRadarZoomLevelThisFrame(1)
	SetRadarBigmapEnabled(false,false)
end
---------------------------------------------------------------------------------------------
local function GetEntityInDirection(from, to)
local rayHandle=StartShapeTestRay(from,to,10,GetPlayerPed(-1),0)
local _,_,_,_,entity=GetRaycastResult(rayHandle)
return entity;end
---------------------------------------------------------
function drawT(text, x, y, size, center, font, r, g, b, a)
local resx,resy=GetScreenResolution();SetTextFont(font);SetTextScale(size,size)
SetTextProportional(true);SetTextColour(r,g,b,a);SetTextCentre(center)
SetTextDropshadow(0,0,0,0,0);SetTextEntry("STRING")
AddTextComponentString(text)DrawText((float(x)/1.5)/resx,((float(y)-6)/1.5)/resy);end
----------------------------------------------------------
function drawText(text, x, y, size, center, font, r, g, b, a)
local resx,resy=GetScreenResolution();SetTextFont(font);SetTextScale(size,size)
SetTextProportional(true);SetTextColour(r,g,b,a);SetTextCentre(center)
SetTextDropshadow(0,0,0,0,0);SetTextEntry("STRING")
AddTextComponentString(text)DrawText((float(x)/1.5)/resx,((float(y)-6)/1.5)/resy);end
-------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while(true)do

        local l_ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(l_ped, false)
        local vehclass = GetVehicleClass(vehicle)
		hudZoom()
		if(alpr_toggled)then;radarDisplayOffset=0;else;radarDisplayOffset=206;end
        if (radar_toggled) or (alpr_toggled) then
            if GetPedInVehicleSeat(vehicle, -1) == l_ped or GetPedInVehicleSeat(vehicle, 0) == l_ped and not IsEntityDead(l_ped) and vehclass == 18 then
                local l_veh_pos = GetEntityCoords(vehicle, true)
                local front_radar = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 2900.0, 0.0)
                local front_radar_veh = GetEntityInDirection(l_veh_pos, front_radar)
                local rear_radar = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -2900.0, 0.0)
                local rear_radar_veh = GetEntityInDirection(l_veh_pos, rear_radar)
				local resx, resy = GetScreenResolution()
                local xoffs = 355
                local eyoffs = 325
				local xspeed = 2.23
                if (DoesEntityExist(front_radar_veh) and IsEntityAVehicle(front_radar_veh)) then
                    front_radar_model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(front_radar_veh)))
                    front_radar_plate = GetVehicleNumberPlateText(front_radar_veh)
					fcol1, fcol2 = GetVehicleColours(front_radar_veh)
					front_plate_index = GetVehicleNumberPlateTextIndex(front_radar_veh)
                    local front_radar_speed = GetEntitySpeed(front_radar_veh)
                    front_radar_mph = math.ceil(front_radar_speed * xspeed)
                    if (front_radar_model == nil) then
                        front_radar_model = ""
                    elseif (front_radar_plate == nil) then
                        front_radar_plate = ""
                    elseif (front_radar_plate == " FIVE M ") then
						isFrontStolen = "~r~STOLEN ~o~- Proceed with caution!"
					elseif (front_radar_plate ~= " FIVE M ") then
						isFrontStolen = "~g~NONE FOUND"
					end
					
                    if (front_radar_model ~= "" and front_radar_plate ~= "") then
                        local front_radar_driver = GetPedInVehicleSeat(front_radar_veh, -1)
 
                        if (IsPedAPlayer(front_radar_driver)) then
                            front_radar_disp = front_radar_mph
                        end
                    end
                end
                if (DoesEntityExist(rear_radar_veh) and IsEntityAVehicle(rear_radar_veh)) then
                    rear_radar_model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(rear_radar_veh)))
                    rear_radar_plate = GetVehicleNumberPlateText(rear_radar_veh)
					rcol1, rcol2 = GetVehicleColours(rear_radar_veh)
					rear_plate_index = GetVehicleNumberPlateTextIndex(rear_radar_veh)
                    local rear_radar_speed = GetEntitySpeed(rear_radar_veh)
                    rear_radar_mph = math.ceil(rear_radar_speed * xspeed)
                    if (rear_radar_model == nil) then
                        rear_radar_model = ""
                    elseif (rear_radar_plate == nil) then
                        rear_radar_plate = ""
                    elseif (rear_radar_plate == " FIVE M ") then
						isRearStolen = "~r~STOLEN ~o~- Proceed with caution!"
					elseif (rear_radar_plate ~= " FIVE M ") then
						isRearStolen = "~g~NONE FOUND"
					end
					
                    if (rear_radar_model ~= "" and rear_radar_plate ~= "") then
                        local rear_radar_driver = GetPedInVehicleSeat(front_radar_veh, -1)
 
                        if (IsPedAPlayer(rear_radar_driver)) then
							rear_radar_disp = rear_radar_mph
                        end
                    end
                end
				if (alpr_toggled) then
				
					local fmodel = front_radar_model
					local fplate = front_radar_plate
					local color1 = fcol1
					local rmodel = rear_radar_model
					local rplate = rear_radar_plate
					local color2 = rcol1
					if (color1 == nil) then
						color1 = ""
					elseif (color1 > 157) then
						color1 = "Unknown Color."
					else
						color1 = VehicleColorNames[color1]
					end
					if (color2 == nil) then
						color2 = ""
					elseif (color2 > 157) then
						color2 = "Unknown Color."
					else
						color2 = VehicleColorNames[color2]
					end
					-- BOX
					DisableControlAction(2, 99, false)
					if vehclass == 18 then
					DrawRect((float(1310 + xoffs)/1.5)/resx, (float(965)/1.5)/resy, (float(480)/1.5)/resx, (float(200)/1.5)/resy, 0, 0, 0, 255)
					DrawRect((float(1310 + xoffs)/1.5)/resx, (float(965)/1.5)/resy, (float(474)/1.5)/resx, (float(194)/1.5)/resy, 0, 0, 0, 255)
					DrawRect((float(1310 + xoffs)/1.5)/resx, (float(965)/1.5)/resy, (float(470)/1.5)/resx, (float(190)/1.5)/resy, 0, 0, 0, 255)
					else
					end
					-- FRONT
					if (front_plate_index ~= "") then
						frontplate = plateIndexTable[front_plate_index].n
						front_plate_red = plateIndexTable[front_plate_index].r
						front_plate_green = plateIndexTable[front_plate_index].g
						front_plate_blue = plateIndexTable[front_plate_index].b
					end
					-- REAR
					if (rear_plate_index ~= "") then
						rearplate = plateIndexTable[rear_plate_index].n
						rear_plate_red = plateIndexTable[rear_plate_index].r
						rear_plate_green = plateIndexTable[rear_plate_index].g
						rear_plate_blue = plateIndexTable[rear_plate_index].b
					end
					-- LOCK
					DisableControlAction(2, 99, false)
					if (alpr_toggled) and IsDisabledControlJustPressed(2, 99) then    -- xbox (X) TAB on kwyboard.
						if (alpr_lock == nil) then
							alpr_lock =
							{
								lock_front_flag = fflag,
								lock_front_ro = front_ro,
								lock_front_pname = frontplate,
								lock_fcolr = front_plate_red,
								lock_fcolg = front_plate_green,
								lock_fcolb = front_plate_blue,
								lock_fplate = fplate,
								lock_fmodel = fmodel,
								lock_fcolor = color1,
								lock_rear_flag = rflag,
								lock_rear_ro = rear_ro,
								lock_rear_pname = rearplate,
								lock_rcolr = rear_plate_red,
								lock_rcolg = rear_plate_green,
								lock_rcolb = rear_plate_blue,
								lock_rplate = rplate,
								lock_rmodel = rmodel,
								lock_rcolor = color2,
							}
						else
							alpr_lock = nil
						end
						PlaySoundFrontend(-1, "HUD_FRONTEND_DEFAULT_SOUNDSET", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
					end
					
					if vehclass == 18 then
					
					drawText("~w~TAB OR ~s~(X) ~w~TO LOCK PLATES", 1490.0, 1056.0, 0.15, true, 0, 0, 130, 255, 100)
					-- FRONT
					drawText("F", 1433.0, 889.0, 0.23, false, 0, 235, 235, 235, 230)
					drawText("R", 1433.0, 889.0+13.0, 0.23, false, 0, 235, 235, 235, 230)
					drawText("O", 1433.0, 889.0+13.0*2, 0.23, false, 0, 235, 235, 235, 230)
					drawText("N", 1433.0, 889.0+13.0*3, 0.23, false, 0, 235, 235, 235, 230)
					drawText("T", 1434.0, 889.0+13.0*4, 0.23, false, 0, 235, 235, 235, 230)
					drawText("L~n~O~n~C~n~K", 1450.0, 891.0, 0.23, false, 0, 0, 0, 0, 255)
				
					if (fplate == "") then
						drawText("MODEL: ~n~COLOR: ~n~FLAGS:", 1620.0+14.0, 885.0, 0.40, false, 4, 235, 235, 235, 230)
						drawText("00000000", 1535.0+14.0, 906.0, 0.75, true, 4, 3, 12, 25, 225)
						DrawSprite("vehshare", "plate01", (float(1180+14.0 + xoffs)/1.5)/resx, (float(920)/1.5)/resy, (float(150)/1.5)/resx, (float(75)/1.5)/resy, 0.0, 255, 255, 255, 230)
						DrawRect((float(1102 + xoffs)/1.5)/resx, (float(920)/1.5)/resy, (float(14)/1.5)/resx, (float(71)/1.5)/resy, 255, 255, 255, 30)
					elseif (alpr_lock ~= nil) and (fplate ~= "") then
						drawText(string.format("MODEL: %s~n~COLOR: %s~n~FLAGS: %s", alpr_lock.lock_fmodel, alpr_lock.lock_fcolor, isFrontStolen), 1620.0+14.0, 885.0, 0.40, false, 4, 235, 235, 235, 230)
						drawText(alpr_lock.lock_fplate, 1535.0+14.0, 906.0, 0.75, true, 4, alpr_lock.lock_fcolr, alpr_lock.lock_fcolg, alpr_lock.lock_fcolb, 225)
						DrawSprite("vehshare", alpr_lock.lock_front_pname, (float(1180+14.0 + xoffs)/1.5)/resx, (float(920)/1.5)/resy, (float(150)/1.5)/resx, (float(75)/1.5)/resy, 0.0, 255, 255, 255, 230)
						DrawRect((float(1102 + xoffs)/1.5)/resx, (float(920)/1.5)/resy, (float(14)/1.5)/resx, (float(71)/1.5)/resy, 255, 0, 0, 235)
					else
						drawText(string.format("MODEL: %s~n~COLOR: %s~n~FLAGS: %s", fmodel, color1, isFrontStolen), 1620.0+14.0, 885.0, 0.40, false, 4, 235, 235, 235, 230)
						drawText(fplate, 1535.0+14.0, 906.0, 0.75, true, 4, front_plate_red, front_plate_green, front_plate_blue, 225)
						DrawSprite("vehshare", frontplate, (float(1180+14.0 + xoffs)/1.5)/resx, (float(920)/1.5)/resy, (float(150)/1.5)/resx, (float(75)/1.5)/resy, 0.0, 255, 255, 255, 230)
						DrawRect((float(1102 + xoffs)/1.5)/resx, (float(920)/1.5)/resy, (float(14)/1.5)/resx, (float(71)/1.5)/resy, 255, 255, 255, 30)
					end
					--REAR
					drawText("R", 1433.0, 986.0, 0.23, false, 0, 235, 235, 235, 230)
					drawText("E", 1433.0, 986.0+13.0, 0.23, false, 0, 235, 235, 235, 230)
					drawText("A", 1433.0, 986.0+13.0*2, 0.23, false, 0, 235, 235, 235, 230)
					drawText("R", 1433.0, 986.0+13.0*3, 0.23, false, 0, 235, 235, 235, 230)
					drawText("L~n~O~n~C~n~K", 1450.0, 983.0, 0.23, false, 0, 0, 0, 0, 255)
					if (rplate == "") then
						drawText("MODEL: ~n~COLOR: ~n~FLAGS:", 1620.0+14.0, 999.0-21.0, 0.40, false, 4, 235, 235, 235, 230)
						drawText("00000000", 1535.0+14.0, 999.0, 0.75, true, 4, 3, 12, 25, 225)
						DrawSprite("vehshare", "plate01", (float(1180+14.0 + xoffs)/1.5)/resx, (float(1012)/1.5)/resy, (float(150)/1.5)/resx, (float(75)/1.5)/resy, 0.0, 255, 255, 255, 230)
						DrawRect((float(1102 + xoffs)/1.5)/resx, (float(920+92)/1.5)/resy, (float(14)/1.5)/resx, (float(71)/1.5)/resy, 255, 255, 255, 30)
					elseif (alpr_lock ~= nil) and (fplate ~= "") then
						drawText(string.format("MODEL: %s~n~COLOR: %s~n~FLAGS: %s", alpr_lock.lock_rmodel, alpr_lock.lock_rcolor, isRearStolen), 1620.0+14.0, 999.0-21.0, 0.40, false, 4, 235, 235, 235, 230)
						drawText(alpr_lock.lock_rplate, 1535.0+14.0, 999.0, 0.75, true, 4, alpr_lock.lock_rcolr, alpr_lock.lock_rcolg, alpr_lock.lock_rcolb, 225)
						DrawSprite("vehshare", alpr_lock.lock_rear_pname, (float(1180+14.0 + xoffs)/1.5)/resx, (float(1012)/1.5)/resy, (float(150)/1.5)/resx, (float(75)/1.5)/resy, 0.0, 255, 255, 255, 230)
						DrawRect((float(1102 + xoffs)/1.5)/resx, (float(920+92)/1.5)/resy, (float(14)/1.5)/resx, (float(71)/1.5)/resy, 255, 0, 0, 235)
					else
						drawText(string.format("MODEL: %s~n~COLOR: %s~n~FLAGS: %s", rmodel, color2, isRearStolen), 1620.0+14.0, 999.0-21.0, 0.40, false, 4, 235, 235, 235, 230)
						drawText(rplate, 1535.0+14.0, 999.0, 0.75, true, 4, rear_plate_red, rear_plate_green, rear_plate_blue, 225)
						DrawSprite("vehshare", rearplate, (float(1180+14.0 + xoffs)/1.5)/resx, (float(1012)/1.5)/resy, (float(150)/1.5)/resx, (float(75)/1.5)/resy, 0.0, 255, 255, 255, 230)
						DrawRect((float(1102 + xoffs)/1.5)/resx, (float(920+92)/1.5)/resy, (float(14)/1.5)/resx, (float(71)/1.5)/resy, 255, 255, 255, 30)
					end
					end
					saved_fplate = fplate
					saved_rplate = rplate
				end
			end
        end
        Citizen.Wait(0)
    end
end)
function float(num)
	num = num + 0.00001
	return num
end


VehicleColorNames =
{
	[-1] = "Random",
	[0] = "Metallic Black",
	[1] = "Metallic Graphite Black",
	[2] = "Metallic Black Steal",
	[3] = "Metallic Dark Silver",
	[4] = "Metallic Silver",
	[5] = "Metallic Blue Silver",
	[6] = "Metallic Steel Gray",
	[7] = "Metallic Shadow Silver",
	[8] = "Metallic Stone Silver",
	[9] = "Metallic Midnight Silver",
	[10] = "Metallic Gun Metal",
	[11] = "Metallic Anthracite Grey",
	[12] = "Matte Black",
	[13] = "Matte Gray",
	[14] = "Matte Light Grey",
	[15] = "Util Black",
	[16] = "Util Black Poly",
	[17] = "Util Dark silver",
	[18] = "Util Silver",
	[19] = "Util Gun Metal",
	[20] = "Util Shadow Silver",
	[21] = "Worn Black",
	[22] = "Worn Graphite",
	[23] = "Worn Silver Grey",
	[24] = "Worn Silver",
	[25] = "Worn Blue Silver",
	[26] = "Worn Shadow Silver",
	[27] = "Metallic Red",
	[28] = "Metallic Torino Red",
	[29] = "Metallic Formula Red",
	[30] = "Metallic Blaze Red",
	[31] = "Metallic Graceful Red",
	[32] = "Metallic Garnet Red",
	[33] = "Metallic Desert Red",
	[34] = "Metallic Cabernet Red",
	[35] = "Metallic Candy Red",
	[36] = "Metallic Sunrise Orange",
	[37] = "Metallic Classic Gold",
	[38] = "Metallic Orange",
	[39] = "Matte Red",
	[40] = "Matte Dark Red",
	[41] = "Matte Orange",
	[42] = "Matte Yellow",
	[43] = "Util Red",
	[44] = "Util Bright Red",
	[45] = "Util Garnet Red",
	[46] = "Worn Red",
	[47] = "Worn Golden Red",
	[48] = "Worn Dark Red",
	[49] = "Metallic Dark Green",
	[50] = "Metallic Racing Green",
	[51] = "Metallic Sea Green",
	[52] = "Metallic Olive Green",
	[53] = "Metallic Green",
	[54] = "Metallic Gasoline Blue Green",
	[55] = "Matte Lime Green",
	[56] = "Util Dark Green",
	[57] = "Util Green",
	[58] = "Worn Dark Green",
	[59] = "Worn Green",
	[60] = "Worn Sea Wash",
	[61] = "Metallic Midnight Blue",
	[62] = "Metallic Dark Blue",
	[63] = "Metallic Saxony Blue",
	[64] = "Metallic Blue",
	[65] = "Metallic Mariner Blue",
	[66] = "Metallic Harbor Blue",
	[67] = "Metallic Diamond Blue",
	[68] = "Metallic Surf Blue",
	[69] = "Metallic Nautical Blue",
	[70] = "Metallic Bright Blue",
	[71] = "Metallic Purple Blue",
	[72] = "Metallic Spinnaker Blue",
	[73] = "Metallic Ultra Blue",
	[74] = "Metallic Bright Blue",
	[75] = "Util Dark Blue",
	[76] = "Util Midnight Blue",
	[77] = "Util Blue",
	[78] = "Util Sea Foam Blue",
	[79] = "Uil Lightning Blue",
	[80] = "Util Maui Blue Poly",
	[81] = "Util Bright Blue",
	[82] = "Matte Dark Blue",
	[83] = "Matte Blue",
	[84] = "Matte Midnight Blue",
	[85] = "Worn Dark Blue",
	[86] = "Worn Blue",
	[87] = "Worn Light Blue",
	[88] = "Metallic Taxi Yellow",
	[89] = "Metallic Race Yellow",
	[90] = "Metallic Bronze",
	[91] = "Metallic Yellow Bird",
	[92] = "Metallic Lime",
	[93] = "Metallic Champagne",
	[94] = "Metallic Pueblo Beige",
	[95] = "Metallic Dark Ivory",
	[96] = "Metallic Choco Brown",
	[97] = "Metallic Golden Brown",
	[98] = "Metallic Light Brown",
	[99] = "Metallic Straw Beige",
	[100] = "Metallic Moss Brown",
	[101] = "Metallic Biston Brown",
	[102] = "Metallic Beechwood",
	[103] = "Metallic Dark Beechwood",
	[104] = "Metallic Choco Orange",
	[105] = "Metallic Beach Sand",
	[106] = "Metallic Sun Bleeched Sand",
	[107] = "Metallic Cream",
	[108] = "Util Brown",
	[109] = "Util Medium Brown",
	[110] = "Util Light Brown",
	[111] = "Metallic White",
	[112] = "Metallic Frost White",
	[113] = "Worn Honey Beige",
	[114] = "Worn Brown",
	[115] = "Worn Dark Brown",
	[116] = "Worn straw beige",
	[117] = "Brushed Steel",
	[118] = "Brushed Black steel",
	[119] = "Brushed Aluminium",
	[120] = "Chrome",
	[121] = "Worn Off White",
	[122] = "Util Off White",
	[123] = "Worn Orange",
	[124] = "Worn Light Orange",
	[125] = "Metallic Securicor Green",
	[126] = "Worn Taxi Yellow",
	[127] = "Police Car Blue",
	[128] = "Matte Green",
	[129] = "Matte Brown",
	[130] = "Worn Orange",
	[131] = "Matte White",
	[132] = "Worn White",
	[133] = "Worn Olive Army Green",
	[134] = "Pure White",
	[135] = "Hot Pink",
	[136] = "Salmon pink",
	[137] = "Metallic Vermillion Pink",
	[138] = "Orange",
	[139] = "Green",
	[140] = "Blue",
	[141] = "Mettalic Black Blue",
	[142] = "Metallic Black Purple",
	[143] = "Metallic Black Red",
	[144] = "Hunter Green",
	[145] = "Metallic Purple",
	[146] = "Metaillic V Dark Blue",
	[147] = "MODSHOP BLACK1",
	[148] = "Matte Purple",
	[149] = "Matte Dark Purple",
	[150] = "Metallic Lava Red",
	[151] = "Matte Forest Green",
	[152] = "Matte Olive Drab",
	[153] = "Matte Desert Brown",
	[154] = "Matte Desert Tan",
	[155] = "Matte Foilage Green",
	[156] = "Alloy",
	[157] = "Epsilon Blue",
}

plateIndexTable =
{
	[0] = {n = "plate01", r = 15, g = 35, b = 82},	--"Blue_on_White_2",
	[1] = {n = "plate02", r = 207, g = 158, b = 0},	--"Yellow_on_Black",
	[2] = {n = "plate03", r = 189, g = 113, b = 33},	--"Yellow_on_Blue",
	[3] = {n = "plate04", r = 15, g = 35, b = 82},	--"Blue_on_White_1",
	[4] = {n = "plate05", r = 15, g = 35, b = 82},	--"Blue_on_White_3",	-- POLICE
	[5] = {n = "yankton_plate", r = 0, g = 0, b = 0},	--"North_Yankton",	-- ADMIN
}









--[[------------------------------------------------------------------------

    Wraith Radar System - v1.02
    Created by WolfKnight

------------------------------------------------------------------------]]--

--[[------------------------------------------------------------------------
    Resource Rename Fix 
------------------------------------------------------------------------]]--
Citizen.CreateThread( function()
    Citizen.Wait( 1000 )
    local resourceName = GetCurrentResourceName()
    SendNUIMessage( { resourcename = resourceName } )
end )

--[[------------------------------------------------------------------------
    Utils 
------------------------------------------------------------------------]]--
function round( num )
    return tonumber( string.format( "%.0f", num ) )
end

function oppang( ang )
    return ( ang + 180 ) % 360 
end 

function FormatSpeed( speed )
    return string.format( "%03d", speed )
end 

function GetVehicleInDirectionSphere( entFrom, coordFrom, coordTo )
    local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 2.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    return vehicle
end

function IsEntityInMyHeading( myAng, tarAng, range )
    local rangeStartFront = myAng - ( range / 2 )
    local rangeEndFront = myAng + ( range / 2 )

    local opp = oppang( myAng )

    local rangeStartBack = opp - ( range / 2 )
    local rangeEndBack = opp + ( range / 2 )

    if ( ( tarAng > rangeStartFront ) and ( tarAng < rangeEndFront ) ) then 
        return true 
    elseif ( ( tarAng > rangeStartBack ) and ( tarAng < rangeEndBack ) ) then 
        return false 
    else 
        return nil 
    end 
end 


--[[------------------------------------------------------------------------
    Police Vehicle Radar 
------------------------------------------------------------------------]]--
local radarEnabled = false 
local hidden = false 
local radarInfo = 
{ 
    patrolSpeed = "000", 

    speedType = "mph", 

    fwdPrevVeh = 0, 
    fwdXmit = true, 
    fwdMode = "same", 
    fwdSpeed = "000", 
    fwdFast = "000", 
    fwdFastLocked = false, 
    fwdDir = nil, 
    fwdFastSpeed = 0,

    bwdPrevVeh = 0, 
    bwdXmit = true, 
    bwdMode = "same", 
    bwdSpeed = "000", 
    bwdFast = "000",
    bwdFastLocked = false, 
    bwdDir = nil, 
    bwdFastSpeed = 0, 

    fastResetLimit = 150,
    fastLimit = 60, 

    angles = { [ "same" ] = { x = 0.0, y = 50.0, z = 0.0 }, [ "opp" ] = { x = -10.0, y = 50.0, z = 0.0 } },

    lockBeep = true 
}

RegisterNetEvent( 'wk:toggleRadar' )
AddEventHandler( 'wk:toggleRadar', function()
    local ped = GetPlayerPed( -1 )

    if ( IsPedSittingInAnyVehicle( ped ) ) then 
        local vehicle = GetVehiclePedIsIn( ped, false )

        if ( GetVehicleClass( vehicle ) == 18 ) then
            radarEnabled = not radarEnabled

            ResetFrontAntenna()
            ResetRearAntenna()

            SendNUIMessage({
                toggleradar = true, 
                fwdxmit = radarInfo.fwdXmit, 
                fwdmode = radarInfo.fwdMode, 
                bwdxmit = radarInfo.bwdXmit, 
                bwdmode = radarInfo.bwdMode
            })
        else 
            Notify( "~r~You must be in a police vehicle." )
        end 
    else 
        Notify( "~r~You must be in a vehicle." )
    end 
end )

RegisterNetEvent( 'wk:changeRadarLimit' )
AddEventHandler( 'wk:changeRadarLimit', function( speed ) 
    radarInfo.fastLimit = speed 
end )

function Radar_SetLimit()
    Citizen.CreateThread( function()
        DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 4 )

        while true do 
            if ( UpdateOnscreenKeyboard() == 1 ) then 
                local speedStr = GetOnscreenKeyboardResult()

                if ( string.len( speedStr ) > 0 ) then 
                    local speed = tonumber( speedStr )

                    if ( speed < 999 and speed > 1 ) then 
                        TriggerEvent( 'wk:changeRadarLimit', speed )
                    end 

                    break
                else 
                    DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 4 )
                end 
            elseif ( UpdateOnscreenKeyboard() == 2 ) then 
                break 
            end  

            Citizen.Wait( 0 )
        end 
    end )
end 

function ResetFrontAntenna()
    if ( radarInfo.fwdXmit ) then 
        radarInfo.fwdSpeed = "000"
        radarInfo.fwdFast = "000"  
    else 
        radarInfo.fwdSpeed = "OFF"
        radarInfo.fwdFast = "   "  
    end 

    radarInfo.fwdDir = nil
    radarInfo.fwdFastSpeed = 0 
    radarInfo.fwdFastLocked = false 
end 

function ResetRearAntenna()
    if ( radarInfo.bwdXmit ) then
        radarInfo.bwdSpeed = "000"
        radarInfo.bwdFast = "000"
    else 
        radarInfo.bwdSpeed = "OFF"
        radarInfo.bwdFast = "   "
    end 

    radarInfo.bwdDir = nil
    radarInfo.bwdFastSpeed = 0 
    radarInfo.bwdFastLocked = false
end 

function ResetFrontFast()
    if ( radarInfo.fwdXmit ) then 
        radarInfo.fwdFast = "000"
        radarInfo.fwdFastSpeed = 0
        radarInfo.fwdFastLocked = false 

        SendNUIMessage( { lockfwdfast = false } )
    end 
end 

function ResetRearFast()
    if ( radarInfo.bwdXmit ) then 
        radarInfo.bwdFast = "000"
        radarInfo.bwdFastSpeed = 0
        radarInfo.bwdFastLocked = false 

        SendNUIMessage( { lockbwdfast = false } )
    end 
end 

function CloseRadarRC()
    SendNUIMessage({
        toggleradarrc = true
    })

    TriggerEvent( 'wk:toggleMenuControlLock', false )

    SetNuiFocus( false )
end 

function ToggleSpeedType()
    if ( radarInfo.speedType == "mph" ) then 
        radarInfo.speedType = "kmh"
        Notify( "~b~Speed type set to Km/h." )
    else 
        radarInfo.speedType = "mph"
        Notify( "~b~Speed type set to MPH." )
    end
end 

function ToggleLockBeep()
    if ( radarInfo.lockBeep ) then 
        radarInfo.lockBeep = false 
        Notify( "~b~Radar fast lock beep disabled." )
    else 
        radarInfo.lockBeep = true
        Notify( "~b~Radar fast lock beep enabled." )
    end    
end 

function GetVehSpeed( veh )
    if ( radarInfo.speedType == "mph" ) then 
        return GetEntitySpeed( veh ) * 2.236936
    else 
        return GetEntitySpeed( veh ) * 3.6
    end 
end 

function ManageVehicleRadar()
    if ( radarEnabled ) then 
        local ped = GetPlayerPed( -1 )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped and GetVehicleClass( vehicle ) == 18 ) then 
                -- Patrol speed 
                local vehicleSpeed = round( GetVehSpeed( vehicle ), 0 )

                radarInfo.patrolSpeed = FormatSpeed( vehicleSpeed )

                -- Rest of the radar options 
                local vehiclePos = GetEntityCoords( vehicle, true )
                local h = round( GetEntityHeading( vehicle ), 0 )

                -- Front Antenna 
                if ( radarInfo.fwdXmit ) then  
                    local forwardPosition = GetOffsetFromEntityInWorldCoords( vehicle, radarInfo.angles[ radarInfo.fwdMode ].x, radarInfo.angles[ radarInfo.fwdMode ].y, radarInfo.angles[ radarInfo.fwdMode ].z )
                    local fwdPos = { x = forwardPosition.x, y = forwardPosition.y, z = forwardPosition.z }
                    local _, fwdZ = GetGroundZFor_3dCoord( fwdPos.x, fwdPos.y, fwdPos.z + 500.0 )

                    if ( fwdPos.z < fwdZ and not ( fwdZ > vehiclePos.z + 1.0 ) ) then 
                        fwdPos.z = fwdZ + 0.5
                    end 

                    local packedFwdPos = vector3( fwdPos.x, fwdPos.y, fwdPos.z )
                    local fwdVeh = GetVehicleInDirectionSphere( vehicle, vehiclePos, packedFwdPos )

                    if ( DoesEntityExist( fwdVeh ) and IsEntityAVehicle( fwdVeh ) ) then 
                        local fwdVehSpeed = round( GetVehSpeed( fwdVeh ), 0 )

                        local fwdVehHeading = round( GetEntityHeading( fwdVeh ), 0 )
                        local dir = IsEntityInMyHeading( h, fwdVehHeading, 100 )

                        radarInfo.fwdSpeed = FormatSpeed( fwdVehSpeed )
                        radarInfo.fwdDir = dir 

                        if ( fwdVehSpeed > radarInfo.fastLimit and not radarInfo.fwdFastLocked ) then 
                            if ( radarInfo.lockBeep ) then 
                                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                            end 

                            radarInfo.fwdFastSpeed = fwdVehSpeed 
                            radarInfo.fwdFastLocked = true 

                            SendNUIMessage( { lockfwdfast = true } )
                        end 

                        radarInfo.fwdFast = FormatSpeed( radarInfo.fwdFastSpeed )

                        radarInfo.fwdPrevVeh = fwdVeh 
                    end
                end 

                -- Rear Antenna 
                if ( radarInfo.bwdXmit ) then 
                    local backwardPosition = GetOffsetFromEntityInWorldCoords( vehicle, radarInfo.angles[ radarInfo.bwdMode ].x, -radarInfo.angles[ radarInfo.bwdMode ].y, radarInfo.angles[ radarInfo.bwdMode ].z )
                    local bwdPos = { x = backwardPosition.x, y = backwardPosition.y, z = backwardPosition.z }
                    local _, bwdZ = GetGroundZFor_3dCoord( bwdPos.x, bwdPos.y, bwdPos.z + 500.0 )              

                    if ( bwdPos.z < bwdZ and not ( bwdZ > vehiclePos.z + 1.0 ) ) then 
                        bwdPos.z = bwdZ + 0.5
                    end

                    local packedBwdPos = vector3( bwdPos.x, bwdPos.y, bwdPos.z )                
                    local bwdVeh = GetVehicleInDirectionSphere( vehicle, vehiclePos, packedBwdPos )

                    if ( DoesEntityExist( bwdVeh ) and IsEntityAVehicle( bwdVeh ) ) then
                        local bwdVehSpeed = round( GetVehSpeed( bwdVeh ), 0 )

                        local bwdVehHeading = round( GetEntityHeading( bwdVeh ), 0 )
                        local dir = IsEntityInMyHeading( h, bwdVehHeading, 100 )

                        radarInfo.bwdSpeed = FormatSpeed( bwdVehSpeed )
                        radarInfo.bwdDir = dir 

                        if ( bwdVehSpeed > radarInfo.fastLimit and not radarInfo.bwdFastLocked ) then 
                            if ( radarInfo.lockBeep ) then 
                                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                            end 

                            radarInfo.bwdFastSpeed = bwdVehSpeed 
                            radarInfo.bwdFastLocked = true 

                            SendNUIMessage( { lockbwdfast = true } )
                        end 

                        radarInfo.bwdFast = FormatSpeed( radarInfo.bwdFastSpeed )

                        radarInfo.bwdPrevVeh = bwdVeh 
                    end  
                end  

                SendNUIMessage({
                    patrolspeed = radarInfo.patrolSpeed, 
                    fwdspeed = radarInfo.fwdSpeed, 
                    fwdfast = radarInfo.fwdFast, 
                    fwddir = radarInfo.fwdDir, 
                    bwdspeed = radarInfo.bwdSpeed, 
                    bwdfast = radarInfo.bwdFast, 
                    bwddir = radarInfo.bwdDir 
                })
            end 
        end 
    end 
end 

RegisterNetEvent( 'wk:radarRC' )
AddEventHandler( 'wk:radarRC', function()
    Citizen.Wait( 10 )

    TriggerEvent( 'wk:toggleMenuControlLock', true )

    SendNUIMessage({
        toggleradarrc = true
    })

    SetNuiFocus( true, true )
end )

RegisterNUICallback( "RadarRC", function( data, cb ) 
    -- Toggle Radar
    if ( data == "radar_toggle" ) then 
        TriggerEvent( 'wk:toggleRadar' )

    -- Front Antenna 
    elseif ( data == "radar_frontopp" and radarInfo.fwdXmit ) then
        radarInfo.fwdMode = "opp"
        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )
    elseif ( data == "radar_frontxmit" ) then 
        radarInfo.fwdXmit = not radarInfo.fwdXmit 
        ResetFrontAntenna()
        SendNUIMessage( { fwdxmit = radarInfo.fwdXmit } )

        if ( radarInfo.fwdXmit == false ) then 
            radarInfo.fwdMode = "none" 
        else 
            radarInfo.fwdMode = "same" 
        end 

        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )
    elseif ( data == "radar_frontsame" and radarInfo.fwdXmit ) then 
        radarInfo.fwdMode = "same"
        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )

    -- Rear Antenna 
    elseif ( data == "radar_rearopp" and radarInfo.bwdXmit ) then
        radarInfo.bwdMode = "opp"
        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )
    elseif ( data == "radar_rearxmit" ) then 
        radarInfo.bwdXmit = not radarInfo.bwdXmit 
        ResetRearAntenna()
        SendNUIMessage( { bwdxmit = radarInfo.bwdXmit } )

        if ( radarInfo.bwdXmit == false ) then 
            radarInfo.bwdMode = "none" 
        else 
            radarInfo.bwdMode = "same" 
        end 

        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )
    elseif ( data == "radar_rearsame" and radarInfo.bwdXmit ) then 
        radarInfo.bwdMode = "same"
        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )

    -- Set Fast Limit 
    elseif ( data == "radar_setlimit" ) then 
        CloseRadarRC()
        Radar_SetLimit()

    -- Speed Type 
    elseif ( data == "radar_speedtype" ) then 
        ToggleSpeedType()

    elseif ( data == "radar_lockbeep" ) then 
        ToggleLockBeep()

    -- Close 
    elseif ( data == "close" ) then 
        CloseRadarRC()
    end 

    if ( cb ) then cb( 'ok' ) end 
end )

Citizen.CreateThread( function()
    SetNuiFocus( false ) 

    while true do 
        ManageVehicleRadar()

        -- Only run 10 times a second, more realistic, also prevents spam 
        Citizen.Wait( 100 )
    end
end )

Citizen.CreateThread( function()
    while true do 
        local ped = GetPlayerPed( -1 )

        local inVeh = IsPedSittingInAnyVehicle( ped )
        local veh = nil 

        if ( inVeh ) then
            veh = GetVehiclePedIsIn( ped, false )
        end 

        if ( ( (not inVeh or (inVeh and GetVehicleClass( veh ) ~= 18)) and radarEnabled and not hidden) or IsPauseMenuActive() and radarEnabled ) then 
            hidden = true 
            SendNUIMessage( { hideradar = true } )
        elseif ( inVeh and GetVehicleClass( veh ) == 18 and radarEnabled and hidden ) then 
            hidden = false 
            SendNUIMessage( { hideradar = false } )
        end 

        Citizen.Wait( 0 )
    end 
end )


--[[------------------------------------------------------------------------
    Menu Control Lock - Prevents certain actions 
    Thanks to the authors of the ES Banking script. 
------------------------------------------------------------------------]]--
local locked = false 

RegisterNetEvent( 'wk:toggleMenuControlLock' )
AddEventHandler( 'wk:toggleMenuControlLock', function( lock ) 
    locked = lock 
end )

Citizen.CreateThread( function()
    while true do
        if ( locked ) then 
            local ped = GetPlayerPed( -1 )  

            DisableControlAction( 0, 1, true ) -- LookLeftRight
            DisableControlAction( 0, 2, true ) -- LookUpDown
            DisableControlAction( 0, 24, true ) -- Attack
            DisablePlayerFiring( ped, true ) -- Disable weapon firing
            DisableControlAction( 0, 142, true ) -- MeleeAttackAlternate
            DisableControlAction( 0, 106, true ) -- VehicleMouseControlOverride

            SetPauseMenuActive( false )
        end 

        Citizen.Wait( 0 )
    end 
end )


--[[------------------------------------------------------------------------
    Notify  
------------------------------------------------------------------------]]--
function Notify( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentSubstringPlayerName( text )
    DrawNotification( false, true )
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

