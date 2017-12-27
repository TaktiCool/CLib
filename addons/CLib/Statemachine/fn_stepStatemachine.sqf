#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Trigger 1 Step in 1 Statemachine.

    Parameter(s):
    0: Statemachine Object <Location>

    Returns:
    Next Statename <String>
*/
params ["_stateMachine"];

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

private _stateValues = [];
if (_currentState isEqualType []) then {
    _stateValues = _currentState select 1;
};

private _allVars = _stateMachine getVariable [QGVAR(allLocalStateVariables), [[], []]];
_allVars params ["_varNames", "_vars"];

private _nextState = if (_varNames isEqualTo []) then {
    [_args, _stateValues] call _code;
} else {
    _vars params _varNames;
    [_args, _stateValues] call _code;

    _vars = _varNames apply {
        call (compile _x);
    };
    _allVars = [_varNames, _vars];
    _stateMachine setVariable [SMVAR(allLocalStateVariables), _allVars];
};

_stateMachine setVariable [SMSVAR(nextStateData), _nextState];

if (_nextState isEqualType []) then {
    _nextState = _nextState select 0;
};
_nextState
