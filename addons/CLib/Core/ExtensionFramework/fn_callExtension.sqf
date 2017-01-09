#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Call extension from the Client to the Server
    After the server Finish the call the extension and getting the result the server transfer the Retunred value to the client
    and calling on the Client the attached Function

    Parameter(s):
    0: Extension name <String>
    0: Action name <String>
    2: Data <Any> (optional)
    3: Callback <Code> (optional)
    3: Arguments <Any> (optional)

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED

params ["_extensionName", "_actionName", ["_data", []], ["_callback", {}], ["_args", []]];

private _id = GVAR(taskIds) find objNull;
if (_id == -1) then {
    _id = GVAR(taskIds) pushBack [_callback, _args];
} else {
    GVAR(taskIds) set [_id, [_callback, _args]];
};

[QGVAR(extensionRequest), [_extensionName, _actionName, _data, CLib_Player, _id]] call CFUNC(serverEvent);
