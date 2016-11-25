#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Gets player name if the corresponding unit is dead

    Parameter(s):
    0: Unit whose name will be detected <Object>

    Returns:
    Name of the unit <String>
*/
params ["_unit"];

if (isNull _unit) exitWith {"objNull"};
private _ret = _unit getVariable QGVAR(playerName);

// fallback if the Unit doesn't have a name set
if (isNil "_ret") then {
    _ret = name _unit;
    // fall back if the unit/Object has no name
    if (_ret == "Error: No vehicle") then {
        [{
            if (_this getVariable [QGVAR(playerName), ""] != "") exitWith {
                _this setVariable [QGVAR(playerName), name _this, true];
            };
        }, {
            name _this == "Error: No vehicle" || _this getVariable [QGVAR(playerName), ""] != ""
        }, _unit] call CFUNC(waitUntil);
    }
};
_ret
