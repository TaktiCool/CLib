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

private _ret = GVAR(configCache) getVariable format [QGVAR(returnParents_%1), _this];
if (isNil "_ret") then {
    _ret = _this call BIS_fnc_returnParents;
    GVAR(configCache) setVariable [format [QGVAR(returnParents_%1), _this], _ret];
};
_ret
