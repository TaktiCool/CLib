#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Read the Localisation if the String is Localised

    Parameter(s):
    0: Localisation Name <String> (Default: "STR_CLib_ERROR")

    Returns:
    Localisted Text <String>
*/

params [
    ["_locaName", "STR_CLib_ERROR", [""]]
];

#ifdef ISDEV
    private _text = GVAR(Namepace) getVariable [_locaName, _locaName];
    if (_text isEqualTo _locaName) then {
        LOG("Error Localisation not Found: " + _locaName);
    };
    _text
#else
    GVAR(Namepace) getVariable [_locaName, _locaName];
#endif
