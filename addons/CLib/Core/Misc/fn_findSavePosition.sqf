#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    this Function is a Fail Save Wraper Function for findEmptyPosition
    Find a Save Postion for a Unit, this function everytime return a Position

    Parameter(s):
    0: Postion <Array>
    1: Radius <Number>
    2: minimal Radui <Number> (Default: 0)
    2: Vehicle Class <String> (Default: Nil)

    Returns:
    Save Position <Array>
*/

params ["_pos", "_radius", ["_minRaduis", 0, [0]], "_type"];
private _haveType = isNil "_type";
private _retPos = if (_haveType) then {
    _pos findEmptyPosition [_minRaduis, _radius];
} else {
    _pos findEmptyPosition [_minRaduis, _radius, _type];
};

if (_retPos isEqualTo []) exitWith {
    if (_haveType) then {
        [_pos, _radius + 10, _minRaduis] call (missionNamespace getVariable [_fnc_scriptName, {}]);
    } else {
        [_pos, _radius + 10, _minRaduis,_type] call (missionNamespace getVariable [_fnc_scriptName, {}]);
    };
};

_retPos
