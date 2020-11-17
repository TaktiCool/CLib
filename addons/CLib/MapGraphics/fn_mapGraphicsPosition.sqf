#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy, Raven

    Description:
    Converts a Position from MapGraphicsPosition into a position

    Parameter(s):
    0: Position <MapGraphicsPosition> (Default: objNull)
    1: Map <Control> (Default: controlNull)

    Returns:
    Position <Position3D>

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
    }

    // Make sure the returned position is Position3D
    private _originalLength = count _position;
    _position resize 3;
    
    // If the original position did contain fewer than 3 entries, replace the nil values inserted by the resize commands
    // with zeros
    for "_i" from _originalLength to 3 do {
        _position set [_i, 0];
    };
};

if (_position isEqualType objNull) then {
    _position = getPosVisual _position;
};

_position
