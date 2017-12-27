#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Handles mouse clicking event

    Parameter(s):
    0: Control <Control>
    1: Mouse button <Number>
    2: Mouse x position <Number>
    3: Mouse y position <Number>

    Returns:
    None
*/

params ["_control", "_button", "_xPos", "_yPos"];

private _nearestIcon = [_control, _xPos, _yPos] call CFUNC(nearestMapGraphicsGroup);

if (_nearestIcon == "") exitWith {};
[_nearestIcon, "clicked", [_control, _xPos, _yPos]] call CFUNC(triggerMapGraphicsEvent);
