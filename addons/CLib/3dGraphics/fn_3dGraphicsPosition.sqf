#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Converts a 3dGraphicsPosition into PositionAGL

    Parameter(s):
    0: 3d GraphicsPosition <3dGraphicsPosition>

    Returns:
    0: Position AGL <PositionAGL>
*/

params ["_positionIn"];

if (_positionIn isEqualType objNull) exitWith {
    _positionIn modelToWorldVisual [0,0,0]; // Return
};


private "_ret";
if (_positionIn isEqualType []) then {
    if ((_positionIn select 0) isEqualType 0) exitWith {
        _ret = _positionIn;
    };
    if ((_positionIn select 0) isEqualType objNull) exitWith {
        _positionIn params ["_refPos", ["_refPosSelection", [0, 0, 0]], ["_refPosOffset", [0, 0, 0]], ["_offset", [0, 0, 0]]];
        _ret = (_refPos modelToWorldVisual ((_refPos selectionPosition _refPosSelection) vectorAdd _refPosOffset)) vectorAdd _offset;
    };
};
_ret;
