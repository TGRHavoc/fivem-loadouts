
-- Fully Loaded
AddEventHandler('es:playerLoaded', function(source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 255, 255}, "Visit the Forum - www.identityrp.co.uk for Command Information, etc!")
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 255, 255}, "Use /skin <id> to pick a skin and /skin save to save the skin to the Database!")
end)

RegisterServerEvent("loadout:playerSpawned")
AddEventHandler("loadout:playerSpawned", function(spawn)
	TriggerEvent("loadout:doLoadout", source, "Default")
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

for key,val in pairs(LOADOUTS) do
	local l = LOADOUTS[key]
	if l.command ~= nil then
		print("registering command /" .. l.command )

		TriggerEvent("es:addAdminCommand", l.command, (l.permission_level or 0), function(source, args, user)
			print("executing command..." .. tostring(l.skins) .. " " .. tostring(l.weapons))

			TriggerEvent("loadout:doLoadout", source, l.name)

			TriggerClientEvent("mt:missiontext", source, "You have been given the loadout " .. l.name, 5000)

		end, function(source, args, user)
			-- Send a message telling them, they don't have permission to use the loadout
			TriggerClientEvent("mt:missiontext", source, "You do not have permission for the " .. l.name .. " loadout", 5000)
		end)

	end
end
