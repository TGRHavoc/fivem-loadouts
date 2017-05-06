local validTorso = {}
local validUnder = {}
local seedSet = false

local options = {
    {
        id = 2,
        name = "hair",
        t = 'drawable',
        max = function()
            return GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 2)
        end
    },
    {
        id = 2,
        t = 'texture',
        name = "haircolour",
        max = function()
            return GetNumberOfPedTextureVariations(GetPlayerPed(-1), 2, GetPedDrawableVariation(GetPlayerPed(-1), 2)) - 1
        end
    },
    {
        id = 4, -- old = 3
        name = "torso",
        t = 'drawable',
        max = function()
            local am = 0
            for i = 0,GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 3) do
                if IsPedComponentVariationValid(GetPlayerPed(-1), 3, i, 2) then
                    am = am + 1
                    validTorso[am] = i
                end
            end
            return am
        end
    },
    {
        id = 3,
        name = "torsotexture",
        t = 'texture',
        max = function()
            return GetNumberOfPedTextureVariations(GetPlayerPed(-1), 3, GetPedDrawableVariation(GetPlayerPed(-1), 3)) - 1
        end
    },
    {
        id = 6, -- old 11
        name = "torsoextra",
        t = 'drawable',
        max = function()
            return GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 11)
        end
    },
    {
        id = 11,
        name = "torsoextratexture",
        t = 'texture',
        max = function()
            return GetNumberOfPedTextureVariations(GetPlayerPed(-1), 11, GetPedDrawableVariation(GetPlayerPed(-1), 11)) - 1
        end
    },
    {
        id = 8, -- old = 4
        name = "pants",
        t = 'drawable',
        max = function()
            return GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 4)
        end
    },
    {
        id = 4,
        name = "pantscolour",
        t = 'texture',
        max = function()
            return GetNumberOfPedTextureVariations(GetPlayerPed(-1), 4, GetPedDrawableVariation(GetPlayerPed(-1), 4)) - 1
        end
    },
    {
        id = 10, -- old = 6
        name = "shoes",
        t = 'drawable',
        max = function()
            return GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 6)
        end
    },
    {
        id = 6,
        name = "shoescolour",
        t = 'texture',
        max = function()
            return GetNumberOfPedTextureVariations(GetPlayerPed(-1), 6, GetPedDrawableVariation(GetPlayerPed(-1), 6)) - 1
        end
    },
    {
        id = 7, -- 11
        name = "bodyaccessory",
        t = 'drawable',
        max = function()
            local am = 0
            for i =0, GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 7) do
                if IsPedComponentVariationValid(GetPlayerPed(-1), 7, i, 2) then
                    am = am + 1
                    validUnder[am] = i

                end
            end
            return am
        end
    },
    {
        id = 8, -- 12
        name = "undershirt",
        t = 'drawable',
        max = function()
            return GetNumberOfPedDrawableVariations(GetPlayerPed(-1),  8)
        end
    },
    {
        id = 9, -- 13
        name = "armor",
        t = 'drawable',
        max = function()
            return GetNumberOfPedDrawableVariations(GetPlayerPed(-1),  9)
        end
    }
}

local userData = {
    ["loadout_name"] = nil,
    ["hair"] = -1,
    ["haircolour"] = -1,
    ["torso"] = -1,
    ["torsotexture"] = -1,
    ["torsoextra"] = -1,
    ["torsoextratexture"] = -1,
    ["pants"] = -1,
    ["pantscolour"] = -1,
    ["shoes"] = -1,
    ["shoescolour"] = -1,
    ["bodyaccessory"] = -1
}

function initValids()
    local am = 0
    for i = 0,GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 3) do
        if IsPedComponentVariationValid(GetPlayerPed(-1), 3, i, 2) then
            am = am + 1
            validTorso[am] = i
        end
    end
    am = 0
    for i =0, GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 7) do
        if IsPedComponentVariationValid(GetPlayerPed(-1), 7, i, 2) then
            am = am + 1
            validUnder[am] = i
        end
    end
end

-- LOADOUT EVENTS
RegisterNetEvent("loadout:playerLoadoutChanged")
AddEventHandler("loadout:playerLoadoutChanged", function(newLoadout)
    userData["loadout_name"] = newLoadout
end)

