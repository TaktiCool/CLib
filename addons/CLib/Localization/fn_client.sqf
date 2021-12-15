#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Client init for localization

    Parameter(s):
    None

    Returns:
    None
*/

private _englishIndex = GVAR(supportedLanguages) find "English";
private _index = GVAR(supportedLanguages) find language;
if (_index == -1) then {
    _index = _englishIndex;
};
{
    private _data = GVAR(Namepace) getVariable _x;
    private _var = _data param [_index, nil];
    if (isNil "_var") then {
        _var = _data select _englishIndex;
    };
    DUMP("L10N Varfound: " + str _x + " Content: " + str _var);
    GVAR(Namepace) setVariable [_x, _var];
    nil
} count ([GVAR(Namepace), QGVAR(allLocalizations)] call CFUNC(allVariables));
