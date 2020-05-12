#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Get a Config Value and Cache the Value to reduce config accesses while runtime.

    Parameter(s):
    0: Config path <Config, Array>
    1: Default return <String, Number, Array> (Default: "")
    2: Force return type <Bool> (Default: false)

    Returns:
    Config Value <Sring, Number, Array>
*/

params [["_path", configNull, [configNull]], ["_default", "", [[], "", 0]], ["_forceDefaultType", false, [true]]];

private _ret = GVAR(configCache) getVariable format [QGVAR(getCachedData_%1), _path];
if (isNil "_ret") then {
    _ret = [_path, _default, _forceDefaultType] call CFUNC(getConfigData);

    GVAR(configCache) setVariable [format [QGVAR(getCachedData_%1), _path], _ret];
};
_ret
