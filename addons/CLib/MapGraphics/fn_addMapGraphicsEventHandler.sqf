#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Adds an eventhandler to a MapGraphics draw

    Parameter(s):
    0: Icon Id <String> (Default: "")
    1: Event name <String> (Default: "")
    2: Code that gets executed on event <Code, String> (Default: {})
    3: Arguments passed to the event <Anything> (Default: [])

    Returns:
    ID of the Event <Number>
*/

params [
    ["_uid", "", [""]],
    ["_eventName", "", [""]],
    ["_code", {}, [{}, ""]],
    ["_args", [], []]
];

// build Namespace Variablename
private _eventNameSpace = format [QGVAR(MapIcon_%1_EventNamespace), _eventName];
private _namespace = missionNamespace getVariable _eventNameSpace;

// Check if namespace exist and if not create and save it
if (isNil "_namespace") then {
    _namespace = call CFUNC(createNamespace);
    missionNamespace setVariable [_eventNameSpace, _namespace];
};

private _eventArray = _namespace getVariable [_uid, []];

private _id = _eventArray pushBack [_code, _args];

_namespace setVariable [_uid, _eventArray];

_id
