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

            TriggerClientEvent('chatMessage', source, "Loadouts", {255, 255, 255}, "There are " .. #availableCommands .. " loadouts to choose from.")
            TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, table.concat(availableCommands, ", "))
        elseif arg == "save" then

            if SETTINGS["enable_database"] then
                TriggerClientEvent("loadout:saveLoadout", source)
            else
                TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Sorry, the save feature is turned off on this server.")
            end

        elseif arg == "load" then
            if not SETTINGS["enable_database"] then
                TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Sorry, the save feature is turned off on this server.")
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
                TriggerClientEvent("loadout:missiontext", source, "You have been given the loadout " .. loadout.name, 5000)
                return
            end

            -- They don't have permission
            print("no permission")
            TriggerClientEvent("loadout:missiontext", source, "You do not have permission for the " .. loadout.name .. " loadout", 5000)
        else -- Not a valid command or loadout

        end
    else
        TriggerClientEvent('chatMessage', source, "Loadouts", {255, 255, 255}, "Use /loadout <id> to pick a loadout.")
        TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Use /loadout help to get a list of available loadouts.")

        TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Use /loadout save to save your current loadout.")
        TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Use /loadout load to load your loadout.")
    end
end)
