#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Remove a new Group to the MapGraphics-System

    Parameter(s):
    0: Group Name <STRING>


    Returns:
    None
*/
params ["_groupName"];

[GVAR(MapGraphicsGroup), _groupName, nil] call CFUNC(setVariable);

// increment map graphics cache
GVAR(MapGraphicsCacheRebuildFlag) = GVAR(MapGraphicsCacheRebuildFlag) + 1;
