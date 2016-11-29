#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas, NetFusion

    Description:
    Init Some Events for Extension Framework

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(tasks) = [];
GVAR(pendingTasks) = 0;

// Communication control
GVAR(SOH) = toString [1];
GVAR(STX) = toString [2];
GVAR(ETX) = toString [3];
GVAR(EOT) = toString [4];
GVAR(ENQ) = toString [5];
GVAR(ACK) = toString [6];

// Information separators
GVAR(RS) = toString [30];
GVAR(US) = toString [31];

[QGVAR(extensionRequest), {
    (_this select 0) params ["_extensionName", "_actionName", "_data", "_sender", "_clientTaskId"];

    // Assign the sender details to the task id to return the result when its there
    private _taskId = GVAR(tasks) find objNull;
    if (_taskId == -1) then {
        _taskId = GVAR(tasks) pushBack [_sender, _clientTaskId];
    } else {
        GVAR(tasks) set [_taskId, [_sender, _clientTaskId]];
    };

    private _result = [_taskId, _extensionName, _actionName, _data] call FUNC(extensionRequest);

    if (!(isNil "_result")) then {
        GVAR(tasks) set [_taskId, objNull];

        [QGVAR(extensionResult), _sender, [_clientTaskId, _result]] call CFUNC(targetEvent);
    };
}] call CFUNC(addEventHandler);