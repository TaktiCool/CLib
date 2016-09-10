#include "macros.hpp"
/*
    Comunity Lib - Clib

    Author: joko // Jonas

    Description:
    this function compile all Functions

    Parameter(s):
    None

    Returns:
    None
*/
DUMP("Start Clib Function Compile")
DUMP(str (parsingNamespace getVariable QGVAR(allFunctionNamesCached)))
{
    private _data = parsingNamespace getVariable _x + "_data";
    DUMP("Compile Loop " + _x)
    DUMP(str _data)
    _data params ["_folderPath", "", "", "", "_modName"];
    diag_log isNil "Clib_fnc_compile";
    [_folderPath, _x, _modName] call Clib_fnc_compile;
    nil
} count (parsingNamespace getVariable QGVAR(allFunctionNamesCached));
DUMP("End Clib Function Compile")
