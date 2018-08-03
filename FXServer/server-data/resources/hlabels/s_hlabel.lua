-- Range Close
TriggerEvent('es:addGroupCommand', 'hlrangec', "mod", function(source, name, message)
	TriggerClientEvent('DisCLS', source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Your headlabel range has been set to: [ CLOSE ]")
	end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient permissions!")
end)


-- Range Medium
TriggerEvent('es:addGroupCommand', 'hlrangem', "mod", function(source, name, message)
	TriggerClientEvent('DisMDM', source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Your headlabel range has been set to: [ MEDIUM ]")
	end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient permissions!")
end)

-- Range Far
TriggerEvent('es:addGroupCommand', 'hlrangef', "mod", function(source, name, message)
	TriggerClientEvent('DisFAR', source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Your headlabel range has been set to: [ FAR ]")
	end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient permissions!")
end)

-- Labels OFF ALL
TriggerEvent('es:addGroupCommand', 'hldisable', "superadmin", function(source, name, message)
	TriggerClientEvent('hlDIS', -1)
	TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, "^1Headlabels have been disabled.")
	end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient permissions!")
end)

-- Labels ON ALL
TriggerEvent('es:addGroupCommand', 'hlenable', "superadmin", function(source, name, message)
	TriggerClientEvent('hlEN', -1)
	TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, "^1Headlabels have been enabled.")
	end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient permissions!")
end)

-- Labels OFF Client
TriggerEvent('es:addGroupCommand', 'hloff', "user", function(source, name, message)
	TriggerClientEvent('hlDIS', source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "^1Headlabels have been disabled.")
	end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient permissions!")
end)

-- Labels ON Client
TriggerEvent('es:addGroupCommand', 'hlon', "user", function(source, name, message)
	TriggerClientEvent('hlEN', source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "^1Headlabels have been enabled.")
	end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient permissions!")
end)