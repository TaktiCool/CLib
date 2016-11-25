#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Get nearest Group from MapGraphicsGeometryCache

    Parameter(s):
    0: map <Control>
    1: x Position <Number>
    2: y Position <Number>

    Returns:
    Group <String>
*/
params ["_map", "_xPos", "_yPos"];

private _mousePosition = [_xPos, _yPos];
_mousePosition = _map ctrlMapScreenToWorld _mousePosition;

private _r = 100000;
private _nearestIcon = "";
{
    _x params ["_iconId", "_pos", "_w", "_h", "_angle", "_isRectangle"];

    if (_mousePosition inArea [_pos, _w, _h, _angle, _isRectangle]) then {
        _temp1 = _pos distance _mousePosition;
        if (_temp1 < _r) then {
            _nearestIcon = _iconId;
            _r = _temp1;
        };
    };

    nil;
} count GVAR(MapGraphicsGeometryCache);

_nearestIcon;
