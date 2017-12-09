#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Get variable of location with default fallback

    Parameter(s):
    0: NameSpace <Any>
    1: Variable name <String>
    2: Default <Any>

    Returns:
    Variable <Any>
*/
params ["_namespace", "_varName", "_default"];

REPLACEDFUNC("CLib_fnc_getVariable", "namespace getVariable ARRAY", "0.9");

_namespace getVariable [_varName, _default];
