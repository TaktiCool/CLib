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

private _ignoredAddons = getArray (configFile >> QPREFIX >> "ModCheck" >> "IgnoredAddons") apply {toLower (_x)};
private _allAddons = [call FUNC(getAllAddons), _ignoredAddons] call DFUNC(clearAddons);
GVAR(serverAddons) = [_allAddons, _ignoredAddons];

publicVariable QGVAR(serverAddons);
