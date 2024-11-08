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

GVAR(configCache) getOrDefaultCall [toLowerANSI (format [QGVAR(configProperties_%1), _this]), {
    configProperties _this
}];
