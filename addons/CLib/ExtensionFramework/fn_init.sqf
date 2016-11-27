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
    (GVAR(taskIds) getVariable [_id, [{}, []]]) params ["_callback", "_args"];

    [_result, _args] call _callback;
}] call CFUNC(addEventHandler);