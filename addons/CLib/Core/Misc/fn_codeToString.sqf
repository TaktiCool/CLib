#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Convert Code to String used for some Eventhandler

    Parameter(s):
    Code to Convert <Code>

    Returns:
    Code in String <String>
*/
params ["_code"];
if (_code isEqualType "") exitWith {_code};
_code = str(_code);
_code = _code select [1, count _code - 2];
_code
