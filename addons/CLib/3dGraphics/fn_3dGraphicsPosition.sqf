#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Converts a 3dGraphicsPosition into PositionAGL

    Parameter(s):
    0: GraphicsPosition <Array, Object> (Default: [0, 0, 0])

    Returns:
    PositionAGL <Array>
*/

params [
    ["_positionIn", [0, 0, 0], [[], objNull]]
];

if (_positionIn isEqualType objNull) exitWith {
    _positionIn modelToWorldVisual [0, 0, 0]; // Return
};

if (_positionIn isEqualType []) exitWith {
    if ((_positionIn select 0) isEqualType 0) exitWith {
        _positionIn
    };
    if ((_positionIn select 0) isEqualType objNull) exitWith {
        _positionIn params ["_refPos", ["_refPosSelection", ""], ["_refPosOffset", [0, 0, 0]], ["_offset", [0, 0, 0]]];
        (_refPos modelToWorldVisual ((_refPos selectionPosition _refPosSelection) vectorAdd _refPosOffset)) vectorAdd _offset
    };
};
