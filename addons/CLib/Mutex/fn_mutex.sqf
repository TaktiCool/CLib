#include "macros.hpp"
/*
    Community Lib - CLib

    Author: NetFusion

    Description:
    Executes a block of code and prevents it from being partially executed on different clients.

    Parameter(s):
    0: Code which gets executed <Code> (Default: {})
    1: Aruments for the Code <Anything> (Default: [])
    2: Mutex identifier <String> (Default: main)

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_code", {}, [{}]],
    ["_args", [], []],
    ["_mutexId", "main", [""]]
];

private _mutexCache = GVAR(mutexCaches) getVariable [_mutexId, []];

// Cache the function and args
private _index = _mutexCache pushBackUnique [_code, _args];

// Exit if there was an duplicate detected
if (_index == -1) exitWith {};

GVAR(mutexCaches) setVariable [_mutexId, _mutexCache];

// Tell the server that there is something to execute
[QGVAR(mutexRequest), [CLib_Player, _mutexId]] call CFUNC(serverEvent);
