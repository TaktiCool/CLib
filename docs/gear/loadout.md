# Events

> Maintainer: joko // Jonas

TODO text here

## CLib_fnc_applyLoadout

Parameter(s):
* [`<Object>`] Unit that get the Loadout
* [`<String>`], [`<Config>`] Loadout Class
* [`<Boolean>`] Allow Random Items

Returns:
* None

Applys a loadout to a unit

Examples:

```sqf
[player, "Rifleman_Opfor", true] call CLib_fnc_applyLoadout;
```

## CLib_fnc_getAllLoadouts

Parameter(s):
* None

Returns:
* [`<Array>`] of [`<String>`] with all Names of Loadouts

Returns all available loadouts

Examples:

```sqf
private _allLoadouts = call CLib_fnc_getAllLoadouts;
```

## CLib_fnc_getLoadoutDetails

### SearchData
* [`<String>`] Search Key
* [`<Anything>`] Default Value

Parameter(s):
* [`<String>`], [`<Config>`] Loadout Class
* [`<Array>`] of [`<SearchData>`] Search Requests

Returns:
* [`<Array>`] of [`<Anything>`] form Serached Data or Default Value

Returns loadout details

Examples:

```sqf
["Rifleman_Opfor", [["removeAllWeapons", 0], ["linkedItems", [["myLinkedItems"]]]]] call CLib_fnc_getLoadoutDetails;
```

## CLib_fnc_loadLoadout

Parameter(s):
* [`<String>`], [`<Config>`] Loadout Class

Returns:
* [`<Array>`] Loadout Data

Load loadout to Unit

Examples:

```sqf
private _loadouts = "Rifleman_Opfor" call CLib_fnc_loadLoadout;
```

[`<Control>`]: https://community.bistudio.com/wiki/Control
[`<Anything>`]: https://community.bistudio.com/wiki/Anything
[`<Config>`]: https://community.bistudio.com/wiki/Config
[`<Object>`]: https://community.bistudio.com/wiki/Object
[`<String>`]: https://community.bistudio.com/wiki/String
[`<Number>`]: https://community.bistudio.com/wiki/Number
[`<Array>`]: https://community.bistudio.com/wiki/Array
[`<Position>`]: https://community.bistudio.com/wiki/Position
[`<Color>`]: https://community.bistudio.com/wiki/Color
[`<Boolean>`]: https://community.bistudio.com/wiki/Boolean
[`<Code>`]: https://community.bistudio.com/wiki/Code
[`<Group>`]: https://community.bistudio.com/wiki/Group
[`<Location>`]: https://community.bistudio.com/wiki/Location
[`<SearchData>`]: #SearchData
