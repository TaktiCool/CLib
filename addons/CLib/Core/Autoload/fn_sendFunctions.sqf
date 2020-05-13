#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Build a recieveFunctionVariable and transfers it to the client

    Parameter(s):
    0: Function name <String> (Default: "")
    1: Client UID <Number> (Default: -1)
    2: Index <Number> (Default: 0)

    Returns:
    None
*/

params [
    ["_functionName", "", [""]],
    ["_clientID", -1, [0]],
    ["_index", 0, [0]]
];

private _functionCode = if (USE_COMPRESSION(true)) then {
    parsingNamespace getVariable [_functionName + "_Compressed", ""];
} else {
    private _code = parsingNamespace getVariable [_functionName, {}];
    // Remove leading and trailing braces from the code.
    _code call CFUNC(codeToString);
};

// Transfers the function name, code and progress to the client.
GVAR(receiveFunction) = [_functionName, _functionCode, _index / GVAR(countRequiredFnc)];

DUMP("sendFunction: " + _functionName + ", " + str (GVAR(receiveFunction) select 2));

_clientID publicVariableClient QGVAR(receiveFunction);
