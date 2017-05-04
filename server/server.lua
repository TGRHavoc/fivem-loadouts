
-- When the server recieved the playerSpawned event, give the player a loadout
-- If you don't want this, remove it
RegisterServerEvent("loadout:playerSpawned")
AddEventHandler("loadout:playerSpawned", function(spawn)
    TriggerEvent("loadout:doLoadout", source, "random", {})
end)

RegisterServerEvent("loadout:saveLoadout")
AddEventHandler("loadout:saveLoadout", function(d)
    print("---------------------")
    print("LOADOUTS: Cannot save. Feature is not yet done!")
    print("---------------------")
    return
end)

AddEventHandler("loadout:loadFromDatabase", function(playerId)
    print("---------------------")
    print("LOADOUTS: Cannot load. Feature is not enabled on the server!")
    print("---------------------")
    return
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
