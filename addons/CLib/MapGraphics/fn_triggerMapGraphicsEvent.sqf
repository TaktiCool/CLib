#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Trigger a Eventhandler on a Map Icon Draw

    Parameter(s):
    0: Icon Id <String> (Default: "")
    1: Icon Event Name <String> (Default: "")
    2: Arguments <Anything> (Default: [])

    Returns:
    None
*/

params [
    ["_uid", "", [""]],
    ["_eventName", "", [""]],
    ["_args", [], []]
];

private _eventNameSpace = format [QGVAR(MapIcon_%1_EventNamespace), _eventName];
private _namespace = missionNamespace getVariable _eventNameSpace;

if (isNil "_namespace") exitWith {};

 
private _eventArray = _namespace get (toLowerANSI _uid);

if (isNil "_eventArray") exitWith {};

{
    if !(isNil "_x") then {
        _x params ["_code", "_data"];
        if (_code isEqualType "") then {
            _code = parsingNamespace getVariable [_code, {}];
        };
        [_args, _data] call _code;
    };
} forEach _eventArray;
nil
