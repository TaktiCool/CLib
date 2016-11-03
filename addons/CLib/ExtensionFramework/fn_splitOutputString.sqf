#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Split Output String

    Parameter(s):
    0: InputString

    Returns:
    Stichted Extension Return <String>
*/
#define __MAXOUTPUTSIZE 7000
params ["_mainStr"];
private _strAr = [];
private _counter = 0;
if !(_mainStr isEqualType "") then {
    _mainStr = str _mainStr;
};
while {_counter <= (count _mainStr)} do {
    _strAr pushback (_mainStr select [_counter, __MAXOUTPUTSIZE]);
    _counter = _counter + __MAXOUTPUTSIZE;
};
_strAr
