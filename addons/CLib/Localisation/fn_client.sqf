#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Init Calls/Functions that Only need to be Executed on the Client

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(ClientNamespace) = false call CFUNC(createNamespace);

private _englishIndex = GVAR(supportedLanguages) find "English";
private _index = GVAR(supportedLanguages) find language;
if (_index == -1) then {
    _index = _englishIndex;
};
{
    private _data = GVAR(ServerNamespace) getVariable _x;
    private _var = _data param [_index, nil];
    if (isNil "_var") then {
        _var = _data select _englishIndex;
    };
    /* TODO Fix Compression
    if (useCompression) then {
        _var = _var call CFUNC(decompressString);
    };
    */
    DUMP("L10N Varfound: " + str _x + " Content: " + str _var)
    GVAR(ClientNamespace) setVariable [_x, _var];
    nil
} count ([GVAR(ServerNamespace), QGVAR(allLocalisations)] call CFUNC(allVariables));
