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

params [["_path", configNull, [configNull, []]], ["_default", "", [[], "", 0]], ["_forceDefaultType", false, [true]]];
// convert Array Config Path to Config Path
if (_path isEqualType []) then {
    _path = _path call FUNC(arrayToPath);
};
private _ret = GVAR(configCache) getVariable format [QGVAR(getCachedData_%1), _path];
if (isNil "_ret") then {
    _ret = _default;
    if (_forceDefaultType) then {
        switch (typeName _default) do {
            case "NUMBER": {
                if (isNumber _path || isText _path) then { // some config Values can be stores as text in a Calculation
                    _ret = getNumber _path;
                };
            };
            case "STRING": {
                if (isText _path) then {
                    _ret = getText _path;
                };
            };
            case "ARRAY": {
                if (isArray _path) then {
                    _ret = getArray _path;
                };
            };
        };
    } else {
        switch (true) do {
            case (isNumber _path): {
                _ret = getNumber _path;
            };
            case (isText _path): {
                _ret = getText _path;
            };
            case (isArray _path): {
                _ret = getArray _path;
            };
        };
    };
    GVAR(configCache) setVariable [format [QGVAR(getCachedData_%1), _path], _ret];
};
_ret
