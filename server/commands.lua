local commands = {}

-- Puts all available louadouts into a table, used later on
for command, _ in pairs(LOADOUTS) do
    table.insert(commands, command)
end

TriggerEvent("es:addCommand", "loadout", function(source, args, user)
    if #args > 1 then
        local arg = args[2]
        -- Check the commands first (e.g. help)
        if arg == "help" then
            local availableCommands = {}
            for command in pairs(commands) do
                local permission = LOADOUTS[commands[command]].permission_level
                if user.permission_level >= (permission or 0) then
                    table.insert(availableCommands, commands[command])
                end
            end
            -- Send the translated messages to the player in chat
            TriggerClientEvent("loadout:translateChatMessage", source, "available_loadouts", SETTINGS["chat_colour"], {#availableCommands})
            TriggerClientEvent("loadout:chatMessage", source, SETTINGS["chat_colour"], table.concat(availableCommands, ", "))

            --TriggerClientEvent('chatMessage', source, "Loadouts", {255, 255, 255}, "There are " .. #availableCommands .. " loadouts to choose from.")
            --TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, table.concat(availableCommands, ", "))
        elseif arg == "save" then

            if SETTINGS["enable_database"] then
                TriggerClientEvent("loadout:saveLoadout", source)
            else
                --TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Sorry, the save feature is turned off on this server.")
                TriggerClientEvent("loadout:translateChatMessage", source, "save_disabled", SETTINGS["chat_colour"], {})
            end

        elseif arg == "test" then
            print("test created by " .. source)
            TriggerEvent("loadout:playerRequestLanguageFile", source, args[3])

        elseif arg == "load" then
            if not SETTINGS["enable_database"] then
                --TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Sorry, the save feature is turned off on this server.")
                TriggerClientEvent("loadout:translateChatMessage", source, "save_disabled", SETTINGS["chat_colour"], {})
            else
                -- TODO: Load loadout
                TriggerEvent("loadout:loadFromDatabase", source)
            end

        elseif LOADOUTS[arg] then -- It's a loadout :D
            -- Do loadout
            local loadout = LOADOUTS[arg]

            print("checking permission levels")
            if user.permission_level >= (loadout.permission_level or 0) then
                print("executing command..." .. tostring(loadout.skins) .. " " .. tostring(loadout.weapons))

                TriggerEvent("loadout:doLoadout", source, arg, {})

                --TriggerClientEvent("loadout:missiontext", source, "You have been given the loadout " .. loadout.name, 5000)
                TriggerClientEvent("loadout:translateSubtitle", source, "loadout_given", 5000, {loadout.name})
                return
            end

            -- They don't have permission
            print("no permission")
            --TriggerClientEvent("loadout:missiontext", source, "You do not have permission for the " .. loadout.name .. " loadout", 5000)
            TriggerClientEvent("loadout:translateSubtitle", source, "no_permission", 5000, {loadout.name})
        else -- Not a valid command or loadout

        end
    else

        TriggerClientEvent("loadout:translateChatMessage", source, "help_1", SETTINGS[colour], {})
        TriggerClientEvent("loadout:translateChatMessage", source, "help_2", SETTINGS[colour], {})

        TriggerClientEvent("loadout:translateChatMessage", source, "help_3", SETTINGS[colour], {})
        TriggerClientEvent("loadout:translateChatMessage", source, "help_4", SETTINGS[colour], {})

        --[[
        TriggerClientEvent('chatMessage', source, "Loadouts", {255, 255, 255}, "Use /loadout <id> to pick a loadout.")
        TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Use /loadout help to get a list of available loadouts.")

        TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Use /loadout save to save your current loadout.")
        TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Use /loadout load to load your loadout.")
        ]]
    end
end)
