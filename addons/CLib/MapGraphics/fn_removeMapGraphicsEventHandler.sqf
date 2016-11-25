#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Remove a Map Icon Draw Event

    Parameter(s):
    0: Group Name <String>
    1: Event Name <String>
    2: Event ID (optional) <Number>

    Returns:
    None
*/
params [["_uid", "", [""]], ["_event", "", [""]], ["_id", -1, [-1]]];

// build Namespace Variablename
_eventNameSpace = format [QGVAR(MapIcon_%1_EventNamespace), _eventName];
private _namespace = missionNamespace getVariable _eventNameSpace;

private _eventArray = [_namespace, _uid, []] call CFUNC(getVariable);
if (_id == -1) then {
    {
        _eventArray set [_forEachIndex, nil];
    } forEach _eventArray;
} else {
    if ((count _eventArray) <= _id) exitWith {};
    _eventArray set [_id, nil];
};

GVAR(MapGraphicsCacheBuildFlag) = GVAR(MapGraphicsCacheBuildFlag) + 1;
