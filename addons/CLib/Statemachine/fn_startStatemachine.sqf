#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Start a Statemachine.

    Parameter(s):
    0: Statemachine Object <Location> (Default: locationNull)
    1: First State <String> (Default: "init")
    2: Tick Time <Number> (Default: 0)

    Returns:
    Index of the Statemachine PFH <Number>
*/

params [
    ["_stateMachine", locationNull, [locationNull]],
    ["_firstState", "init", [""]],
    ["_tickeTime", 0, [0]]
];

if !(isNil "_firstState") then {
    _stateMachine setVariable [SMSVAR(nextStateData), _firstState];
};

[{
    private _ret = _this call CFUNC(stepStatemachine);
    if (_ret in EGVAR(Statemachine,exitStateNames)) then {
        (_this select 1) call CFUNC(removePerFrameHandler);
    };
}, _tickeTime, _stateMachine] call CFUNC(addPerFrameHandler);
