#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Copy a Statemachine and create a New one with the same States

    Parameter(s):
    0: Statemachine Object <Location>

    Returns:
    Statemachine Object <Location>
*/
params [["_stateMachine", locationNull, [locationNull]]];

private _stateMachineNew = call CFUNC(createStatemachine);
private _allVar = [_stateMachine, QGVAR(allStatemachineVariables)] call CFUNC(allVariables);
private _allStates = [_stateMachine, QGVAR(allStatemachineStates)] call CFUNC(allVariables);

{
    [_stateMachineNew, _x, _stateMachine getVariable _x, QGVAR(allStatemachineVariables), false] call CFUNC(setVariable);
    nil
} count _allVar;

{
    [_stateMachineNew, _x, _stateMachine getVariable _x, QGVAR(allStatemachineStates), false] call CFUNC(setVariable);
    nil
} count _allStates;
_stateMachineNew
