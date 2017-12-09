#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    -

    Parameter(s):
    0: Event ID <String>
    1: Functions <Code>
    2: Arguments <Any>

    Returns:
    the ID of the Current Eventhandler <Number>
*/

EXEC_ONLY_UNSCHEDULED

params [["_event", "", [""]], ["_function", {}, [{}, ""]], ["_args", []]];

// add This so we get can get sure some events that only gets triggered once get right
["eventAdded", [_event, _function, _args]] call CFUNC(localEvent);

private _eventArray = GVAR(EventNamespace) getVariable [_event, []];
private _id = _eventArray pushBack [_function, _args];
GVAR(EventNamespace) setVariable [_event, _eventArray];

_id
