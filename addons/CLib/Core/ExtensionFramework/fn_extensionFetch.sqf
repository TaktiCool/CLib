#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Fetch data from extension. Data transmission according to RFC20.
    See https://tools.ietf.org/pdf/rfc20.pdf for details.

    Parameter(s):
    0: Result <String>

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED

params ["_result"];

// If there is more data acknowledge and collect more
while {_result select [count _result - 1] != GVAR(EOT)} do {
    _result = _result + ("CLib" callExtension GVAR(ACK));
};
_result = _result select [0, count _result - 1];

// Parse the data
if (_result select [0, 1] == GVAR(STX)) exitWith {
    _result select [1]
};

if (_result select [0, 1] == GVAR(SOH)) exitWith {
    private _results = _result splitString GVAR(SOH);
    {
        (_x splitString GVAR(STX)) params ["_taskId", "_result"];
        _taskId = parseNumber _taskId;
        (GVAR(tasks) param [_taskId, [objNull, 0]]) params ["_sender", "_senderId"];
        GVAR(tasks) set [_taskId, objNull];

        [QGVAR(extensionResult), _sender, [_senderId, _result]] call CFUNC(targetEvent);
        GVAR(pendingTasks) = GVAR(pendingTasks) - 1;
        nil
    } count _results;
};
