#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Remove a group from the MapGraphics system

    Parameter(s):
    0: Group name <String>

    Returns:
    None
*/

params ["_groupName"];

[GVAR(MapGraphicsGroup), _groupName, nil] call CFUNC(setVariable);

// increment map graphics cache
GVAR(MapGraphicsCacheBuildFlag) = GVAR(MapGraphicsCacheBuildFlag) + 1;
