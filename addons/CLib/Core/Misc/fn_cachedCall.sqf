#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Original author: esteldunedain, Jaynus
    https://github.com/acemod/ACE3/blob/05d30c55732b95cfe38d145c738f3fdc227aec18/addons/common/functions/fnc_cachedCall.sqf

    Description:
    Calls the given function and caches the result for a period of time

    Parameter(s):
    0: Cache ID <String>
    1: Function whose return value gets cached <String, Code>
    2: Arguments <Any>
    3: Time until the cached values are being obsolet <Number>
    4: Event that clears the cache <String>

    Returns:
    0: Return Name <TYPE>
*/
params ["_uid", "_fnc", "_args", "_duration", "_event"];
if (([GVAR(cachedCall), _uid, [-9999999]] call CFUNC(getVariable)) select 0 < time) then {
    GVAR(cachedCall) setVariable [_uid, [time + _duration, _args call _fnc]];

    // Does the cache need to be cleared on an event?
    if (!isNil "_event") then {
        private _varName = format [QGVAR(clearCache_%1), _event];
        private _cacheList = GVAR(cachedCall) getVariable _varName;

        // If there was no EH to clear these caches, add one
        if (isNil "_cacheList") then {
            _cacheList = [];
            GVAR(cachedCall) setVariable [_varName, _cacheList];

            [_event, {
                // _eventName is defined on the function that calls the event
                // Get the list of caches to clear
                private _varName = format [QGVAR(clearCache_%1), _eventName];
                private _cacheList = [GVAR(cachedCall), _varName, []] call CFUNC(getVariable);
                // Erase all the cached results
                {
                    GVAR(cachedCall) setVariable [_x, nil];
                    nil
                } count _cacheList;
                // Empty the list
                GVAR(cachedCall) setVariable [_varName, []];
            }] call CFUNC(addEventhandler);
        };

        // Add this cache to the list of the event
        _cacheList pushBack _uid;
    };
};

(GVAR(cachedCall) getVariable _uid) select 1
