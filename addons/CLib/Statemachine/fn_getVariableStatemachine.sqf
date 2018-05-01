#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Get Variable for Statemachine

    Parameter(s):
    0: Statemachine Object <Location> (Default: locationNull)
    1: Variable Name <String> (Default: "")
    2: Default <Anything> (Default: nil)

    Returns:
    Variable Value <Anything>
*/

params [
    ["_stateMachine", locationNull, [locationNull]],
    ["_varName", "", [""]],
    ["_default", nil, []]
];

_stateMachine getVariable [format [SMVAR(%1), _varName], _default];
