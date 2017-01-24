#include "macros.hpp"
/*
    Community Lib - CLib
    Author: joko // Jonas
    Description:
    Server for Core Module
    Parameter(s):
    None
    Returns:
    None
*/
GVAR(serverAddons) = [call FUNC(getAllAddons), (getArray (configFile >> QPREFIX + "_IgnoredAddons"))];
publicVariable QGVAR(serverAddons);
