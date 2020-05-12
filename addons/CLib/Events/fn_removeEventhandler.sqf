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
private _eventArray = GVAR(EventNamespace) getVariable [_event, []];
if (count _eventArray >= _id) then {
    _eventArray set [_id, nil];
    GVAR(EventNamespace) setVariable [_event, _eventArray];
    true
} else {
    false
};
