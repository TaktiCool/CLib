#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Removes a MapGraphics draw event

    Parameter(s):
    0: Group name <String>
    1: Event name <String>
    2: Event ID <Number> (Default: -1)

    Returns:
    None
*/
params [["_uid", "", [""]], ["_eventName", "", [""]], ["_id", -1, [-1]]];

// build Namespace Variablename
private _eventNameSpace = format [QGVAR(MapIcon_%1_EventNamespace), _eventName];
private _namespace = missionNamespace getVariable [_eventNameSpace, objNull];

if (isNull _namespace) exitWith {};

private _eventArray = _namespace getVariable [_uid, []];
if (_id == -1) then {
    _namespace setVariable [_uid, nil];
} else {
    if ((count _eventArray) <= _id) exitWith {};
    _eventArray set [_id, nil];
};

GVAR(MapGraphicsCacheBuildFlag) = GVAR(MapGraphicsCacheBuildFlag) + 1;
