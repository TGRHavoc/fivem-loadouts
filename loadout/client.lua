
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

AddEventHandler("playerSpawned", function(spawn)
	TriggerServerEvent("loadout:playerSpawned", spawn)
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

RegisterNetEvent("loadout:missiontext")
AddEventHandler("loadout:missiontext", function(text, time)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(text)
	DrawSubtitleTimed(time, 1)
end)
