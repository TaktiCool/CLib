#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Check if the RemoteExecFall Back is used and handle after that the Data and share it to the server

    Parameter(s):
    0: Arguments for the function or command <Anything> (Default: [])
    1: Function or command that get executed on the remote clients <String> (Default: "")
    2: Target who should receive the event <Number, Object, Side, Group, Array> (Default: 0)
    3: Forced to use fallback version <Bool> (Default: false)

    Returns:
    None
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_args", [], []],
    ["_function", "", [""]],
    ["_target", 0, [0, objNull, sideUnknown, grpNull, []], []],
    ["_forceUseFallBack", false, [true]]
];

// exit with Vanilla Method if it is not disabled
if !(GVAR(useRemoteFallback) || _forceUseFallBack) exitWith {
    _args remoteExecCall [_function, _target];
};

// exit if the Target is only server
if (_target isEqualTo 2) exitWith {
    if (isServer) then {
        [_function, _args] call FUNC(execute);
    } else {
        GVAR(remoteExecCode) = [_function, _args];
        publicVariableServer QGVAR(remoteExecCode);
    };
};

// exit if the Target is Everyone and send it via PublicVariable to all Clients
if (_target isEqualTo 0) exitWith {
    [_function, _args] call FUNC(execute);
    GVAR(remoteExecCode) = [_function, _args];
    publicVariable QGVAR(remoteExecCode);
};

// exit if the Object is Local
if (_target isEqualType objNull && {local _target}) exitWith {
    [_function, _args] call FUNC(execute);
};

// if it is the server we need to call the handleIncomeData directly else send it via publicVaraibleServer
if (isServer) then {
    [_target, _args, _function] call FUNC(handleIncomeData);
} else {
    GVAR(remoteServerData) = [_target, _args, _function];
    publicVariableServer QGVAR(remoteServerData);
};
