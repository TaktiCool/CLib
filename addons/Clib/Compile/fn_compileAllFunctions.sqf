#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    this function compile all Functions

    Parameter(s):
    None

    Returns:
    None
*/
{
    private _data = parsingNamespace getVariable _x + "_data";
    _data params ["_folderPath", "", "", "", "_modName"];
    diag_log isNil "CLib_fnc_compile";
    [_folderPath, _x] call CLib_fnc_compile;
    nil
} count (parsingNamespace getVariable QGVAR(allFunctionNamesCached));
