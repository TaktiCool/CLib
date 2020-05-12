#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Converts a Position from MapGraphicsPosition into a position

    Parameter(s):
    0: Position <Array, Object> (Default: objNull)
    1: Map <Control> (Default: controlNull)

    Returns:
    Position <Array>

    TYPE <MapGraphicsPosition>:
    OBJECT | POSITION3D | POSITION2D | [OBJECT | POSITION3D | POSITION2D,[ScreenOffsetX,ScreenOffsetY]]
*/

params [
    ["_position", objNull, [[], objNull], [2, 3]],
    ["_map", controlNull, [controlNull]]
];

if (_position isEqualType [] && {(_position select 1) isEqualType []}) then {
    _position params ["_pos", "_offset"];

    if (_pos isEqualType objNull) then {
        _pos = getPosVisual _pos;
    };
    _pos = _map ctrlMapWorldToScreen _pos;
    _pos = [(_pos select 0) + (_offset select 0) / 640, (_pos select 1) + (_offset select 1) / 480];
    _pos = _map ctrlMapScreenToWorld _pos;
    _position = _pos;
};

if (_position isEqualType objNull) then {
    _position = getPosVisual _position;
};

_position
