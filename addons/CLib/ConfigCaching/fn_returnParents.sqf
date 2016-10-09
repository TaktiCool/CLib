#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    Returns all parents of a ConfigClass and caches them in a namespace

    Parameter(s):
    0: ConfigPath <ConfigPath>
    1: Return names <Bool>

    Returns:
    All Parent Classes <Array<ConfigPath>>
*/
private _ret = GVAR(configCache) getVariable format [QGVAR(returnParents_%1), _this];
if (isNil "_ret") then {
    _ret = _this call BIS_fnc_returnParents;
    GVAR(configCache) setVariable [format [QGVAR(returnParents_%1), _this], _ret];
};
_ret
