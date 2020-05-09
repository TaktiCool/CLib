# Animation Framework

> Maintainer: joko // Jonas

The Animation Framework is Build around the build in Animation System in Arma 3 to make it easier to Sync Animations over the network and on multiple Clients.


## CLib_fnc_doAnimation

Parameter(s):
* [`<Object>`] Unit
* [`<String>`] Animation
* [`<Number>`] Priority (optional)

Returns:
* None

Do an Animation for a Unit

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
