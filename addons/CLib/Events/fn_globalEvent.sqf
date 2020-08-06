#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Trigger a event on every machine

    Parameter(s):
    0: Event name <String> (Default: "EventError")
    1: Arguments <Anything> (Default: [])
    2: Persistent <String, Bool> (Default: false)

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_event", "EventError", [""]],
    ["_args", [], []],
    ["_persistent", false, ["", true]]
];

#ifdef ISDEV
    [[_event, _args, (if (isDedicated) then {"2"} else {(format ["%1:%2", profileName, CGVAR(playerUID)])})], QCFUNC(localEvent), 0, true] call CFUNC(remoteExec);
#else
    [[_event, _args], QCFUNC(localEvent), 0, true] call CFUNC(remoteExec);
#endif

if (!(_persistent isEqualType true && {!_persistent})) then {
    ["registerJIPQueue", [_persistent, _args, _event], true] call CFUNC(serverEvent);
};
