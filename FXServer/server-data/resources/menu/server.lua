RegisterServerEvent('showideee')
AddEventHandler('showideee', function(first, last, age, state)
    TriggerClientEvent('chatMessage', -1, 'DMV', {28, 107, 255}, "^3Name: ^7"..first.."  "..last.."  ^3Age: ^7"..age)
end)	

RegisterServerEvent("cuffNear")
AddEventHandler("cuffNear", function(id)

	print("cuffing "..id)
	TriggerClientEvent("cuff1", id)

end)


RegisterServerEvent('police:dragRequest')
AddEventHandler('police:dragRequest', function(t)
	TriggerClientEvent('police:toggleDrag', t, source)
end)

RegisterServerEvent('Cuff_close:getUnseatServer')
AddEventHandler('Cuff_close:getUnseatServer', function(t, v)
    TriggerClientEvent('Cuff_close:unseatme', t, v)
end)

RegisterServerEvent('Cuff_close:getSeatedServer')
AddEventHandler('Cuff_close:getSeatedServer', function(t)
    TriggerClientEvent('Cuff_close:forcedEnteringVeh', t)
end)

RegisterServerEvent('EMS_close:getUnseatServer')
AddEventHandler('EMS_close:getUnseatServer', function(t, v)
    TriggerClientEvent('EMS_close:unseatme', t, v)
end)

RegisterServerEvent('EMS_close:getSeatedServer')
AddEventHandler('EMS_close:getSeatedServer', function(t)
    TriggerClientEvent('EMS_close:forcedEnteringVeh', t)
end)

AddEventHandler('chatMessage', function(source, n, msg)
    local args = stringsplit(msg, ' ')
        
    if string.lower(args[1]) == "/emotes" then
        TriggerClientEvent("emote:display", source)
        CancelEvent()
    elseif string.lower(args[1]) == "/emote" then
        if args[2] ~= nil then
            TriggerClientEvent("emote:invoke", source, args[2])
        else
            TriggerClientEvent("chatMessage", source, "^1Emotes | Error", {255,0,0}, "^7Use \"^3/emotes^7\" to display all of the emotes")
        end
        CancelEvent()
    elseif string.lower(args[1]) == "/cancelemote" then
        TriggerClientEvent("emote:cancelnow", source)
        CancelEvent()
    end
end)

bacData = {} 
RegisterServerEvent("returnData")
AddEventHandler('returnData', function(id)
	RconPrint("Breathalyzing: "..id)
	if bacData[id] ~= nil then
		TriggerClientEvent("Breath", source, bacData[id])
	elseif bacData[id] == nil then
		TriggerClientEvent("Breath", source, "0.00")
	end
end)

RegisterServerEvent("setBac")
AddEventHandler("setBac", function(amount)

	TriggerClientEvent("Bac", source)
	bacData[source] = amount

end)












RegisterServerEvent("syncad1")
AddEventHandler('syncad1', function(inputText)
TriggerClientEvent('displayad1', -1, inputText)
end)

RegisterServerEvent("syncad2")
AddEventHandler('syncad2', function(inputText)
TriggerClientEvent('displayad2', -1, inputText)
end)

RegisterServerEvent("syncad3")
AddEventHandler('syncad3', function(inputText)
TriggerClientEvent('displayad3', -1, inputText)
end)

RegisterServerEvent("syncad4")
AddEventHandler('syncad4', function(inputText)
TriggerClientEvent('displayad4', -1, inputText)
end)

RegisterServerEvent("syncad5")
AddEventHandler('syncad5', function(inputText)
TriggerClientEvent('displayad5', -1, inputText)
end)

RegisterServerEvent("syncad6")
AddEventHandler('syncad6', function(inputText)
TriggerClientEvent('displayad6', -1, inputText)
end)

RegisterServerEvent("syncad7")
AddEventHandler('syncad7', function(inputText)
TriggerClientEvent('displayad7', -1, inputText)
end)

RegisterServerEvent("syncad8")
AddEventHandler('syncad8', function(inputText)
TriggerClientEvent('displayad8', -1, inputText)
end)

RegisterServerEvent("syncad9")
AddEventHandler('syncad9', function(inputText)
TriggerClientEvent('displayad9', -1, inputText)
end)

RegisterServerEvent("syncad10")
AddEventHandler('syncad10', function(inputText)
TriggerClientEvent('displayad10', -1, inputText)
end)

RegisterServerEvent("syncad11")
AddEventHandler('syncad11', function(inputText)
TriggerClientEvent('displayad11', -1, inputText)
end)

RegisterServerEvent("syncad12")
AddEventHandler('syncad12', function(inputText)
TriggerClientEvent('displayad12', -1, inputText)
end)

RegisterServerEvent("syncad13")
AddEventHandler('syncad13', function(inputText)
TriggerClientEvent('displayad13', -1, inputText)
end)

RegisterServerEvent("syncad14")
AddEventHandler('syncad14', function(inputText)
TriggerClientEvent('displayad14', -1, inputText)
end)

RegisterServerEvent("syncad15")
AddEventHandler('syncad15', function(inputText)
TriggerClientEvent('displayad15', -1, inputText)
end)

RegisterServerEvent("syncad16")
AddEventHandler('syncad16', function(inputText)
TriggerClientEvent('displayad16', -1, inputText)
end)

RegisterServerEvent("syncad17")
AddEventHandler('syncad17', function(inputText)
TriggerClientEvent('displayad17', -1, inputText)
end)

RegisterServerEvent("syncad18")
AddEventHandler('syncad18', function(inputText)
TriggerClientEvent('displayad18', -1, inputText)
end)

RegisterServerEvent("syncad19")
AddEventHandler('syncad19', function(inputText)
TriggerClientEvent('displayad19', -1, inputText)
end)

RegisterServerEvent("syncad20")
AddEventHandler('syncad20', function(inputText)
TriggerClientEvent('displayad20', -1, inputText)
end)

RegisterServerEvent("syncad21")
AddEventHandler('syncad21', function(inputText)
TriggerClientEvent('displayad21', -1, inputText)
end)

--[[
SERVER FUNCTIONS
]]--	
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

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
--[[
END OF SERVER FUNCTIONS
]]--	