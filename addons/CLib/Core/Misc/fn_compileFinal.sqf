#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Compiles a function final and saves it in a namespace.
    If variable name is not set it will only return the function as final compiled code.

    Parameter(s):
    0: Code to Compile Final <Code, String> (Default: {})
    1: Variable Name <String> (Default: nil)

    Returns:
    Final Compiled Code <Code>
*/

params [
    ["_code", {}, [{}, ""]],
    ["_varName", nil, [""]]
];

private _strCode = _code call CFUNC(codeToString);
#ifdef ISDEV
    private _finalCode = compile _strCode;
#else
    private _finalCode = compileFinal _strCode;
#endif

if !(isNil "_varName") then {
    {
        _x setVariable [_varName, _finalCode];
    } forEach [missionNamespace, uiNamespace, parsingNamespace];
};

_finalCode
