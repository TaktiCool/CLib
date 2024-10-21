#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Do a Animation for a Unit

    Parameter(s):
    0: Unit <Object> (Default: objNull)
    1: Animation <String> (Default: "")
    2: Priority <Number> (Default: 0)

    Returns:
    None
*/

params [
    ["_unit", objNull, [objNull]],
    ["_anim", "", [""]],
    ["_priority", 0, [0]]
];

if (_anim == "") then {
    _anim = _unit call CFUNC(getDefaultAnimation);
};

private _case = ["playMove", "playMoveNow"] select (_priority min 1);

// Execute on all machines. PlayMove and PlayMoveNow are bugged: They have no global effects when executed on remote machines inside vehicles.
if (isNull (objectParent _unit)) then {
    [_case, _unit, [_unit, _anim]] call CFUNC(targetEvent);
} else {
    [_case, [_unit, _anim]] call CFUNC(globalEvent);
};

if (_priority >= 2) then {
    [{
        params ["_unit", "_anim"];

        if (animationState _unit != _anim) then {
            ["switchMove", [_unit, _anim]] call CFUNC(globalEvent);
        };
    }, 0.1, [_unit, _anim]] call CFUNC(wait);
};
