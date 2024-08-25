#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Adds an event handler

    Parameter(s):
    0: Event ID <String> (Default: "EventError")
    1: Callback <Code, String> (Default: {})
    2: Arguments <Anything> (Default: [])

    Returns:
    ID of the Current Eventhandler <Number>
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_event", "EventError", [""]],
    ["_callback", {}, [{}, ""]],
    ["_args", [], []]
];
_event = toLowerANSI _event;
// Add this so we get can get sure some events that only gets triggered once get right
["eventAdded", [_event, _callback, _args]] call CFUNC(localEvent);

private _eventArray = GVAR(EventNamespace) getOrDefault [_event, []];
private _id = _eventArray pushBack [_callback, _args];
GVAR(EventNamespace) set [_event, _eventArray];

_id
