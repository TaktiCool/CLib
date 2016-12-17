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
    (_this select 0) params ["_id", "_result"];
    private _taskId = GVAR(taskIds) param [_id, objNull];
    if (_taskId isEqualType objNull) exitWith {};

    _taskId params ["_callback", "_args"];
    GVAR(taskIds) set [_id, objNull];

    [_result, _args] call _callback;
}] call CFUNC(addEventHandler);