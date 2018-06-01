#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Execute RemoteExecCommands

    Parameter(s):
    0: Function or command that get executed <String> (Default: "")
    1: Arguments for the event <Any> (Default: [])

    Returns:
    Function return <Anything>
*/

EXEC_ONLY_UNSCHEDULED;

params [
    ["_function", "", [""]],
    ["_args", [], []]
];

if (isNil {currentNamespace getVariable _function} || {!((currentNamespace getVariable _function) isEqualType {})}) then {
    if (!isClass (configFile >> "CfgRemoteExecCommands" >> _function) || {!isClass (missionConfigFile >> "CfgRemoteExecCommands" >> _function)} || {!isClass (campaignConfigFile >> "CfgRemoteExecCommands" >> _function)}) exitWith {
        LOG("ERROR: Command '" + _function + "' is not allowed to be Executed over Network.");
    };
    if (_args isKindOf []) then { // if the Command has Arguments that are not array it only can be Unary
        switch (count _args) do {
            // Nular Command
            case 0: {
                call compile _function;
            };
            // Binary Command
            case 2: {
                _args call compile (format ["(_this select 1) %1 (_this select 2)", _function]);
            };
            // Unary Command when the Arguments are bigger then 2 it only can be a Unary Command
            default {
                _args call compile (format ["%1 _this", _function]);
            };
        };
    } else {
        // Unary Command
        _args call compile (format ["%1 _this", _function]);
    };
} else {
    _args call (currentNamespace getVariable _function);
};
