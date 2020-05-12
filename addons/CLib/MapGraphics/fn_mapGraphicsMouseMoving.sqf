#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Handles mouse moving event

    Parameter(s):
    0: Control <Control> (Default: controlNull)
    1: Mouse x position <Number> (Default: 0)
    2: Mouse y position <Number> (Default: 0)

    Returns:
    None
*/

params [
    ["_control", controlNull, [controlNull]],
    ["_xPos", 0, [0]],
    ["_yPos", 0, [0]]
];

private _nearestIcon = [_control, _xPos, _yPos] call CFUNC(nearestMapGraphicsGroup);
{
    private _icon = GVAR(MapGraphicsGroup) getVariable _x;
    if ((_icon select 2) == 1 && _nearestIcon != _x) then {
        _icon set [2, 0];
        GVAR(MapGraphicsGroup) setVariable [_x, _icon];
        [_x, "hoverout", [_control, _xPos, _yPos]] call CFUNC(triggerMapGraphicsEvent);
        GVAR(MapGraphicsCacheBuildFlag) = GVAR(MapGraphicsCacheBuildFlag) + 1;
    };
    nil;
} count ([GVAR(MapGraphicsGroup)] call CFUNC(allVariables));

if (_nearestIcon == "") exitWith {};

private _icon = GVAR(MapGraphicsGroup) getVariable _nearestIcon;

if ((_icon select 2) < 1) then {
    _icon set [2, 1];
    GVAR(MapGraphicsGroup) setVariable [_nearestIcon, _icon];
    [_nearestIcon, "hoverin", [_control, _xPos, _yPos]] call CFUNC(triggerMapGraphicsEvent);
    GVAR(MapGraphicsCacheBuildFlag) = GVAR(MapGraphicsCacheBuildFlag) + 1;
};
