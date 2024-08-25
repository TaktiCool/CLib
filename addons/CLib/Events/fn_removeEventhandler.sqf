#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Remove Eventhandler

    Parameter(s):
    0: Event name <String> (Default: "")
    1: ID <Number> (Default: -1)

    Returns:
    Removed <Bool>
*/

params [
    ["_event", "", [""]],
    ["_id", -1, [0]]
];

DUMP("Eventhandler Removed: "+ _event);
_event = toLowerANSI _event;
private _eventArray = GVAR(EventNamespace) getOrDefault [_event, []];
if (count _eventArray >= _id) then {
    _eventArray set [_id, nil];
    GVAR(EventNamespace) set [_event, _eventArray];
    true
} else {
    false
};
