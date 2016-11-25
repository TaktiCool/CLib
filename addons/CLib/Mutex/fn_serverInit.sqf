#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Init for Mutex System on Server

    Parameter(s):
    None

    Returns:
    None
*/
// Queue of clients who requested mutex executing
GVAR(mutexes) = false call CFUNC(createNamespace); // Entries are [currentClient, clientQueue, currentMutexTime]

DFUNC(checkNextMutexClient) = {
    params ["_mutexId"];

    private _mutex = [GVAR(mutexes), _mutexId, [0, [], 0]] call CFUNC(getVariable);
    _mutex params ["_currentClient", "_clientQueue", "_currentMutexTime"];

    if (!(_clientQueue isEqualTo [])) then {
        // Next client in queue
        _currentMutexTime = time;
        _currentClient = _clientQueue deleteAt 0;
        [GVAR(mutexes), _mutexId, [_currentClient, _clientQueue, _currentMutexTime], QGVAR(mutexesCache)] call CFUNC(setVariable);
        [QGVAR(mutexLock), _currentClient, _mutexId] call CFUNC(targetEvent);
    } else {
        // Reset current client because no next client available
        [GVAR(mutexes), _mutexId, [0, [], 0], QGVAR(mutexesCache)] call CFUNC(setVariable);
    };
};

// Handle disconnect of client
[QGVAR(mutex), "onPlayerDisconnected", {
    {
        private _mutex = [GVAR(mutexes), _x, [0, []]] call CFUNC(getVariable);
        _mutex params ["_currentClient", "_clientQueue", "_currentMutexTime"];

        // Clean the queue
        private _index =_clientQueue find _owner;
        if (_index != -1) then {
            _clientQueue deleteAt _index;
            [GVAR(mutexes), _x, [_currentClient, _clientQueue, _currentMutexTime], QGVAR(mutexesCache)] call CFUNC(setVariable);
        };

        // If the client is currently executing reset the lock
        if (_currentClient == _owner) then {
            _x call FUNC(checkNextMutexClient);
        };

        nil
    } count ([GVAR(mutexes), QGVAR(mutexesCache)] call CFUNC(allVariables));

    false
}] call BIS_fnc_addStackedEventHandler;

// EH which fired if some client requests mutex executing
[QGVAR(mutexRequest), {
    (_this select 0) params ["_clientObject", "_mutexId"];
    
    private _mutex = [GVAR(mutexes), _mutexId, [0, [], 0]] call CFUNC(getVariable);
    _mutex params ["_currentClient", "_clientQueue", "_currentMutexTime"];

    // We enqueue the value in the queue
    _clientQueue pushBackUnique (owner _clientObject);
    [GVAR(mutexes), _mutexId, [_currentClient, _clientQueue, _currentMutexTime], QGVAR(mutexesCache)] call CFUNC(setVariable);

    if (_currentClient == 0) then {
        // Tell the client that he can start and remove him from the queue
        _mutexId call FUNC(checkNextMutexClient);
    };
}] call CFUNC(addEventHandler);

[QGVAR(unlockMutex), {
    (_this select 0) params ["_mutexId"];

    //private _mutex = [GVAR(mutexes), _mutexId, [0, []]] call CFUNC(getVariable);
    //_mutex params ["_currentClient", "_clientQueue"];
    // Tell the client that he can start and remove him from the queue
    _mutexId call FUNC(checkNextMutexClient);
}] call CFUNC(addEventHandler);

GVAR(TimeOutSM) = call CFUNC(createStatemachine);

[GVAR(TimeOutSM), "init", {
    private _mutexIds = +([GVAR(mutexes), QGVAR(mutexesCache)] call CFUNC(allVariables));
    [["checkMutex", _mutexIds], "init"] select (_mutexIds isEqualTo []);
}] call CFUNC(addStatemachineState);

[GVAR(TimeOutSM), "checkMutex", {
    params ["_dummy", "_mutexIds"];
    private _mutexId = _mutexIds deleteAt 0;
    private _mutex = [GVAR(mutexes), _mutexId, [0, [], 0]] call CFUNC(getVariable);
    _mutex params ["_currentClient", "_clientQueue", "_currentMutexTime"];
    if (!(_clientQueue isEqualTo []) && (time - _currentMutexTime) > 3) then {
        _mutexId call FUNC(checkNextMutexClient);
    };
    [["checkMutex", _mutexIds], "init"] select (_mutexIds isEqualTo []);
}] call CFUNC(addStatemachineState);

[GVAR(TimeOutSM), "init", 0.5] call CFUNC(startStatemachine);
