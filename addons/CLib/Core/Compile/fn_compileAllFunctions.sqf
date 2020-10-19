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
private _allFunctions = parsingNamespace getVariable QCGVAR(allFunctionNamesCached);
#ifdef ISDEV
    private _count = count _allFunctions;
#endif
{
    (parsingNamespace getVariable (_x + "_data")) params ["_folderPath"];
    #ifdef ISDEV
        private _str = format ["Compile Function: %1 %2%3", _x, (_forEachIndex/_count)*100, "%"];
        DUMP(_str);
    #endif
    [_folderPath, _x] call CFUNC(compile);
} forEach _allFunctions;
