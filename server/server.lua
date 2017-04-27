local commands = {}

-- Puts all available louadouts into a table, used later on
for command, _ in pairs(LOADOUTS) do
    table.insert(commands, command)
end

if SETTINGS["enable_database"] then
    print("STARTING CONNECTION")
    -- Set up MySql connection
    require "resources/essentialmode/lib/MYSQL"
    print("Opening connection with " .. SETTINGS["database"].ip)
    MySQL:open(SETTINGS["database"].ip, SETTINGS["database"].database, SETTINGS["database"].username, SETTINGS["database"].password)
end


-- When the server recieved the playerSpawned event, give the player a loadout
-- If you don't want this, remove it
RegisterServerEvent("loadout:playerSpawned")
AddEventHandler("loadout:playerSpawned", function(spawn)
    TriggerEvent("loadout:doLoadout", source, "random", {})

    --[[
    Uncomment the line below and remove the line above to load the player's
    loadout from the database when they spawn
    ]]
    -- TriggerEvent("loadout:loadFromDatabase", source)

    local defaultLang = SETTINGS["default_lang"]

    if not defaultLang then
        print("---------------------")
        print("LOADOUTS: No default language found.. Defaulting to English (gb)!")
        print("---------------------")
        defaultLang = "gb"
    end

    -- Load the player's prefered language?
    TriggerEvent("loadout:playerRequestLanguageFile", source, defaultLang)
end)

RegisterServerEvent("loadout:requestLanguageFile")
AddEventHandler("loadout:requestLanguageFile", function(languageCode)
    TriggerEvent("loadout:playerRequestLanguageFile", source, languageCode)
end)

AddEventHandler("loadout:playerRequestLanguageFile", function(id, languageCode)

    local langFile = io.open("resources/" .. GetInvokingResource() .. "/languages/" .. languageCode .. ".json", "r")

    if langFile == nil then
        print("Error lang: " .. tostring(langFile))
    else
        print("Found language file..")
        local text = langFile:read('*a')
        local json = json.decode(text)
        print("sending: " .. tostring(json) .. " to " .. id)
        TriggerClientEvent("loadout:loadLanguageFile", id, languageCode, json)
    end

    langFile:close()
end)

RegisterServerEvent("loadout:saveLoadout")
AddEventHandler("loadout:saveLoadout", function(d)
    if not SETTINGS["enable_database"] then
        print("---------------------")
        print("LOADOUTS: Cannot save. Feature is not enabled on the server!")
        print("---------------------")
        return
    end

    local fields = {"identifier", "loadout_name", "hair", "haircolour", "torso", "torsotexture", "torsoextra", "torsoextratexture", "pants", "pantscolour", "shoes", "shoescolour", "bodyaccessory"}
    local newData = {}

    for k,v in pairs(d) do
        newData["@" .. k .. "_data"] = v
    end

    TriggerEvent("es:getPlayerFromId", source, function(user)
        newData["@id"] = user.identifier

        local getCurrentQuery = MySQL:executeQuery("SELECT * FROM loadouts WHERE identifier = '@id'", {["@id"] = user.identifier})
        local result = MySQL:getResults(getCurrentQuery, fields, "identifier")

        if result[1] == nil then
            -- Insert
            MySQL:executeQuery("INSERT INTO loadouts (`identifier`, `loadout_name`, `hair`, `haircolour`, `torso`, `torsotexture`, `torsoextra`, `torsoextratexture`, `pants`, `pantscolour`, `shoes`, `shoescolour`, `bodyaccessory`) " ..
                                "VALUES ('@id', '@loadout_name_data', @hair_data, @haircolour_data, @torso_data, @torsotexture_data, @torsoextra_data, @torsoextratexture_data, @pants_data, @pantscolour_data, @shoes_data, @shoescolour_data, @bodyaccessory_data)",
                                newData)
        else
            -- update
            MySQL:executeQuery("UPDATE loadouts SET `loadout_name`='@loadout_name_data', `hair`='@hair_data', `haircolour`='@haircolour_data', `torso`='@torso_data', `torsotexture`='@torsotexture_data', `torsoextra`='@torsoextra_data', `torsoextratexture`='@torsoextratexture_data', `pants`='@pants_data', `pantscolour`='@pantscolour_data', `shoes`='@shoes_data', `shoescolour`='@shoescolour_data', `bodyaccessory`='@bodyaccessory_data' WHERE identifier='@id'",
                newData)
        end

        TriggerClientEvent("chatMessage", source, "Loadouts", {255, 255, 255}, "Successfully saved your loadout!")
    end)
end)

AddEventHandler("loadout:loadFromDatabase", function(playerId)
    if not SETTINGS["enable_database"] then
        print("---------------------")
        print("LOADOUTS: Cannot load. Feature is not enabled on the server!")
        print("---------------------")
        return
    end

    local fields = {"identifier", "loadout_name", "hair", "haircolour", "torso", "torsotexture", "torsoextra", "torsoextratexture", "pants", "pantscolour", "shoes", "shoescolour", "bodyaccessory"}

    TriggerEvent("es:getPlayerFromId", playerId, function(user)

        local getCurrentQuery = MySQL:executeQuery("SELECT * FROM loadouts WHERE identifier = '@id'", {["@id"] = user.identifier})
        local result = MySQL:getResults(getCurrentQuery, fields, "identifier")

        if result[1] == nil then
            TriggerClientEvent("chatMessage", playerId, "Loadouts", {255, 255, 255}, "Sorry, you don't have any loadouts saved.")
        else
            --Load them up!
            local r = result[1]

            TriggerEvent("loadout:doLoadout", playerId, r.loadout_name, r) -- Force our variance

            ---TriggerClientEvent("loadout:loadVariants", playerId, r, 1000)
        end

    end)

end)

--[[
The main loadout event, gives the player a loadout that is defined in the loadouts file
player : int - The player's server ID (used to send events to them)
loadoutName : string - The loadout to give (index for the loadout in the loadout file)

E.g.
TriggerEvent("loadout:doLoadout", -1, "random") - will give all players the "random" loadout
TriggerEvent("loadout:doLoadout", 1, "cop") - will give the first player "cop" loadout
]]
AddEventHandler("loadout:doLoadout", function(player , loadoutName, forcedVariance)
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

    if next(forcedVariance) == nil then
        print("setting forcedVariance to nil")
        forcedVariance = nil
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
            delay = 1000 -- 1 second
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

    -- UNIQUE CHARACTERS
    local makeUnique = false
    if loadout.randomize then
        makeUnique = true
    end

    if (makeUnique and forcedVariance == nil) then
        TriggerEvent("es:getPlayerFromId", player, function(user)
            local delay = nil
            if skin ~= nil then
                delay = 1000 -- 1 sec
            end

            TriggerClientEvent("loadout:setRandomSeed", player, user.identifier) -- Make sure the seed has been set

            TriggerClientEvent("loadout:makeUnique", player, delay) -- Randomize the character
        end)
    elseif (forcedVariance ~= nil) then
        print("Forcing variance")
        -- Force it!
        local delay = nil
        if skin ~= nil then
            delay = 1000 -- 1 sec
        end
        TriggerClientEvent("loadout:loadVariants", player, forcedVariance, delay)
    end

    -- Make sure the data on client is updated
    TriggerClientEvent("loadout:playerLoadoutChanged", source, loadoutName)
end)
