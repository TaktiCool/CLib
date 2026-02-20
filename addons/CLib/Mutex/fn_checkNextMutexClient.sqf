#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Init for mutex system on server

    Parameter(s):
    None

    Returns:
    None
*/

params ["_mutexId"];

private _mutex = GVAR(mutexes) getOrDefault [_mutexId, [0, [], 0]];
_mutex params ["_currentClient", "_clientQueue", "_currentMutexTime"];

if (_clientQueue isNotEqualTo []) then {
    // Next client in queue
    _currentMutexTime = time;
    _currentClient = _clientQueue deleteAt 0;
    GVAR(mutexes) set [_mutexId, [_currentClient, _clientQueue, _currentMutexTime]];
    [QGVAR(mutexLock), _currentClient, _mutexId] call CFUNC(targetEvent);
} else {
    // Reset current client because no next client available
    GVAR(mutexes) set [_mutexId, [0, [], 0]]
};
