#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy, Raven

    Description:
    Converts a Position from MapGraphicsPosition into a position

    Parameter(s):
    0: MapGraphicsPosition <Array, Object> (Default: objNull)
    1: Map <Control> (Default: controlNull)

    Returns:
    Position3D <Array>

    TYPE <MapGraphicsPosition>:
    OBJECT | POSITION3D | POSITION2D | [OBJECT | POSITION3D | POSITION2D,[ScreenOffsetX,ScreenOffsetY]]
*/

params [
    ["_position", objNull, [[], objNull]],
    ["_map", controlNull, [controlNull]]
];

if (_position isEqualType []) then {
    if ((_position select 1) isEqualType []) then {
        _position params ["_pos", "_offset"];

        if (_pos isEqualType objNull) then {
            _pos = getPosVisual _pos;
        };
        _pos = _map ctrlMapWorldToScreen _pos;
        _pos = [(_pos select 0) + (_offset select 0) / 640, (_pos select 1) + (_offset select 1) / 480];
        _pos = _map ctrlMapScreenToWorld _pos;
        _position = _pos;
    };

    // Make sure the returned position is Position3D
    private _size = count _position;
    if (_size != 3) then {
        if (_size > 3) then {
            _position resize 3;
        } else {
            // Array size is 2 as the only other valid option at this point is Position2D
            _position pushBack 0;
        };
    };
};

if (_position isEqualType objNull) then {
    _position = getPosVisual _position;
};

_position
