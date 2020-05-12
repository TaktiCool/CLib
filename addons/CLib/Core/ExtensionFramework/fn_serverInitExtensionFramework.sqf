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

[QGVAR(extensionRequest), {
    (_this select 0) params ["_extensionName", "_actionName", "_data", "_sender", "_clientTaskId"];

    // Assign the sender details to the task id to return the result when its there
    private _taskId = GVAR(tasks) find objNull;
    if (_taskId == -1) then {
        _taskId = GVAR(tasks) pushBack [_sender, _clientTaskId];
    } else {
        GVAR(tasks) set [_taskId, [_sender, _clientTaskId]];
    };

    private _result = [_taskId, _extensionName, _actionName, _data] call CFUNC(extensionRequest);
    if (!isNil "_result") then {
        GVAR(tasks) set [_taskId, objNull];
        [QGVAR(extensionResult), _sender, [_clientTaskId, _result]] call CFUNC(targetEvent);
    };
}] call CFUNC(addEventHandler);

DFUNC(serverLog) = {
    params [["_log", "", [""]], ["_file", "", [""]]];
    _file = _file call CFUNC(sanitizeString);
    ["CLibLogging", "Log", _file + ":" + _log] call CFUNC(callExtension);
};

[QCGVAR(serverLog), {
    (_this select 0) params ["_log", "_id"];
    [_log, _id] call FUNC(serverLog);
}] call CFUNC(addEventhandler);

QCGVAR(sendlogfile) addPublicVariableEventHandler {
    (_this select 1) call FUNC(serverLog);
};
