#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Init for Mutex System on Client

    Parameter(s):
    None

    Returns:
    None
*/

// Storage for mutex functions
GVAR(mutexCaches) = createHashMap;

// EH which fires on server response
[QGVAR(mutexLock), {
    (_this select 0) params ["_mutexId"];

    private _mutexCache = GVAR(mutexCaches) getOrDefault [_mutexId, []];

    // Its time to execute the cached functions.
    {
        _x params ["_code", "_args"];

        if (_code isEqualType "") then {
            _code = missionNamespace getVariable [_code, {}];
        };

        if (_code isEqualType {}) then {
            _args call _code;
        };
    } forEach +_mutexCache;

    // Empty the cache
    GVAR(mutexCaches) set [_mutexId, []];

    // Tell the server that we finished
    [QGVAR(unlockMutex), _mutexId] call CFUNC(serverEvent);
}] call CFUNC(addEventHandler);
