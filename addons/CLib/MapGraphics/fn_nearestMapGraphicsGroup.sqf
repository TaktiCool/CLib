#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Get nearest Group from MapGraphicsGeometryCache

    Parameter(s):
    0: Map <Control> (Default: controlNull)
    1: Map x position <Number> (Default: 0)
    2: Map y position <Number> (Default: 0)

    Returns:
    MapGraphicsGroup identifier <String>
*/

params [
    ["_map", controlNull, [controlNull]],
    ["_xPos", 0, [0]],
    ["_yPos", 0, [0]]
];

private _mousePosition = [_xPos, _yPos];
_mousePosition = _map ctrlMapScreenToWorld _mousePosition;

private _r = 100000;
private _nearestIcon = "";
{
    _x params ["_iconId", "_pos", "_w", "_h", "_angle", "_isRectangle", ["_isPoly", false]];

    if (_isPoly) then {
        if (_mousePosition inPolygon _pos) then {
            private _centerPos = [0, 0, 0];
            private _count = count _pos;
            {
                _centerPos = _centerPos vectorAdd (_x vectorMultiply (1 / _count));
                private _temp1 = _x distance2D _mousePosition;
                if (_temp1 < _r) then {
                    _nearestIcon = _iconId;
                    _r = _temp1;
                };
                nil
            } count _pos;

            private _temp1 = _centerPos distance2D _mousePosition;
            if (_temp1 < _r) then {
                _nearestIcon = _iconId;
                _r = _temp1;
            };
        };
    } else {
        if (_mousePosition inArea [_pos, _w, _h, _angle, _isRectangle]) then {
            private _temp1 = _pos distance2D _mousePosition;
            if (_temp1 < _r) then {
                _nearestIcon = _iconId;
                _r = _temp1;
            };
        };
    };
    nil;
} count GVAR(MapGraphicsGeometryCache);

_nearestIcon;
