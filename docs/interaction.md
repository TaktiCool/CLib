# Interaction

> Maintainer: NetFusion, BadGuy, joko // Jonas

The Interaction System allows to add Interactions, Hold Actions and Overrite Vanilla Actions, it also Adds the CanInteractWith Framework


## Data Types
### Named Parameters
The Named Parameters are build so that the User does not need to input all data and only the onces needed.

Types:
* `"arguments"`: Arguments which get passed to the callback [`<Anything>`]
* `"priority"`: Priority of the action [`<Number>`]
* `"showWindow"`: Players see title text in mid screen  [`<Boolean>`]
* `"hideOnUse"`: Hide action menu after use [`<Boolean>`]
* `"shortcut"`: Key name to add binding for action [`<String>`]
* `"radius"`: Distance in meters the unit activating the action must be within to activate it [`<Number>`]
* `"unconscious"`: Visible to incapacitated player [`<Boolean>`]
* `"onActionAdded"`: Code which will be executed when action was added [`<Code>`]
* `"ignoredCanInteractConditions"`: Interact conditions that will be ignored [`<Array>`]
* `"selection"`: named selection in Geometry LOD to which the action is attached [`<String>`]
* `"memorypoint"`: memory point on the object to which the action is attached. If parameter selection is supplied, parameter memoryPoint is not used [`<String>`]

## Functions

### CLib_fnc_addAction

Parameter(s):
* [`<Code>`], [`<String>`] Title of the action
* [`<Object>`], [`<String>`], [`<Array>`] Object or type which the action should be added to
* [`<Number>`] Distance in which the action is visible
* [`<Code>`], [`<String>`] Condition which is evaluated on every frame if player is in range to determine if the action is visible
* [`<Code>`] Callback which gets called when the action is activated
* [`<Array>`] Optional named parameters

Returns:
* None

Add an action to an object or types of objects

Examples:

```sqf
TODO Example here
```

### CLib_fnc_addHoldAction

Parameter(s):
* [`<Object>`], [`<String>`], [`<Array>`] Target
* [`<String>`] Title
* [`<Code>`], [`<String>`] Idle icon
* [`<Code>`], [`<String>`] Progress icon
* [`<Code>`] Show condition
* [`<Code>`] Progress condition
* [`<Code>`] Start code
* [`<Code>`] Progress code
* [`<Code>`] Completed code
* [`<Code>`] Interrupted code
* [`<Anything>`] Arguments
* [`<Number>`] Priority
* [`<Boolean>`] Remove on complete
* [`<Boolean>`] Show unconscious
* [`<Array>`] Ignored canInteract conditions
* [`<String>`] Selection
* [`<String>`] Memorypoint

Returns:
* None

Adds a Hold Action to a Object, Object Type, or A Array of Both, or Overrides Vanilla Action with Hold Action

Examples:

```sqf
[
    cursorTarget,
    "TestHold",
    "",
    "",
    {true},
    {true},
    {StartTime = time;},
    {(time - StartTime)/10},
    {hint "COMPLETED";},
    {hint "INTERRUPTED"}
] call CLib_fnc_addHoldAction;
```

### CLib_fnc_overrideAction

Parameter(s):
* [`<Type>`] TODO text here

Returns:
* [`<Type>`] TODO text here

TODO text here

Examples:

```sqf
TODO Example here
```

### CLib_fnc_addCanInteractWith

Parameter(s):
* [`<String>`] Type
* [`<Code>`] Condition

Returns:
* None

Add a canInteractWith condition

Examples:

```sqf
["isNotInVehicle", {
    params ["_caller", "_target"];
    (isNull objectParent _caller) && (isNull objectParent _target)
}] call CLib_fnc_addCanInteractWith;
```

### CLib_fnc_canInteractWith

Parameter(s):
* [`<Object>`] Unit
* [`<Object>`] Target
* [`<Array>`] Igonred Types

Returns:
* [`<Boolean>`] Can Interact with

TODO text here

Examples:

```sqf
TODO Example here
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
