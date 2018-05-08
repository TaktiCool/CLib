#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Call extension on the server. When the server finished the return value gets passed to the callback as a parameter.

    Parameter(s):
    0: Extension name <String>
    0: Action name <String>
    2: Data <Any> (optional)
    3: Callback <Code> (optional)
    3: Arguments <Any> (optional)

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params ["_extensionName", "_actionName", ["_data", ""], ["_callback", {}], ["_args", []]];

private _id = GVAR(taskIds) find objNull;
if (_id == -1) then {
    _id = GVAR(taskIds) pushBack [_callback, _args];
} else {
    GVAR(taskIds) set [_id, [_callback, _args]];
};

private _sender = [CLib_Player, 2] select isServer;
[QGVAR(extensionRequest), [_extensionName, _actionName, _data, _sender, _id]] call CFUNC(serverEvent);
