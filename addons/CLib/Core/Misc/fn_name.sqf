#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    Get Player Name if the Unit is Dead

    Parameter(s):
    0: Unit what the name will be get Detected <Object>

    Returns:
    Name Of the Unit <String>
*/
params ["_unit"];

if (isNull _unit) exitWith {"objNull"};
private _ret = _unit getVariable QGVAR(playerName);

// fallback if the Unit dont have a Name set
if (isNil "_ret") then {
    _ret = name _unit;
    // fall back if the unit/Object have no name
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
