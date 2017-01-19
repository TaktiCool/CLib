#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Caches values from config properties

    Parameter(s):
    0: Config <Config>
    1: Condition <String>
    2: Inherit <Bool>

    Returns:
    configProperties Return
*/

private _ret = GVAR(configCache) getVariable format [QGVAR(configProperties_%1), _this];
if (isNil "_ret") then {
    _ret = configProperties _this;
    GVAR(configCache) setVariable [format [QGVAR(configProperties_%1), _this], _ret];
};
_ret
