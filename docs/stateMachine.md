# State Machine

> Maintainer: joko // Jonas

Statemachine is a simplifed Statemachine. It is missing features like transitions, Entry and Exit State Actions, and Conditions. It is based around Returns of the State.

## Statemachine
The Statemachine is Stored on a Object of Type [`<Location>`]

## Statemachine Config
```csharp
class MyStateMachine {
    entryPoint = "Start"; // The State where the Statemachine Enters
    autostart = 1; // Autostart after Creation
    class Start { // State
        stateCode = "Docs_AllPlayers = allPlayers; Docs_Index = -1; 'IsInArea'";
    };
    class IsInArea {
        stateCode = "Docs_Index = (Docs_Index + 1) mod (count allPlayers); if ((Docs_allPlayers select Docs_Index) inArea MyTrigger) then {'InArea'} else {'IsInArea'};";
    };
    class InArea {
        stateCode = "private _target = Docs_allPlayers select Docs_Index; _target setDamage ((damage _target) + 0.01); 'IsInArea'";
    };
};
```

## Functions
### CLib_fnc_addStatemachineState

Parameter(s):
* [`<Statemachine>`] Statemachine Object
* [`<String>`] Statename
* [`<Code>`] State Code
* [`<Arguments>`] State Arguments


Returns:
* None

Add State to Statemachine. Every State should return the Next State that should be executed.

Examples:

```sqf
[_statemachine, "HasBanana", {}, []] call CLib_fnc_addStatemachineState
```

### CLib_fnc_copyStatemachine

Parameter(s):
* [`<Statemachine>`] Statemachine Object to Copy from

Returns:
* [`<Statemachine>`] Statemachine Object Copy

Copy a Statemachine and create a New one with the same States

Examples:

```sqf
private _statemachine2 = _statemachine call CLib_fnc_copyStatemachine;
```

### CLib_fnc_createStatemachine

Parameter(s):
* None

Returns:
* [`<Statemachine>`] Statemachine Object

Create a New Statemachine Object.

Examples:

```sqf
private _statemachine = call CLib_fnc_createStatemachine;
```

### CLib_fnc_createStatemachineFromConfig

Parameter(s):
* [`<Config>`] Config Path

Returns:
* [`<Statemachine>`] Statemachine Object

Create Statemachine from Config

Examples:

```sqf
private _configStatemachine call CLib_fnc_createStatemachineFromConfig;
```

### CLib_fnc_getVariableStatemachine

Parameter(s):
* [`<Statemachine>`] Statemachine Object
* [`<String>`] Variable Name
* [`<Anything>`] Default Value

Returns:
* [`<Anything>`] Variable Value

Get Variable for Statemachine.

Examples:

```sqf
private _variable = [_statemachine, "Yellow"] call CLib_fnc_getVariableStatemachine;
```

### CLib_fnc_setVariableStatemachine

Parameter(s):
* [`<Statemachine>`] Statemachine Object
* [`<String>`] Variable Name
* [`<Anything>`] Value

Returns:
* None

Set Variable for Statemachine

Examples:

```sqf
[_statemachine, "MyImportentVariable", "Are Bananas yellow?"] call CLib_fnc_setVariableStatemachine;
```

### CLib_fnc_startStatemachine

Parameter(s):
* [`<Statemachine>`] Statemachine Object
* [`<String>`] Init Statename
* [`<Number>`] Tick Time (in seconds)

Returns:
* [`<Number>`] Index of the Statemachine PFH

Starts a Statemachine Automatic Ticks.

Examples:

```sqf
[_statemachine, "start", 0.1] call CLib_fnc_startStatemachine
```

### CLib_fnc_stepStatemachine

Parameter(s):
* [`<Statemachine>`] Statemachine Object

Returns:
* [`<String>`] Next Statename

Manualy Triggers a Step in a Statemachine

Examples:

```sqf
private _nextState = _statemachine call CLib_fnc_stepStatemachine;
```

[`<Statemachine>`]: #statemachine

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
