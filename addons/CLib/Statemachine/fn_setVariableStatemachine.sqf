#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Set Variable for Statemachine

    Parameter(s):
    0: Statemachine Object <Location>
    1: Variable Name <String>
    2: Value <Any> (default: nil)

    Returns:
    0: Return <Type>
*/
params ["_stateMachine", "_varName", "_var"];
[_stateMachine, format[SMVAR(%1), _varName], _var, QGVAR(allStatemachineVariables), false] call CFUNC(setVariable);
