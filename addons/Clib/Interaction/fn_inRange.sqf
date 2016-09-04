/*
    Author: NetFusion

    Description:
    Checks whether an object is in a given range to player.

    Parameter(s):
    0: OBJECT - the object which should be checked.
    1: NUMBER - the range to check.

    Returns:
    - BOOL - true if the object in in range, false if not.

    Example:
    [object, 10] call JK_Core_fnc_inRange;
*/
params["_object", "_distance"];

if (_object isKindOf "CAManBase") exitWith {Clib_Player distance _object < _distance};

private _playerPos = eyePos Clib_Player;
private _viewDirection = eyeDirection Clib_Player;

private _direction = _viewDirection vectorMultiply (_distance / (vectorMagnitude _viewDirection));

_object in lineIntersectsWith [_playerPos, _playerPos vectorAdd _direction] || Clib_Player distance _object < _distance
