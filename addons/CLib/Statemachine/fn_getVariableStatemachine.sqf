#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Get Variable for Statemachine

    Parameter(s):
    0: Statemachine Object <Location>
    1: Variable Name <String>
    2: Default <Any> (default: nil)

    Returns:
    Variable Value <Any>
*/
params ["_stateMachine", "_varName", "_default"];

[_stateMachine, format[SMVAR(%1), _varName], _default] call CFUNC(getVariable);
