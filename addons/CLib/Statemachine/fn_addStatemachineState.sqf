#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add State to Statemachine. Every State should return the Next State that should be executed.

    Parameter(s):
    0: Statemachine Object <Location> (Default: locationNull)
    1: Statename <String> (Default: "")
    2: StateCode <Code> (Default: {})
    3: Arguments <Anything> (Default: [])

    Returns:
    None
*/

params [
    ["_stateMachine", locationNull, [locationNull]],
    ["_stateName", "", [""]],
    ["_stateCode", {}, [{}]],
    ["_args", [], []]
];

[_stateMachine, format [SMSVAR(%1), _stateName], [_stateCode, _args], QGVAR(allStatemachineStates), false] call CFUNC(setVariable);
