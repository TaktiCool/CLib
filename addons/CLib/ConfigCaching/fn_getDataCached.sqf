#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Caches Values from configProperties

    Parameter(s):
    0: Config Path <Config, Array<String>>
    1: Default Return if config Entry dont exist <String, Number, Array> (Default: "")
    2: Force Type of Default Value <Bool> (Default: false)

    Returns:
    Config Value <Sring, Number, Array>
*/

params [["_path", configNull, [configNull, []]], ["_default", "", [[], "", 0]], ["_forceDefaultType", false, [true]]];
// convert Array Config Path to Config Path
if (_path isEqualType []) then {
    _path = _path call CFUNC(arrayToPath);
};
private _ret = GVAR(configCache) getVariable format [QGVAR(getCachedData_%1), _path];
if (isNil "_ret") then {
    _ret = _default;
    if (_forceDefaultType) then {
        switch (typeName _default) {
            case "NUMBER": {
                if (isNumber _path) then {
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
        switch (true) {
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
