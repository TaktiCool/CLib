# Config Caching

> Maintainer: joko // Jonas

The Config Caching Module is a system build around Vanilla Config functions/commands that caches the static Config values to reduce Config accesses

## Functions
### CLib_fnc_configProperties

Parameter(s):
* https://community.bistudio.com/wiki/configProperties

Returns:
* https://community.bistudio.com/wiki/configProperties

https://community.bistudio.com/wiki/configProperties

Examples:
```sqf
private _return = [(configFile), "isClass _x", true] call CLib_fnc_configProperties;
```

### CLib_fnc_returnParents

Parameter(s):
* https://community.bistudio.com/wiki/BIS_fnc_returnParents

Returns:
* https://community.bistudio.com/wiki/BIS_fnc_returnParents

https://community.bistudio.com/wiki/BIS_fnc_returnParents

Examples:
```sqf
private _config = configFile >> "CfgVehicles" >> "Land_FirePlace_F";
private _return = [_config, true] call CLib_fnc_returnParents;
```

### CLib_fnc_getConfigData

Parameter(s):
* [`<Config>`], [`<Array>`] Path to Data
* [`<String>`], [`<Array>`], [`<Number>`] Default Return (optional)
* [`<Boolean>`] Force Type of Default Return (optional)

Returns:
* [`<String>`], [`<Array>`], [`<Number>`] Config Data or Default value if the Config does not exist

Get a Config Value.

Examples:
```sqf
private _config = configFile >> "CfgVehicles" >> "Land_FirePlace_F" >> "hasBanana";
private _return = [_config, 0, false] call CLib_fnc_getConfigData;
```

### CLib_fnc_getConfigDataCached

Parameter(s):
* [`<Config>`], [`<Array>`] Path to Data
* [`<String>`], [`<Array>`], [`<Number>`] Default Return (optional)
* [`<Boolean>`] Force Type of Default Return (optional)

Returns:
* [`<String>`], [`<Array>`], [`<Number>`] Config Data or Default value if the Config does not exist

Get a Config Value and Cache the Value to reduce config accesses while runtime.

Examples:
```sqf
private _config = configFile >> "CfgVehicles" >> "Land_FirePlace_F" >> "hasBanana";
private _return = [_config, 0, false] call CLib_fnc_getConfigDataCached;
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
[`<Structured Text>`]: https://community.bistudio.com/wiki/Structured_Text
[`<Waypoint>`]: https://community.bistudio.com/wiki/Waypoint
[`<Task>`]: https://community.bistudio.com/wiki/Task
