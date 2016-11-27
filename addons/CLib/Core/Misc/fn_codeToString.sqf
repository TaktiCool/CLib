#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Converts the given code to a string which is needed for some EventHandler

    Parameter(s):
    Code to convert <Code>

    Returns:
    Code as String <String>
*/
params ["_code"];
if (_code isEqualType "") exitWith {_code};
_code = str(_code);
_code = _code select [1, count _code - 2];
_code
