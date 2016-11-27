#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init Some Events for Extension Framework

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(taskIds) = [];

[QGVAR(extensionResult), {
    DUMP(_this)
    (_this select 0) params ["_id", "_result"];
    DUMP(_id)
    DUMP(_result)
    (GVAR(taskIds) select _id) params ["_callback", "_args"];
    DUMP(_callback)
    DUMP(_args)
    GVAR(taskIds) set [_id, objNull];

    [_result, _args] call _callback;
}] call CFUNC(addEventHandler);