#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Handles mouse clicking event

    Parameter(s):
    0: Control <Control> (Default: controlNull)
    1: Mouse button <Number> (Default: 0)
    2: Mouse x position <Number> (Default: 0)
    3: Mouse y position <Number> (Default: 0)

    Returns:
    None
*/

params [
    ["_control", controlNull, [controlNull]],
    ["_button", 0, [0]],
    ["_xPos", 0, [0]],
    ["_yPos", 0, [0]]
];

private _nearestIcon = [_control, _xPos, _yPos] call CFUNC(nearestMapGraphicsGroup);

if (_nearestIcon == "") exitWith {};
[_nearestIcon, "clicked", [_control, _xPos, _yPos]] call CFUNC(triggerMapGraphicsEvent);
