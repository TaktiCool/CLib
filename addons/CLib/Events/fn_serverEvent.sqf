#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Trigger an event on the server

    Parameter(s):
    0: Event Name <String> (Default: "EventError")
    1: Arguments <Anything> (Default: [])

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_event", "EventError", [""]],
    ["_args", [], []]
];

if (isServer) then {
    [_event, _args] call CFUNC(localEvent);
} else {
    #ifdef ISDEV
        [[_event, _args, "2"], QCFUNC(localEvent), 2, true] call CFUNC(remoteExec);
    #else
        [[_event, _args], QCFUNC(localEvent), 2, true] call CFUNC(remoteExec);
    #endif
};
