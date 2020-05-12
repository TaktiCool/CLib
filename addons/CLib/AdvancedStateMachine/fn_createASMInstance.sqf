#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Creates an instance of a state machine

    Parameter(s):
    0: State machine <Location> (Default: locationNull)
    1: Data <Anything> (Default: nil)
    2: Initial state <String> (Default: "init")

    Returns:
    None
*/

params [
    ["_stateMachine", locationNull, [locationNull]],
    "_data",
    ["_initialStateName", "init", [""]]
];

if (isNull _stateMachine) exitWith {
    LOG("Invalid state machine passed to createASMInstance");
};

if (_initialStateName == "") exitWith {
    LOG("Invalid state name passed to createASMInstance");
};

private _instances = _stateMachine getVariable [QGVAR(Instances), []];
_instances pushBack [_initialStateName, _data];
_stateMachine setVariable [QGVAR(Instances), _instances];

if ((_stateMachine getVariable [QGVAR(pfhId), -1]) == -1) then {
    _stateMachine setVariable [QGVAR(pfhId), [{
        params ["_stateMachine"];
        [_stateMachine] call FUNC(stepASM)
    }, 0, _stateMachine] call CFUNC(addPerFrameHandler)];
};
