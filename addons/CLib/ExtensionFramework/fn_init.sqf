#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init Some Events for Extension Framework

    Parameter(s):
    None

    Returns:
    None
*/

if (isServer) then {
    ["extensionRequest", {
        (_this select 0) params ["_args", "_target"];
        _args params [
            ["_action", "", [""]],
            ["_data", "", [""]],
            ["_function", {hint "Error";}, ["", {}]],
            "_funcArgs"
        ];

        private _return = [_action, _data] call CFUNC(callExtension);
        ["extensionResponse", _target, [_return, _function, _funcArgs]] call CFUNC(targetEvent);
    }] call CFUNC(addEventhandler);
};

["extensionResponse", {
    (_this select 0) params ["_return", "_function", "_funcArgs"];
    if (_function isEqualType "") then {
        _function = currentNamespace getVariable _function;
    };
    [_return, _funcArgs] call _function;
}] call CFUNC(addEventhandler);

if (isServer) then {
    // add Eventhandler for Remote Logging
    DFUNC(log) = {
        params [["_log", "", [""]], ["_file", "", [""]]];
        _file = _file call CFUNC(sanitizeString);
        "PRA3_Server" callExtension (format ["logging:%1:", _file] + _log); // TODO
    };

    QGVAR(sendlogfile) addPublicVariableEventHandler {
        (_this select 1) call FUNC(log);
    };
};
