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

// Queue of clients who requested mutex executing
GVAR(mutexes) = createHashMap; // Entries are [currentClient, clientQueue, currentMutexTime]

DFUNC(checkNextMutexClient) = {
    params ["_mutexId"];

    private _mutex = GVAR(mutexes) getOrDefault [_mutexId, [0, [], 0]];
    _mutex params ["_currentClient", "_clientQueue", "_currentMutexTime"];

    if (!(_clientQueue isEqualTo [])) then {
        // Next client in queue
        _currentMutexTime = time;
        _currentClient = _clientQueue deleteAt 0;
        GVAR(mutexes) set [_mutexId, [_currentClient, _clientQueue, _currentMutexTime]];
        [QGVAR(mutexLock), _currentClient, _mutexId] call CFUNC(targetEvent);
    } else {
        // Reset current client because no next client available
        GVAR(mutexes) set [_mutexId, [0, [], 0]] call CFUNC(setVariable);
    };
};

// Handle disconnect of client
addMissionEventHandler ["PlayerDisconnected", {
    params ["", "", "", "", "_owner"];

    {
        private _mutex = _y;
        _mutex params ["_currentClient", "_clientQueue", "_currentMutexTime"];

        // Clean the queue
        private _index = _clientQueue find _owner;
        if (_index != -1) then {
            _clientQueue deleteAt _index;
            GVAR(mutexes) set [_x, [_currentClient, _clientQueue, _currentMutexTime], QGVAR(mutexesCache)];
        };

        // If the client is currently executing reset the lock
        if (_currentClient == _owner) then {
            _x call FUNC(checkNextMutexClient);
        };
    } forEach GVAR(mutexes);

    false
}];

// EH which fires if a client requests mutex executing
[QGVAR(mutexRequest), {
    (_this select 0) params ["_clientObject", "_mutexId"];

    private _mutex = GVAR(mutexes) getOrDefault [_mutexId, [0, [], 0]];
    _mutex params ["_currentClient", "_clientQueue", "_currentMutexTime"];

    // We enqueue the value in the queue
    _clientQueue pushBackUnique (owner _clientObject);
    GVAR(mutexes) set [_mutexId, [_currentClient, _clientQueue, _currentMutexTime]];

    if (_currentClient == 0) then {
        // Tell the client that he can start and remove him from the queue
        _mutexId call FUNC(checkNextMutexClient);
    };
}] call CFUNC(addEventHandler);

[QGVAR(unlockMutex), {
    (_this select 0) params ["_mutexId"];
    // Tell the client that he can start and remove him from the queue
    _mutexId call FUNC(checkNextMutexClient);
}] call CFUNC(addEventHandler);

GVAR(TimeOutSM) = call CFUNC(createStatemachine);

[GVAR(TimeOutSM), "init", {
    private _mutexIds = +([GVAR(mutexes), QGVAR(mutexesCache)] call CFUNC(allVariables));
    [["checkMutex", _mutexIds], "init"] select (_mutexIds isEqualTo []);
}] call CFUNC(addStatemachineState);

[GVAR(TimeOutSM), "checkMutex", {
    params ["", "_mutexIds"];
    private _mutexId = _mutexIds deleteAt 0;
    private _mutex = GVAR(mutexes) getOrDefault [_mutexId, [0, [], 0]];
    _mutex params ["", "_clientQueue", "_currentMutexTime"];
    if (!(_clientQueue isEqualTo []) && (time - _currentMutexTime) > 3) then {
        _mutexId call FUNC(checkNextMutexClient);
    };
    [["checkMutex", _mutexIds], "init"] select (_mutexIds isEqualTo []);
}] call CFUNC(addStatemachineState);

[GVAR(TimeOutSM), "init", 0.5] call CFUNC(startStatemachine);
