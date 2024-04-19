#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Removes a MapGraphics draw event

    Parameter(s):
    0: Group name <String> (Default: "")
    1: Event name <String> (Default: "")
    2: Event ID <Number> (Default: -1)

    Returns:
    None
*/

params [
    ["_uid", "", [""]],
    ["_eventName", "", [""]],
    ["_id", -1, [0]]
];

// build Namespace Variablename
private _eventNameSpace = format [QGVAR(MapIcon_%1_EventNamespace), _eventName];
private _namespace = missionNamespace getVariable [_eventNameSpace, objNull];

if (isNull _namespace) exitWith {};

_uid = toLower _uid;

private _eventArray = _namespace getOrDefault [_uid, []];
if (_id == -1) then {
    _namespace set [_uid, nil];
} else {
    if ((count _eventArray) <= _id) exitWith {};
    _eventArray set [_id, nil];
};

_namespace set [_uid, _eventArray];
GVAR(MapGraphicsCacheBuildFlag) = GVAR(MapGraphicsCacheBuildFlag) + 1;
