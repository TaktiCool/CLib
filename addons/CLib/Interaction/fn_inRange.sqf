#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Checks whether an object is in a given range to player.

    Parameter(s):
    0: Object which should be checked <Object> (Default: objNull)
    1: Range to check <Number> (Default: 10)

    Returns:
    If the object in in range <Bool>

    Example:
    [object, 10] call CLib_fnc_inRange;
*/

params [
    ["_object", objNull, [objNull]],
    ["_distance", 10, [0]]
];

if (_object isKindOf "CAManBase") exitWith {CLib_Player distance _object < _distance};

private _playerPos = eyePos CLib_Player;
private _viewDirection = eyeDirection CLib_Player;
private _viewDirectionMagnitude = vectorMagnitude _viewDirection;

if (_viewDirectionMagnitude == 0) exitWith {false};

private _direction = _viewDirection vectorMultiply (_distance / _viewDirectionMagnitude);

_object in lineIntersectsWith [_playerPos, _playerPos vectorAdd _direction] || CLib_Player distance _object < _distance
