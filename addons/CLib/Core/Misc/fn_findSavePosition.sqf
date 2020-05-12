#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    This function is a failsave wrapper function for findEmptyPosition.
    Finds a save postion for a unit. This function always returns a position.

    Parameter(s):
    0: Position <Array> (Default: [0, 0, 0])
    1: Radius <Number> (Default: 0)
    2: Distance <Number> (Default: 0)
    3: Vehicle Class <String> (Default: Nil)

    Returns:
    Save Position <Array>
*/

params [
    ["_pos", [0, 0, 0], [[]], 2],
    ["_radius", 0, [0]],
    ["_distance", 0, [0]],
    ["_type", nil, [""]]
];

private _hasType = isNil "_type";
private _retPos = if (_hasType) then {
    _pos findEmptyPosition [_minRadius, _distance];
} else {
    _pos findEmptyPosition [_minRadius, _distance, _type];
};

if (_retPos isEqualTo []) exitWith {
    if (_hasType) then {
        [_pos, _distance + 10, _minRadius] call (missionNamespace getVariable [_fnc_scriptName, {}]);
    } else {
        [_pos, _distance + 10, _minRadius, _type] call (missionNamespace getVariable [_fnc_scriptName, {}]);
    };
};

_retPos
