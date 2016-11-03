#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Caches Values from configProperties

    Parameter(s):
    configProperties Arguments

    Returns:
    configProperties Arguments
*/
private _ret = GVAR(configCache) getVariable format [QGVAR(configProperties_%1), _this];
if (isNil "_ret") then {
    _ret = configProperties _this;
    GVAR(configCache) setVariable [format [QGVAR(configProperties_%1), _this], _ret];
};
_ret
