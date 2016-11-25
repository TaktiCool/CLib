#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    add a Eventhandler to a Map Icon Draw

    Parameter(s):
    0: Icon Id <String>
    1: Icon Event Name <String>
    2: Code that get Executed on this Event <Code or String>
    3: Arugments that get return in the Event <Any>
    
    Returns:
    ID of the Event <Number>
*/
params [["_uid", "", [""]], ["_eventName", "", [""]], ["_code", {}, ["", {}]], ["_args", []]];

// build Namespace Variablename
_eventNameSpace = format [QGVAR(MapIcon_%1_EventNamespace), _eventName];
private _namespace = missionNamespace getVariable _eventNameSpace;

// Check if namespace exist and if not create and save it
if (isNil "_namespace") then {
    _namespace = call CFUNC(createNamespace);
    missionNamespace setVariable [_eventNameSpace, _namespace];
};

private _eventArray = [_namespace, _uid, []] call CFUNC(getVariable);

private _id = _eventArray pushBack [_code, _args];

_namespace setVariable [_uid, _eventArray];

_id
