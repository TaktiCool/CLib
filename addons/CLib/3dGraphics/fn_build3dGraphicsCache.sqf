#include "macros.hpp"
/*
    Community Lib - CLib

    Author: BadGuy

    Description:
    Updates the 3dGraphicsCache

    Parameter(s):
    None

    Returns:
    None
*/

private _cache = [];

{
    _cache append _y;
} forEach (values GVAR(3dGraphicsNamespace));

GVAR(3dGraphicsCache) = +_cache;
