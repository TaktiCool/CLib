#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Caches values from config properties

    Parameter(s):
    https://community.bistudio.com/wiki/configProperties

    Returns:
    https://community.bistudio.com/wiki/configProperties
*/

private _ret = GVAR(configCache) getVariable format [QGVAR(configProperties_%1), _this];
if (isNil "_ret") then {
    _ret = configProperties _this;
    GVAR(configCache) setVariable [format [QGVAR(configProperties_%1), _this], _ret];
};
_ret
