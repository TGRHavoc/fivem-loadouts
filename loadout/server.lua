local commands = {}

for command, _ in pairs(LOADOUTS) do
    table.insert(commands, command)
end

RegisterServerEvent("loadout:playerSpawned")
AddEventHandler("loadout:playerSpawned", function(spawn)
    TriggerEvent("loadout:doLoadout", source, "random")
end)

RegisterServerEvent("loadout:doLoadout")
AddEventHandler("loadout:doLoadout", function(player, loadoutName)
    print("changing " .. player)
    local loadout = LOADOUTS[loadoutName]
    local skins, weapons

    if not loadout.skins then
        skins = {}
    else
        skins = loadout.skins
    end

    if not loadout.weapons then
        weapons = {}
    else
        weapons = loadout.weapons
    end

    local sIdx = math.random(1, (#skins or 0) +1)
    local skin = skins[sIdx] -- Choose a random skin
    --print( "------- GOT SKIN: " .. skin .. " --------")
    TriggerClientEvent("loadout:changeSkin", player, skin)

    if weapons then
        local delay = nil
        if skin ~= nil then
            delay = 2000
        end

        for wIdx = 1, #weapons do
            --print("giving weapon " .. weapons[wIdx] .. " with delay " .. tostring(delay))
            TriggerClientEvent("loadout:giveWeapon", player, weapons[wIdx], delay)
        end
    end
end)

TriggerEvent("es:addCommand", "loadout", function(source, args, user)
    if #args > 1 then
        local arg = args[2]

        if LOADOUTS[arg] then
            -- Do loadout
            local loadout = LOADOUTS[arg]

            print("checking permission levels")
            if user.permission_level >= (loadout.permission_level or 0) then
                print("executing command..." .. tostring(loadout.skins) .. " " .. tostring(loadout.weapons))

                TriggerEvent("loadout:doLoadout", source, arg)
                TriggerClientEvent("loadout:missiontext", source, "You have been given the loadout " .. loadout.name, 5000)

                return
            end

            -- They don't have permission
            print("no permission")
            TriggerClientEvent("loadout:missiontext", source, "You do not have permission for the " .. loadout.name .. " loadout", 5000)

        else
            -- TODO: Other commands? e.g. /loadout help
            if arg == "help" then
                local availableCommands = {}
                for command in pairs(commands) do
                    local permission = LOADOUTS[commands[command]].permission_level
                    if user.permission_level >= (permission or 0) then
                        table.insert(availableCommands, commands[command])
                    end
                end

                TriggerClientEvent('chatMessage', source, "Loadouts", {255, 255, 255}, "There are " .. #availableCommands .. " loadouts to choose from.")
                TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, table.concat(availableCommands, ", "))
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "Loadouts", {255, 255, 255}, "Use /loadout <id> to pick a loadout.")
        TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Use /loadout help to get a list of available loadouts.")
    end
end)
