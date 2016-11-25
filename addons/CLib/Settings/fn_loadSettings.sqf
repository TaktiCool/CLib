#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Load settings to settings namespace

    Parameter(s):
    None

    Returns:
    None
*/
params ["_prefix", "_config"];

if (!isClass _config) exitWith {};

{
    GVAR(settingsNamespace) setVariable [format ["%1_%2", _prefix, configName _x], switch (true) do {
        case (isArray _x): {getArray _x};
        case (isNumber _x): {getNumber _x};
        case (isText _x): {getText _x};
    }];
    nil
} count (configProperties [_config, "!(isClass _x)"]);

{
    [format ["%1_%2", _prefix, configName _x], _x] call CFUNC(loadSettings);
    nil
} count ("true" configClasses _config);
