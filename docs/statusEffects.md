# Status Effects

> Maintainer: BadGuy

Status effects is a module which manages effects on units which depend on multiple conditions.  
For example, if a unit is forced to walk it could have several reasons. It could be due to an injured leg or a heavy box he is carrying.
If the status changes (e.g. the unit drops the box) the status effects module will check if there are any other conditions preventing the unit to walk normally again and apply the effect accordingly.

## Functions
### CLib_fnc_addStatusEffectType

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

### CLib_fnc_setStatusEffect

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
