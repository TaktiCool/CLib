#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    Do a Animation for a Unit

    Parameter(s):
    0: Unit <Object>
    1: Animation <String>
    2: Priority <Number>

    Returns:
    None
*/
params ["_unit", "_anim", ["_prio", 0]];

if (_anim == "") then {
    _anim = _unit call CFUNC(getDefaultAnimation);
};

private _case = ["playMove", "playMoveNow"] select (_prio min 1);

if (isNull (objectParent _unit)) then {
    // Execute on all machines. PlayMove and PlayMoveNow are bugged: They have no global effects when executed on remote machines inside vehicles.
    [_case, [_unit, _anim]] call CFUNC(globalEvent);
} else {
    [_case, [_unit, _anim]] call CFUNC(targetEvent);
};

if (_prio >= 2 && {animationState _unit != _animation}) then {
    ["switchMove", [_unit, _anim]] call CFUNC(globalEvent);
};
