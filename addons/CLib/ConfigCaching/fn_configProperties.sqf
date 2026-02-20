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

    params [
        ["_config", configNull, [configNull]],
        ["_filter", "", [""]],
        ["_recurse", false, [false]]
    ];

    if (_this select 1 == "_filter") then {
        "true" configClasses _config;
    } else {
        configProperties _this;
    };

    
}];
