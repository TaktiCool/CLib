# AnimFramework

> Maintainer: joko // Jonas

## CLib_fnc_doAnimation

Parameter(s):
* [`<Object>`] Unit
* [`<String>`] Animation
* [`<Number>`] Priority (optional)

Returns:
* None

Do a Animation for a Unit

Examples:
```sqf
[player, "AmovPercMstpSrasWrflDnon_Salute"] call CLib_fnc_doAnimation;
```

## CLib_fnc_getDeathAnimation

Parameter(s):
* [`<Object>`] Unit

Returns:
* [`<String>`] Death animation

Gets the death animation for a unit

Examples:
```sqf
private _deathAnimation = [player] call CLib_fnc_getDeathAnimation;
```

## CLib_fnc_getDefaultAnimation

Parameter(s):
* [`<Object>`] Unit

Returns:
* [`<String>`] Default animation

Gets the default animation for a unit

Examples:
```sqf
private _defaultAnimation = [player] call CLib_fnc_getDefaultAnimation;
```

[`<Object>`]: https://community.bistudio.com/wiki/Object
[`<String>`]: https://community.bistudio.com/wiki/String
[`<Number>`]: https://community.bistudio.com/wiki/Number