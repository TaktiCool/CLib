#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Gets a Object Name or displayName.

    Parameter(s):
    0: Object whose name will be detected <Object> (Default: objNull)

    Returns:
    Name of the Object <String>
*/

params [
    ["_object", objNull, [objNull]]
];

if (isNull _object) exitWith {"objNull"};
private _ret = _object getVariable QGVAR(objectName);

// fallback if the Unit doesn't have a name set
if (isNil "_ret") then {
    if (player == _object) exitWith {
        _ret = profileName;
        _object setVariable [QGVAR(objectName), _ret];
    };
    if (_object isKindOf "CAManBase") then {
        _ret = name _object;
        if (_ret != "Error: No vehicle") exitWith {
            _object setVariable [QGVAR(objectName), _ret];
        };
        _ret = getText (configOf _object >> "displayName");
        _object setVariable [QGVAR(objectName), _ret]; // Temp set the objectName until we found the name
        [{
            if (isNull _this) exitWith {};
            if (_this getVariable [QGVAR(objectName), ""] != "") exitWith {
                _this setVariable [QGVAR(objectName), name _this];
            };
        }, {
            name _this != "Error: No vehicle"
            || _this getVariable [QGVAR(objectName), ""] != ""
            || isNull _this
        }, _object] call CFUNC(waitUntil);
    } else {
        _ret = getText (configOf _object >> "displayName");
        _object setVariable [QGVAR(objectName), _ret];
    };
};
_ret
