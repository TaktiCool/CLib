#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: joko // Jonas

    Description:
    trigger a Event on every Maschine

    Parameter(s):
    0: Event Name <String>
    1: Arguments <Any>
    2: is Persistent <String, Number>

    Returns:
    None
*/
params [["_event", "EventError", [""]], ["_args", []], "_persistent"];
#ifdef isDev
    [_event, _args, (if (isDedicated) then {"2"} else {(format ["%1:%2", profileName, CGVAR(playerUID)])})] remoteExecCall [QFUNC(localEvent), 0];
#else
    [_event, _args] remoteExecCall [QFUNC(localEvent), 0];
#endif

if !(isNil "_persistent") then {
    ["registerJIPQueue", [_persistent, _args, _event]] call CFUNC(serverEvent);
};
