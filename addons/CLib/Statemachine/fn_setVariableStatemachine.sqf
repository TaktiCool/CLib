#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Set Variable for Statemachine

    Parameter(s):
    0: Statemachine Object <Location> (Default: locationNull)
    1: Variable Name <String> (Default: "")
    2: Value <Anything> (Default: nil)

    Returns:
    None
*/

params [
    ["_stateMachine", locationNull, [locationNull]],
    ["_varName", "", [""]],
    ["_var", nil, []]
];

[_stateMachine, format [SMVAR(%1), _varName], _var, QGVAR(allStatemachineVariables), false] call CFUNC(setVariable);
