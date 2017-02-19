#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Trigger a event on every machine

    Parameter(s):
    0: Event name <String>
    1: Arguments <Any>
    2: Persistent <String, Number>

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED

params [["_event", "EventError", [""]], ["_args", []], "_persistent"];
#ifdef ISDEV
    [[_event, _args, (if (isDedicated) then {"2"} else {(format ["%1:%2", profileName, CGVAR(playerUID)])})], QCFUNC(localEvent), 0, true] call CFUNC(remoteExec);
#else
    [[_event, _args], QCFUNC(localEvent), 0, true] call CFUNC(remoteExec);
#endif

if !(isNil "_persistent") then {
    ["registerJIPQueue", [_persistent, _args, _event], true] call CFUNC(serverEvent);
};
