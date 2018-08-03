-- CONFIG --

-- The watermark text --

servername = "~n~~n~Discord: ~w~discord.gg/fAYRnpa ~n~ ~s~VSRP ~w~VSRP.com"

-- The x and y offset (starting at the top left corner) --
-- Default: 0.005, 0.001
offset = {x = 0.173, y = 0.77}

-- Text RGB Color --
-- Default: 64, 64, 64 (gray)
rgb = {r = 191, g = 10, b = 48}
-- Text transparency --
-- Default: 255
alpha = 205

-- Text scale
-- Default: 0.4
-- NOTE: Number needs to be a float (so instead of 1 do 1.0)
scale = 0.45
-- Text Font --
-- 0 - 5 possible
-- Default: 1
font = 0
-- Rainbow Text --
-- false: Turn off
-- true: Activate rainbow text (overrides color)
bringontherainbows = false

-- CODE --
Citizen.CreateThread(function()
	while true do
		Wait(1)

		if bringontherainbows then
			rgb = RGBRainbow(1)
		end
		
		SetTextColour(rgb.r, rgb.g, rgb.b, alpha)

		SetTextFont(4)
		SetTextScale(scale, scale)
		SetTextProportional(0)
		SetTextCentre(false)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(2, 0, 0, 0, 255)
		SetTextEntry("STRING")
		SetTextOutline()
		AddTextComponentString(servername)
		DrawText(offset.x, offset.y)
	end
end)





-- By ash
function RGBRainbow(frequency)
    local result = {}
    local curtime = GetGameTimer() / 1000

    result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
    result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
    result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

    return result
end