RegisterNetEvent("loadout:changeSkin")
AddEventHandler("loadout:changeSkin", function(skinName)
    if skinName == nil then
        Citizen.Trace("skin was null.\n")
        return
    end

    Citizen.CreateThread(function()
        local model = GetHashKey(skinName)

        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            RequestModel(model)
            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
    end)
end)

RegisterNetEvent("loadout:giveWeapon")
AddEventHandler("loadout:giveWeapon", function(name, delayTime)
    if delayTime == nil then
        delayTime = 0
    end

    Citizen.CreateThread(function()
        Wait(delayTime)
        local hash = GetHashKey(name)
        GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false)
    end)
end)

RegisterNetEvent("loadout:position")
AddEventHandler("loadout:position", function(position)
    if position == nil then
        return
    end
    SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z)
end)

RegisterNetEvent("loadout:setRandomSeed")
AddEventHandler("loadout:setRandomSeed", function(identifier)
    if seedSet then
        return
    end

    local numbers = string.match(identifier, "[0-9]+") -- Grab the first set of numbers
    --[[
    Note: The above "number" won't be unique for non-steam users with the same IP
    ]]
    math.randomseed( tonumber(numbers) )

    Citizen.Trace("randomseed = " .. numbers)
    initValids()
    seedSet = true
end)

RegisterNetEvent("loadout:makeUnique")
AddEventHandler("loadout:makeUnique", function(delay)
    if delay == nil then
        delay = 0
    end
    -- Ped variation shit wants to be on it's own thread :(
    Citizen.CreateThread(function()
        Wait(delay)

        for k,v in pairs(options) do
            local changed = false
            local changedTo = nil

            if (options[k].t == "drawable") then
                local id = options[k].id
                local max = options[k].max()
                --Citizen.Trace("Trying to customize " .. options[k].name .. "( " .. max .. " posibilities)")

                if (max > 0) then
                    local randomNumber = math.random(1, max)
                    Citizen.Trace("Randomized " .. options[k].name .. " (" .. randomNumber .. "/" .. max ..")")

                    if (options[k].name == "torso") then
                        if IsPedComponentVariationValid(GetPlayerPed(-1), id, validTorso[randomNumber], 2) then
                            --Citizen.Trace("The random value is valid :D")
                            SetPedComponentVariation(GetPlayerPed(-1), id,  validTorso[randomNumber], 1, 2)

                            changedTo = validTorso[randomNumber]
                        end
                    elseif (options[k].name == "bodyaccessory") then
                        if IsPedComponentVariationValid(GetPlayerPed(-1), id, validUnder[randomNumber], 2) then
                            --Citizen.Trace("The random value is valid :D")
                            SetPedComponentVariation(GetPlayerPed(-1), id, validUnder[randomNumber], 1, 2)

                            changedTo = validTorso[randomNumber]
                        end
                    else
                        if IsPedComponentVariationValid(GetPlayerPed(-1), id, randomNumber, 2) then
                            --Citizen.Trace("The random value is valid :D")
                            SetPedComponentVariation(GetPlayerPed(-1), id, randomNumber, 1, 2)

                            changedTo = randomNumber
                        end
                    end
                end
            else -- Textures

                local id = options[k].id
                local max = options[k].max()
                --Citizen.Trace("Trying to customize " .. options[k].name .. "( " .. max .. " posibilities)")

                if (max > 0) then
                    local randomNumber = math.random(1, options[k].max())
                    Citizen.Trace("Randomized " .. options[k].name .. " (" .. randomNumber .. "/" .. max ..")")

                    SetPedComponentVariation(GetPlayerPed(-1), id, GetPedDrawableVariation(GetPlayerPed(-1), id), randomNumber, 2)
                    changedTo = randomNumber
                end

            end -- end if options[k].t

            if changedTo ~= nil then
                userData[options[k].name] = changedTo
            end
        end -- end for k,v
    end) -- End citizen.CreateThread
end)

RegisterNetEvent("loadout:saveLoadout")
AddEventHandler("loadout:saveLoadout", function()
    TriggerServerEvent("loadout:saveLoadout", userData)
end)

