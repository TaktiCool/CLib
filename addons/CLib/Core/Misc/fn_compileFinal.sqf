#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Compiles a Function Final and Saves them in a namespace
    if Variable Name is not set it will only return the function as Final Compiled Code
    Parameter(s):
    0: Code to Compile Final <Code>
    1: Variable Name <String> (Default: nil)

    Returns:
    Final Compiled Code <Code>
*/
params [["_code", {}, [{}, ""]], "_varName"];
private _strCode = _code call CFUNC(codeToString);
#ifdef ISDEV
    private _finalCode = compile _strCode;
#else
    private _finalCode = compileFinal _strCode;
#endif


if !(isNil "_varName") {
    {
        _x setVariable [_varName, _finalCode];
    } forEach [missionNamespace, uiNamespace, parsingNamespace];
};

_finalCode
