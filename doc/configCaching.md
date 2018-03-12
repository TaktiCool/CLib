# ConfigCaching

> Maintainer: joko // Jonas

The Config Caching Module is a system build around Vanilla Config functions/commands that caches the static Config values to reduce Config accesses


## CLib_fnc_configProperties

Parameter(s):
* https://community.bistudio.com/wiki/configProperties

Returns:
* https://community.bistudio.com/wiki/configProperties

https://community.bistudio.com/wiki/configProperties

Examples:
```sqf
private _return = [(configFile), "isClass _x", true] call CLib_fnc_configProperties;
```

## CLib_fnc_returnParents

Parameter(s):
* https://community.bistudio.com/wiki/BIS_fnc_returnParents

Returns:
* https://community.bistudio.com/wiki/BIS_fnc_returnParents

https://community.bistudio.com/wiki/BIS_fnc_returnParents

Examples:
```sqf
private _return = [(configFile >> "CfgVehicles" >> "Land_FirePlace_F"), true] call CLib_fnc_returnParents;
```

## CLib_fnc_getConfigData

Parameter(s):
* [`<Config>`], [`<Array>`] Path to Data
* [`<String>`], [`<Array>`], [`<Number>`] Default Return (optional)
* [`<Boolean>`] Force Type of Default Return (optional)

Returns:
* [`<String>`], [`<Array>`], [`<Number>`] Config Data or Default value if the Config does not exist

Get a Config Value.

Examples:
```sqf
private _return = [(configFile >> "CfgVehicles" >> "Land_FirePlace_F" >> "hasBananaPower"), 0, false] call CLib_fnc_getConfigData;
```

## CLib_fnc_getConfigDataCached

Parameter(s):
* [`<Config>`], [`<Array>`] Path to Data
* [`<String>`], [`<Array>`], [`<Number>`] Default Return (optional)
* [`<Boolean>`] Force Type of Default Return (optional)

Returns:
* [`<String>`], [`<Array>`], [`<Number>`] Config Data or Default value if the Config does not exist

Get a Config Value and Cache the Value to reduce config accesses while runtime.

Examples:
```sqf
private _return = [(configFile >> "CfgVehicles" >> "Land_FirePlace_F" >> "hasBananaPower"), 0, false] call CLib_fnc_getConfigDataCached;
```

[`<Array>`]: https://community.bistudio.com/wiki/Array
[`<String>`]: https://community.bistudio.com/wiki/String
[`<Boolean>`]: https://community.bistudio.com/wiki/Boolean
[`<Config>`]: https://community.bistudio.com/wiki/Config
[`<Number>`]: https://community.bistudio.com/wiki/Number
