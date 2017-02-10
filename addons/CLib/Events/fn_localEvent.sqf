#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Trigger Event on a Traget

    Parameter(s):
    0: Event name <String>
    1: Arguments <Any> (Default: nil)

    Returns:
    Return of Last set on _CLib_EventReturn <Any>
*/

EXEC_ONLY_UNSCHEDULED

#ifdef ISDEV
    params [["_eventName", "", [""]], ["_args", []], ["_sender", "Local Called"]];

    // dont Log to reduce Spam
    if (!(toLower _eventName in GVAR(ignoredLogEventNames_0))) then {
        // remove spamm events like eventadded, cursortargetchanged, playerinventorychanged from being logged
        if (toLower _eventName in GVAR(ignoredLogEventNames_1)) then {
            DUMP("Local event: " + "Sendet from: " + _sender + "; EventName: " + _eventName)
        } else {
            DUMP("Local event: " + "Sendet from: " + _sender + "; EventName: " + _eventName + ":" + str _args)
        };
    };
#else
    params [["_eventName", "", [""]], ["_args", []]];
#endif

private _eventArray = GVAR(EventNamespace) getVariable _eventName;
private _CLib_EventReturn = nil;
if (!isNil "_eventArray") then {
    {
        if (!isNil "_x") then {
            _x params ["_eventFunctions", "_data"];
            if (_eventFunctions isEqualType "") then {
                _eventFunctions = parsingNamespace getVariable [_eventFunctions, {LOG("ERROR: Function call Over Eventhandler Dont Exist: " + _eventFunctions)}];
            };
            [_args, _data] call _eventFunctions;
        };
        nil
    } count _eventArray;
};
if (isNil "_CLib_EventReturn") then {
    nil
} else {
    DUMP("Event " + _eventName + " Returned: " + str _CLib_EventReturn);
    _CLib_EventReturn
};
