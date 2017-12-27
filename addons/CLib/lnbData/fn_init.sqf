#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init for ListBox data

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(lnbDataControlCache) = [];

[{
    GVAR(lnbDataControlCache) = GVAR(lnbDataControlCache) - [controlNull];
}, 1] call CFUNC(addPerFrameHandler);