RegisterNetEvent("loadout:loadVariants")
AddEventHandler("loadout:loadVariants", function(data, delay)
    userData = data
    if delay == nil then
        delay = 0
    end

    Citizen.CreateThread(function()
        Wait(delay)
        for name, value in pairs(data) do
            for k, v in pairs(options) do
                if options[k].name == name then
                    Citizen.Trace(options[k].name .. " == " .. name)
					if (options[k].t == "drawable") then
						local id = options[k].id
						if (value > 0) then
							local randomNumber = value
							Citizen.Trace(options[k].name .. " (" .. randomNumber ..")")

							if (options[k].name == "torso") then
								if IsPedComponentVariationValid(GetPlayerPed(-1), id, validTorso[randomNumber], 2) then
									SetPedComponentVariation(GetPlayerPed(-1), id,  validTorso[randomNumber], 1, 2)
								end
							elseif (options[k].name == "bodyaccessory") then
								if IsPedComponentVariationValid(GetPlayerPed(-1), id, validUnder[randomNumber], 2) then
									SetPedComponentVariation(GetPlayerPed(-1), id, validUnder[randomNumber], 1, 2)
								end
							else
								if IsPedComponentVariationValid(GetPlayerPed(-1), id, randomNumber, 2) then
									SetPedComponentVariation(GetPlayerPed(-1), id, randomNumber, 1, 2)
								end
							end
						end
					else -- Textures
						local id = options[k].id
						if (value > 0) then
							local randomNumber = data[name]
							Citizen.Trace(options[k].name .. " (" .. randomNumber ..")")
							SetPedComponentVariation(GetPlayerPed(-1), id, GetPedDrawableVariation(GetPlayerPed(-1), id), randomNumber, 2)
						end

					end -- end if options[k].t

				end -- end if name == options[k].name
            end -- end for k,v
        end -- end for name, value
    end) -- End citizen.CreateThread
end)

-- END LOADOUT EVENTS

-- SPAWN WRAPPER
AddEventHandler("playerSpawned", function(spawn)
    TriggerServerEvent("loadout:playerSpawned", spawn)
end)

-- LANGUAGE EVENTS

RegisterNetEvent("loadout:translateChatMessage")
AddEventHandler("loadout:translateChatMessage", function(indexString, colour, args)
    local messageString = LANG[indexString]
    local pluginName = LANG["name"]

    if (not messageString) or (not pluginName) then
        Citizen.Trace("Error: No name or message string: " .. indexString)
        return
    end

    messageString = string.format(messageString, table.unpack(args))

    TriggerEvent("chatMessage", pluginName, colour, messageString)
end)

RegisterNetEvent("loadout:chatMessage")
AddEventHandler("loadout:chatMessage", function(colour, message)
    local pluginName = LANG["name"]

    if not pluginName then
        Citizen.Trace("Error: No name for the plugin set: " .. indexString)
        return
    end

    TriggerEvent("chatMessage", pluginName, colour, message)
end)

RegisterNetEvent("loadout:translateSubtitle")
AddEventHandler("loadout:translateSubtitle", function(indexString, time, args)
    local translatedString = LANG[indexString]
    if translatedString == nil then
        Citizen.Trace("Couldn't translate the string \"" .. indexString .. "\"")
        return
    end
    translatedString = string.format(translatedString, table.unpack(args))
    TriggerEvent("loadout:subtitleText", translatedString, time)
end)

RegisterNetEvent("loadout:translateNotif")
AddEventHandler("loadout:translateNotif", function(indexString, time, args)
    local translatedString = LANG[indexString]
    local a = args
    if not translatedString then
        Citizen.Trace("Couldn't translate the string \"" .. indexString .. "\"")
        return
    end
    translatedString = string.format(translatedString, table.unpack(a))

    --Citizen.Trace(translatedString)
    TriggerEvent("loadout:lexiconText", translatedString, time)
end)

-- NOTIFICATIONS
AddEventHandler("loadout:subtitleText", function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end)

AddEventHandler("loadout:lexiconText", function(text, time)
    local name = LANG["name"]
    local subject = LANG["notification_subject"]
    if (not name) or (not subject) then
        Citizen.Trace("Cannot use lexiconText 'cause the name or subject doesn't exist in the language file: " .. (name) .. ", " .. subject)
        return
    end
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage("CHAR_SOCIAL_CLUB", "CHAR_SOCIAL_CLUB", 1, 1, name, subject)
    DrawNotification(false, false)
end)
