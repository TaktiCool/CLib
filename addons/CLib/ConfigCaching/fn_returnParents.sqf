#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Returns all parents of a ConfigClass and caches them in a namespace

    Parameter(s):
    https://community.bistudio.com/wiki/BIS_fnc_returnParents

    Returns:
    https://community.bistudio.com/wiki/BIS_fnc_returnParents
*/

GVAR(configCache) getOrDefaultCall [toLower (format [QGVAR(returnParents_%1), _this]), {
    _this call BIS_fnc_returnParents
}];
