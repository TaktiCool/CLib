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
GVAR(mutexCaches) = false call CFUNC(createNamespace);

// EH which fires on server response
[QGVAR(mutexLock), {
    (_this select 0) params ["_mutexId"];

    private _mutexCache = [GVAR(mutexCaches), _mutexId, []] call CFUNC(getVariable);

    // Its time to execute the cached functions.
    {
        _x params ["_code", "_args"];

        if (_code isEqualType "") then {
            _code = missionNamespace getVariable [_code, {}];
        };

        if (_code isEqualType {}) then {
            _args call _code;
        };
        nil
    } count +_mutexCache;

    // Empty the cache
    GVAR(mutexCaches) setVariable [_mutexId, []];

    // Tell the server that we finished
    [QGVAR(unlockMutex), _mutexId] call CFUNC(serverEvent);
}] call CFUNC(addEventHandler);
