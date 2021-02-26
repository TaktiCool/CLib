#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Check if all Compression work right

    Parameter(s):
    None

    Returns:
    None
*/

params [["_useSQF", false]];
["CheckAllFunctionCompression", "Checking Function Compressions"] call BIS_fnc_startLoadingScreen;
private _allFunctions = parsingNamespace getVariable QCGVAR(allFunctionNamesCached);
private _count = count _allFunctions;
{
    private _fncName = _x;
    private _originalFunction = (parsingNamespace getVariable _fncName) call CFUNC(codeToString);
    if ([_originalFunction, _useSQF] call CFUNC(checkCompression)) then {
        LOG("Compression Check: " + _fncName + " passed Test")
    } else {
        ERROR_LOG("Compression Check ERROR: " + _fncName + " compression does not work correct")
    };
    [_forEachIndex/_count] call BIS_fnc_progressLoadingScreen;
} forEach _allFunctions;
"CheckAllFunctionCompression" call BIS_fnc_endLoadingScreen;
LOG("Done with all Checks");
