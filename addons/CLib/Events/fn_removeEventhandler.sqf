#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Remove Eventhandler

    Parameter(s):
    0: Event name <String>
    1: ID <Number>

    Returns:
    is Removed <Bool>
*/
params [["_event", "", [""]], ["_id", -1, [-1]]];

DUMP("Eventhandler Removed: "+ _event);
private _eventArray = GVAR(EventNamespace) getVariable [_event, []];
if (count _eventArray >= _id) then {
    _eventArray set [_id, nil];
    GVAR(EventNamespace) setVariable [_event, _eventArray];
    true
} else {
    false
};
