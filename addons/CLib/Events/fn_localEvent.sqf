#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Triggers a Event on the Local Client

    Parameter(s):
    0: Event name <String> (Default: "")
    1: Arguments <Anything> (Default: [])

    Returns:
    Return of Last set on _CLib_EventReturn <Anything>
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_eventName", "EventError", [""]],
    ["_args", [], []]
];

#ifdef ISDEV
    private _CLib_sender = param [2, "Local Called", [""]];
    private _Clib_EventTime = diag_tickTime;
#endif

_eventName = toLower _eventName;

private _eventArray = GVAR(EventNamespace) get _eventName;
private _CLib_EventReturn = nil;
if !(isNil "_eventArray") then {
    {
        if !(isNil "_x") then {
            _x params ["_eventFunctions", "_data"];
            if (_eventFunctions isEqualType "") then {
                _eventFunctions = parsingNamespace getVariable [_eventFunctions, {LOG("ERROR: Function call Over Eventhandler Dont Exist: " + _eventFunctions)}];
            };
            [_args, _data] call _eventFunctions;
        };
    } forEach _eventArray;
};

#ifdef ISDEV
    if !(_eventName in GVAR(ignoredLogEventNames_0)) then {
        _Clib_EventTime = ((diag_tickTime - _Clib_EventTime) * 1000) call CFUNC(toFixedNumber);
        private _text = format ["Local Event: %1 (%2ms) sent from %3: %4", _eventName, _Clib_EventTime, _CLib_sender, [_args, ""] select (_eventName in GVAR(ignoredLogEventNames_1))];
        DUMP(_text);
    };
#endif
if (isNil "_CLib_EventReturn") then {
    nil
} else {
    DUMP("Event " + _eventName + " Returned: " + str _CLib_EventReturn);
    _CLib_EventReturn
};
