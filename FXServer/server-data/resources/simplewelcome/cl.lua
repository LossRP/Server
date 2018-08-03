AddEventHandler("playerSpawned", function(spawn)
    Citizen.Wait(5000)
    TriggerEvent("chatMessage", "", { 49, 196, 157 }, "Welcome to Virginia State RP.\nType /respawn to teleport to AOP\nJoin our discord at ^1http://discord.gg/WdNy86N")
end)
