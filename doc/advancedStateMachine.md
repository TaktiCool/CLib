# AdvancedStateMachine

> Maintainer: BadGuy

The advanced state machine is a module which provides basic functions to create a basic state machine with states and transitions.
Its design allows running managing multiple instances of a machine. This makes it ideal to use with AI or similar things.


## CLib_fnc_addASMState

Parameter(s):
* [`<Location>`] State machine
* [`<String>`] State name
* [`<Code>`] Entry action (optional)
* [`<Code>`] State action (optional)
* [`<Code>`] Exit action (optional)

Returns:
* None

Adds a state to the state machine. Each state has to have a unique, non-empty name.
The `entryAction` gets called when the state is entered. The `stateAction` is called *every frame*  as long as the state is active.
The `exitAction` gets called when the state is left. Each action gets the instance data as a parameter.  
The state `exit` is reserved as an exit state. Once this state is reached the instance will stop itself automatically.

Examples:

```sqf
[_stateMachine, "attackGroup", {}, {}, {}] call CLib_fnc_addASMState;
```

## CLib_fnc_addASMTransition

Parameter(s):
* [`<Location>`] State machine
* [`<Array>`], [`<String>`] Source state names
* [`<String>`] Destination state name
* [`<Code>`] Condition (optional)
* [`<Code>`] Action (optional)

Returns:
* None

Adds a transition to the state machine. Each transition connects one or multiple source states to a single destination state.
Once one instance of the state machine is in one of the source states the condition gets evaluated.
And once the result of the condition is `true` the action gets call and the instance transits to the destination state.
No other conditions of the source state are checked if a transit happens.  
The condition and the action gets the instance data as a parameter.

Examples:

```sqf
[_stateMachine, ["init", "state1"], "state2", {
    time > 100
}, {
    diag_log "Transition activated!";
}] call CLib_fnc_addASMTransition;
```

## CLib_fnc_createASM

Parameter(s):
* None

Returns:
* [`<Location>`] State machine

Creates a state machine.

Examples:

```sqf
private _stateMachine = call CLib_fnc_createASM;
```

## CLib_fnc_createASMInstance

Parameter(s):
* [`<Location>`] State machine
* [`<Anything>`] Data (optional)
* [`<String>`] Initial state (optional, default: "init")

Returns:
* None

Creates an instance for a state machine.
Each instance runs independent of each other.  

Examples:

```sqf
[_stateMachine, [], "customStartState"] call CLib_fnc_createASMInstance;
```

[`<Location>`]: https://community.bistudio.com/wiki/Location
[`<String>`]: https://community.bistudio.com/wiki/String
[`<Code>`]: https://community.bistudio.com/wiki/Code
[`<Array>`]: https://community.bistudio.com/wiki/Array
[`<Anything>`]: https://community.bistudio.com/wiki/Anything