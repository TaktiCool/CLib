#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Format localization wrapper

    Parameter(s):
    https://community.bistudio.com/wiki/format

    Returns:
    Formated and localized string <String>
*/

format (_this apply {
    if (_x isEqualType "" && {_x call CFUNC(isLocalized)}) then {
        LOC(_x)
    } else {
        _x
    };
});
