#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Format localisation wrapper

    Parameter(s):
    https://community.bistudio.com/wiki/format

    Returns:
    Formated and localised string <String>
*/

format (_this apply {
    if (_x isEqualType "" && {_x call CFUNC(isLocalised)}) then {
        LOC(_x)
    } else {
        _x
    };
});
