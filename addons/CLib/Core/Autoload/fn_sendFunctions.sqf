#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Append Unit to SendFunctions Queue if the mission is allready Trigger else it just pushes the functions

    Parameter(s):
    0: Client UID <Number>

    Returns:
    None
*/

#ifdef disableCompression
    #define useCompression false
#else
    #define useCompression CGVAR(useFunctionCompression)
#endif


params [["_functionName", ""], ["_clientID", -1], ["_index", 0]];

private _functionCode = if (useCompression) then {
    parsingNamespace getVariable [_functionName + "_Compressed", ""];
} else {
    private _code = parsingNamespace getVariable [_functionName, {}];
    // Remove leading and trailing braces from the code.
    _code call CFUNC(codeToString);
};

// Transfer the function name, code and progress to the client.
GVAR(receiveFunction) = [_functionName, _functionCode, _index / GVAR(countRequiredFnc)];


DUMP("sendFunction: " + _functionName + ", " + str (GVAR(receiveFunction) select 2))

_clientID publicVariableClient QGVAR(receiveFunction);
