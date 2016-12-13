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
    _return = _originalFunction call CFUNC(checkCompression);
    {
        if (_return select _forEachIndex) then {
            LOG("Compression Check ERROR: " + _fncName + " " + _x + " compression dont work correct")
        } else {
            LOG("Compression Check: " + _fncName + " " + _x + " passed Test")
        };
    } forEach AllCompressionTypes;
    nil
} count (parsingNamespace getVariable QCGVAR(allFunctionNamesCached));
