#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: joko // Jonas

    Description:
    Check if the RemoteExecFall Back is used and handle after that the Data and share it to the server

    Parameter(s):
    0: Arguments for the function/command <Any>
    1: Function/Command that get executed on the remote Clients <String>
    2: Target to what the Event should get sendet <Number, Side, Object, Group, Array of Prev named Types>

    Returns:
    None
*/
params ["_args", ["_function", "", [""]], ["_target", 0, [0, sideUnknown, objNull, grpNull, []]]];

// exit with Vanilla Method if it is not disabled
if !(GVAR(useRemoteFallback)) exitWith {
    _args remoteExecCall [_function, _target];
};

// exit if the Target is only server
if (_target isEqualTo 2) exitWith {
    if (isServer) then {
         [_args, _function] call CFUNC(execute);
    } else {
        GVAR(remoteExecCode) = [_args, _function];
        publicVariableServer  QGVAR(remoteExecCode);
    };
};

// exit if the Target is Everyone and send it via PublicVariable to all Clients
if (_target isEqualTo 0) exitWith {
    [_args, _function] call CFUNC(execute);
    GVAR(remoteExecCode) = [_args, _function];
    publicVariable QGVAR(remoteExecCode);
};

// exit if the Object is Local
if (_target isEqualType objNull && {local _target} ) exitWith {
    [_args, _function] call CFUNC(execute);
};

// if it is the server we need to call the handleIncomeData directly else send it via publicVaraibleServer
if (isServer) then {
    [_target, _args, _function] call CFUNC(handleIncomeData);
} else {
    GVAR(remoteServerData) = [_target, _args, _target];
    publicVariableServer QGVAR(remoteServerData);
};
