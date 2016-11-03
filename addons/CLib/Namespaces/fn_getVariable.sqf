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

if !(_namespace isEqualType locationNull) exitWith {
    _namespace getVariable [_varName, _default];
};

private _ret = _namespace getVariable _varName;

if (isNil "_ret") exitWith {_default};

_ret
