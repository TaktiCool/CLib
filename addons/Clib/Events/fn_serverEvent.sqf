#include "macros.hpp"
/*
    Comunity Lib - Clib

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
        [_event, _args, "2"] remoteExecCall [QFUNC(localEvent), 2];
    #else
        [_event, _args] remoteExecCall [QFUNC(localEvent), 2];
    #endif
};
