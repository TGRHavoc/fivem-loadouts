-- TODO: Add
SETTINGS = {
    enable_database = true, -- Set to false if you don't want to save the loadouts to the database
    database = { -- Database settings (please change)
        ip = "127.0.0.1", -- IP of the SQL server
        database = "gta5_gamemode_essential", -- Can use the essentialmode database or, a new one. Up to you :)
        username = "root",
        password = ""
    }
}

-- Edit the table below for more loadouts!
LOADOUTS =  {
    ["cop"] = { -- This is the command that is used to get the loadout (i.e. /loadout cop)
        name = "Cop", -- The name of the loadout (shown to the player)
        permission_level = 2, -- The player must hhave this permission to get the loadout
        -- Below is a list of weapons the player gets with the loadout (see https://www.se7ensins.com/forums/threads/weapon-and-explosion-hashes-list.1045035/)
        weapons = { "WEAPON_PISTOL50", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN" },
        --Below is a list of skins (randomly picked) the player can become with this loadout (see http://www.nextgenupdate.com/forums/gta-5-mods/725735-full-npcs-ped-models-characters-list-case-you-need-p-3.html)
        skins = { "s_m_y_swat_01" }
    },
    ["test"] = {
        name = "Test Loadout",
        permission_level = 0,
        weapons = { "WEAPON_PISTOL50", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_ASSAULTSMG" },
        skins = { "s_m_y_swat_01"},
        spawnPos = { -- A list of potential spawn points for this loadout (randomly picked)
            {
                x = 2409.005,
                y = 3079.255,
                z = 48.15277
            },
            {
                x = 2409.005,
                y = 3079.255,
                z = 48.15277
            }
        },
        randomize = true -- Randomise the character based on the player's identifier
    },
    ["test2"] = {
        name = "Test Loadout 2",
        skins = { "player_two" }, -- trevor
        randomize = true -- Randomise the character based on the player's identifier
    },
    ["random"] = {
        name = "Random",
        weapons = { "WEAPON_PETROLCAN" },
        skins = {"a_m_y_skater_01",
            "a_m_y_skater_02",
            "a_m_m_beach_01",
            "a_m_m_bevhills_01",
            "a_m_m_bevhills_02",
            "a_m_m_business_01",
            "a_m_m_eastsa_01",
            "a_m_m_eastsa_02",
            "a_m_m_farmer_01",
            "a_m_m_genfat_01",
            "a_m_m_golfer_01",
            "a_m_m_hillbilly_01",
            "a_m_m_indian_01",
            "a_m_m_mexcntry_01",
            "a_m_m_paparazzi_01",
            "a_m_m_tramp_01",
            "a_m_y_hiker_01",
            "a_m_y_hippy_01",
            "a_m_y_genstreet_01",
            "a_m_m_socenlat_01",
            "a_m_m_og_boss_01",
            "a_f_y_tourist_02",
            "a_f_y_tourist_01",
            "a_f_y_soucent_01",
            "a_f_y_scdressy_01",
            "a_m_y_cyclist_01",
            "a_m_y_golfer_01"
        }
    }
}
