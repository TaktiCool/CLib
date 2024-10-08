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

private _functionCode =  if (getNumber (missionConfigFile >> "CLib" >> "OptimiseForSize") == 1) then {
    if (USE_COMPRESSION(!isNil {parsingNamespace getVariable _functionName + "_Compressed"})) then {
        parsingNamespace getVariable [_functionName + "_Compressed", ""];
    } else {
        parsingNamespace getVariable [_functionName, {}];
    };
} else {
    parsingNamespace getVariable [_functionName, {}];
};


// Transfers the function name, code and progress to the client.
GVAR(receiveFunction) = [_functionName, _functionCode, _index / GVAR(countRequiredFnc)];
if (_functionCode isEqualType "") then {
    if (isNil QGVAR(TransmissionSize)) then {
        GVAR(TransmissionSize) = 0;
    };

    private _size = count _functionCode/1024;
    GVAR(TransmissionSize) = GVAR(TransmissionSize) + _size;

#ifdef ISDEV
    private _str = format ["SendFunctions: %1, Size: %2KB, Process: %3%4", _functionName, _size, GVAR(receiveFunction) select 2, "%"];
    DUMP(_str);
#endif

};



_clientID publicVariableClient QGVAR(receiveFunction);
