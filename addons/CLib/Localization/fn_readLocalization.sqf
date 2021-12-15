#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Read the Localization if the String is Localized

    Parameter(s):
    0: Localization Name <String, Array> (Default: "STR_CLib_ERROR")

    Returns:
    Localized Text <String>
*/

params [
    ["_locaName", "STR_CLib_ERROR", [""]]
];

#ifdef ISDEV
    if (isLocalized _locaName) exitWith {
        localize _locaName;
    };
    private _text = GVAR(Namepace) getVariable [_locaName, _locaName];
    if (_text isEqualTo _locaName) then {
        LOG("Error Localization not Found: " + _locaName);
    };
    _text
#else
    if (isLocalized _locaName) exitWith {
        localize _locaName;
    };
    GVAR(Namepace) getVariable [_locaName, _locaName];
#endif
