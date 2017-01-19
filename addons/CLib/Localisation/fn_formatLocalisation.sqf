#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Localisation format Wrapper

    Parameter(s):
    0: FormatString <String>
    1: Var1 <Any>
    2: Var2 <Any>
    ...

    Returns:
    Formated and Localised String
*/

private _array = +_this;
{
    if (_x isEqualType "" && {_x call CFUNC(isLocalised)}) then {
        _array set [_forEachIndex, LOC(_x)];
    };
} forEach _array;
format _array;
