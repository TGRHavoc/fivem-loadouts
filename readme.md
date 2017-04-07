# Loadouts

A loadout system for the [FiveM](https://forum.fivem.net) mod for GTA-V.
Give your players the ability to change their skin and weapons!

## Prerequisites

Before you install this plugin, please make sure to follow the installation instructions for [EssentialMode](https://forum.fivem.net/t/release-essentialmode-base/3665).

## Usage

To use the scripts, you just have to modify the "loadouts.lua" file to your preference.
Below you can see a rundown of how you can configure the loadouts (Note: This is only one loadout, see the default "loadouts.lua" file for more).
The example below will allow the players to use the command `/loadout cop`.

```
LOADOUTS =  {
	["cop"] = { -- The argument to the /loadout command (i.e /loadout cop)
		name = "Cop", -- The name of the loadout (shown to players)
		permission_level = 0, -- The essential mode permission needed to run this command
		weapons = { "WEAPON_PISTOL50", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN" }, -- List of weapons the player will get with this loadout
		skins = { "s_m_y_swat_01", "s_m_y_swat_01" } -- List of potential skins for the player (random)
	}
}
```

The players can also run the `/loadout help` command to get a list of loadouts they can use.

#### <small>**Please note: Adding a "help" loadout will remove this functionality :cry:**</small>

## Installing

1. Copy the plugin into it's own folder in the `resources/` folder.
    - E.g. `resources/fivem-loadouts`

2. Modify your "AutoStartResources" to load the plugin. It should look like
```
AutoStartResources:
    - chat
    ...
    - fivem-loadouts
```

If you set up the plugin successfully you should see "Starting resource fivem-loadouts" in your console. Something like this:

![Console Output](http://i.imgur.com/Q3jJQHO.png)

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Authors

* **Jordan Dalton** - *Initial work* - [TGRHavoc](https://github.com/TGRHavoc)

See also the list of [contributors](https://github.com/TGRHavoc/fivem-loadouts/contributors) who participated in this project.
