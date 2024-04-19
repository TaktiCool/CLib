#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Get a Config Value and Cache the Value to reduce config accesses while runtime.

    Parameter(s):
    0: Config path <Config> (Default: configNull)
    1: Default return <String, Number, Array> (Default: "")
    2: Force return type <Bool> (Default: false)

    Returns:
    Config Value <String, Number, Array>
*/

params [
    ["_path", configNull, [configNull]],
    ["_default", "", ["", 0, []], []],
    ["_forceDefaultType", false, [true]]
];

GVAR(configCache) getOrDefaultCall [toLower (format [QGVAR(getCachedData_%1), _path]), {
[_path, _default, _forceDefaultType] call CFUNC(getConfigData);
}];
