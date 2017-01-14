#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Compiles all functions

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
