# StatusEffects

> Maintainer: BadGuy

Status effects is a module which manages effects on units which depend on multiple conditions.  
For example if a unit is forced to walk it could have several reasons. It could be due to an injured leg or a heavy box he is carrying.
If the status changes (e.g. the unit drops the box) the status effects module will check if there are any other conditions preventing the unit to walk normally again and apply the effect accordingly.


## CLib_fnc_addStatusEffectType

Parameter(s):
* [`<String>`] Identifier
* [`<Code>`] Effect code

Returns:
* None

To create a new effect you have to call `CLib_fnc_addStatusEffectType`. The ID is a unique identifier of the effect (usually a descriptive name).  
The second parameter is the code which gets executed anytime a condition of the effect changes.

Examples:

```sqf
["forceWalk", {
    params ["_unit", "_allParameters"];
    _unit forceWalk (true in _allParameters);
}] call CLib_fnc_addStatusEffectType;
```

## CLib_fnc_setStatusEffect

Parameter(s):
* [`<Object>`] Unit
* [`<String>`] Identifier
* [`<String>`] Reason
* [`<Anything>`] Status

Returns:
* None

Call this function to publish a change of a status. Pass the affected unit and the identifier of the effect used in `CLib_fnc_addStatusEffectType`.
Also pass a reason which should be a unique name for the condition. Calls with the same reason are treated as the same condition.  
The last parameter is the status. This could be a boolean to indicate whether the unit can or cannot do something. Its also possible to pass an integer indicating the amount of something. Anything is allowed here.

Examples:

```sqf
[CLib_Player, "allowDamage", "Respawn", false] call CLib_fnc_setStatusEffect;
```

[`<String>`]: https://community.bistudio.com/wiki/String
[`<Code>`]: https://community.bistudio.com/wiki/Code
[`<Object>`]: https://community.bistudio.com/wiki/Object
[`<Anything>`]: https://community.bistudio.com/wiki/Anything