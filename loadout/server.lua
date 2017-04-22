local commands = {}

-- Puts all available louadouts into a table, used later on
for command, _ in pairs(LOADOUTS) do
    table.insert(commands, command)
end

-- When the server recieved the playerSpawned event, give the player a loadout
-- If you don't want this, remove it
RegisterServerEvent("loadout:playerSpawned")
AddEventHandler("loadout:playerSpawned", function(spawn)
    TriggerEvent("loadout:doLoadout", source, "random")
end)

--[[
The main loadout event, gives the player a loadout that is defined in the loadouts file
player : int - The player's server ID (used to send events to them)
loadoutName : string - The loadout to give (index for the loadout in the loadout file)

E.g.
TriggerEvent("loadout:doLoadout", -1, "random") - will give all players the "random" loadout
TriggerEvent("loadout:doLoadout", 1, "cop") - will give the first player "cop" loadout
]]
RegisterServerEvent("loadout:doLoadout")
AddEventHandler("loadout:doLoadout", function(player , loadoutName)
    math.randomseed(os.time()) -- Apparently people have been having issues when random isn't seeded.

    print("changing " .. player)
    local loadout = LOADOUTS[loadoutName]
    local skins, weapons, spawns

    if not loadout then
        print("-------------------------------------")
        print("LOADOUT ERROR: Loadout with the index '" .. loadoutName .. "' doesn't exist")
        print("-------------------------------------")
        return -- We don't want to continue, loadout doesn't exist
    end

    if not loadout.skins then
        print("Loadouts: No skins found.. Leaving empty")
        skins = {}
    else
        skins = loadout.skins
    end

    if not loadout.weapons then
        print("Loadouts: No weapons found.. Leaving empty")
        weapons = {}
    else
        weapons = loadout.weapons
    end

    --  LOADOUT SKINS
    -- Choose a random skin from the skins provided
    local sIdx = math.random(1, (#skins or 0) +1)
    local skin = skins[sIdx]
    -- If the skin is nil, the client will pick this up and fail.

    --print( "------- GOT SKIN: " .. skin .. " --------")
    -- Change their skin
    TriggerClientEvent("loadout:changeSkin", player, skin)


    -- LOADOUT WEAPONS
    -- Give them their weapons (if they have any)
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

    -- LOADOUT SPAWNS

    if not loadout.spawnPos then
        print("Loadouts: No spawn points found.. Leaving empty")
        spawns = nil
    else
        spawns = loadout.spawnPos
    end

    -- If the loadout has a "spawn" then ppick random and teleport the player there.
    if spawns ~= nil then
        local spawnIndex = math.random(1, (#spawns or 0) + 1)

        print("Random spawn = " .. spawnIndex)

        local spawn = spawns[spawnIndex]

        TriggerClientEvent("loadout:position", player, spawn)
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
