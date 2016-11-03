#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    this function compile all Functions

    Parameter(s):
    None

    Returns:
    None
*/
{
    (parsingNamespace getVariable (_x + "_data")) params ["_folderPath"];
    [_folderPath, _x] call CFUNC(compile);
    nil
} count (parsingNamespace getVariable QCGVAR(allFunctionNamesCached));
