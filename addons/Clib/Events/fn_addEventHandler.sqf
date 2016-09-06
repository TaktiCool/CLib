#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: joko // Jonas

    Description:
    [Description]

    Parameter(s):
    0: Event ID <String>
    1: Functions <Code>
    2: Arguments <Any>

    Returns:
    the ID of the Current Eventhandler <Number>
*/
params [["_event", "", [""]], ["_function", {}, [{}, ""]], ["_args", []]];

// add This so we get can get sure some events that only gets triggered once get right
["eventAdded", [_event, _function, _args]] call FUNC(localEvent);

_event = format ["Clib_Event_%1", _event];
private _eventArray = [GVAR(EventNamespace), _event, []] call FUNC(getVariable);
private _id = _eventArray pushBack [_function, _args];
GVAR(EventNamespace) setVariable [_event, _eventArray];

_id
