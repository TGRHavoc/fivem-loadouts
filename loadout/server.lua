
-- Fully Loaded
AddEventHandler('es:playerLoaded', function(source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 255, 255}, "Visit the Forum - www.identityrp.co.uk for Command Information, etc!")
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 255, 255}, "Use /skin <id> to pick a skin and /skin save to save the skin to the Database!")
end)

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
				TriggerClientEvent("mt:missiontext", source, "You have been given the loadout " .. loadout.name, 5000)
				
				return
			end
			
			-- They don't have permission
			print("no permission")
			TriggerClientEvent("mt:missiontext", source, "You do not have permission for the " .. loadout.name .. " loadout", 5000)
			
		else
			-- TODO: Other commands? e.g. /loadout help
		end
	else 
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 255, 255}, "Use /loadout <id> to pick a loadout.")
	end
end)


