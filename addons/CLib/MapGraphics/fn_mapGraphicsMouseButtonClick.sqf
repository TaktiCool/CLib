#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Handles Mouse Moving/Clicking event

    Parameter(s):
    0: control <Control>
    1: Mouse x position <Number>
    2: Mouse y position <Number>
    2: mouseOver <???> // Don't know, look at arma wiki

    Returns:
    None
*/
params ["_control", "_button", "_xPos", "_yPos"];

private _nearestIcon = [_control, _xPos, _yPos] call CFUNC(nearestMapGraphicsGroup);
{
    private _icon = GVAR(MapGraphicsGroup) getVariable _x;
    if ((_icon select 2) == 2 && _nearestIcon != _x) then {
        _icon set [2, 0];
        GVAR(MapGraphicsGroup) setVariable [_x, _icon];
        [_x, "unselected", [_control, _xPos, _yPos]] call CFUNC(triggerMapGraphicsEvent);
        GVAR(MapGraphicsCacheBuildFlag) = GVAR(MapGraphicsCacheBuildFlag) + 1;
    };
    nil;
} count ([GVAR(MapGraphicsGroup)] call CFUNC(allVariables));

if (_nearestIcon == "") exitWith {};

private _icon = GVAR(MapGraphicsGroup) getVariable _nearestIcon;

if ((_icon select 2) < 2) then {
    _icon set [2, 1];
    GVAR(MapGraphicsGroup) setVariable [_nearestIcon, _icon];
    [_nearestIcon, "selected", [_control, _xPos, _yPos]] call CFUNC(triggerMapGraphicsEvent);
    GVAR(MapGraphicsCacheBuildFlag) = GVAR(MapGraphicsCacheBuildFlag) + 1;
};
