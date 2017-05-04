local commands = {}

-- Puts all available louadouts into a table, used later on
for command, _ in pairs(LOADOUTS) do
    table.insert(commands, command)
end

function stringsplit(str, delimiter)
    local a = str:Split(delimiter)
    local t = {}

    for i = 0, #a - 1 do
        table.insert(t, a[i])
    end

    return t
end

TriggerEvent("chatMessage", function(source, n, message)

    if  (string.sub(message, 1, string.len(message)) ~= "/") then
        print("not a command")
        return
    end

    local args = stringsplit(message, " ")
    args[1] = string.gsub(args[1], "/", "")

    if (args[1] ~= "loadouts") then
        print("not our loadout command")
        return
    end

    -- it's a loadout command..
    CancelEvent()

    if #args > 1 then
        local arg = args[2]
        -- Check the commands first (e.g. help)
        if arg == "help" then
            local availableCommands = {}
            for command in pairs(commands) do
                table.insert(availableCommands, commands[command])
            end
            -- Send the translated messages to the player in chat
            TriggerClientEvent("loadout:translateChatMessage", source, "available_loadouts", SETTINGS["chat_colour"], {#availableCommands})
            TriggerClientEvent("loadout:chatMessage", source, SETTINGS["chat_colour"], table.concat(availableCommands, ", "))

        elseif arg == "save" then

            TriggerClientEvent("loadout:translateChatMessage", source, "save_disabled", SETTINGS["chat_colour"], {})

        elseif arg == "load" then

            TriggerClientEvent("loadout:translateChatMessage", source, "save_disabled", SETTINGS["chat_colour"], {})

        elseif LOADOUTS[arg] then -- It's a loadout :D
            -- Do loadout
            local loadout = LOADOUTS[arg]

            print("checking permission levels")
            print("executing command..." .. tostring(loadout.skins) .. " " .. tostring(loadout.weapons))

            TriggerEvent("loadout:doLoadout", source, arg, {})

            --TriggerClientEvent("loadout:missiontext", source, "You have been given the loadout " .. loadout.name, 5000)
            TriggerClientEvent("loadout:translateSubtitle", source, "loadout_given", 5000, {loadout.name})
            --[[
            -- They don't have permission
            print("no permission")
            --TriggerClientEvent("loadout:missiontext", source, "You do not have permission for the " .. loadout.name .. " loadout", 5000)
            TriggerClientEvent("loadout:translateSubtitle", source, "no_permission", 5000, {loadout.name})
            ]]

        else -- Not a valid command or loadout

        end
    else

        TriggerClientEvent("loadout:translateChatMessage", source, "help_1", SETTINGS[colour], {})
        TriggerClientEvent("loadout:translateChatMessage", source, "help_2", SETTINGS[colour], {})

        TriggerClientEvent("loadout:translateChatMessage", source, "help_3", SETTINGS[colour], {})
        TriggerClientEvent("loadout:translateChatMessage", source, "help_4", SETTINGS[colour], {})
    end
end)
