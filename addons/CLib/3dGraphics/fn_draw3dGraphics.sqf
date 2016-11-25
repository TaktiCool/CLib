#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Draw3d EH

    Parameter(s):
    None

    Returns:
    None
*/

// Dont Render 3d Icons if a UI is Open.
if (!isNull (findDisplay 49) || dialog) exitWith {};

PERFORMANCECOUNTER_START(3dGraphics)

private _fov = (call CFUNC(getFOV)) * 3;
private _cameraPosition = positionCameraToWorld [0, 0, 0];

if (GVAR(3dGraphicsCacheVersion) != GVAR(3dGraphicsCacheBuildFlag)) then {
    GVAR(3dGraphicsCacheVersion) = GVAR(3dGraphicsCacheBuildFlag);
    call CFUNC(build3dGraphicsCache);
};

{
    if (!isNil "_x") then {
        switch (_x select 0) do {
            case ("ICON"): {
                _x params ["_type", "_texture", "_color", "_position", "_width", "_height", "_angle", "_text", "_shadow", "_textSize", "_font", "_align", "_drawSideArrows", "_code"];
                private _isVisible = call _code;
                if (_isVisible) then {
                    _position = [_position] call CFUNC(3dGraphicsPosition);
                    drawIcon3d [_texture, _color, _position, _width, _height, _angle, _text, _shadow, _textSize, _font, _align, _drawSideArrows];
                };
            };
            case ("LINE"): {
                _x params ["_type","_start", "_end", "_lineColor", "_code"];
                private _isVisible = call _code;
                if (_isVisible) then {
                    _start = [_start] call CFUNC(3dGraphicsPosition);
                    _end = [_end] call CFUNC(3dGraphicsPosition);
                    drawLine3d [_start, _end, _lineColor];
                };
            };
        };
    };
    nil
} count GVAR(3dGraphicsCache);


PERFORMANCECOUNTER_END(3dGraphics)
