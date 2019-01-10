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

{
    private _fncName = _x;
    private _originalFunction = (parsingNamespace getVariable _fncName) call CFUNC(codeToString);

    if (_originalFunction call CFUNC(checkCompression)) then {
        LOG("Compression Check: " + _fncName + " passed Test")
    } else {
        LOG("Compression Check ERROR: " + _fncName + " compression does not work correct")
    };
    nil
} count (parsingNamespace getVariable QCGVAR(allFunctionNamesCached));
LOG("Done with all Checks")
