#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Removes a 3d Graphics group from the system

    Parameter(s):
    0: Id <String>

    Returns:
    None
*/

params ["_id"];

[GVAR(3dGraphicsNamespace), _id, nil] call CFUNC(setVariable);
GVAR(3dGraphicsCacheBuildFlag) = GVAR(3dGraphicsCacheBuildFlag) + 1;
