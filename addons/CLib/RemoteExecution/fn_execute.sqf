#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Execute RemoteExecCommands

    Parameter(s):
    0: Function or command that get executed <String> (Default: "")
    1: Arguments for the event <Anything> (Default: [])

    Returns:
    Function return <Anything>
*/

EXEC_ONLY_UNSCHEDULED

params [
    ["_function", "", [""]],
    ["_args", [], []]
];

if (isNil {currentNamespace getVariable _function} && {((currentNamespace getVariable _function) isEqualType {})}) then {
    LOG("ERROR: Unknown function: " + _function)
} else {
    _args call (currentNamespace getVariable _function);
};
