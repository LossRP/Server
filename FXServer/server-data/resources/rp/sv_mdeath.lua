--[[
Copyright © Julie Manlet // State of San Andreas

All rights reserved. 


No part of this script may be reproduced, distributed, or transmitted in any form or by any means. 
These include, but are not limited to: uploading, privately sharing, or other electronic methods without the prior written permission of the owner.
Please understand that there will be no exceptions, no matter the case.
If you have any questions, concerns or suggestions - please contact the SOSA Development Department.

v1.0

]]--


AddEventHandler('chatMessage', function(from,name,message)
	if(message:sub(1,1) == "/") then

		local args = stringsplit(message, " ")
		local cmd = args[1] 

		if (cmd == "/revive") then
			CancelEvent()

			if (args[2] ~= nil) then
				local playerID = tonumber(args[2])

				if(playerID == nil or playerID == 0 or GetPlayerName(playerID) == nil) then
					TriggerClientEvent('chatMessage', from, "Roleplay Death", {200,0,0} , "The PlayerID you attempted to revive is invalid!")
					return
				end

				TriggerClientEvent('manlet:allowRevive', playerID, from)

				TriggerClientEvent('chatMessage', from, "SOSA-REVIVE", {200,0,0} , "You have revived that PlayerID!")
			else
			end
		end
	end
end)


-- String splits by the separator.
function stringsplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
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