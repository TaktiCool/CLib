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
    params [["_eventName", "", [""]], ["_args", []], ["_CLib_sender", "Local Called"]];
    private _Clib_EventTime = diag_tickTime;
#else
    params [["_eventName", "", [""]], ["_args", []]];
#endif

private _eventArray = GVAR(EventNamespace) getVariable _eventName;
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
        nil
    } count _eventArray;
};

#ifdef ISDEV
    if (!(toLower _eventName in GVAR(ignoredLogEventNames_0))) then {
        _Clib_EventTime = ((diag_tickTime - _Clib_EventTime) * 1000) call CFUNC(toFixedNumber);
        private _text = format ["Local Event: %1 (%2ms) Sendet from %3: %4", _eventName, _Clib_EventTime , _CLib_sender, [_args, ""] select ((toLower _eventName) in GVAR(ignoredLogEventNames_1))];
        DUMP(_text);
    };
#endif
if (isNil "_CLib_EventReturn") then {
    nil
} else {
    DUMP("Event " + _eventName + " Returned: " + str _CLib_EventReturn);
    _CLib_EventReturn
};
