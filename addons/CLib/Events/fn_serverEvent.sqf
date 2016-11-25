#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    trigger a event on the Server

    Parameter(s):
    0: Event Name <String>
    1: Arguments <Any>

    Returns:
    None
*/
params [["_event", "EventError", [""]], ["_args", []]];

if (isServer) then {
    [_event, _args] call CFUNC(localEvent);
} else {
    #ifdef isDev
        // [_event, _args, "2"] remoteExecCall [QCFUNC(localEvent), 2];
        [[_event, _args, "2"], QCFUNC(localEvent), 2, true] call CFUNC(remoteExec);
    #else
        // [_event, _args] remoteExecCall [QCFUNC(localEvent), 2];
        [[_event, _args], QCFUNC(localEvent), 2, true] call CFUNC(remoteExec);
    #endif
};
