#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Checks if a string is localized

    Parameter(s):
    0: Localization Name <String> (Default: "STR_CLib_ERROR")

    Returns:
    Is Localized <Bool>
*/

params [
    ["_locaName", "STR_CLib_ERROR", [""]]
];

private _temp = GVAR(Namepace) getVariable _locaName;

!isNil "_temp" || isLocalized _locaName;
