#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Return all Parents of a ConfigClass and Cache them in a Namespace

    Parameter(s):
    0: ConfigPath <ConfigPath>
    1: return Names <Bool>

    Returns:
    all Partent Classes <Array<ConfigPath>>
*/
private _ret = GVAR(configCache) getVariable format [QGVAR(returnParents_%1), _this];
if (isNil "_ret") then {
    _ret = _this call BIS_fnc_returnParents;
    GVAR(configCache) setVariable [format [QGVAR(returnParents_%1), _this], _ret];
};
_ret
