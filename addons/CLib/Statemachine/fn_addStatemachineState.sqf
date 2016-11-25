#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add State to Statemachine.

    Reminder:
    Every State should return the Next State that should be executed.

    Parameter(s):
    0: Statemachine Object <Location>
    1: Statename <String>
    2: StateCode <Code, String>
    3: Arguments <Any> (default: [])

    Returns:
    None
*/
params [["_stateMachine", locationNull, [locationNull]], ["_stateName", "", [""]], ["_stateCode", {}, [{}, ""]], ["_args", []]];

[_stateMachine, format[SMSVAR(%1), _stateName], [_stateCode, _args], QGVAR(allStatemachineStates), false] call CFUNC(setVariable);
