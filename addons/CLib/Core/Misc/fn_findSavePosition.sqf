#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    This function is a failsave wrapper function for findEmptyPosition.
    Finds a save postion for a unit. This function always returns a position.

    Parameter(s):
    0: Position <Array>
    1: Radius <Number>
    2: Minimal Radius <Number> (Default: 0)
    3: Vehicle Class <String> (Default: Nil)

    Returns:
    Save Position <Array>
*/

params ["_pos", "_radius", ["_minRadius", 0, [0]], "_type"];
private _hasType = isNil "_type";
private _retPos = if (_hasType) then {
    _pos findEmptyPosition [_minRadius, _radius];
} else {
    _pos findEmptyPosition [_minRadius, _radius, _type];
};

if (_retPos isEqualTo []) exitWith {
    if (_hasType) then {
        [_pos, _radius + 10, _minRadius] call (missionNamespace getVariable [_fnc_scriptName, {}]);
    } else {
        [_pos, _radius + 10, _minRadius, _type] call (missionNamespace getVariable [_fnc_scriptName, {}]);
    };
};

_retPos
