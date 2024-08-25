#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Remove a group from the MapGraphics system

    Parameter(s):
    0: Group name <String> (Default: "")

    Returns:
    None
*/

params [
    ["_groupName", "", [""]]
];

GVAR(MapGraphicsGroup) deleteAt (toLowerANSI _groupName);

[_groupName, "hoverin"] call CFUNC(removeMapGraphicsEventHandler);
[_groupName, "hoverout"] call CFUNC(removeMapGraphicsEventHandler);
[_groupName, "dblclicked"] call CFUNC(removeMapGraphicsEventHandler);
[_groupName, "clicked"] call CFUNC(removeMapGraphicsEventHandler);

// increment map graphics cache
GVAR(MapGraphicsCacheBuildFlag) = GVAR(MapGraphicsCacheBuildFlag) + 1;
