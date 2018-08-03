function DrawText2(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

	
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		 if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		 	x = 1.000
			y = 0.950
			vehicleHud()
		 elseif not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			x = 1.000
			y = 0.970
		 end
	end
end)

	
-- Use the following variable(s) to adjust the color(s) of each element.
	-- Use the following variables to adjust the color of the border around direction.
	border_r = 255
	border_g = 255
	border_b = 255
	border_a = 100
	
	-- Use the following variables to adjust the color of the direction user is facing.
	dir_r = 255
	dir_g = 255
	dir_b = 255
	dir_a = 255
	
	-- Use the following variables to adjust the color of the street user is currently on.
	curr_street_r = 191
	curr_street_g = 10
	curr_street_b = 48
	curr_street_a = 255
	
	-- Use the following variables to adjust the color of the street around the player. (this will also change the town the user is in)
	str_around_r = 255
	str_around_g = 255 
	str_around_b = 255
	str_around_a = 255
	
	-- Use the following variables to adjust the color of the city the player is in (without there being a street around them)
	town_r = 255
	town_g = 255
	town_b = 255
	town_a = 255
	
function vehicleHud()
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
	local plate = GetVehicleNumberPlateText(veh)
	local rpm = math.ceil(GetVehicleCurrentRpm(veh) * 11) - 1
	local mph = math.ceil(GetEntitySpeed(veh) * 2.23)
	local gear = GetVehicleCurrentGear(veh)
	if ( gear == 0 ) then 
	gear = "~r~R"
	end
	DrawText2(0.67195, 1.430, 1.0,1.0,0.45, string.format("Plate: ~w~%s~s~ | RPM: ~w~%sX ~s~| MPH: ~w~%s ~s~| Gear: ~w~%s",plate,rpm,mph,gear), 191,10,48,205)
	
end

t = true
function GetTimeAndMinutes()
	
	gethour=GetClockHours()
	getmins=GetClockMinutes()

	local y,mo,d,h,m,s=GetLocalTime()

	minz=""
		if(getmins<=9)then
			minz="0"
		end
	
	local hour=h
		if(h>12)then
			hour=h-12
		end
		if(h==0)then
			hour="12"
		end
	
	local period="AM"
		if(h>=12)then
			period="PM"
		end

	local minutes=m
		if(m<10)then
			minutes="0"..m..""
		end
	
	
	if(t)then
		drawTDMFPS(string.format("Time:          | ~w~%s~s~/~w~%s~s~/~w~%s~s~ | AOP:",d,mo,y),1500,12.5,0.46,true,4,191,10,48,205) -- puts the whole thing in the desired location, drawT is a funciton below		
		drawTDMFPS2(string.format("~w~%s:~w~%s%s~s~",gethour,minz,getmins),1600,12.5,0.46,true,4,191,10,48,205) -- puts the whole thing in the desired location, drawT is a funciton below
	end
end
Citizen.CreateThread(function()
	while true do
		Wait(0)
	
		local ped_l=GetPlayerPed(-1)
	
		if(DoesEntityExist(ped_l))then
			GetTimeAndMinutes()
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Wait(1000)

		local fpscounter=math.floor(1.0/GetFrameTime())
		fps=fpscounter	
	end
end)
function drawTDMFPS(text, x, y, size, center, font, r, g, b, a)
local resx,resy=GetScreenResolution() -- determines resoultion using native
	SetTextFont(font)
	SetTextScale(size,size)
	SetTextProportional(true)
	SetTextColour(r,g,b,a)
	SetTextCentre(center)
	SetTextDropshadow(0,0,0,0,0)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.226, 0.955) 
end

function drawTDMFPS2(text, x, y, size, center, font, r, g, b, a)
local resx,resy=GetScreenResolution() -- determines resoultion using native
	SetTextFont(font)
	SetTextScale(size,size)
	SetTextProportional(true)
	SetTextColour(r,g,b,a)
	SetTextCentre(center)
	SetTextDropshadow(0,0,0,0,0)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.205, 0.955) 
end

function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end



	
	
