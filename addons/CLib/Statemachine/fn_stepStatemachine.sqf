#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Trigger 1 Step in 1 Statemachine.

    Parameter(s):
    0: Statemachine Object <Location> (Default: locationNull)

    Returns:
    Next Statename <String>
*/

params [
    ["_stateMachine", locationNull, [locationNull]]
];

private _currentState = _stateMachine getVariable SMSVAR(nextStateData);
// check if current state exist in Namespace.
if (isNil "_currentState") exitWith {
    LOG("Error Next State is Nil");
    "exit"
};

private _stateData = if (_currentState isEqualType "") then {
    _stateMachine getVariable format [SMSVAR(%1), _currentState];
} else {
    _stateMachine getVariable format [SMSVAR(%1), (_currentState select 0)];
};

// check if state data exist.
if (isNil "_stateData") exitWith {
    LOG("Error Next State is Unknown: " + _currentState);
    "exit"
};

_stateData params ["_code", "_args"];

private _nextState = if (_currentState isEqualType "") then {
    [_args, []] call _code;
} else {
    [_args, _currentState select 1] call _code;
};
private _nextStateName = if (_nextState isEqualType "") then {
    _nextState
} else {
    _nextState select 0;
};

_stateMachine setVariable [SMSVAR(nextStateData), _nextState];
_nextStateName
